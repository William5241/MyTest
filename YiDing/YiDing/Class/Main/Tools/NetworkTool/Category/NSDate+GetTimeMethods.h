//
//  NSDate+GetTimeMethods.h
//  BookQA
//
//  Created by wihan on 15/11/3.
//  Copyright © 2015年 wihan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (GetTimeMethods)

/**
 * 获取当前时间
 */
+ (NSString *)getCurrentTime;

/**
 *  返回当前时间戳string
 */
+ (NSString *)getTimeStamp;

/**
 *  根据时间戳返回随机数string
 */
+ (NSString *)getTimeRandom;
@end
