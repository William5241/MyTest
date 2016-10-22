//
//  AppContext.m
//  KoMovie
//
//  Created by hanwei on 15/6/17.
//  Copyright (c) 2015年 wihan. All rights reserved.
//

#import "AppContext.h"
#import "NetworkingConfiguration.h"
#import "AFNetworking.h"

@implementation AppContext

@synthesize appVersion = _appVersion;

#pragma mark - public methods
+ (instancetype)sharedInstance
{
    static AppContext *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[AppContext alloc] init];
    });
    return sharedInstance;
}

#pragma mark - getters and setters
- (BOOL)isReachable
{
    if ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus == AFNetworkReachabilityStatusUnknown) {
        return YES;
    } else {
        return [[AFNetworkReachabilityManager sharedManager] isReachable];
    }
}

- (NSString *)appVersion {
    if (!_appVersion) {
        NSDictionary *softwareInfo = [[NSDictionary alloc] initWithContentsOfFile:
                                      [NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] bundlePath], @"Info.plist"]];
        NSString *currentVersion = [softwareInfo objectForKey:@"CFBundleVersion"];
        _appVersion = [currentVersion copy];
    }
    return _appVersion;
}

@end
