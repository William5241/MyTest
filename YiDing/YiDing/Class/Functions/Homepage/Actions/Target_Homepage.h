//
//  Target_Homepage.h
//  YiDing
//
//  Created by 韩伟 on 16/10/14.
//  Copyright © 2016年 韩伟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Target_Homepage : NSObject

/**
 如下是targe Homepage中，action的具体实现；通过params初始化当前controller

 @param params 需要的参数，使用基本数据类型用来解耦；dic中可以
 包含基本数据类型，自定义的mode类型，block等；参数在当前
 方法中进行解析处理

 @return 返回调用者需要的UIViewController
 */
- (UIViewController *)action_nativeHomepageViewController:(NSDictionary *)params;

@end
