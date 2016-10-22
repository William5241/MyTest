//
//  NSString+ReqularExpression.m
//  DongAoAcc
//
//  Created by wihan on 15/11/27.
//  Copyright © 2015年 wihan. All rights reserved.
//

#import "NSString+ReqularExpression.h"

@implementation NSString (ReqularExpression)

- (BOOL)isMatchWithRegularExpression:(NSString *)regularExpressionPattern
{
    NSError *error = nil;
    //1.设置string规则
    NSUInteger option = NSRegularExpressionCaseInsensitive | NSRegularExpressionDotMatchesLineSeparators | NSRegularExpressionUseUnixLineSeparators | NSRegularExpressionAnchorsMatchLines;
    //2.设置规则表达式
    NSRegularExpression *regularExpression = [NSRegularExpression regularExpressionWithPattern:regularExpressionPattern options:option error:&error];
    //3.返回当前string符合规则的数量，如果有符合的，就返回YES
    NSUInteger numberOfMatches = [regularExpression numberOfMatchesInString:self options:0 range:NSMakeRange(0, self.length)];
    if (numberOfMatches > 0) {
        return YES;
    } else {
        return NO;
    }
}

@end
