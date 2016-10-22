  //
//  APIBaseManager.m
//  KoMovie
//
//  Created by hanwei on 15/6/17.
//  Copyright (c) 2015年 wihan. All rights reserved.
//

#import "APIBaseManager.h"
#import "NetworkCache.h"
#import "AppContext.h"
#import "NetworkTool.h"
#import "NetworkingConfiguration.h"
#import "NSDictionary+NetworkingMethods.h"
#import "NSArray+NetworkingMethods.h"

//之所以写成宏，是为了拼接函数名称
#define CallAPI(REQUEST_METHOD, REQUEST_ID)                                                       \
{                                                                                       \
REQUEST_ID = [[NetworkTool sharedInstance] call##REQUEST_METHOD##WithParams:apiParams serviceIdentifier:self.child.serviceType methodName:self.child.methodName success:^(URLResponse *response) { \
[self successedOnCallingAPI:response];                                          \
} fail:^(URLResponse *response) {                                                \
[self failedOnCallingAPI:response withErrorType:APIManagerErrorTypeDefault];  \
}];                                                                                 \
[self.requestIdList addObject:@(REQUEST_ID)];                                          \
}

@interface APIBaseManager ()

@property (nonatomic, strong, readwrite) id fetchedRawData;

@property (nonatomic, copy, readwrite) NSString *errorMessage;
@property (nonatomic, readwrite) APIManagerErrorType errorType;
@property (nonatomic, strong) NSMutableArray *requestIdList;
@property (nonatomic, strong) NetworkCache *cache;

@end

@implementation APIBaseManager

#pragma mark - getters and setters
- (NetworkCache *)cache
{
    if (_cache == nil) {
        _cache = [NetworkCache sharedInstance];
    }
    return _cache;
}

- (NSMutableArray *)requestIdList
{
    if (_requestIdList == nil) {
        _requestIdList = [[NSMutableArray alloc] init];
    }
    return _requestIdList;
}

- (BOOL)isReachable
{
    BOOL isReachability = [AppContext sharedInstance].isReachable;
    if (!isReachability) {
        self.errorType = APIManagerErrorTypeNoNetWork;
    }
    return isReachability;
}

- (BOOL)isLoading
{
    return [self.requestIdList count] > 0;
}

#pragma mark - life cycle
- (instancetype)init
{
    self = [super init];
    if (self) {
        _delegate = nil;
        _validator = nil;
        _paramSource = nil;
        
        _fetchedRawData = nil;
        
        _errorMessage = nil;
        _errorType = APIManagerErrorTypeDefault;
        
        if ([self conformsToProtocol:@protocol(APIManager)]) {
            self.child = (NSObject<APIManager> *)self;
        }
    }
    return self;
}

- (void)dealloc
{
    [self cancelAllRequests];
    self.requestIdList = nil;
}

#pragma mark - public methods
- (void)cancelAllRequests
{
    [[NetworkTool sharedInstance] cancelRequestWithRequestIDList:self.requestIdList];
    [self.requestIdList removeAllObjects];
}

- (void)cancelRequestWithRequestId:(NSInteger)requestID
{
    [self removeRequestIdWithRequestID:requestID];
    [[NetworkTool sharedInstance] cancelRequestWithRequestID:@(requestID)];
}

- (id)fetchDataWithReformer:(id<APIManagerCallbackDataReformer>)reformer
{
    id resultData = nil;
    //如果后台返回异常的NSData类型，则为异常，返回nil
    if ([self.fetchedRawData isKindOfClass:[NSData class]]) {
        return resultData;
    }

    if ([reformer respondsToSelector:@selector(manager:reformData:)]) {
        resultData = [reformer manager:self reformData:self.fetchedRawData];
    } else {
        resultData = [self.fetchedRawData mutableCopy];
    }
    return resultData;
}

#pragma mark - calling api
- (NSInteger)loadData
{
    NSDictionary *params = [self.paramSource paramsForApi:self];
    NSInteger requestId = [self loadDataWithParams:params];
    return requestId;
}

