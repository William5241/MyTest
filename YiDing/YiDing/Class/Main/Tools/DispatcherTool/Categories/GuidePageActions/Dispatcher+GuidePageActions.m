//
//  Dispatcher+GuidePageActions.m
//  YiDing
//
//  Created by 韩伟 on 16/10/15.
//  Copyright © 2016年 韩伟. All rights reserved.
//

#import "Dispatcher+GuidePageActions.h"

//Target name
NSString * const kDispatcherTargetGuidePage = @"GuidePage";
//Action name
NSString * const kDispatcherActionNativeGuidePageViewController = @"nativeGuidePageViewController";

@implementation Dispatcher (GuidePageActions)

- (UIViewController *)dispatcher_viewControllerForGuidePage:(NSDictionary *)params {
    
    //1.创建GuidePageViewController
    UIViewController *viewController = [self performTarget:kDispatcherTargetGuidePage
                                                    action:kDispatcherActionNativeGuidePageViewController
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
