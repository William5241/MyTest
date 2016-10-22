//
//  Dispatcher+WebViewActions.h
//  YiDing
//
//  Created by 韩伟 on 16/10/17.
//  Copyright © 2016年 韩伟. All rights reserved.
//

#import "Dispatcher.h"

@interface Dispatcher (WebViewActions)

- (UIViewController *)dispatcher_viewControllerForWebView:(NSDictionary *)params;

@end
