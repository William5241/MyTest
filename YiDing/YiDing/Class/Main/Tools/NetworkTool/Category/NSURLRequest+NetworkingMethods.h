//
//  NSURLRequest+NetworkingMethods.h
//  KoMovie
//
//  Created by hanwei on 15/6/17.
//  Copyright (c) 2015年 wihan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURLRequest (NetworkingMethods)

@property (nonatomic, copy) NSDictionary *requestParams;
@property (nonatomic, assign) NSUInteger requestType;

@end
