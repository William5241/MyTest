//
//  NSString+Size.h
//  NearBar
//
//  Created by zhanghb on 15/1/2.
//  Copyright (c) 2015年 zhanghb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Size)

/**
 根据给定的最大宽度和字体，获取string size

 @param font 给定字体
 @param maxW 给定最大宽度

 @return 返回string所占size
 */
- (CGSize)string_sizeWithFont:(UIFont *)font maxW:(CGFloat)maxW;

/**
 根据给定字体，获取string size，默认最大宽度为MAXFLOAT

 @param font 给定字体

 @return 返回string所占size
 */
- (CGSize)string_sizeWithFont:(UIFont *)font;

/**
 计算混合中文字符串长度

 @return 返回混合中文字符串的长度
 */
- (NSUInteger)string_unicodeLengthOfString;

/**
 计算混合中文字符串长度
 
 @@param font 给定字体
 @param size 给定最大宽度
 @param lineBreakMode 类型
 
 @return 返回混合中文字符串的长度
 */
- (CGSize)string_sizeWithFontCompatible:(UIFont *)font constrainedToSize:(CGSize)size lineBreakMode:(NSLineBreakMode)lineBreakMode;
@end
