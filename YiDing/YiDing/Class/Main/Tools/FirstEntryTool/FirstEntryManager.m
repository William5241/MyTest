//
//  FirstEntryManager.m
//  YiDing
//
//  Created by 韩伟 on 16/10/15.
//  Copyright © 2016年 韩伟. All rights reserved.
//

#import "FirstEntryManager.h"
#import "Dispatcher+GuidePageActions.h"

@implementation FirstEntryManager

+ (void)firstEnterHandle {
    
    //如何知道是否是第一次使用这个版本？可以通过比较上次使用的版本进行判断
    //1.从沙盒中取出上次存储的软件版本号（取出用户上次的使用记录）
    NSString *versionKey = @"CFBundleShortVersionString";
    NSUserDefaults *defaults = [[NSUserDefaults alloc] init];
    NSString *lastVersion = [defaults objectForKey:versionKey];
    
    //2.获得当前打开软件的版本号
    NSString *currentVersion = kCurrentVersion;
    
    //3.当前版本号==上次使用的版本号
    if ([currentVersion isEqualToString:lastVersion])  {
        [kKQAppDelegate.window setRootViewController:kKQAppDelegate.tabBarViewController];
    }
    //4.当前版本号 != 上次使用的版本号：显示新版本的特性
    else {
        UIViewController *guidePageVC= [[Dispatcher sharedInstance] dispatcher_viewControllerForGuidePage:nil];
        [kKQAppDelegate.window setRootViewController:guidePageVC];
        //4.1存储这个使用的软件版本，并立刻写入
        [defaults setObject:currentVersion forKey:versionKey];
        [defaults synchronize];
    }
}

@end
