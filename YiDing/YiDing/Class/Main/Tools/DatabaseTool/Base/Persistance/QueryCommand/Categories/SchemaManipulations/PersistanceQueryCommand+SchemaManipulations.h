//
//  PersistanceQueryCommand+SchemaManipulations.h
//  DongAoAcc
//
//  Created by wihan on 15/11/27.
//  Copyright © 2015年 wihan. All rights reserved.
//

#import "PersistanceQueryCommand.h"

@interface PersistanceQueryCommand (SchemaManipulations)

/**
 *  根据column信息创建表
 */
- (PersistanceQueryCommand *)createTable:(NSString *)tableName columnInfo:(NSDictionary *)columnInfo;

/**
 *  删除指定名字的表
 */
- (PersistanceQueryCommand *)dropTable:(NSString *)tableName;

/**
 *  根据表名，columnName，columnInfo增加一个column
 */
- (PersistanceQueryCommand *)addColumn:(NSString *)columnName columnInfo:(NSString *)columnInfo tableName:(NSString *)tableName;

/**
 *  根据ColumnList创建一个index（一行）
 *  @param isUnique          YES, 创建唯一的index
 */
- (PersistanceQueryCommand *)createIndex:(NSString *)indexName tableName:(NSString *)tableName indexedColumnList:(NSArray *)indexedColumnList condition:(NSString *)condition conditionParams:(NSDictionary *)conditionParams isUnique:(BOOL)isUnique;

/**
 *  根据index name删除index
 */
- (PersistanceQueryCommand *)dropIndex:(NSString *)indexName;

@end
