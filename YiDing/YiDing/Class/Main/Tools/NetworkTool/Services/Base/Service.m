//
//  Service.m
//  KoMovie
//
//  Created by hanwei on 15/6/20.
//  Copyright (c) 2015年 wihan. All rights reserved.
//

#import "Service.h"

@implementation Service

- (instancetype)init
{
    self = [super init];
    if (self) {
        if ([self conformsToProtocol:@protocol(ServiceProtocal)]) {
            self.child = (id<ServiceProtocal>)self;
        }
    }
    return self;
}

#pragma mark - getters and setters
- (NSString *)apiBaseUrl
{
    return self.child.isOnline ? self.child.onlineApiBaseUrl : self.child.offlineApiBaseUrl;
}

- (NSString *)apiVersion
{
    return self.child.isOnline ? self.child.onlineApiVersion : self.child.offlineApiVersion;
}

- (NSUInteger)apiType
{
    return self.child.isOnline ? self.child.onlineApiType : self.child.offlineApiType;
}

@end
