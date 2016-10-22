//
//  NSString+Encode.h
//  YiDing
//
//  Created by 韩伟 on 16/10/12.
//  Copyright © 2016年 韩伟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Encode)

/**
 将输入字符串转成md5

 @param input 源字符串

 @return 返回md5
 */
+ (NSString *)string_md5HexDigest:(NSString*)input;

@end
