//
//  PersistanceMigrator.h
//  DongAoAcc
//
//  Created by wihan on 15/11/28.
//  Copyright © 2015年 wihan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PersistanceDataBase.h"
#import "PersistanceQueryCommand.h"
#import "PersistanceQueryCommand+DataManipulations.h"
#import "PersistanceQueryCommand+ReadMethods.h"
#import "PersistanceQueryCommand+SchemaManipulations.h"

/**
 *  这个协议用作数据库迁移
 */
@protocol PersistanceMigrationStep <NSObject>

/**
 *  回溯到上一个版本
 *
 *  如果你执行这个方法，可以将数据库迁移到上一个版本；如果error不是nil，将会调用goDownWithQueryCommand
 */
- (BOOL)goUpWithQueryCommand:(PersistanceQueryCommand *)queryCommand error:(NSError **)error;

/**
 *  迁移到下一个版本
 *
 *  当goUpWithQueryCommand失败，则会调用这个方法
 */
- (BOOL)goDownWithQueryCommand:(PersistanceQueryCommand *)queryCommand error:(NSError **)error;

@end

/**
 *  数据迁移实例继承自PersistanceMigrator，必须遵循PersistanceMigratorProtocol
 */
@protocol PersistanceMigratorProtocol <NSObject>

@required
/**
 *  迁移版本list
 */
- (NSArray *)migrationVersionList;

/**
 *  这个dic包含一些step对象，这些对象需要遵循PersistanceMigrationStep协议，这些对象一verison string为key
 */
- (NSDictionary *)migrationStepDictionary;

@end

/**
 *  迁移版本对象必须遵循PersistanceMigratorProtocol协议
 */
@interface PersistanceMigrator : NSObject

/**
 *  返回是否应该执行数据迁移
 */
- (BOOL)databaseShouldMigrate:(PersistanceDataBase *)database;

/**
 *  执行迁移步骤
 */
- (void)databasePerformMigrate:(PersistanceDataBase *)database;

/**
 *  如果version table不存在，则为数据库创建version table
 */
- (void)createVersionTableWithDatabase:(PersistanceDataBase *)database;

@end
