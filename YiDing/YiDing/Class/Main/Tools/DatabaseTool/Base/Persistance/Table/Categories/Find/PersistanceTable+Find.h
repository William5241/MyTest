//
//  PersistanceTable+Find.h
//  DongAoAcc
//
//  Created by wihan on 15/11/26.
//  Copyright © 2015年 wihan. All rights reserved.
//

#import "PersistanceTable.h"
#import "PersistanceRecord.h"
#import "PersistanceCriteria.h"

@interface PersistanceTable (Find)

/**
 *  找到表中最后一个record
 */
- (NSObject <PersistanceRecordProtocol> *)findLatestRecordWithError:(NSError **)error;

/**
 *  根据condition and conditionParams找到所有符合条件的records
 *
 *  @param condition       条件string
 *  @param conditionParams 条件值dic
 *  @param isDistinct      YES, 去除重复项
 *
 *  @return return 返回符合条件的record list
 */
- (NSArray <NSObject <PersistanceRecordProtocol> *> *)findAllWithWhereCondition:(NSString *)condition conditionParams:(NSDictionary *)conditionParams isDistinct:(BOOL)isDistinct error:(NSError **)error;

/**
 *  根据sqlString and params找到所有符合条件的records
 *
 *  @param sqlString 查询sqlString
 *  @param params    绑定到sqlString上的参数
 *
 *  @return return 返回record list
 */
- (NSArray <NSObject <PersistanceRecordProtocol> *> *)findAllWithSQL:(NSString *)sqlString params:(NSDictionary *)params error:(NSError **)error;

/**
 *  根据sqlString and params找到所有符合条件的原始数据
 *
 *  @param sqlString 查询sqlString
 *  @param params    绑定到sqlString上的参数
 *
 *  @return return 返回record list
 */
- (NSArray *)findAllWithSQLWithOriginData:(NSString *)sqlString params:(NSDictionary *)params error:(NSError **)error;

/**
 *  根据criteria对象找到符合条件的所有records
 *
 *  @param criteria criteria对象
 */
- (NSArray <NSObject <PersistanceRecordProtocol> *> *)findAllWithCriteria:(PersistanceCriteria *)criteria error:(NSError **)error;

/**
 *  根据condition and conditionParams找到所有记录中的第一个条记录
 *
 *  @param condition       WHERE条件字句
 *  @param conditionParams 绑定的dic参数
 *  @param isDistinct      if YES, will use 'SELECT DISTINCT' clause
 */
- (NSObject <PersistanceRecordProtocol> *)findFirstRowWithWhereCondition:(NSString *)condition conditionParams:(NSDictionary *)conditionParams isDistinct:(BOOL)isDistinct error:(NSError **)error;

/**
 *  根据sql条件找到所有记录的第一条记录
 *
 *  @param sqlString sqlString
 *  @param params    绑定的dic参数
 */
- (NSObject <PersistanceRecordProtocol> *)findFirstRowWithSQL:(NSString *)sqlString params:(NSDictionary *)params error:(NSError **)error;

/**
 *  根据criteria条件找到所有记录的第一条记录
 */
- (NSObject <PersistanceRecordProtocol> *)findFirstRowWithCriteria:(PersistanceCriteria *)criteria error:(NSError **)error;

/**
 *  返回表中总记录数
 */
- (NSNumber *)countTotalRecord;

/**
 *  找到满足条件的记录数
 *
 *  @param whereCondition  WHERE条件子句
 *  @param conditionParams 绑定条件子句的dic参数
 */
- (NSNumber *)countWithWhereCondition:(NSString *)whereCondition conditionParams:(NSDictionary *)conditionParams error:(NSError **)error;

/**
 *  找到满足sqlString条件的记录数
 *
 *  @param sqlString sqlString条件
 *  @param params    绑定sqlString的dic参数
 */
- (NSDictionary *)countWithSQL:(NSString *)sqlString params:(NSDictionary *)params error:(NSError **)error;

/**
 *  根据指定主键找到record
 *
 *  @param primaryKeyValue 主键
 */
- (NSObject <PersistanceRecordProtocol> *)findWithPrimaryKey:(NSNumber *)primaryKeyValue error:(NSError **)error;

/**
 *  根据指定主键list找到相应的record list
 *
 *  @param primaryKeyValueList 主键list
 */
- (NSArray <NSObject <PersistanceRecordProtocol> *> *)findAllWithPrimaryKey:(NSArray <NSNumber *> *)primaryKeyValueList error:(NSError **)error;

@end
