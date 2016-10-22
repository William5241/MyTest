//
//  PersistanceQueryCommand.h
//  DongAoAcc
//
//  Created by wihan on 15/11/26.
//  Copyright © 2015年 wihan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PersistanceDataBase.h"

/**
 *  PersistanceQueryCommand是SQL builder
 *
 *  @warning 不要自己试图创建他的实例
 *
 */
@interface PersistanceQueryCommand : NSObject

/**
 *  生成的sql
 */
@property (nonatomic, strong, readonly) NSMutableString *sqlString;

/**
 *  相关的数据库
 */
@property (nonatomic, weak, readonly) PersistanceDataBase *database;

/**
 *  通过数据库的名字创建PersistanceQueryCommand实例
 *
 *  @param databaseName 数据库的名字the name of database
 *
 *  @return return PersistanceQueryCommand
 *
 */
- (instancetype)initWithDatabaseName:(NSString *)databaseName;

/**
 *  通过数据库实例创建PersistanceQueryCommand
 *
 *  @param database 数据库实例
 *
 */
- (instancetype)initWithDatabase:(PersistanceDataBase *)database;

/**
 *  清除SQL string
 *
 *  @return return PersistanceQueryCommand
 */
- (PersistanceQueryCommand *)resetQueryCommand;

/**
 *  根据sqlString做execute操作
 */
- (BOOL)executeWithError:(NSError **)error;

/**
 *  根据sqlString fetch data
 *
 *  @return return 返回list
 */
- (NSArray <NSDictionary *> *)fetchWithError:(NSError **)error;

/**
 *  count data with sqlString
 *
 *  @param error error if fails
 *
 *  @return return count, return -1 if fails
 */
//- (NSNumber *)countWithError:(NSError **)error;

@end

