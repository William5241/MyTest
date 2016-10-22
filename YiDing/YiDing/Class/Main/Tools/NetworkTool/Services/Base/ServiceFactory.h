//
//  ServiceFactory.h
//  KoMovie
//
//  Created by hanwei on 15/6/20.
//  Copyright (c) 2015年 wihan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Service.h"

@interface ServiceFactory : NSObject

+ (instancetype)sharedInstance;
- (Service<ServiceProtocal> *)serviceWithIdentifier:(NSString *)identifier;

@end
