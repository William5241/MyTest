//
//  PersistanceTable.h
//  DongAoAcc
//
//  Created by wihan on 15/11/25.
//  Copyright © 2015年 wihan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PersistanceRecord.h"

@class PersistanceQueryCommand;

/**
 *  每一个table都用该遵循这个协议
 */
@protocol PersistanceTableProtocol <NSObject>
@required
/**
 *  返回数据库名字，PersistanceDatabasePool会通过名字创建数据库
 *
 *  @return 返回数据名字
 */
- (NSString *)databaseName;

/**
 *  返回表名
 *
 *  @return 返回表名
 */
- (NSString *)tableName;

/**
 *  返回表的column信息，如果表不存在，将会根据column信息创建表
 *
 *  @return 返回表的column信息
 */
- (NSDictionary *)columnInfo;

/**
 *  表中record的类型
 *
 *  PersistanceTable要转换data成你想要的record，可以通过这个方法制定类型
 *
 *  @return 返回record的类型
 */
- (Class)recordClass;

/**
 *  返回主键名字
 *
 *  @return 返回主键名字
 */
- (NSString *)primaryKeyName;

@optional
/**
 *  更改当前数据库名字
 *
 *  例如：进行数据迁移时，表将会创建一个PersistanceQueryCommand，但是PersistanceQueryCommand的数据库的名字和这个表不match，所以query command将会询问是否更改数据库
 *
 *  再如：有多个数据库，他们共享相同的表；如果你想当前的表工作在新的数据库上，则应该更改表的数据库的名字
 *
 *  @param newDatabaseName 新的表名字name.
 */
- (void)modifyDatabaseName:(NSString *)newDatabaseName;

/**
 *  在插入记录前，检测记录有效性
 *
 *  @param record 等待插入的record
 *
 *  @return return 返回NO不予插入
 */
- (BOOL)isCorrectToInsertRecord:(NSObject <PersistanceRecordProtocol> *)record;

/**
 *  在update前检测记录有效性
 *
 *  @param record 等待update的记录
 *
 *  @return return 返回NO不予update
 */
- (BOOL)isCorrectToUpdateRecord:(NSObject <PersistanceRecordProtocol> *)record;
@end

/**
 *  PersistanceTable用于操作records.
 *
 *  通过继承PersistanceTable来创建table object，并遵守PersistanceTableProtocol协议
 */
@interface PersistanceTable : NSObject

/**
 *  通过PersistanceQueryCommand创建表，不要通过这个方法创建表
 *
 *  @param queryCommand 查询命令
 *
 *  @return return 返回PersistanceTable实例
 */
- (instancetype)initWithQueryCommand:(PersistanceQueryCommand *)queryCommand;

/**
 *  child同self，通过他来检测table是否遵守PersistanceTableProtocol
 */
@property (nonatomic, weak) PersistanceTable <PersistanceTableProtocol> *child;

/**
 *  查询的command
 */
@property (nonatomic, strong, readonly) PersistanceQueryCommand *queryCommand;

/**
 *  对表执行sql语句
 *
 *  @return return 如果失败返回NO
 */
- (BOOL)executeSQL:(NSString *)sqlString error:(NSError **)error;

/**
 *  通过sql获取表中数据
 *
 *  @return return 如果失败返回NO
 */
- (NSArray *)fetchWithSQL:(NSString *)sqlString error:(NSError **)error;

@end
