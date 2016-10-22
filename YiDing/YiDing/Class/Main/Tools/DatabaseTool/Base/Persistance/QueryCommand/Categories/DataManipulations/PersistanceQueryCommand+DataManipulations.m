//
//  PersistanceQueryCommand+DataManipulations.m
//  DongAoAcc
//
//  Created by wihan on 15/11/26.
//  Copyright © 2015年 wihan. All rights reserved.
//

#import "PersistanceQueryCommand+DataManipulations.h"

#import "PersistanceMarcos.h"
#import "NSString+SQL.h"
#import "PersistanceQueryCommand+ReadMethods.h"

@implementation PersistanceQueryCommand (DataManipulations)

- (PersistanceQueryCommand *)insertTable:(NSString *)tableName withDataList:(NSArray *)dataList
{
    //1.清除sqlString
    [self resetQueryCommand];
    
    //2.设置表名，如果为空直接返回
    NSString *safeTableName = [tableName safeSQLMetaString];
    if (Persistance_isEmptyString(safeTableName) || dataList == nil) {
        return self;
    }
    
    //3.创建插入的sql语句
    NSMutableArray *valueItemList = [[NSMutableArray alloc] init];
    __block NSString *columString = nil;
    [dataList enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull description, NSUInteger idx, BOOL * _Nonnull stop) {
        NSMutableArray *columList = [[NSMutableArray alloc] init];
        NSMutableArray *valueList = [[NSMutableArray alloc] init];
        
        [description enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull colum, NSString * _Nonnull value, BOOL * _Nonnull stop) {
            //3.1保存column名到columList中
            [columList addObject:[NSString stringWithFormat:@"`%@`", [colum safeSQLMetaString]]];
            //3.2保存value值到valueList中
            if ([value isKindOfClass:[NSString class]]) {
                [valueList addObject:[NSString stringWithFormat:@"'%@'", [value safeSQLEncode]]];
            } else if ([value isKindOfClass:[NSNull class]]) {
                [valueList addObject:@"NULL"];
            } else {
                [valueList addObject:[NSString stringWithFormat:@"'%@'", value]];
            }
        }];
        
        if (columString == nil) {
            columString = [columList componentsJoinedByString:@","];
        }
        NSString *valueString = [valueList componentsJoinedByString:@","];
        
        [valueItemList addObject:[NSString stringWithFormat:@"(%@)", valueString]];
    }];
    
    //4.创建insert语句
    [self.sqlString appendFormat:@"INSERT INTO `%@` (%@) VALUES %@;", safeTableName, columString, [valueItemList componentsJoinedByString:@","]];
    
    return self;
}

- (PersistanceQueryCommand *)updateTable:(NSString *)tableName withData:(NSDictionary *)data condition:(NSString *)condition conditionParams:(NSDictionary *)conditionParams
{
    [self resetQueryCommand];
    //1.检测表名和condition的有效性
    NSString *safeTableName = [tableName safeSQLMetaString];
    NSString *trimmedCondition = [condition safeSQLMetaString];
    if (Persistance_isEmptyString(safeTableName) || Persistance_isEmptyString(trimmedCondition) || data == nil){
        return self;
    }
    
    NSMutableArray *valueList = [[NSMutableArray alloc] init];
    
    //2.根据输入的data dic得到valueList
    [data enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull colum, NSString * _Nonnull value, BOOL * _Nonnull stop) {
        if ([value isKindOfClass:[NSString class]]) {
            [valueList addObject:[NSString stringWithFormat:@"`%@`='%@'", [colum safeSQLMetaString], [value safeSQLEncode]]];
        } else if ([value isKindOfClass:[NSNull class]]) {
            [valueList addObject:[NSString stringWithFormat:@"`%@`=NULL", [colum safeSQLMetaString]]];
        } else {
            [valueList addObject:[NSString stringWithFormat:@"`%@`=%@", [colum safeSQLMetaString], value]];
        }
    }];
    
    NSString *valueString = [valueList componentsJoinedByString:@","];
    //3.得到update sql语句
    [self.sqlString appendFormat:@"UPDATE `%@` SET %@ ", safeTableName, valueString];
    //4.返回创建的command
    return [self where:condition params:conditionParams];
}

- (PersistanceQueryCommand *)deleteTable:(NSString *)tableName withCondition:(NSString *)condition conditionParams:(NSDictionary *)conditionParams
{
    [self resetQueryCommand];
    
    NSString *safeTableName = [tableName safeSQLMetaString];
    NSString *trimmedCondition = [condition safeSQLMetaString];
    
    if (Persistance_isEmptyString(safeTableName) || Persistance_isEmptyString(trimmedCondition)) {
        return self;
    }
    
    [self.sqlString appendFormat:@"DELETE FROM `%@` ", safeTableName];
    
    return [self where:trimmedCondition params:conditionParams];
}

@end
