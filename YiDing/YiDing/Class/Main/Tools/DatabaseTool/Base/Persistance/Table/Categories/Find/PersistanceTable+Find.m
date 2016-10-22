//
//  PersistanceTable+Find.m
//  DongAoAcc
//
//  Created by wihan on 15/11/26.
//  Copyright © 2015年 wihan. All rights reserved.
//

#import "PersistanceTable+Find.h"
#import "NSString+SQL.h"
#import "PersistanceQueryCommand+ReadMethods.h"
#import "NSArray+PersistanceRecordTransform.h"
#import <UIKit/UIKit.h>
#import "PersistanceConfiguration.h"

@implementation PersistanceTable (Find)

- (NSObject<PersistanceRecordProtocol> *)findLatestRecordWithError:(NSError *__autoreleasing *)error
{
    //设置criteria条件（不排重，以主键降序，限制1个记录）
    PersistanceCriteria *criteria = [[PersistanceCriteria alloc] init];
    criteria.isDistinct = NO;
    criteria.orderBy = [self.child primaryKeyName];
    criteria.isDESC = YES;
    criteria.limit = 1;
    return [self findFirstRowWithCriteria:criteria error:error];
}

- (NSArray <NSObject <PersistanceRecordProtocol> *> *)findAllWithWhereCondition:(NSString *)condition conditionParams:(NSDictionary *)conditionParams isDistinct:(BOOL)isDistinct error:(NSError **)error
{
    //创建并设置criteria
    PersistanceCriteria *criteria = [[PersistanceCriteria alloc] init];
    criteria.isDistinct = isDistinct;
    criteria.whereCondition = condition;
    criteria.whereConditionParams = conditionParams;
    return [self findAllWithCriteria:criteria error:error];
}

- (NSArray <NSObject <PersistanceRecordProtocol> *> *)findAllWithSQL:(NSString *)sqlString params:(NSDictionary *)params error:(NSError **)error
{
    //1.如果sqlSting为空，则创建空string
    if (sqlString == nil) {
        return @[];
    }
    //2.根据参数和sqlstring生成最终的sql语句
    NSString *finalString = [sqlString stringWithSQLParams:params];
    [self.queryCommand resetQueryCommand];
    [self.queryCommand.sqlString appendString:finalString];
    //3.获取查询结果数组
    NSArray *fetchedResult = [self.queryCommand fetchWithError:error];
    //4.根据查询结果，再根据record类型过滤出我要的record list
    return [fetchedResult transformSQLItemsToClass:[self.child recordClass]];
}

/**
 *  根据sqlString and params找到所有符合条件的原始数据
 *
 *  @param sqlString 查询sqlString
 *  @param params    绑定到sqlString上的参数
 *
 *  @return return 返回record list
 */
- (NSArray *)findAllWithSQLWithOriginData:(NSString *)sqlString params:(NSDictionary *)params error:(NSError **)error
{
    //1.如果sqlSting为空，则创建空string
    if (sqlString == nil) {
        return @[];
    }
    //2.根据参数和sqlstring生成最终的sql语句
    NSString *finalString = [sqlString stringWithSQLParams:params];
    [self.queryCommand resetQueryCommand];
    [self.queryCommand.sqlString appendString:finalString];
    //3.获取查询结果数组
    NSArray *fetchedResult = [self.queryCommand fetchWithError:error];
    //4.返回查询结果
    return fetchedResult;
}

- (NSArray <NSObject <PersistanceRecordProtocol> *> *)findAllWithCriteria:(PersistanceCriteria *)criteria error:(NSError **)error
{
    //1.根据criteria获得查询结果list
    [self.queryCommand resetQueryCommand];
    [criteria applyToSelectQueryCommand:self.queryCommand tableName:[self.child tableName]];
    NSArray *fetchedResult = [self.queryCommand fetchWithError:error];
    //根据查询结果，再根据record类型过滤出我要的record list
    return [fetchedResult transformSQLItemsToClass:[self.child recordClass]];
}

- (NSObject <PersistanceRecordProtocol> *)findFirstRowWithWhereCondition:(NSString *)condition conditionParams:(NSDictionary *)conditionParams isDistinct:(BOOL)isDistinct error:(NSError **)error
{
    PersistanceCriteria *criteria = [[PersistanceCriteria alloc] init];
    criteria.isDistinct = isDistinct;
    criteria.whereCondition = condition;
    criteria.whereConditionParams = conditionParams;
    //控制找到第一条数据
    criteria.limit = 1;
    return [self findFirstRowWithCriteria:criteria error:error];
}

