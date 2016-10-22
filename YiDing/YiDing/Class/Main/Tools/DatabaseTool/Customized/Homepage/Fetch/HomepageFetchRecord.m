//
//  HomepageFetchRecord.m
//  YiDing
//
//  Created by 韩伟 on 16/10/16.
//  Copyright © 2016年 韩伟. All rights reserved.
//

#import "HomepageFetchRecord.h"
#import "Persistance.h"

@implementation HomepageFetchRecord

- (HomepageRecord *)homepageFetchData {
    
    HomepageTable *homepageTable = [[HomepageTable alloc] init];
    NSError *error = nil;
    
    NSString *fetchSqlString = @"Select * FROM :tableName WHERE :userId = :targetUserId and :year = :targetYear";
    NSString *tableName = [homepageTable tableName];
    NSString *userId = @"userId";
    NSString *year = @"year";
    NSString *targetUserId = [NSString stringWithFormat:@"'%@'", @"123456"];
    NSString *targetYear = [NSString stringWithFormat:@"'%@'", @"2016"];
    
    NSDictionary *params = NSDictionaryOfVariableBindings(tableName, userId, year, targetUserId, targetYear);
    NSArray *fetchedRecordList = [homepageTable findAllWithSQL:fetchSqlString params:params error:&error];
    if (fetchedRecordList && fetchedRecordList.count) {
        return fetchedRecordList[0];
    }
    else {
        return nil;
    }
}

@end
