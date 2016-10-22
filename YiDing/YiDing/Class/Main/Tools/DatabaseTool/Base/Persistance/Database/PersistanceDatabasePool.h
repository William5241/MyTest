//
//  PersistanceDatabasePool.h
//  DongAoAcc
//
//  Created by wihan on 15/11/25.
//  Copyright © 2015年 wihan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PersistanceDataBase.h"

/**
 *  数据库池对象
 *
 *  不要自己创建这个对象，他会在你使用数据库时自动创建
 */
@interface PersistanceDatabasePool : NSObject

/**
 *  这是个单例模式
 */
+ (instancetype)sharedInstance;

/**
 *  根据数据库名字获取数据库实例，如果数据库没有创建，则创建它
 *
 *  @param databaseName 数据库文件名
 *
 *  @return return 返回数据库实例
 */
- (PersistanceDataBase *)databaseWithName:(NSString *)databaseName;

/**
 *  根据数据库名字，关闭数据库
 *
 *  @param databaseName 数据库文件名
 */
- (void)closeDatabaseWithName:(NSString *)databaseName;

/**
 *  关闭所有数据库
 */
- (void)closeAllDatabase;

@end

