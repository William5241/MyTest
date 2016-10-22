//
//  NSDictionary+NetworkingMethods.h
//  KoMovie
//
//  Created by hanwei on 15/6/17.
//  Copyright (c) 2015年 wihan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (NetworkingMethods)

- (NSString *)urlParamsStringSignature:(BOOL)isForSignature;
- (NSString *)jsonString;
- (NSArray *)transformedUrlParamsArraySignature:(BOOL)isForSignature;
- (NSString *)combineDictionaryToString;

@end
