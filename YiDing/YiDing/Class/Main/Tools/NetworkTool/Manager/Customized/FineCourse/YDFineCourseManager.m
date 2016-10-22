//
//  YDFineCourseManager.m
//  YiDing
//
//  Created by ALLIN on 16/10/18.
//  Copyright © 2016年 韩伟. All rights reserved.
//

#import "YDFineCourseManager.h"
#import "YDFineCourseReformer.h"
@interface YDFineCourseManager()<APIManager, APIManagerApiCallBackDelegate, APIManagerParamSourceDelegate, APIManagerValidator>
//Common params
@property (nonatomic, copy, readwrite) NSString *methodName;
@property (nonatomic, copy, readwrite) NSString *serviceType;
@property (nonatomic, assign, readwrite) APIManagerRequestType requestType;

//Request params
@property (nonatomic, strong, readwrite) NSDictionary *paramsDic;
@end
@implementation YDFineCourseManager
#pragma mark - life cycle
- (instancetype)initFineCourse:(NSDictionary *)params finished:(FinishDownLoadBlock)block {
    
    self = [super init];
    if (self) {
        _methodName = @"YDFineCourseManager";
        _serviceType = kServiceFineCourse;
        _requestType = APIManagerRequestTypeRestGet;
        _paramsDic = params;
        
        self.finishBlock = block;
        self.delegate = self;
        self.paramSource = self;
        self.validator = self;
    }
    return self;
}

#pragma mark - APIManagerApiCallBackDelegate
- (void)managerCallAPIDidSuccess:(APIBaseManager *)manager {
    
    if ([manager isKindOfClass:[YDFineCourseManager class]]) {
        YDFineCourseReformer *reformer = [YDFineCourseReformer initFineCourseReformer:self.serviceType];
        NSDictionary *resultDic = [self fetchDataWithReformer:reformer];
        //检测返回数据是否正确，如果code字段返回“1”则说明返回数据成功
        NSDictionary *result = resultDic[@"result"];
        BOOL success = NO;
        if (result) {
            NSString *code =[NSString stringWithFormat:@"%@", resultDic[@"code"]];
            if (code && [code isEqualToString:@"1"]) {
                success = YES;
            }
        }
        [self doCallBack:success info:resultDic];
    }
}

- (void)managerCallAPIDidFailed:(APIBaseManager *)manager {
    
    if ([manager isKindOfClass:[YDFineCourseManager class]]) {
        YDFineCourseReformer *reformer = [YDFineCourseReformer initFineCourseReformer:self.serviceType];
        NSDictionary *resultDic = [self fetchDataWithReformer:reformer];
        [self doCallBack:NO info:resultDic];
    }
}

#pragma mark - APIManagerParamSourceDelegate
- (NSDictionary *)paramsForApi:(APIBaseManager *)manager {
    
    NSDictionary *params;
    if([self.serviceType isEqualToString:kServiceFineCourse]){
        params = _paramsDic;
    }
    
    return params;
}

#pragma mark - APIManagerValidator
- (BOOL)manager:(APIBaseManager *)manager isCorrectWithCallBackData:(NSDictionary *)data {
    
    return YES;
}

- (BOOL)manager:(APIBaseManager *)manager isCorrectWithParamsData:(NSDictionary *)data {
    
    return YES;
}
@end
