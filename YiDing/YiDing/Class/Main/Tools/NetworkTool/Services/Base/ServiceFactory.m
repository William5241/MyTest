//
//  ServiceFactory.m
//  KoMovie
//
//  Created by hanwei on 15/6/20.
//  Copyright (c) 2015年 wihan. All rights reserved.
//

#import "ServiceFactory.h"
#import "YDHomepageService.h"
#import "YDFineCourseService.h"
//Homepage
NSString * const kServiceHomepage = @"kServiceHomepage";
// FineCourse
NSString *const kServiceFineCourse = @"kServiceFineCourse";
// 版本
NSString *const kServiceNetworkVersionCheck = @"kServiceNetworkVersionCheck";
// 上传图片
NSString *const kServiceUpLoadImage = @"kServiceUpLoadImage";

@interface ServiceFactory ()

@property (nonatomic, strong) NSMutableDictionary *serviceStorage;

@end

@implementation ServiceFactory

#pragma mark - life cycle
+ (instancetype)sharedInstance {
    
    static dispatch_once_t onceToken;
    static ServiceFactory *sharedInstance;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[ServiceFactory alloc] init];
    });
    return sharedInstance;
}

#pragma mark - public methods
- (Service<ServiceProtocal> *)serviceWithIdentifier:(NSString *)identifier {
    
    if (self.serviceStorage[identifier] == nil) {
        self.serviceStorage[identifier] = [self newServiceWithIdentifier:identifier];
    }
    return self.serviceStorage[identifier];
}

#pragma mark - private methods
- (Service<ServiceProtocal> *)newServiceWithIdentifier:(NSString *)identifier {

    if ([identifier isEqualToString:kServiceHomepage]) {
        YDHomepageService *homepageService = [[YDHomepageService alloc] init];
        return homepageService;
    }
    if ([identifier isEqualToString:kServiceFineCourse]) {
        YDFineCourseService *fineCourseService = [[YDFineCourseService alloc]init];
        return fineCourseService;
    }
    return nil;
}

#pragma mark - getters and setters
- (NSMutableDictionary *)serviceStorage {
    
    if (_serviceStorage == nil) {
        _serviceStorage = [[NSMutableDictionary alloc] init];
    }
    return _serviceStorage;
}
@end
