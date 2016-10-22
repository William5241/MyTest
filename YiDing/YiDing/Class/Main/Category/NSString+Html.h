//
//  NSString+Html.h
//  YiDing
//
//  Created by 韩伟 on 16/10/12.
//  Copyright © 2016年 韩伟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Html)

/**
 过滤html string中指定标签

 @param html 输入的html string

 @return 返回过滤后html string
 */
+ (NSString *)string_filterSpecifyHtml:(NSString *)html;

/**
 判断是否包含html标签

 @param html 输入的string

 @return YES:包含html标签
          NO:不包含html标签
 */
+ (BOOL)string_isIncludeHtml:(NSString *)html;

@end
