//
//  YDHomepageDataCenter.m
//  YiDing
//
//  Created by 韩伟 on 16/10/16.
//  Copyright © 2016年 韩伟. All rights reserved.
//

#import "YDHomepageDataCenter.h"
#import "HomepageFetchRecord.h"
#import "HomepageInsertRecord.h"
#import "HomepageTable.h"

@implementation YDHomepageDataCenter

#pragma mark - public methods
- (void)saveHomepageData:(NSDictionary *)userInfo {
    
    NSMutableDictionary * saveDic = [NSMutableDictionary new];
    saveDic[@"userId"] = @"123456";
    saveDic[@"year"] = @"2016";
    [self homepageDataCenterInsert:saveDic];
}

- (void)homepageDataCenterInsert:(NSDictionary *)dic {
    
    HomepageInsertRecord *homepageInsertRecord = [HomepageInsertRecord new];
    [homepageInsertRecord homepageInsertData:dic];
}

- (YDHomepageViewModel *)homepageDataCenterFetch {
    
    HomepageFetchRecord *homepageFetchRecord = [HomepageFetchRecord new];
    HomepageRecord *homepageRecord = [homepageFetchRecord homepageFetchData];
    if (homepageRecord) {
        //1.根据返回的record，经过处理后返回需要的model
        YDHomepageViewModel *homepageViewModel = [YDHomepageViewModel new];
        return homepageViewModel;
    }
    else {
        return nil;
    }
}

@end
