//
//  PersistanceQueryCommand+SchemaManipulations.m
//  DongAoAcc
//
//  Created by wihan on 15/11/27.
//  Copyright © 2015年 wihan. All rights reserved.
//

#import "PersistanceQueryCommand+SchemaManipulations.h"

#import "PersistanceMarcos.h"
#import "PersistanceQueryCommand+ReadMethods.h"
#import "NSString+SQL.h"

@implementation PersistanceQueryCommand (SchemaManipulations)

- (PersistanceQueryCommand *)createTable:(NSString *)tableName columnInfo:(NSDictionary *)columnInfo
{
    [self resetQueryCommand];
    //1.检测表名字的有效性
    NSString *safeTableName = [tableName safeSQLMetaString];
    if (Persistance_isEmptyString(safeTableName)) {
        return self;
    }
    
    //2.组织建立创建表的sql语句
    NSMutableArray *columnList = [[NSMutableArray alloc] init];
    
    [columnInfo enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull columnName, NSString * _Nonnull columnDescription, BOOL * _Nonnull stop) {
        NSString *safeColumnName = columnName;
        NSString *safeDescription = columnDescription;
        
        if (Persistance_isEmptyString(safeDescription)) {
            [columnList addObject:[NSString stringWithFormat:@"`%@`", safeColumnName]];
        } else {
            [columnList addObject:[NSString stringWithFormat:@"`%@` %@", safeColumnName, safeDescription]];
        }
    }];
    
    NSString *columns = [columnList componentsJoinedByString:@","];
    [self.sqlString appendFormat:@"CREATE TABLE IF NOT EXISTS `%@` (%@);", safeTableName, columns];
    
    return self;
}

- (PersistanceQueryCommand *)dropTable:(NSString *)tableName
{
    [self resetQueryCommand];
    if (Persistance_isEmptyString(tableName)) {
        return self;
    }
    NSString *safeTableName = [tableName safeSQLMetaString];
    [self.sqlString appendFormat:@"DROP TABLE IF EXISTS `%@`;", safeTableName];
    return self;
}

- (PersistanceQueryCommand *)createIndex:(NSString *)indexName tableName:(NSString *)tableName indexedColumnList:(NSArray *)indexedColumnList condition:(NSString *)condition conditionParams:(NSDictionary *)conditionParams isUnique:(BOOL)isUnique
{
    [self resetQueryCommand];
    
    NSString *safeIndexName = [indexName safeSQLMetaString];
    NSString *safeTableName = [tableName safeSQLMetaString];
    if (Persistance_isEmptyString(safeTableName) || Persistance_isEmptyString(safeIndexName) || indexedColumnList == nil) {
        return self;
    }
    
    NSString *indexedColumnListString = [indexedColumnList componentsJoinedByString:@","];
    
    if (isUnique) {
        [self.sqlString appendFormat:@"CREATE UNIQUE INDEX IF NOT EXISTS "];
    } else {
        [self.sqlString appendFormat:@"CREATE INDEX IF NOT EXISTS "];
    }
    
    [self.sqlString appendFormat:@"`%@` ON `%@` (%@) ", safeIndexName, safeTableName, indexedColumnListString];
    
    return [self where:condition params:conditionParams];
}

- (PersistanceQueryCommand *)dropIndex:(NSString *)indexName
{
    [self resetQueryCommand];
    NSString *safeIndexName = [indexName safeSQLMetaString];
    [self.sqlString appendFormat:@"DROP INDEX IF EXISTS `%@`;", safeIndexName];
    return self;
}

- (PersistanceQueryCommand *)addColumn:(NSString *)columnName columnInfo:(NSString *)columnInfo tableName:(NSString *)tableName
{
    [self resetQueryCommand];
    NSString *safeColumnName = [columnName safeSQLMetaString];
    NSString *safeColumnInfo = [columnInfo safeSQLMetaString];
    NSString *safeTableName = [tableName safeSQLMetaString];
    
    if (Persistance_isEmptyString(safeTableName) || Persistance_isEmptyString(safeColumnInfo) || Persistance_isEmptyString(safeColumnName)) {
        return self;
    }
    
    [self.sqlString appendFormat:@"ALTER TABLE `%@` ADD COLUMN `%@` %@;", safeTableName, safeColumnName, safeColumnInfo];
    
    return self;
}

@end

