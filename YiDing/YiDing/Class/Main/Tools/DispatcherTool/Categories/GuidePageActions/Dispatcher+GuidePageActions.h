//
//  Dispatcher+GuidePageActions.h
//  YiDing
//
//  Created by 韩伟 on 16/10/15.
//  Copyright © 2016年 韩伟. All rights reserved.
//

#import "Dispatcher.h"

@interface Dispatcher (GuidePageActions)

- (UIViewController *)dispatcher_viewControllerForGuidePage:(NSDictionary *)params;

@end
