//
//  PersistanceDataBase.h
//  DongAoAcc
//
//  Created by wihan on 15/11/25.
//  Copyright © 2015年 wihan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

/**
 *  FMDB sqlite3 database的封装
 */
@interface PersistanceDataBase : NSObject

/**
 *  sqlite3数据库实体
 */
@property (nonatomic, assign, readonly) sqlite3 *database;

/**
 *  数据库文件名字，如：dongaoAcc.sqlite
 */
@property (nonatomic, copy, readonly) NSString *databaseName;

/**
 *  数据库文件路径
 */
@property (nonatomic, copy, readonly) NSString *databaseFilePath;

/**
 *  根据databaseName创建并connect数据库.
 *
 *  1.文件创建在本地NSLibraryDirectory中。如果数据库文件不存在则创建
 *
 *  2.如果在PersistanceConfiguration.plist中记录了“数据库名字”和“Migrator类名字”，则这个方法会根据你指定的类名创建一个Migrator，并且如果数据库文件第一次创建，则再创建一个version table
 *
 *  3.如果migrator != nil, 这个方法将会检测是否每一次connect数据库时，都进行数据库迁移
 *
 *  @param databaseName 数据库文件名字
 *  @param error        错误
 *
 *  @return return 返回self
 */
- (instancetype)initWithDatabaseName:(NSString *)databaseName error:(NSError **)error;

/**
 *  关闭数据连接
 */
- (void)closeDatabase;

@end
