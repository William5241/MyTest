//
//  NSString+Size.m
//  NearBar
//
//  Created by zhanghb on 15/1/2.
//  Copyright (c) 2015年 zhanghb. All rights reserved.
//

#import "NSString+Size.h"

@implementation NSString (Size)

- (CGSize)string_sizeWithFont:(UIFont *)font maxW:(CGFloat)maxW {
    
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = font;
    CGSize maxSize = CGSizeMake(maxW, MAXFLOAT);
    return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

- (CGSize)string_sizeWithFont:(UIFont *)font {
    
    return [self string_sizeWithFont:font maxW:MAXFLOAT];
}

- (NSUInteger)string_unicodeLengthOfString {
    
    NSUInteger strlength = 0;
    char* p = (char*)[self cStringUsingEncoding:NSUnicodeStringEncoding];
    for (NSUInteger i=0 ; i<[self lengthOfBytesUsingEncoding:NSUnicodeStringEncoding]; i++) {
        if (*p) {
            p++;
            strlength++;
        }
        else {
            p++;
        }
    }
    return (strlength+1)/2;
}

    
- (CGSize)string_sizeWithFontCompatible:(UIFont *)font constrainedToSize:(CGSize)size lineBreakMode:(NSLineBreakMode)lineBreakMode {
    
    if([self respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)] == YES)
    {
        NSDictionary *dictionaryAttributes = @{NSFontAttributeName:font,};
        CGRect stringRect = [self boundingRectWithSize:size
                                               options:NSStringDrawingUsesLineFragmentOrigin
                                            attributes:dictionaryAttributes
                                               context:nil];
        
        return CGSizeMake(ceil(stringRect.size.width), ceil(stringRect.size.height));
    }
    else
    {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        return [self sizeWithFont:font constrainedToSize:size lineBreakMode:lineBreakMode];
#pragma clang diagnostic pop
    }
}
@end
