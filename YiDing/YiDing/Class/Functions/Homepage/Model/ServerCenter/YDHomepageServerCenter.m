//
//  YDHomepageServerCenter.m
//  YiDing
//
//  Created by 韩伟 on 16/10/15.
//  Copyright © 2016年 韩伟. All rights reserved.
//

#import "YDHomepageServerCenter.h"
#import "YDHomepageManager.h"
#import "YDHomepageDataCenter.h"

@interface YDHomepageServerCenter ()

//我的课程数据库center
@property (nonatomic, strong) YDHomepageDataCenter *homepageDataCenter;

@end

@implementation YDHomepageServerCenter

#pragma mark – public
- (void)requestHomepageData {
    
    NSDictionary *paramDic = [self getRequestParamForceUpdate];
    YDHomepageManager *homepageManager = [[YDHomepageManager alloc] initHomepage:paramDic finished:^(BOOL succeeded, NSDictionary *userInfo) {
        [self homepageFinished:userInfo status:succeeded];
    }];
    self.currentReqId = [homepageManager loadData];
}

#pragma mark – private
/**
 准备请求server数据
 注：由于有缓存机制，因此通过增加forceUpdate字段控制缓存使用

 @return 返回请求需要的dic
 */
- (NSDictionary *)getRequestParamForceUpdate {
    
    NSMutableDictionary *paramDic = [NSMutableDictionary new];
    paramDic[@"forceUpdate"] = @"1";
    paramDic[@"customerNum"] = @"6";
    paramDic[@"tagId"] = @"20513";
    paramDic[@"scene"] = @"2";
    paramDic[@"customerId"] = @"";
    paramDic[@"maxResult"] = @"1";
    paramDic[@"firstResult"] = @"0";
    
//    paramDic[@"passwd"] = @"123456";
//    paramDic[@"mobile"] = @"18101088884";
//    paramDic[@"deviceToken"] = @"";
    
//    paramDic[@"passwd"] = @"222222";
//    paramDic[@"customerId"] = @"1397790298504";
    
    return paramDic;
}

/**
 处理homepage数据返回结果

 @param userInfo  返回结果信息
 @param succeeded 是否成功标志
 */
- (void)homepageFinished:(NSDictionary *)userInfo status:(BOOL)succeeded {
    
    if (succeeded) {
        [self homepageSuccess:userInfo];
    }
    else {
        [self homepageFailed:userInfo];
    }
}

/**
 拉去成功处理

 @param userInfo 返回结果信息
 */
- (void)homepageSuccess:(NSDictionary *)userInfo {
    
    BOOL success = FALSE;
    if (userInfo) {
        //1.将网络数据转化为本地model
        self.homepageViewModel = [YDHomepageViewModel mj_objectWithKeyValues:userInfo];
        //2.处理成功数据
        if (self.delegate && [self.delegate respondsToSelector:@selector(getHomepageDataSuccess)]) {
            [self.delegate getHomepageDataSuccess];
            //3.保存数据
            [self.homepageDataCenter saveHomepageData:userInfo];
            success = YES;
        }
    }
    //4.异常处理页面
    if (!success) {
        [self homepageFailed:userInfo];
    }
}

/**
 处理失败数据

 @param userInfo 返回结果信息
 */
- (void)homepageFailed:(NSDictionary *)userInfo {
    
    //1.从数据库获取信息
    self.homepageViewModel = [self.homepageDataCenter homepageDataCenterFetch];
#warning test
    [self.homepageDataCenter saveHomepageData:userInfo];
    //2.更新页面数据
    if (self.delegate && [self.delegate respondsToSelector:@selector(getHomepageDataFailed:)]) {
        [self.delegate getHomepageDataFailed:userInfo];
    }
}

#pragma mark – getters and setters
- (YDHomepageDataCenter *)homepageDataCenter {
    
    if (_homepageDataCenter == nil) {
        _homepageDataCenter = [[YDHomepageDataCenter alloc] init];
    }
    return _homepageDataCenter;
}

@end
