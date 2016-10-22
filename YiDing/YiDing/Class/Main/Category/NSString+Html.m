//
//  NSString+Html.m
//  YiDing
//
//  Created by 韩伟 on 16/10/12.
//  Copyright © 2016年 韩伟. All rights reserved.
//

#import "NSString+Html.h"

@implementation NSString (Html)

+ (NSString *)string_filterSpecifyHtml:(NSString *)html {
    
    NSString *htmlStr = [html copy];
    htmlStr = [htmlStr stringByReplacingOccurrencesOfString:@"<p>" withString:@""];
    htmlStr = [htmlStr stringByReplacingOccurrencesOfString:@"</p>" withString:@""];
    htmlStr = [htmlStr stringByReplacingOccurrencesOfString:@"<br />" withString:@""];
    htmlStr = [htmlStr stringByReplacingOccurrencesOfString:@"<br/>" withString:@""];
    htmlStr = [htmlStr stringByReplacingOccurrencesOfString:@"<br>" withString:@""];
    
    return htmlStr;
}

+ (BOOL)string_isIncludeHtml:(NSString *)html {
    
    if([html rangeOfString:@"<"].location == NSNotFound && [html rangeOfString:@"/>"].location == NSNotFound) {
        return NO;
    }
    return YES;
}

@end