- (NSObject <PersistanceRecordProtocol> *)findFirstRowWithCriteria:(PersistanceCriteria *)criteria error:(NSError **)error
{
    [self.queryCommand resetQueryCommand];
    criteria.limit = 1;
    return [[[[criteria applyToSelectQueryCommand:self.queryCommand tableName:[self.child tableName]] fetchWithError:error] transformSQLItemsToClass:[self.child recordClass]] firstObject];
}

- (NSObject <PersistanceRecordProtocol> *)findFirstRowWithSQL:(NSString *)sqlString params:(NSDictionary *)params error:(NSError **)error
{
    //1.获得sql语句
    NSString *finalString = [sqlString stringWithSQLParams:params];
    [self.queryCommand resetQueryCommand];
    //2.去掉sql语句中的“;”
    finalString = [finalString stringByReplacingOccurrencesOfString:@";" withString:@""];
    //3.在sql语句后增加空格
    [self.queryCommand.sqlString appendFormat:@"%@ ", finalString];
    //4.设置获取第一条record
    [self.queryCommand limit:1];
    return [[[self.queryCommand fetchWithError:error] transformSQLItemsToClass:[self.child recordClass]] firstObject];
}

- (NSNumber *)countTotalRecord
{
    //1.找到表中所有record
    NSString *sqlString = [NSString stringWithFormat:@"SELECT COUNT(*) as count FROM %@", self.child.tableName];
    NSDictionary *countResult = [self countWithSQL:sqlString params:nil error:NULL];
    //2.返回所有record数
    return countResult[@"count"];
}

- (NSNumber *)countWithWhereCondition:(NSString *)whereCondition conditionParams:(NSDictionary *)conditionParams error:(NSError **)error
{
    NSString *sqlString = @"SELECT COUNT(*) AS count FROM :tableName WHERE :whereString;";
    //1.生成查询条件
    NSString *whereString = [whereCondition stringWithSQLParams:conditionParams];
    NSString *tableName = self.child.tableName;
    NSDictionary *params = NSDictionaryOfVariableBindings(whereString, tableName);
    NSDictionary *countResult = [self countWithSQL:sqlString params:params error:NULL];
    //2.得到符合条件的count
    return countResult[@"count"];
}

- (NSDictionary *)countWithSQL:(NSString *)sqlString params:(NSDictionary *)params error:(NSError **)error
{
    [self.queryCommand resetQueryCommand];
    NSString *finalString = [sqlString stringWithSQLParams:params];
    [self.queryCommand resetQueryCommand];
    [self.queryCommand.sqlString appendString:finalString];
    return [[self.queryCommand fetchWithError:NULL] firstObject];
}

- (NSObject <PersistanceRecordProtocol> *)findWithPrimaryKey:(NSNumber *)primaryKeyValue error:(NSError **)error
{
    //1.如果key值为空，则返回错误
    if (primaryKeyValue == nil) {
        if (error) {
            *error = [NSError errorWithDomain:kPersistanceErrorDomain
                                         code:PersistanceErrorCodeQueryStringError
                                     userInfo:@{NSLocalizedDescriptionKey:@"primaryKeyValue or primaryKeyValue is nil"}];
        }
        return nil;
    }
    //2.根据主键值获得相应record
    PersistanceCriteria *criteria = [[PersistanceCriteria alloc] init];
    criteria.whereCondition = [NSString stringWithFormat:@"%@ = :primaryKeyValue", [self.child primaryKeyName]];
    criteria.whereConditionParams = NSDictionaryOfVariableBindings(primaryKeyValue);
    return [self findFirstRowWithCriteria:criteria error:error];
}

- (NSArray <NSObject <PersistanceRecordProtocol> *> *)findAllWithPrimaryKey:(NSArray <NSNumber *> *)primaryKeyValueList error:(NSError **)error
{
    //1.生成一个用“,”分开的string
    NSString *primaryKeyValueListString = [primaryKeyValueList componentsJoinedByString:@","];
    PersistanceCriteria *criteria = [[PersistanceCriteria alloc] init];
    //2.根据criteria进行查找
    criteria.whereCondition = [NSString stringWithFormat:@"%@ IN (:primaryKeyValueListString)", [self.child primaryKeyName]];
    criteria.whereConditionParams = NSDictionaryOfVariableBindings(primaryKeyValueListString);
    return [self findAllWithCriteria:criteria error:error];
}

@end
