//
//  Target_GuidePage.m
//  YiDing
//
//  Created by 韩伟 on 16/10/15.
//  Copyright © 2016年 韩伟. All rights reserved.
//

#import "Target_GuidePage.h"
#import "CMGuidePageViewController.h"

@implementation Target_GuidePage

- (UIViewController *)action_nativeGuidePageViewController:(NSDictionary *)params {
    
    CMGuidePageViewController *viewController = [[CMGuidePageViewController alloc] init];
    
    return viewController;
}

@end
