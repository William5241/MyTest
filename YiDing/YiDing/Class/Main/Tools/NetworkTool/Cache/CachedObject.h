//
//  CachedObject.h
//  KoMovie
//
//  Created by hanwei on 15/6/17.
//  Copyright (c) 2015年 wihan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CachedObject : NSObject

@property (nonatomic, copy, readonly) NSData *content;
@property (nonatomic, copy, readonly) NSDate *lastUpdateTime;

@property (nonatomic, readonly) BOOL isOutdated;
@property (nonatomic, readonly) BOOL isEmpty;

- (instancetype)initWithContent:(NSData *)content;
- (void)updateContent:(NSData *)content;

@end
