//
//  Dispatcher+ProfileActions.h
//  YiDing
//
//  Created by 韩伟 on 16/10/14.
//  Copyright © 2016年 韩伟. All rights reserved.
//

#import "Dispatcher.h"

@interface Dispatcher (ProfileActions)

- (UIViewController *)dispatcher_viewControllerForProfile:(NSDictionary *)params;

@end
