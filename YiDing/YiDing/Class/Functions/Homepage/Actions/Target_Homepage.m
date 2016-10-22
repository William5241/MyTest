//
//  Target_Homepage.m
//  YiDing
//
//  Created by 韩伟 on 16/10/14.
//  Copyright © 2016年 韩伟. All rights reserved.
//

/**
 1.这个类中可以包含调用者和当前模块的mode类型
 2.在这个类中，可以通过调用者传入的mode，整理当前模块需要的参数
 3.把所有依赖关系，集中在这个类中，从而解除了模块间的依赖关系
 */
#import "Target_Homepage.h"
#import "YDHomepageViewController.h"

@implementation Target_Homepage

- (UIViewController *)action_nativeHomepageViewController:(NSDictionary *)params {
    
    YDHomepageViewController *viewController = [[YDHomepageViewController alloc] init];
    
    return viewController;
}

@end
