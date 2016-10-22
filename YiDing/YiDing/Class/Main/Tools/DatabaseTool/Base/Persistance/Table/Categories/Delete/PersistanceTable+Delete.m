//
//  PersistanceTable+Delete.m
//  DongAoAcc
//
//  Created by wihan on 15/11/26.
//  Copyright © 2015年 wihan. All rights reserved.
//

#import "PersistanceTable+Delete.h"
#import "NSString+SQL.h"
#import <UIKit/UIKit.h>

@implementation PersistanceTable (Delete)

- (BOOL)deleteRecord:(NSObject <PersistanceRecordProtocol> *)record error:(NSError **)error
{
    //通过record主键删除record
    return [self deleteWithPrimaryKey:[record valueForKey:[self.child primaryKeyName]] error:error];
}

- (BOOL)deleteRecordList:(NSArray <NSObject <PersistanceRecordProtocol> *> *)recordList error:(NSError **)error
{
    NSMutableArray *primatKeyList = [[NSMutableArray alloc] init];
    [recordList enumerateObjectsUsingBlock:^(NSObject <PersistanceRecordProtocol> * _Nonnull record, NSUInteger idx, BOOL * _Nonnull stop) {
        NSNumber *primaryKeyValue = [record valueForKey:[self.child primaryKeyName]];
        if (primaryKeyValue) {
            [primatKeyList addObject:primaryKeyValue];
        }
    }];
    //根据主键list删除record list
    return [self deleteWithPrimaryKeyList:primatKeyList error:error];
}

- (BOOL)deleteWithWhereCondition:(NSString *)whereCondition conditionParams:(NSDictionary *)conditionParams error:(NSError **)error
{
    //根据条件对象实现删除
    PersistanceCriteria *criteria = [[PersistanceCriteria alloc] init];
    criteria.whereCondition = whereCondition;
    criteria.whereConditionParams = conditionParams;
    return [self deleteWithCriteria:criteria error:error];
}

- (BOOL)deleteWithCriteria:(PersistanceCriteria *)criteria error:(NSError **)error
{
    //通过条件对象，查询command，table name进行删除
    return [[criteria applyToDeleteQueryCommand:self.queryCommand tableName:[self.child tableName]] executeWithError:error];
}

- (BOOL)deleteWithSql:(NSString *)sqlString params:(NSDictionary *)params error:(NSError **)error
{
    //1.根据sqlString和params，生成真正的sql语句
    NSString *finalSql = [sqlString stringWithSQLParams:params];
    [self.queryCommand resetQueryCommand];
    [self.queryCommand.sqlString appendString:finalSql];
    //2.调用实行接口执行删除指令
    return [self.queryCommand executeWithError:error];
}

- (BOOL)deleteWithPrimaryKey:(NSNumber *)primaryKeyValue error:(NSError **)error
{
    if (primaryKeyValue) {
        //1.创建criteria
        PersistanceCriteria *criteria = [[PersistanceCriteria alloc] init];
        //2.根据指定格式赋值whereCondition
        criteria.whereCondition = [NSString stringWithFormat:@"%@ = :primaryKeyValue", [self.child primaryKeyName]];
        //3.生成whereConditionParams dic
        criteria.whereConditionParams = NSDictionaryOfVariableBindings(primaryKeyValue);
        //4.根据criteria删除record
        return [self deleteWithCriteria:criteria error:error];
    }
    return NO;
}

- (BOOL)deleteWithPrimaryKeyList:(NSArray <NSNumber *> *)primaryKeyValueList error:(NSError **)error
{
    if ([primaryKeyValueList count] > 0) {
        NSString *primaryKeyValueListString = [primaryKeyValueList componentsJoinedByString:@","];
        PersistanceCriteria *criteria = [[PersistanceCriteria alloc] init];
        criteria.whereCondition = [NSString stringWithFormat:@"%@ IN (:primaryKeyValueListString)", [self.child primaryKeyName]];
        criteria.whereConditionParams = NSDictionaryOfVariableBindings(primaryKeyValueListString);
        return [self deleteWithCriteria:criteria error:error];
    }
    return NO;
}

@end
