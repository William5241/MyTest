//
//  YDHomepageManager.m
//  YiDing
//
//  Created by 韩伟 on 16/10/15.
//  Copyright © 2016年 韩伟. All rights reserved.
//

#import "YDHomepageManager.h"
#import "YDHomepageReformer.h"

@interface YDHomepageManager ()
//Common params
@property (nonatomic, copy, readwrite) NSString *methodName;
@property (nonatomic, copy, readwrite) NSString *serviceType;
@property (nonatomic, assign, readwrite) APIManagerRequestType requestType;

//Request params
@property (nonatomic, strong, readwrite) NSDictionary *paramsDic;

@end

@implementation YDHomepageManager

#pragma mark - life cycle
- (instancetype)initHomepage:(NSDictionary *)params finished:(FinishDownLoadBlock)block {
    
    self = [super init];
    if (self) {
        _methodName = @"YDHomepageManager";
        _serviceType = kServiceHomepage;
        _requestType = APIManagerRequestTypeRestGet;
//        _requestType = APIManagerRequestTypeRestPost;
//        _requestType = APIManagerRequestTypeRestPut;
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
    
    if ([manager isKindOfClass:[YDHomepageManager class]]) {
        YDHomepageReformer *homepageReformer = [YDHomepageReformer initHomepageReformer:self.serviceType];
        NSDictionary *resultDic = [self fetchDataWithReformer:homepageReformer];
        //检测返回数据是否正确，如果code字段返回“1”则说明返回数据成功
        NSNumber *result = resultDic[@"responseStatus"];
        BOOL success = NO;
        if (result) {
            if (result && ([result integerValue] == 1)) {
                success = YES;
            }
        }
        [self doCallBack:success info:resultDic];
    }
}

- (void)managerCallAPIDidFailed:(APIBaseManager *)manager {
    
    if ([manager isKindOfClass:[YDHomepageManager class]]) {
        YDHomepageReformer *homepageReformer = [YDHomepageReformer initHomepageReformer:self.serviceType];
        NSDictionary *resultDic = [self fetchDataWithReformer:homepageReformer];
        [self doCallBack:NO info:resultDic];
    }
}

#pragma mark - APIManagerParamSourceDelegate
- (NSDictionary *)paramsForApi:(APIBaseManager *)manager {
    
    NSDictionary *params;
    if([self.serviceType isEqualToString:kServiceHomepage]){
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