- (NSInteger)loadDataWithParams:(NSDictionary *)params
{
    NSInteger requestId = 0;
    NSDictionary *apiParams = nil;
    //强制刷新标志，如果不为空则不是用缓存
    NSString *forceUpdate = params[@"forceUpdate"];
    //如果有强制刷新标记，则去除
    if (forceUpdate && ![forceUpdate compare:@"1"]) {
        NSMutableDictionary *finalDic = [NSMutableDictionary dictionaryWithDictionary:params];
        [finalDic removeObjectForKey:@"forceUpdate"];
        apiParams = [self reformParams:finalDic];
    }
    else {
        apiParams = [self reformParams:params];
    }

    if ([self shouldCallAPIWithParams:apiParams]) {
        if ([self.validator manager:self isCorrectWithParamsData:apiParams]) {
            
            // 先检查一下是否有缓存
            if ([self shouldCache] && [self hasCacheWithParams:apiParams] && !forceUpdate) {
                return 0;
            }
            
            // 实际的网络请求
            if ([self isReachable]) {
                switch (self.child.requestType)
                {
                    case APIManagerRequestTypeGet:
                        CallAPI(GET, requestId);
                        break;
                    case APIManagerRequestTypePost:
                        CallAPI(POST, requestId);
                        break;
                    case APIManagerRequestTypeRestGet:
                        CallAPI(RestfulGET, requestId);
                        break;
                    case APIManagerRequestTypeRestPost:
                        CallAPI(RestfulPOST, requestId);
                        break;
                    case APIManagerRequestTypeRestPut:
                        CallAPI(RestfulPUT, requestId);
                        break;
                    default:
                        break;
                }
                
                NSMutableDictionary *params = [apiParams mutableCopy];
                params[kAPIBaseManagerRequestID] = @(requestId);
                [self afterCallingAPIWithParams:params];
                return requestId;
                
            } else {
                [self failedOnCallingAPI:nil withErrorType:APIManagerErrorTypeNoNetWork];
                return requestId;
            }
        } else {
            [self failedOnCallingAPI:nil withErrorType:APIManagerErrorTypeParamsError];
            return requestId;
        }
    }
    return requestId;
}

- (NSInteger)uploadData
{
    NSDictionary *params = [self.paramSource paramsForApi:self];
    NSDictionary *postParams = params[@"postParams"];
    UIImage *oriImage = params[@"oriImage"];
    NSString *url = params[@"url"];
    
    NSInteger requestId = [self uploadDataWithUrl:url postParams:postParams oriImage:oriImage];
    return requestId;
}

/**
 * 根据上传地址url，上传参数postParams，上传image申请上传文件
 */
- (NSInteger)uploadDataWithUrl: (NSString *)url
                    postParams: (NSDictionary *)postParams
                      oriImage: (UIImage *)oriImage {
    
    NSInteger requestId = 0;
    
    if ([self shouldCallAPIWithParams:postParams]) {
        if ([self.validator manager:self isCorrectWithParamsData:postParams]) {

            // 实际的网络请求
            if ([self isReachable]) {
                // 上传文件
                requestId = [[NetworkTool sharedInstance] uploadFileWithUrl:url postParams:postParams oriImage:oriImage success:^(URLResponse *response) {
                    
                    [self successedOnUploadData:response];
                } fail:^(URLResponse *response) {
                    
                    [self failedOnCallingAPI:response withErrorType:APIManagerErrorTypeDefault];
                }];
                [self.requestIdList addObject:@(requestId)];
                
                NSMutableDictionary *params = [postParams mutableCopy];
                params[kAPIBaseManagerRequestID] = @(requestId);
                [self afterCallingAPIWithParams:params];
                return requestId;
                
            } else {
                [self failedOnCallingAPI:nil withErrorType:APIManagerErrorTypeNoNetWork];
                return requestId;
            }
        } else {
            [self failedOnCallingAPI:nil withErrorType:APIManagerErrorTypeParamsError];
            return requestId;
        }
    }
    return requestId;
}

#pragma mark - api callbacks
- (void)apiCallBack:(URLResponse *)response
{
    if (response.status == URLResponseStatusSuccess) {
        [self successedOnCallingAPI:response];
    }else{
        [self failedOnCallingAPI:response withErrorType:APIManagerErrorTypeTimeout];
    }
}

- (void)successedOnCallingAPI:(URLResponse *)response
{
    if (response.content) {
        self.fetchedRawData = [response.content copy];
    } else {
        self.fetchedRawData = [response.responseData copy];
    }
    [self removeRequestIdWithRequestID:response.requestId];
    if ([self.validator manager:self isCorrectWithCallBackData:response.content]) {
        
        if (kShouldCache && !response.isCache) {
            [self.cache saveCacheWithData:response.responseData serviceIdentifier:self.child.serviceType methodName:self.child.methodName requestParams:response.requestParams];
        }
        
        [self beforePerformSuccessWithResponse:response];
        [self.delegate managerCallAPIDidSuccess:self];
        [self afterPerformSuccessWithResponse:response];
    } else {
        [self failedOnCallingAPI:response withErrorType:APIManagerErrorTypeNoContent];
    }
}

- (void)successedOnUploadData:(URLResponse *)response
{
    if (response.content) {
        self.fetchedRawData = [response.content copy];
    } else {
        self.fetchedRawData = [response.responseData copy];
    }
    
    [self removeRequestIdWithRequestID:response.requestId];
    if ([self.validator manager:self isCorrectWithCallBackData:response.content]) {
        
        [self beforePerformSuccessWithResponse:response];
        [self.delegate managerCallAPIDidSuccess:self];
        [self afterPerformSuccessWithResponse:response];
    } else {
        [self failedOnCallingAPI:response withErrorType:APIManagerErrorTypeNoContent];
    }
}

