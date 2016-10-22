//
//  Dispatcher+ClassifyActions.m
//  YiDing
//
//  Created by 韩伟 on 16/10/14.
//  Copyright © 2016年 韩伟. All rights reserved.
//

#import "Dispatcher+ClassifyActions.h"

//Target name
NSString * const kDispatcherTargetClassify = @"Classify";
//Action name
NSString * const kDispatcherActionNativeClassifyViewController = @"nativeClassifyViewController";

@implementation Dispatcher (ClassifyActions)

- (UIViewController *)dispatcher_viewControllerForClassify:(NSDictionary *)params {
    
    //1.创建ClassifyViewController
    UIViewController *viewController = [self performTarget:kDispatcherTargetClassify
                                                    action:kDispatcherActionNativeClassifyViewController
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
