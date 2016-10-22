//
//  HomepageTable.m
//  YiDing
//
//  Created by 韩伟 on 16/10/16.
//  Copyright © 2016年 韩伟. All rights reserved.
//

#import "HomepageTable.h"

@implementation HomepageTable

#pragma mark - PersistanceTableProtocol
- (NSString *)tableName {
    
    return @"Homepage";
}

- (NSString *)databaseName {
    
    return @"YiDing.sqlite";
}

- (NSDictionary *)columnInfo {
    
    return @{
             @"primaryKey":@"INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL",
             @"userId":@"TEXT NOT NULL",
             @"year":@"TEXT NOT NULL"
             };
}

- (Class)recordClass {
    
    return [HomepageRecord class];
}

- (NSString *)primaryKeyName {
    
    return @"primaryKey";
}

- (void)modifyDatabaseName:(NSString *)databaseName {
    
}

@end
