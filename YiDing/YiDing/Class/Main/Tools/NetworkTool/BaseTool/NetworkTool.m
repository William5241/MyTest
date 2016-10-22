//
//  NetworkTool.m
//  KoMovie
//
//  Created by hanwei on 15/6/17.
//  Copyright (c) 2015年 wihan. All rights reserved.
//

#import "NetworkTool.h"
#import "AFNetworking.h"
#import "RequestGenerator.h"
#import "Service.h"
#import "UIImage+CompressMethods.h"
#import "NSDate+GetTimeMethods.h"
#import "NetworkingConfiguration.h"
#import "NSURLRequest+NetworkingMethods.h"

static NSString * const kNetworkToolDispatchItemKeyCallbackSuccess = @"kNetworkToolDispatchItemKeyCallbackSuccess";
static NSString * const kNetworkToolDispatchItemKeyCallbackFail = @"kNetworkToolDispatchItemKeyCallbackFail";

typedef void(^responseHandle)(NSURLSessionDataTask * _Nonnull sessionDataTask, id  _Nullable responseObject);

@interface NetworkTool ()

@property (nonatomic, strong) NSMutableDictionary *dispatchTable;
@property (nonatomic, strong) NSNumber *recordedRequestId;
@property (nonatomic, strong) AFHTTPSessionManager *operationManager;
@property (nonatomic, copy) responseHandle successHandle;
@property (nonatomic, copy) responseHandle failedHandle;

@end

@implementation NetworkTool
#pragma mark - getters and setters
- (NSMutableDictionary *)dispatchTable
{
    if (_dispatchTable == nil) {
        _dispatchTable = [[NSMutableDictionary alloc] init];
    }
    return _dispatchTable;
}

- (AFHTTPSessionManager *)operationManager
{
    if (_operationManager == nil)  {
        _operationManager = [[AFHTTPSessionManager alloc] initWithBaseURL:nil];
        _operationManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    }
    return _operationManager;
}

#pragma mark - life cycle
+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    static NetworkTool *sharedInstance = nil;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[NetworkTool alloc] init];
    });
    return sharedInstance;
}

#pragma mark - public methods
- (NSInteger)callGETWithParams:(NSDictionary *)params serviceIdentifier:(NSString *)servieIdentifier methodName:(NSString *)methodName success:(ResponseCallback)success fail:(ResponseCallback)fail
{
    NSURLRequest *request = [[RequestGenerator sharedInstance] generateGETRequestWithServiceIdentifier:servieIdentifier requestParams:params methodName:methodName];
    NSNumber *requestId = [self callApiWithRequest:request success:success fail:fail];
    return [requestId integerValue];
}

- (NSInteger)callPOSTWithParams:(NSDictionary *)params serviceIdentifier:(NSString *)servieIdentifier methodName:(NSString *)methodName success:(ResponseCallback)success fail:(ResponseCallback)fail
{
    NSURLRequest *request = [[RequestGenerator sharedInstance] generatePOSTRequestWithServiceIdentifier:servieIdentifier requestParams:params methodName:methodName];
    NSNumber *requestId = [self callApiWithRequest:request success:success fail:fail];
    return [requestId integerValue];
}

- (NSInteger)callRestfulGETWithParams:(NSDictionary *)params serviceIdentifier:(NSString *)servieIdentifier methodName:(NSString *)methodName success:(ResponseCallback)success fail:(ResponseCallback)fail
{
    NSURLRequest *request = [[RequestGenerator sharedInstance] generateRestfulGETRequestWithServiceIdentifier:servieIdentifier requestParams:params methodName:methodName];
    NSNumber *requestId = [self callApiWithRequest:request success:success fail:fail];
    return [requestId integerValue];
}

- (NSInteger)callRestfulPOSTWithParams:(NSDictionary *)params serviceIdentifier:(NSString *)servieIdentifier methodName:(NSString *)methodName success:(ResponseCallback)success fail:(ResponseCallback)fail
{
    NSURLRequest *request = [[RequestGenerator sharedInstance] generateRestfulPOSTRequestWithServiceIdentifier:servieIdentifier requestParams:params methodName:methodName];
    NSNumber *requestId = [self callApiWithRequest:request success:success fail:fail];
    return [requestId integerValue];
}

- (NSInteger)callRestfulPUTWithParams:(NSDictionary *)params serviceIdentifier:(NSString *)servieIdentifier methodName:(NSString *)methodName success:(ResponseCallback)success fail:(ResponseCallback)fail
{
    NSURLRequest *request = [[RequestGenerator sharedInstance] generateRestfulPUTRequestWithServiceIdentifier:servieIdentifier requestParams:params methodName:methodName];
    NSNumber *requestId = [self callApiWithRequest:request success:success fail:fail];
    return [requestId integerValue];
}

