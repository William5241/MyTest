//
//  NSURLRequest+NetworkingMethods.m
//  KoMovie
//
//  Created by hanwei on 15/6/17.
//  Copyright (c) 2015年 wihan. All rights reserved.
//

#import "NSURLRequest+NetworkingMethods.h"
#import <objc/runtime.h>

static void *NetworkingRequestParams;
static void *NetworkingRequestType;

@implementation NSURLRequest (AIFNetworkingMethods)

- (void)setRequestParams:(NSDictionary *)requestParams
{
    objc_setAssociatedObject(self, &NetworkingRequestParams, requestParams, OBJC_ASSOCIATION_COPY);
}

- (void)setRequestType:(NSUInteger)requestType
{
    NSNumber *typeNumber = [NSNumber numberWithUnsignedInteger:requestType];
    objc_setAssociatedObject(self, &NetworkingRequestType, typeNumber, OBJC_ASSOCIATION_ASSIGN);
}

- (NSDictionary *)requestParams
{
    return objc_getAssociatedObject(self, &NetworkingRequestParams);
}

- (NSUInteger)requestType
{
    NSNumber *typeNumber = objc_getAssociatedObject(self, &NetworkingRequestType);
    
    return typeNumber.unsignedIntegerValue;
}

@end
