//
//  PersistanceTable+Delete.h
//  DongAoAcc
//
//  Created by wihan on 15/11/26.
//  Copyright © 2015年 wihan. All rights reserved.
//

#import "PersistanceTable.h"
#import "PersistanceRecord.h"
#import "PersistanceCriteria.h"

@interface PersistanceTable (Delete)

/**
 *  删除记录
 */
- (BOOL)deleteRecord:(NSObject <PersistanceRecordProtocol> *)record error:(NSError **)error;

/**
 *  删除record list
 *
 *  @param recordList 记录list
 */
- (BOOL)deleteRecordList:(NSArray <NSObject<PersistanceRecordProtocol> *> *)recordList error:(NSError **)error;

/**
 *  根据条件删除。"where condition"是sql的WHERE字句，如果如":name"则表示name所指定的值
 *
 *  例如：
    whereCondition:
        NSString *whereCondition = @"hello = :something";
        key一定以“:”开头
    conditionParams:
        NSDictionary *conditionParams = @{
           @"something":@"world" };
        所以上面的赋值有"hello = world"
 *
 *  @param whereCondition  WHERE 字句
 *  @param conditionParams 相应参数绑定的值
 *  @param error           错误对象
 */
- (BOOL)deleteWithWhereCondition:(NSString *)whereCondition conditionParams:(NSDictionary *)conditionParams error:(NSError **)error;

/**
 *  根据条件删除
 *
 *  @param criteria 删除条件
 */
- (BOOL)deleteWithCriteria:(PersistanceCriteria *)criteria error:(NSError **)error;

/**
 *  根据sql删除
 *
 *  @param sqlString 这个sql string的格式类似于
 *  @param params    针对sql绑定的参数
 */
- (BOOL)deleteWithSql:(NSString *)sqlString params:(NSDictionary *)params error:(NSError **)error;

/**
 *  根据主键删除
 *
 *  @param primaryKeyValue 记录的主键
 */
- (BOOL)deleteWithPrimaryKey:(NSNumber *)primaryKeyValue error:(NSError **)error;

/**
 *  根据主键list删除
 *
 *  @param primaryKeyValueList 组件list
 */
- (BOOL)deleteWithPrimaryKeyList:(NSArray <NSNumber *> *)primaryKeyValueList error:(NSError **)error;

@end
