//
//  Dispatcher+HomepageActions.m
//  Kaoqian3.0
//
//  Created by wihan on 16/5/3.
//  Copyright © 2016年 wihan. All rights reserved.
//

#import "Dispatcher+HomepageActions.h"

//Target name
NSString * const kDispatcherTargetHomepage = @"Homepage";
//Action name
NSString * const kDispatcherActionNativeHomepageViewController = @"nativeHomepageViewController";

@implementation Dispatcher (HomepageActions)

- (UIViewController *)dispatcher_viewControllerForHomepage:(NSDictionary *)params {
    
    //1.创建HomepageViewController
    UIViewController *viewController = [self performTarget:kDispatcherTargetHomepage
                                                    action:kDispatcherActionNativeHomepageViewController
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
