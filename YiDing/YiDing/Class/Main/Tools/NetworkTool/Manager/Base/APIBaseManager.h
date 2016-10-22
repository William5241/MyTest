//
//  APIBaseManager.h
//  KoMovie
//
//  Created by hanwei on 15/6/17.
//  Copyright (c) 2015年 wihan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "URLResponse.h"

typedef void ( ^FinishDownLoadBlock )(BOOL succeeded, NSDictionary* userInfo);

//可以根据不同状态显示不同页面
typedef NS_ENUM (NSUInteger, APIManagerErrorType){
    APIManagerErrorTypeDefault,       //没有产生过API请求，这个是manager的默认状态。
    APIManagerErrorTypeSuccess,       //API请求成功。
    APIManagerErrorTypeNoContent,     //API请求成功但返回数据不正确
    APIManagerErrorTypeParamsError,   //参数错误
    APIManagerErrorTypeTimeout,       //请求超时
    APIManagerErrorTypeNoNetWork      //网络不通
};

//请求类型
typedef NS_ENUM (NSUInteger, APIManagerRequestType){
    APIManagerRequestTypeGet,//没有做header设置
    APIManagerRequestTypePost,//没有做header设置
    APIManagerRequestTypeRestGet,//可以做header设置
    APIManagerRequestTypeRestPost,//可以做header设置
    APIManagerRequestTypeRestPut,//可以做header设置
    APIManagerRequestTypeUploadPost//可以做header设置
};

@class APIBaseManager;

// 在调用成功之后的params字典里面，用这个key可以取出requestID
static NSString * const kAPIBaseManagerRequestID = @"kAPIBaseManagerRequestID";

//response的成功和失败的回调
@protocol APIManagerApiCallBackDelegate <NSObject>
@required
- (void)managerCallAPIDidSuccess:(APIBaseManager *)manager;
- (void)managerCallAPIDidFailed:(APIBaseManager *)manager;
@end

//这个函数可以返回每一个manager需要的，view可以直接使用的内容
@protocol APIManagerCallbackDataReformer <NSObject>
@required
- (id)manager:(APIBaseManager *)manager reformData:(NSDictionary *)data;
@end

//验证传进来的参数是否合法
@protocol APIManagerValidator <NSObject>
@required
//检测success/faild回调函数的参数是否有效
- (BOOL)manager:(APIBaseManager *)manager isCorrectWithCallBackData:(NSDictionary *)data;
//检测请求传入参数是否有效
- (BOOL)manager:(APIBaseManager *)manager isCorrectWithParamsData:(NSDictionary *)data;
@end

//在请求发起前，获取对应APIManager的参数
@protocol APIManagerParamSourceDelegate <NSObject>
@required
- (NSDictionary *)paramsForApi:(APIBaseManager *)manager;
@end

//派生类要符合这些协议
@protocol APIManager <NSObject>

@required
- (NSString *)methodName;
- (APIManagerRequestType)requestType;

@optional
//upload并没有通过serviceType处理
- (NSString *)serviceType;
- (void)cleanData;
- (NSDictionary *)reformParams:(NSDictionary *)params;
- (BOOL)shouldCache;

@end

//拦截器协议
@protocol APIManagerInterceptor <NSObject>

@optional
- (void)manager:(APIBaseManager *)manager beforePerformSuccessWithResponse:(URLResponse *)response;
- (void)manager:(APIBaseManager *)manager afterPerformSuccessWithResponse:(URLResponse *)response;

- (void)manager:(APIBaseManager *)manager beforePerformFailWithResponse:(URLResponse *)response;
- (void)manager:(APIBaseManager *)manager afterPerformFailWithResponse:(URLResponse *)response;

- (BOOL)manager:(APIBaseManager *)manager shouldCallAPIWithParams:(NSDictionary *)params;
- (void)manager:(APIBaseManager *)manager afterCallingAPIWithParams:(NSDictionary *)params;

@end


@interface APIBaseManager : NSObject

@property (nonatomic, weak) id<APIManagerApiCallBackDelegate> delegate;
@property (nonatomic, weak) id<APIManagerParamSourceDelegate> paramSource;
@property (nonatomic, weak) id<APIManagerValidator> validator;
@property (nonatomic, weak) NSObject<APIManager> *child; //里面会调用到NSObject的方法，所以这里不用id
@property (nonatomic, weak) id<APIManagerInterceptor> interceptor;

@property (nonatomic, copy, readonly) NSString *errorMessage;
@property (nonatomic, readonly) APIManagerErrorType errorType;

@property (nonatomic, assign, readonly) BOOL isReachable;
@property (nonatomic, assign, readonly) BOOL isLoading;

@property (nonatomic, copy, readwrite) FinishDownLoadBlock finishBlock;

//通过这个函数返回网络请求需要的参数
- (id)fetchDataWithReformer:(id<APIManagerCallbackDataReformer>)reformer;

//尽量使用loadData这个方法
- (NSInteger)loadData;

//上传图片到server使用这个方法
- (NSInteger)uploadData;

- (void)cancelAllRequests;
- (void)cancelRequestWithRequestId:(NSInteger)requestID;

// 拦截器方法，继承之后需要调用一下super
- (void)beforePerformSuccessWithResponse:(URLResponse *)response;
- (void)afterPerformSuccessWithResponse:(URLResponse *)response;

- (void)beforePerformFailWithResponse:(URLResponse *)response;
- (void)afterPerformFailWithResponse:(URLResponse *)response;

- (BOOL)shouldCallAPIWithParams:(NSDictionary *)params;
- (void)afterCallingAPIWithParams:(NSDictionary *)params;

- (NSDictionary *)reformParams:(NSDictionary *)params;
- (void)cleanData;
- (BOOL)shouldCache;

//回调处理好的response数据给上层
- (void)doCallBack:(BOOL)succeeded info:(id)info;

@end
