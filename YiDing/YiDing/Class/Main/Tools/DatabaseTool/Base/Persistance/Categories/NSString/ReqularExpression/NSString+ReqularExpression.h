//
//  NSString+ReqularExpression.h
//  DongAoAcc
//
//  Created by wihan on 15/11/27.
//  Copyright © 2015年 wihan. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  标准表达式的处理
 */
@interface NSString (ReqularExpression)
/**
 *  检测string是否符合标准表达模板
 *
 *  模板：
    每个单子都是独立的case
    NSRegularExpressionCaseInsensitive |
    容许(.)match任意一个字符，包括行分割符
    NSRegularExpressionDotMatchesLineSeparators |
    仅使用(\n)作为行分隔符
    NSRegularExpressionUseUnixLineSeparators | 
    容许(^)和($)作为行的开始与结束
    NSRegularExpressionAnchorsMatchLines
 */
- (BOOL)isMatchWithRegularExpression:(NSString *)regularExpressionPattern;

@end
