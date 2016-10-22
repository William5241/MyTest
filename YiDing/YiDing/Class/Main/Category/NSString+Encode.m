//
//  NSString+Encode.m
//  YiDing
//
//  Created by 韩伟 on 16/10/12.
//  Copyright © 2016年 韩伟. All rights reserved.
//

#import "NSString+Encode.h"
#import "NSData+CommonCrypto.h"

@implementation NSString (Encode)

+ (NSString *)string_md5HexDigest:(NSString*)input {
    
    const char* cStr = [input UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (uint32_t)strlen(cStr), result);
    
    NSMutableString *ret = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH];
    for (NSInteger i=0; i<CC_MD5_DIGEST_LENGTH; i++) {
        [ret appendFormat:@"%02x", result[i]];
    }
    return ret;
}

@end
