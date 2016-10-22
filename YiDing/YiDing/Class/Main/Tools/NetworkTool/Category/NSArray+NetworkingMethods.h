//
//  NSArray+NetworkingMethods.h
//  KoMovie
//
//  Created by hanwei on 15/6/17.
//  Copyright (c) 2015年 wihan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (NetworkingMethods)

- (NSString *)paramsString;
- (NSString *)jsonString;
- (NSString *)combineArrayItems;

@end