- (void)failedOnCallingAPI:(URLResponse *)response withErrorType:(APIManagerErrorType)errorType
{
    if (response.content) {
        self.fetchedRawData = [response.content copy];
    } else {
        self.fetchedRawData = [response.responseData copy];
    }
    
    self.errorType = errorType;
    [self removeRequestIdWithRequestID:response.requestId];
    [self beforePerformFailWithResponse:response];
    [self.delegate managerCallAPIDidFailed:self];
    [self afterPerformFailWithResponse:response];
}

#pragma mark - method for interceptor

- (void)beforePerformSuccessWithResponse:(URLResponse *)response
{
    self.errorType = APIManagerErrorTypeSuccess;
    if (self != (APIBaseManager *)self.interceptor && [self.interceptor respondsToSelector:@selector(manager:beforePerformSuccessWithResponse:)]) {
        [self.interceptor manager:self beforePerformSuccessWithResponse:response];
    }
}

- (void)afterPerformSuccessWithResponse:(URLResponse *)response
{
    if (self != (APIBaseManager *)self.interceptor && [self.interceptor respondsToSelector:@selector(manager:afterPerformSuccessWithResponse:)]) {
        [self.interceptor manager:self afterPerformSuccessWithResponse:response];
    }
}

- (void)beforePerformFailWithResponse:(URLResponse *)response
{
    if (self != (APIBaseManager *)self.interceptor && [self.interceptor respondsToSelector:@selector(manager:beforePerformFailWithResponse:)]) {
        [self.interceptor manager:self beforePerformFailWithResponse:response];
    }
}

- (void)afterPerformFailWithResponse:(URLResponse *)response
{
    if (self != (APIBaseManager *)self.interceptor && [self.interceptor respondsToSelector:@selector(manager:afterPerformFailWithResponse:)]) {
        [self.interceptor manager:self afterPerformFailWithResponse:response];
    }
}

//只有返回YES才会继续调用API
- (BOOL)shouldCallAPIWithParams:(NSDictionary *)params
{
    if (self != (APIBaseManager *)self.interceptor && [self.interceptor respondsToSelector:@selector(manager:shouldCallAPIWithParams:)]) {
        return [self.interceptor manager:self shouldCallAPIWithParams:params];
    } else {
        return YES;
    }
}

- (void)afterCallingAPIWithParams:(NSDictionary *)params
{
    if (self != (APIBaseManager *)self.interceptor && [self.interceptor respondsToSelector:@selector(manager:afterCallingAPIWithParams:)]) {
        [self.interceptor manager:self afterCallingAPIWithParams:params];
    }
}

#pragma mark - method for child
- (void)cleanData
{
    IMP childIMP = [self.child methodForSelector:@selector(cleanData)];
    IMP selfIMP = [self methodForSelector:@selector(cleanData)];
    
    if (childIMP == selfIMP) {
        self.fetchedRawData = nil;
        self.errorMessage = nil;
        self.errorType = APIManagerErrorTypeDefault;
    } else {
        if ([self.child respondsToSelector:@selector(cleanData)]) {
            [self.child cleanData];
        }
    }
}

//如果需要在调用API之前额外添加一些参数，比如pageNumber和pageSize之类的就在这里添加
- (NSDictionary *)reformParams:(NSDictionary *)params
{
    IMP childIMP = [self.child methodForSelector:@selector(reformParams:)];
    IMP selfIMP = [self methodForSelector:@selector(reformParams:)];
    
    if (childIMP == selfIMP) {
        return params;
    } else {
        // 如果child是继承得来的，那么这里就不会跑到，会直接跑子类中的IMP。
        // 如果child是另一个对象，就会跑到这里
        NSDictionary *result = nil;
        result = [self.child reformParams:params];
        if (result) {
            return result;
        } else {
            return params;
        }
    }
}

- (BOOL)shouldCache
{
    return kShouldCache;
}

#pragma mark - private methods
- (void)removeRequestIdWithRequestID:(NSInteger)requestId
{
    NSNumber *requestIDToRemove = nil;
    for (NSNumber *storedRequestId in self.requestIdList) {
        if ([storedRequestId integerValue] == requestId) {
            requestIDToRemove = storedRequestId;
        }
    }
    if (requestIDToRemove) {
        [self.requestIdList removeObject:requestIDToRemove];
    }
}

- (BOOL)hasCacheWithParams:(NSDictionary *)params
{
    NSString *serviceIdentifier = self.child.serviceType;
    NSString *methodName = self.child.methodName;
    NSData *result = [self.cache fetchCachedDataWithServiceIdentifier:serviceIdentifier methodName:methodName requestParams:params];
    
    if (result == nil) {
        return NO;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        URLResponse *response = [[URLResponse alloc] initWithData:result];
        response.requestParams = params;
        [self successedOnCallingAPI:response];
    });
    return YES;
}

- (void)doCallBack:(BOOL)succeeded info:(id)info
{
    if (self.finishBlock) {
        dispatch_async(dispatch_get_main_queue(), ^{
                self.finishBlock(succeeded, info);
                self.finishBlock = nil;
        });
    }
}
@end
