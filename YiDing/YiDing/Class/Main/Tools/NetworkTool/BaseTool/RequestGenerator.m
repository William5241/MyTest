//
//  RequestGenerator.m
//  KoMovie
//
//  Created by hanwei on 15/6/17.
//  Copyright (c) 2015年 wihan. All rights reserved.
//

#import <AdSupport/ASIdentifierManager.h>
#import "RequestGenerator.h"
#import "AFNetworking.h"
#import "NetworkingConfiguration.h"
#import "NSURLRequest+NetworkingMethods.h"
#import "Service.h"
#import "ServiceFactory.h"
#import "AppContext.h"
#import "NSDate+GetTimeMethods.h"
#import "CommonParameterTool.h"

@interface RequestGenerator ()

@property (nonatomic, strong) AFHTTPRequestSerializer *httpRequestSerializer;

@end

@implementation RequestGenerator
#pragma mark - getters and setters
- (AFHTTPRequestSerializer *)httpRequestSerializer
{
    if (_httpRequestSerializer == nil) {
        _httpRequestSerializer = [AFHTTPRequestSerializer serializer];
        _httpRequestSerializer.timeoutInterval = kNetworkingTimeoutSeconds;
        _httpRequestSerializer.cachePolicy = NSURLRequestUseProtocolCachePolicy;
    }
    return _httpRequestSerializer;
}

#pragma mark - public methods
+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    static RequestGenerator *sharedInstance = nil;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[RequestGenerator alloc] init];
    });
    return sharedInstance;
}

- (NSURLRequest *)generateGETRequestWithServiceIdentifier:(NSString *)serviceIdentifier requestParams:(NSDictionary *)requestParams methodName:(NSString *)methodName
{
    Service *service = [[ServiceFactory sharedInstance] serviceWithIdentifier:serviceIdentifier];
    NSDictionary *finalParams = [self appendVerifyInfo:requestParams isGet:YES apiType:service.apiType];
    NSString *urlString = [NSString stringWithFormat:@"%@?%@", service.apiBaseUrl, [finalParams urlParamsStringSignature:NO]];
    
    NSMutableURLRequest *request = [self.httpRequestSerializer requestWithMethod:@"GET" URLString:urlString parameters:nil error:NULL];
    request.timeoutInterval = kNetworkingTimeoutSeconds;
    request.requestParams = finalParams;
    //这里可以增加log
    return request;
}

- (NSURLRequest *)generatePOSTRequestWithServiceIdentifier:(NSString *)serviceIdentifier requestParams:(NSDictionary *)requestParams methodName:(NSString *)methodName
{
    Service *service = [[ServiceFactory sharedInstance] serviceWithIdentifier:serviceIdentifier];
    NSDictionary *finalParams = [self appendVerifyInfo:requestParams isGet:NO apiType:service.apiType];
    NSString *urlString = [NSString stringWithFormat:@"%@?%@", service.apiBaseUrl, [finalParams urlParamsStringSignature:NO]];
    
    NSURLRequest *request = [self.httpRequestSerializer requestWithMethod:@"POST" URLString:urlString parameters:finalParams error:NULL];
    request.requestParams = finalParams;
    return request;
}

- (NSURLRequest *)generateRestfulGETRequestWithServiceIdentifier:(NSString *)serviceIdentifier requestParams:(NSDictionary *)requestParams methodName:(NSString *)methodName
{
    Service *service = [[ServiceFactory sharedInstance] serviceWithIdentifier:serviceIdentifier];
    //1.Get请求将返回common+special参数拼成的json
    NSDictionary *finalParams = [self appendVerifyInfo:requestParams isGet:YES apiType:service.apiType];
    //2.拼装成url
    NSString *urlString = [NSString stringWithFormat:@"%@?%@", service.apiBaseUrl, [finalParams urlParamsStringSignature:NO]];
    
    NSDictionary *restfulHeader = [self commRESTHeadersWithService:service.apiType];
    //3.创建request
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:kNetworkingTimeoutSeconds];
    request.HTTPMethod = @"GET";
    [restfulHeader enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [request setValue:obj forHTTPHeaderField:key];
    }];
    //4.将参数传入request
    request.requestParams = finalParams;
    return request;
}

- (NSURLRequest *)generateRestfulPOSTRequestWithServiceIdentifier:(NSString *)serviceIdentifier requestParams:(NSDictionary *)requestParams methodName:(NSString *)methodName
{
    Service *service = [[ServiceFactory sharedInstance] serviceWithIdentifier:serviceIdentifier];
    //1.Post请求将返回common+special参数拼成的dic
    NSDictionary *finalParams = [self appendVerifyInfo:requestParams isGet:NO apiType:service.apiType];
    //2.Post请求url中不带任何参数
    NSString *urlString = [NSString stringWithFormat:@"%@", service.apiBaseUrl];
    NSDictionary *restfulHeader = [self commRESTHeadersWithService:service.apiType];
    //3.创建请求request
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:kNetworkingTimeoutSeconds];
    request.HTTPMethod = @"POST";
    request.requestType = service.requestType;
    [restfulHeader enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [request setValue:obj forHTTPHeaderField:key];
    }];
    //4.将参数传入request
    request.requestParams = finalParams;
    return request;
}

