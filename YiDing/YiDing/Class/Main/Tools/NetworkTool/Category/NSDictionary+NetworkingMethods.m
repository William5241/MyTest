//
//  NSDictionary+NetworkingMethods.m
//  KoMovie
//
//  Created by hanwei on 15/6/17.
//  Copyright (c) 2015年 wihan. All rights reserved.
//

#import "NSDictionary+NetworkingMethods.h"
#import "NSArray+NetworkingMethods.h"

@implementation NSDictionary (NetworkingMethods)

/** 字符串前面是没有问号的，如果用于POST，那就不用加问号，如果用于GET，就要加个问号 */
- (NSString *)urlParamsStringSignature:(BOOL)isForSignature
{
    NSArray *sortedArray = [self transformedUrlParamsArraySignature:isForSignature];
    return [sortedArray paramsString];
}

/** 字典变json */
- (NSString *)jsonString
{
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:NULL];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

/** 转义参数 */
- (NSArray *)transformedUrlParamsArraySignature:(BOOL)isForSignature
{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if (![obj isKindOfClass:[NSString class]]) {
            obj = [NSString stringWithFormat:@"%@", obj];
        }
        if (!isForSignature) {
            obj = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,  (CFStringRef)obj,  NULL,  (CFStringRef)@"!*'();:@&;=+$,/?%#[]",  kCFStringEncodingUTF8));
        }
        if ([obj length] > 0) {
            [result addObject:[NSString stringWithFormat:@"%@=%@", key, obj]];
        }
    }];
    NSArray *sortedResult = [result sortedArrayUsingSelector:@selector(compare:)];
    return sortedResult;
}

//先按照key值排序，然后把对应的value值存入数组中
- (NSString *)combineDictionaryToString
{
    __block NSMutableArray *result = [[NSMutableArray alloc] init];
    //将Dictionary转化成key值在前的数组
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if (![obj isKindOfClass:[NSString class]]) {
            obj = [NSString stringWithFormat:@"%@", obj];
        }
        
        [result addObject:[NSString stringWithFormat:@"%@=%@", key, obj]];
    }];
    //排序数组
    NSArray *sortedResult = [result sortedArrayUsingSelector:@selector(compare:)];
    __block NSString *finalStr = @"";
    
    //组合成新的str,如：userName=1234&password=1234
    [sortedResult enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *paramString = (NSString *)obj;
        (idx == 0) ? (finalStr = paramString) : (finalStr = [finalStr stringByAppendingString:[NSString stringWithFormat:@"&%@", paramString]]);
    }];
    return finalStr;
}

@end
