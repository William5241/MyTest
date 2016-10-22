//
//  FirstEntryManager.h
//  YiDing
//
//  Created by 韩伟 on 16/10/15.
//  Copyright © 2016年 韩伟. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YDTabBarViewController.h"

@interface FirstEntryManager : NSObject

/**
 通过比较上次使用的版本进行判断，是否是第一次使用这个版本
 如果是第一次使用则开启轮播图，如果不是正常进入root controller
 */
+ (void)firstEnterHandle;
@end
