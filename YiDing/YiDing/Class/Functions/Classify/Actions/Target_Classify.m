//
//  Target_Classify.m
//  YiDing
//
//  Created by 韩伟 on 16/10/14.
//  Copyright © 2016年 韩伟. All rights reserved.
//

#import "Target_Classify.h"
#import "YDClassifyViewController.h"

@implementation Target_Classify

- (UIViewController *)action_nativeClassifyViewController:(NSDictionary *)params {
    
    YDClassifyViewController *viewController = [[YDClassifyViewController alloc] init];
    
    return viewController;
}

@end
