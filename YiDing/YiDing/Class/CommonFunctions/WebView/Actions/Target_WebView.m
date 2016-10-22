//
//  Target_WebView.m
//  YiDing
//
//  Created by 韩伟 on 16/10/17.
//  Copyright © 2016年 韩伟. All rights reserved.
//

#import "Target_WebView.h"
#import "CMWebViewController.h"

@implementation Target_WebView

- (UIViewController *)action_nativeWebViewViewController:(NSDictionary *)params {
    
    CMWebViewController *viewController = [[CMWebViewController alloc] init];
    
    return viewController;
}

@end