- (void)cancelRequestWithRequestID:(NSNumber *)requestID
{
    NSURLSessionDataTask *sessionDataTask = self.dispatchTable[requestID];
    [sessionDataTask cancel];
    [self.dispatchTable removeObjectForKey:requestID];
}

- (void)cancelRequestWithRequestIDList:(NSArray *)requestIDList
{
    for (NSNumber *requestId in requestIDList) {
        [self cancelRequestWithRequestID:requestId];
    }
}

#pragma mark - private methods
/**
 * 这个函数存在的意义在于，如果将来要把AFNetworking换掉，
 * 只要修改这个函数的实现即可。
 */
- (NSNumber *)callApiWithRequest:(NSURLRequest *)request success:(ResponseCallback)success fail:(ResponseCallback)fail
{
    NSNumber *requestId = [self generateRequestId];
    //1.设置request请求类型json or http
    if (request.requestType == RequestSerializerTypeHTTP) {
        self.operationManager.requestSerializer = [AFHTTPRequestSerializer serializer];
    }
    else if (request.requestType == RequestSerializerTypeJSON) {
        self.operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    }
    //2.设置successHandle block和failedHandle block
    __weak __typeof(self)weakSelf = self;
    self.successHandle = ^(NSURLSessionDataTask * _Nonnull sessionDataTask, id  _Nullable responseObject) {
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        NSURLSessionDataTask *storedSessionDataTask = weakSelf.dispatchTable[requestId];
        if (storedSessionDataTask == nil) {
            // 如果这个urlSessionDataTask是被cancel的，那就不用处理回调了。
            return;
        } else {
            [weakSelf.dispatchTable removeObjectForKey:requestId];
        }
        //这里可以增加log信息
        NSString *contentString = [[NSString alloc] initWithData:(NSData *)responseObject  encoding:NSUTF8StringEncoding];
        URLResponse *response = [[URLResponse alloc] initWithResponseString:contentString
                                                                  requestId:requestId
                                                                    request:sessionDataTask.originalRequest
                                                               responseData:responseObject
                                                                     status:URLResponseStatusSuccess];
        success?success(response):nil;
    };
    
    self.failedHandle = ^(NSURLSessionDataTask * _Nullable sessionDataTask, NSError * _Nonnull error) {
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        NSURLSessionDataTask *storedSessionDataTask = weakSelf.dispatchTable[requestId];
        if (storedSessionDataTask == nil) {
            // 如果这个urlSessionDataTask是被cancel的，那就不用处理回调了。
            return;
        } else {
            [weakSelf.dispatchTable removeObjectForKey:requestId];
        }
        //这里可以增加log信息
        URLResponse *response = [[URLResponse alloc] initWithResponseString:nil
                                                                  requestId:requestId
                                                                    request:sessionDataTask.originalRequest
                                                               responseData:nil
                                                                      error:error];
        fail?fail(response):nil;
    };
    
    //3.根据request类型分别处理get，post，put请求
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    NSURLSessionDataTask *urlSessionDataTask = nil;
    if ([request.HTTPMethod isEqualToString:@"POST"]) {
        urlSessionDataTask = [self.operationManager POST:[request.URL absoluteString] parameters:request.requestParams
              progress:nil
                                                 success:^(NSURLSessionDataTask * _Nonnull sessionDataTask, id  _Nullable responseObject) {
                                                     self.successHandle(sessionDataTask,responseObject);
                                                 }
                                                 failure:^(NSURLSessionDataTask * _Nullable sessionDataTask, NSError * _Nonnull error) {
                                                  self.failedHandle(sessionDataTask,error);
                                                 }];
    }
    else if([request.HTTPMethod isEqualToString:@"GET"]) {
        urlSessionDataTask = [self.operationManager GET:[request.URL absoluteString] parameters:request.requestParams
                                                progress:^(NSProgress * _Nonnull uploadProgress) {
                                                }
                                                success:^(NSURLSessionDataTask * _Nonnull sessionDataTask, id  _Nullable responseObject) {
                                                    self.successHandle(sessionDataTask,responseObject);
                                                }
                                                failure:^(NSURLSessionDataTask * _Nullable sessionDataTask, NSError * _Nonnull error) {
                                                    self.failedHandle(sessionDataTask,error);
                                                }];
    }
    else if([request.HTTPMethod isEqualToString:@"PUT"]) {
        urlSessionDataTask = [self.operationManager PUT:[request.URL absoluteString] parameters:request.requestParams
                                                success:^(NSURLSessionDataTask * _Nonnull sessionDataTask, id  _Nullable responseObject) {
                                                    self.successHandle(sessionDataTask,responseObject);
                                                }
                                                failure:^(NSURLSessionDataTask * _Nullable sessionDataTask, NSError * _Nonnull error) {
                                                    self.failedHandle(sessionDataTask,error);
                                                }];
    }
    
    self.dispatchTable[requestId] = urlSessionDataTask;
    [urlSessionDataTask resume];
    return requestId;
}

