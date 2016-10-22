//
//  YDHomepageService.m
//  YiDing
//
//  Created by 韩伟 on 16/10/15.
//  Copyright © 2016年 韩伟. All rights reserved.
//

#import "YDHomepageService.h"

#define SubUrl @"recommend/tag/item/v3/getInformationByTagId"
//#define SubUrl @"customer/unite/login"
//#define SubUrl @"customer/resetpassword/update"
#define UrlHomepageVersion @"v3"

@implementation YDHomepageService

#pragma mark - ServiceProtocal
- (BOOL)isOnline {
    
    return YES;
}

- (NSString *)onlineApiBaseUrl {
    
    return [NSString stringWithFormat:@"%@%@", BaseUrl, SubUrl];
}

- (NSString *)onlineApiVersion {
    
    return UrlHomepageVersion;
}

- (RequestSerializerType)requestType {
    
    return RequestSerializerTypeJSON;
}

- (NSUInteger)onlineApiType {
    
    return ServiceReqTypeNormarl;
}

- (NSString *)offlineApiBaseUrl{
    
    return self.onlineApiBaseUrl;
}

- (NSString *)offlineApiVersion {
    
    return self.onlineApiVersion;
}

- (NSUInteger)offlineApiType {
    
    return self.onlineApiType;
}

@end
