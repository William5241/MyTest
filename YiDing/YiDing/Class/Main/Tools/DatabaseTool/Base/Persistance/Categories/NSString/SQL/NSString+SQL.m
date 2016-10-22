//
//  NSString+SafeSQL.m
//  DongAoAcc
//
//  Created by wihan on 15/11/27.
//  Copyright © 2015年 wihan. All rights reserved.
//

#import "NSString+SQL.h"

@implementation NSString (SQL)

- (NSString *)safeSQLEncode
{
    NSString *safeSQL = [self copy];
    safeSQL = [safeSQL stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
    safeSQL = [safeSQL stringByReplacingOccurrencesOfString:@";" withString:@""];
    return safeSQL;
}

- (NSString *)safeSQLDecode
{
    NSString *safeSQL = [self copy];
    //用"'"替换"\\'"
    safeSQL = [safeSQL stringByReplacingOccurrencesOfString:@"\\'" withString:@"'"];
    return safeSQL;
}

- (NSString *)safeSQLMetaString
{
    NSCharacterSet *charSet = [NSCharacterSet characterSetWithCharactersInString:@"'`"];
    return [[self componentsSeparatedByCharactersInSet:charSet] componentsJoinedByString:@""];
}

- (NSString *)stringWithSQLParams:(NSDictionary *)params
{
    NSMutableArray *keyList = [[NSMutableArray alloc] init];
    //1.设置正则表达式模板
    NSRegularExpression *expression = [NSRegularExpression regularExpressionWithPattern:@":[\\w]*" options:0 error:NULL];
    //2.获得match 这个表达式的string list
    NSArray *list = [expression matchesInString:self options:0 range:NSMakeRange(0, self.length)];
    //3.将list中的冒号去掉，再生成一个数组keyList
    [list enumerateObjectsUsingBlock:^(NSTextCheckingResult * _Nonnull checkResult, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *subString = [self substringWithRange:checkResult.range];
        [keyList addObject:[subString substringWithRange:NSMakeRange(1, subString.length-1)]];
    }];
    //4.将params dic中的值替换原有的加冒号的string，并返回
    NSMutableString *resultString = [self mutableCopy];
    [keyList enumerateObjectsUsingBlock:^(NSString * _Nonnull key, NSUInteger idx, BOOL * _Nonnull stop) {
        if (params[key]) {
            NSRegularExpression *expressionForReplace = [NSRegularExpression regularExpressionWithPattern:[NSString stringWithFormat:@":%@\\b", key] options:0 error:NULL];
            NSString *value = [NSString stringWithFormat:@"%@", params[key]];
            [expressionForReplace replaceMatchesInString:resultString options:0 range:NSMakeRange(0, resultString.length) withTemplate:value];
        }
    }];
    
    return resultString;
}

@end