/**
 *  上传文件，这里不需要组织request，POST方法自动生成request
 *  @param url 上传的地址
 *  @param postParams 提交参数据集合
 *  @param oriImage 原始image
 *  @param success 上传成功的block
 *  @param fail 上传失败的block
 */
- (NSInteger)uploadFileWithUrl: (NSString *)url
                    postParams: (NSDictionary *)postParams
                      oriImage: (UIImage *)oriImage
                       success: (ResponseCallback)success
                          fail: (ResponseCallback)fail {
    
    NSNumber *requestId = [[NetworkTool sharedInstance] generateRequestId];
    //1.请求参数+通用参数
    NSDictionary *commonParams = [[RequestGenerator sharedInstance] appendVerifyInfo:postParams isGet:NO apiType:ServiceReqTypeNormarl];
    //2.生成带有common参数的url
    NSString *urlString = [NSString stringWithFormat:@"%@?%@", url, [commonParams urlParamsStringSignature:NO]];
    
    //3.处理文件上传，urlString带有common参数的url，postParams通过body发送
    NSURLSessionDataTask *urlSessionDataTask = [self.operationManager POST:urlString parameters:postParams constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        //3.1获取文件data
        NSData *fileData = [UIImage getImageDataWithImage:oriImage];
        //3.2处理文件名字
        NSString *fileNameStr = nil;
        if (!fileNameStr) {
            fileNameStr = [NSDate getCurrentTime];
        }
        //3.3上传图片，以文件流的格式
        if (fileData) {
            
            [formData appendPartWithFileData:fileData name:@"file" fileName:[NSString stringWithFormat:@"%@.png",fileNameStr] mimeType:@"image/jpge, image/gif, image/jpeg, image/pjpeg, image/pjpeg, image/png"];
            //             [formData appendPartWithFileData:fileData name:@"file" fileName:[NSString stringWithFormat:@"%@.png",fileNameStr] mimeType:@"image/png"];
        }
    } progress:nil
   success:^(NSURLSessionDataTask *sessionDataTask, id responseObject) {
       
       NSURLSessionDataTask *storedSessionDataTask = self.dispatchTable[requestId];
       if (storedSessionDataTask == nil) {
           // 如果这个urlSessionDataTask是被cancel的，那就不用处理回调了。
           return;
       } else {
           [self.dispatchTable removeObjectForKey:requestId];
       }
       NSString *contentString = [[NSString alloc] initWithData:(NSData *)responseObject  encoding:NSUTF8StringEncoding];
       URLResponse *response = [[URLResponse alloc] initWithResponseString:contentString
                                                                 requestId:requestId
                                                                   request:sessionDataTask.originalRequest
                                                              responseData:responseObject
                                                                    status:URLResponseStatusSuccess];
       success?success(response):nil;
   } failure:^(NSURLSessionDataTask *sessionDataTask, NSError *error) {
       
       NSURLSessionDataTask *storedSessionDataTask = self.dispatchTable[requestId];
       if (storedSessionDataTask == nil) {
           // 如果这个urlSessionDataTask是被cancel的，那就不用处理回调了。
           return;
       } else {
           [self.dispatchTable removeObjectForKey:requestId];
       }
       
       //这里可以增加log信息
       
       URLResponse *response = [[URLResponse alloc] initWithResponseString:nil
                                                                 requestId:requestId
                                                                   request:sessionDataTask.originalRequest
                                                              responseData:nil
                                                                     error:error];
       fail?fail(response):nil;
   }];
    
    self.dispatchTable[requestId] = urlSessionDataTask;
    return [requestId integerValue];
}

- (NSNumber *)generateRequestId
{
    if (_recordedRequestId == nil) {
        _recordedRequestId = @(1);
    } else {
        if ([_recordedRequestId integerValue] == NSIntegerMax) {
            _recordedRequestId = @(1);
        } else {
            _recordedRequestId = @([_recordedRequestId integerValue] + 1);
        }
    }
    return _recordedRequestId;
}

- (NSURLSessionDataTask *)dataTaskWithRequest:(NSURLRequest *)request
                               uploadProgress:(nullable void (^)(NSProgress *uploadProgress)) uploadProgress
                             downloadProgress:(nullable void (^)(NSProgress *downloadProgress)) downloadProgress
                                      success:(void (^)(NSURLSessionDataTask *, id))success
                                      failure:(void (^)(NSURLSessionDataTask *, NSError *))failure
{
    __block NSURLSessionDataTask *dataTask = nil;
    dataTask = [self.operationManager dataTaskWithRequest:request
                                           uploadProgress:uploadProgress
                                         downloadProgress:downloadProgress
                                        completionHandler:^(NSURLResponse * __unused response, id responseObject, NSError *error) {
                                            if (error) {
                                                if (failure) {
                                                    failure(dataTask, error);
                                                }
                                            } else {
                                                if (success) {
                                                    success(dataTask, responseObject);
                                                }
                                            }
                                        }];
    
    return dataTask;
}

@end
