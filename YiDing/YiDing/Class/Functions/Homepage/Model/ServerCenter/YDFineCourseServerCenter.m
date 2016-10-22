//
//  YDFineCourseServerCenter.m
//  YiDing
//
//  Created by ALLIN on 16/10/18.
//  Copyright © 2016年 韩伟. All rights reserved.
//

#import "YDFineCourseServerCenter.h"
#import "YDFineCourseDataCenter.h"
#import "YDFineCourseManager.h"
@interface YDFineCourseServerCenter()
@property (nonatomic,strong) YDFineCourseDataCenter *dataCenter;
@end
@implementation YDFineCourseServerCenter
#pragma mark- public
- (void)requestFineCourseData{
    NSDictionary *dict = [self getRequestParamForceUpdate];
    
    YDFineCourseManager *manager = [[YDFineCourseManager alloc]initFineCourse:dict finished:^(BOOL succeeded, NSDictionary *userInfo) {
        [self fineCourseFinished:userInfo status:succeeded];
    }];
    self.currentReqId = [manager loadData];

}
#pragma mark- private
- (NSDictionary *)getRequestParamForceUpdate {
//    paramDic[@"forceUpdate"] = @"1";

//    NSMutableDictionary *dict =[NSMutableDictionary dictionary];
    NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:@"1460698250086",@"customerId",
                           @"1460698250086",@"sessionCustomerId",
                           [NSString stringWithFormat:@"%ld",(long)4],@"logoUseFlag",
                           [NSString stringWithFormat:@"%ld",(long)8],@"attUseFlag",
                           [NSString stringWithFormat:@"%ld",(long)7],@"collectionType",
                           [NSString stringWithFormat:@"%ld",(long)0],@"firstResult",
                           [NSString stringWithFormat:@"%ld",(long)20],@"maxResult",@"1",@"forceUpdate" ,nil];
    return dict;
}
- (void)fineCourseFinished:(NSDictionary *)userInfo status:(BOOL)succeeded {
    if (succeeded) {
        [self fineCourseSuccess:userInfo];
    }else{
        [self fineCourseFailed:userInfo];
    }
}

/**
 拉去成功处理
 
 @param userInfo 返回结果信息
 */
- (void)fineCourseSuccess:(NSDictionary *)userInfo {
    self.dataArray = [userInfo objectForKey:@"result"];
    BOOL success = FALSE;
    if (userInfo) {
        //1.将网络数据转化为本地model
//        self.fineCourseViewModel = [YDFineCourseViewModel objectWithKeyValues:userInfo];
        //2.处理成功数据
        if (self.delegate && [self.delegate respondsToSelector:@selector(getFineCourseDataSuccess)]) {
            [self.delegate getFineCourseDataSuccess];
            
            [self.delegate getFineCourseDataSuccess];
            //3.保存数据
//            [self.dataCenter saveHomepageData:userInfo];
            success = YES;
        }
    }
    //4.异常处理页面
    if (!success) {
//        [self homepageFailed:userInfo];
    }
}

/**
 处理失败数据
 
 @param userInfo 返回结果信息
 */
- (void)fineCourseFailed:(NSDictionary *)userInfo {
    
    //1.从数据库获取信息
//    self.fineCourseViewModel = [self.dataCenter homepageDataCenterFetch];
#warning test
//    [self.dataCenter saveHomepageData:userInfo];
    //2.更新页面数据
    if (self.delegate && [self.delegate respondsToSelector:@selector(getFineCourseDataFailed:)]) {
        [self.delegate getFineCourseDataFailed:userInfo];
    }
}

#pragma mark – getters and setters
- (YDFineCourseDataCenter *)dataCenter {
    
    if (_dataCenter == nil) {
        _dataCenter = [[YDFineCourseDataCenter alloc] init];
    }
    return _dataCenter;
}
@end
