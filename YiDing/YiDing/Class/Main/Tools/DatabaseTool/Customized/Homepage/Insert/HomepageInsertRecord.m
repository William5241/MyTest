//
//  HomepageInsertRecord.m
//  YiDing
//
//  Created by 韩伟 on 16/10/16.
//  Copyright © 2016年 韩伟. All rights reserved.
//

#import "HomepageInsertRecord.h"
#import "Persistance.h"
#import "HomepageTable.h"

@implementation HomepageInsertRecord

- (void)homepageInsertData:(NSDictionary *)dic {
    
    NSError *error = nil;
    //1.初始化table和record
    HomepageTable *homepageTable = [[HomepageTable alloc] init];
    HomepageRecord *homepageRecord = [HomepageRecord mj_objectWithKeyValues:dic];
    //2.删除指定userId和year的homepageRecord
    NSString *deleteSqlString = @"Delete FROM :tableName WHERE :userId = :targetUserId and :year = :targetYear";
    NSString *tableName = [homepageTable tableName];
    NSString *userId = @"userId";
    NSString *targetUserId = [NSString stringWithFormat:@"'%@'", homepageRecord.userId];
    NSString *year = @"year";
    NSString *targetYear = [NSString stringWithFormat:@"'%@'", homepageRecord.year];
    NSDictionary *params = NSDictionaryOfVariableBindings(tableName, userId, year, targetUserId, targetYear);
    [homepageTable deleteWithSql:deleteSqlString params:params error:&error];
    //3.插入相关记录
    [homepageTable insertRecord:homepageRecord error:&error];
}

@end
