//
//  Target_Profile.m
//  YiDing
//
//  Created by 韩伟 on 16/10/14.
//  Copyright © 2016年 韩伟. All rights reserved.
//

#import "Target_Profile.h"
#import "YDProfileViewController.h"

@implementation Target_Profile

- (UIViewController *)action_nativeProfileViewController:(NSDictionary *)params {
    
    YDProfileViewController *viewController = [[YDProfileViewController alloc] init];
    
    return viewController;
}

@end