- (NSURLRequest *)generateRestfulPUTRequestWithServiceIdentifier:(NSString *)serviceIdentifier requestParams:(NSDictionary *)requestParams methodName:(NSString *)methodName
{
    Service *service = [[ServiceFactory sharedInstance] serviceWithIdentifier:serviceIdentifier];
    //1.Put请求将返回common+special参数拼成的dic
    NSDictionary *finalParams = [self appendVerifyInfo:requestParams isGet:NO apiType:service.apiType];
    //2.Post请求url中不带任何参数
    NSString *urlString = [NSString stringWithFormat:@"%@", service.apiBaseUrl];
    NSDictionary *restfulHeader = [self commRESTHeadersWithService:service.apiType];
    //3.创建请求request
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:kNetworkingTimeoutSeconds];
    request.HTTPMethod = @"PUT";
    request.requestType = service.requestType;
    [restfulHeader enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [request setValue:obj forHTTPHeaderField:key];
    }];
    //4.将参数传入request
    request.requestParams = finalParams;
    return request;
}

#pragma mark - private methods
- (NSDictionary *)commRESTHeadersWithService:(NSUInteger)apiTpye
{
    //根据项目规定设置head
    NSMutableDictionary *headerDic = [NSMutableDictionary dictionary];
    [headerDic setValue:@"gzip,deflate" forKey:@"Accept-Encoding"];
    
    return headerDic;
}

/**
 * 根据get or post请求获取common参数
 */
- (NSDictionary *)appendVerifyInfo:(NSDictionary *)params isGet:(BOOL)isGet apiType:(NSUInteger)apiTpye
{
    //1.将special参数存入requestParams中
    NSMutableDictionary *requestParams = [NSMutableDictionary new];
    if (params) {
        [requestParams addEntriesFromDictionary:params];
    }
    //2.设置通用参数，并存入requestParams中
    if (apiTpye == ServiceReqTypeNormarl) {
        //1.设备类型，0为iphone
        requestParams[@"visitSiteId"] = kDeviceType;
        //2.ios版本号
        NSString *appVersion = [kCurrentVersion stringByReplacingOccurrencesOfString:@"." withString:@""];
        requestParams[@"appVersion"] = appVersion;
        //3.外网ip
        requestParams[@"opIp"] = [CommonParameterTool sharedInstance].wanIpString;
        //4.设备硬件型号+软件版本
        NSString *deviceHardwareString = [[CommonParameterTool sharedInstance] getDeviceHardwareString];
        NSString * deviceInfo = [NSString stringWithFormat:@"无,%@,%@",
                                 deviceHardwareString,
                                 kDeviceSystemInfo];
        deviceInfo ? deviceInfo : (deviceInfo = @"无,无,无");
        requestParams[@"opAdvice"] = deviceInfo;
        //5.软件OS类型
        requestParams[@"osVersion"] = kOSVersion;
        //6.设备硬件型号
        requestParams[@"tVersion"] = deviceHardwareString;
        //7.当前网络状态
        requestParams[@"netVersion"] = [[CommonParameterTool sharedInstance] curNetStatus];
        //8.当前运营商
        requestParams[@"telecom"] = [[CommonParameterTool sharedInstance] carrierCode];
        
        //2.1如果是get请求，则将所有参数转成json
        //2.2如果非get请求，则直接返回common+special的requestParams
        if (isGet) {
            NSData * data = [NSJSONSerialization dataWithJSONObject:requestParams options:NSJSONWritingPrettyPrinted error:nil];
            requestParams = [NSMutableDictionary dictionaryWithObject:[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] forKey:@"queryJson"];
        }
    }
    return requestParams;
}

/**
 * 将请求参数requestParams，按照key值的字母顺序拼成如：userName=1234&password=1234的串，然后加salt取md5
 */
- (NSString *)getSignStr:(NSDictionary *)requestParams {
    NSString *signStr = @"";
    if (requestParams) {
        
        NSString *toMD5 = [requestParams combineDictionaryToString];
        toMD5 = [toMD5 stringByAppendingString:Md5Salt];
        signStr = [NSString string_md5HexDigest:toMD5];
    }
    
    return signStr;
}

/**
 * 将post请求的加密参数转成string格式（userName=1234&password=1234）
 */
- (NSString *)getBodyStr:(NSDictionary *)requestParams {
    __block NSString *bodyStr = @"";
    [requestParams.allKeys enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *bodyItem = nil;
        (idx==0) ? (bodyItem = [NSString stringWithFormat:@"%@=%@", obj, requestParams[obj]]) : (bodyItem = [NSString stringWithFormat:@"&%@=%@", obj, requestParams[obj]]);
        bodyStr = [bodyStr stringByAppendingString:bodyItem];
    }];
    return bodyStr;
}
@end
