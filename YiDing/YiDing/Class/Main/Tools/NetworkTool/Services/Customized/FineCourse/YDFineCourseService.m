//
//  YDFineCourseService.m
//  YiDing
//
//  Created by ALLIN on 16/10/18.
//  Copyright © 2016年 韩伟. All rights reserved.
//

#import "YDFineCourseService.h"
#define SubUrl @"customer/collection/v3/getMapList"

#define UrlHomepageVersion @"v1/"
@implementation YDFineCourseService

#pragma mark - ServiceProtocal
- (BOOL)isOnline {
    
    return NO;
}

- (NSString *)onlineApiBaseUrl {
    
    return [NSString stringWithFormat:@"%@%@", @"http://192.168.1.174:18080/services/", SubUrl];
}

- (NSString *)onlineApiVersion {
    
    return UrlHomepageVersion;
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
