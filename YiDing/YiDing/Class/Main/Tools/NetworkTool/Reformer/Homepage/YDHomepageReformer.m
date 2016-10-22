//
//  YDHomepageReformer.m
//  YiDing
//
//  Created by 韩伟 on 16/10/15.
//  Copyright © 2016年 韩伟. All rights reserved.
//

#import "YDHomepageReformer.h"

@interface YDHomepageReformer ()

@property (nonatomic, copy, readwrite) NSString *serviceType;

@end

@implementation YDHomepageReformer

#pragma mark - init
- (id)initWithSubType:(NSString *)serviceType {
    
    if (self = [super init]) {
        _serviceType = serviceType;
    }
    return self;
}

+ (id)initHomepageReformer:(NSString *)serviceType {
    
    return [[self alloc] initWithSubType:serviceType];
}

#pragma mark - APIManagerCallbackDataReformer
- (id)manager:(APIBaseManager *)manager reformData:(NSDictionary *)data {
    
    if([self.serviceType isEqualToString:kServiceHomepage]){
        if (data) {
            NSMutableDictionary *resultDic = [NSMutableDictionary new];
            if (data[@"responseData"] && ![data[@"responseData"] isEqual:[NSNull null]]) {
                [resultDic addEntriesFromDictionary:data[@"responseData"]];
            }
            if (data[@"responseStatus"] && ![data[@"responseData"] isEqual:[NSNull null]]) {
                resultDic[@"responseStatus"] = data[@"responseStatus"];
            }
            
            return resultDic;
        }
    }
    
    return nil;
}

@end
