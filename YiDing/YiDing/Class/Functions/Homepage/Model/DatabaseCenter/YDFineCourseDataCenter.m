//
//  YDFineCourseDataCenter.m
//  YiDing
//
//  Created by ALLIN on 16/10/18.
//  Copyright © 2016年 韩伟. All rights reserved.
//

#import "YDFineCourseDataCenter.h"

@implementation YDFineCourseDataCenter
- (void)saveFineCourseData:(NSDictionary *)userInfo {
    
    NSMutableDictionary * saveDic = [NSMutableDictionary new];
    saveDic[@"userId"] = @"123456";
    saveDic[@"year"] = @"2016";
    [self fineCourseDataCenterInsert:saveDic];
}

- (void)fineCourseDataCenterInsert:(NSDictionary *)dic {
    
//    HomepageInsertRecord *homepageInsertRecord = [HomepageInsertRecord new];
//    [homepageInsertRecord homepageInsertData:dic];
}

//- (YDHomepageViewModel *)homepageDataCenterFetch {

//    HomepageFetchRecord *homepageFetchRecord = [HomepageFetchRecord new];
//    HomepageRecord *homepageRecord = [homepageFetchRecord homepageFetchData];
//    if (homepageRecord) {
//        //1.根据返回的record，经过处理后返回需要的model
//        YDHomepageViewModel *homepageViewModel = [YDHomepageViewModel new];
//        return homepageViewModel;
//    }
//    else {
//        return nil;
//    }
//}

@end
