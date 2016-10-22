//
//  PersistanceTable+Update.h
//  DongAoAcc
//
//  Created by wihan on 15/11/26.
//  Copyright © 2015年 wihan. All rights reserved.
//

#import "PersistanceTable.h"
#import "PersistanceRecord.h"

@interface PersistanceTable (Update)

/**
 *  更新相应记录
 */
- (void)updateRecord:(NSObject <PersistanceRecordProtocol> *)record error:(NSError **)error;

/**
 *  更新record list
 */
- (void)updateRecordList:(NSArray <NSObject <PersistanceRecordProtocol> *> *)recordList error:(NSError **)error;

/**
 *  根据条件更新record
 */
- (void)updateValue:(id)value forKey:(NSString *)key whereCondition:(NSString *)whereCondition whereConditionParams:(NSDictionary *)whereConditionParams error:(NSError **)error;

/**
 *  根据条件更新对应key的值
 *
 *  @param keyValueList         需要更新的key-values
 */
- (BOOL)updateKeyValueList:(NSDictionary *)keyValueList whereCondition:(NSString *)whereCondition whereConditionParams:(NSDictionary *)whereConditionParams error:(NSError **)error;

/**
 *  根据主键值，更新相应的key-value
 */
- (void)updateValue:(id)value forKey:(NSString *)key primaryKeyValue:(NSNumber *)primaryKeyValue error:(NSError **)error;

/**
 *  根据主键list，更新相应的key-value
 */
- (void)updateValue:(id)value forKey:(NSString *)key primaryKeyValueList:(NSArray <NSNumber *> *)primaryKeyValueList error:(NSError **)error;

/**
 *  根据主键值，更新 key-value list
 */
- (void)updateKeyValueList:(NSDictionary *)keyValueList primaryKeyValue:(NSNumber *)primaryKeyValue error:(NSError **)error;

/**
 *  根据主键值list，更新 key-value list
 */
- (void)updateKeyValueList:(NSDictionary *)keyValueList primaryKeyValueList:(NSArray <NSNumber *> *)primaryKeyValueList error:(NSError **)error;

@end
