//
//  Service.h
//  KoMovie
//
//  Created by hanwei on 15/6/20.
//  Copyright (c) 2015年 wihan. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum{
    ServiceReqTypeNormarl = 0,
    ServiceReqTypeOther
} ServiceReqType;

typedef enum{
    RequestSerializerTypeHTTP = 0,
    RequestSerializerTypeJSON
} RequestSerializerType;

// 所有Service的派生类都要符合这个protocal，这里是在线和离线资源
@protocol ServiceProtocal <NSObject>

@property (nonatomic, readonly) BOOL isOnline;

@property (nonatomic, copy, readonly) NSString *offlineApiBaseUrl;
@property (nonatomic, copy, readonly) NSString *onlineApiBaseUrl;

@property (nonatomic, copy, readonly) NSString *offlineApiVersion;
@property (nonatomic, copy, readonly) NSString *onlineApiVersion;

@property (nonatomic, readonly) NSUInteger offlineApiType;
@property (nonatomic, readonly) NSUInteger onlineApiType;
@property (nonatomic, readonly) RequestSerializerType requestType;

@end

@interface Service : NSObject

@property (nonatomic, strong, readonly) NSString *apiBaseUrl;
@property (nonatomic, strong, readonly) NSString *apiVersion;
@property (nonatomic, assign, readonly) NSUInteger apiType;
@property (nonatomic, assign, readonly) RequestSerializerType requestType;

@property (nonatomic, weak) id<ServiceProtocal> child;

@end
