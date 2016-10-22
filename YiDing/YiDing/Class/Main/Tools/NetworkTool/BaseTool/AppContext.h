//
//  AppContext.h
//  KoMovie
//
//  Created by hanwei on 15/6/17.
//  Copyright (c) 2015年 wihan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppContext : NSObject

@property (nonatomic, readonly) BOOL isReachable;
@property (nonatomic, copy, readonly) NSString *appVersion;

+ (instancetype)sharedInstance;

@end
