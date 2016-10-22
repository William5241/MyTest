//
//  Dispatcher+ProfileActions.m
//  YiDing
//
//  Created by 韩伟 on 16/10/14.
//  Copyright © 2016年 韩伟. All rights reserved.
//

#import "Dispatcher+ProfileActions.h"

//Target name
NSString * const kDispatcherTargetProfile = @"Profile";
//Action name
NSString * const kDispatcherActionNativeProfileViewController = @"nativeProfileViewController";

@implementation Dispatcher (ProfileActions)

- (UIViewController *)dispatcher_viewControllerForProfile:(NSDictionary *)params {
    
    //1.创建ProfileViewController
    UIViewController *viewController = [self performTarget:kDispatcherTargetProfile
                                                    action:kDispatcherActionNativeProfileViewController
                                                    params:params];
    //2.交付view controller，由外界选择是push还是present
    if ([viewController isKindOfClass:[UIViewController class]]) {
        return viewController;
    //3.这里处理异常场景，具体如何处理取决于产品，这里返回空白controller
    } else {
        return [[UIViewController alloc] init];
    }
}

@end
