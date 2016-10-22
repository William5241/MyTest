//
//  NSDate+GetTimeMethods.m
//  BookQA
//
//  Created by wihan on 15/11/3.
//  Copyright © 2015年 wihan. All rights reserved.
//

#import "NSDate+GetTimeMethods.h"

@implementation NSDate (GetTimeMethods)

+ (NSString *)getCurrentTime {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMddHHmmss";
    NSString *timeStr = [formatter stringFromDate:[NSDate date]];
    return timeStr;
}

+ (NSString *)getTimeStamp {
    
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970]*1000;
    long long dTime = [[NSNumber numberWithDouble:time] longLongValue];
    NSString *timeStamp = [NSString stringWithFormat:@"%llu", dTime];
    return timeStamp;
}

+ (NSString *)getTimeRandom {
    
    int random = arc4random()%100;
    NSString *randomStr = [NSString stringWithFormat:@"%@%d", [self getTimeStamp], random];
    NSString *md5RadomStr = [NSString string_md5HexDigest:randomStr];
    return md5RadomStr;
}


@end
