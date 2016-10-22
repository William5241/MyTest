//
//  Dispatcher+HomepageActions.h
//  Kaoqian3.0
//
//  Created by wihan on 16/5/3.
//  Copyright © 2016年 wihan. All rights reserved.
//

#import "Dispatcher.h"

@interface Dispatcher (HomepageActions)

/**
 其他模块通过Dispatcher实例，调用如下方法实现：
 通过target Homepage启动并创建UIViewController的action

 @param params 需要传递的参数，这里使用基本数据类型dic，减轻耦合

 @return 返回调用者需要的UIViewController
 */
- (UIViewController *)dispatcher_viewControllerForHomepage:(NSDictionary *)params;

@end
