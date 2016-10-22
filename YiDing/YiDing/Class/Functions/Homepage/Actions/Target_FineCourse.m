//
//  Target_FineCourse.m
//  YiDing
//
//  Created by ALLIN on 16/10/18.
//  Copyright © 2016年 韩伟. All rights reserved.
//

#import "Target_FineCourse.h"
#import "YDFineCourseViewController.h"
@implementation Target_FineCourse
- (UIViewController *)action_nativeFineCourseViewController:(NSDictionary *)params{
    YDFineCourseViewController *viewController = [[YDFineCourseViewController alloc] init];
    
    return viewController;
}

@end
