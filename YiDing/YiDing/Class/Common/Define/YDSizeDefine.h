//
//  YDSizeDefine.h
//  YiDing
//
//  Created by zhangbin on 16/10/20.
//  Copyright © 2016年 韩伟. All rights reserved.
//

#ifndef YDSizeDefine_h
#define YDSizeDefine_h


/**
 系统版本是否大于传入的值
 
 @param v 需比较的值

 @return 是否大于
 */
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

/**
    屏幕宽度
 */
#define PHONE_WIDTH ([[UIScreen mainScreen]bounds].size.width)
/**
    屏幕高度
 */
#define PHONE_HEIGH  ([UIApplication sharedApplication].statusBarFrame.size.height > 20 ? \
(([[UIScreen mainScreen] bounds].size.height - [UIApplication sharedApplication].statusBarFrame.size.height + 20)) : \
[[UIScreen mainScreen] bounds].size.height)

/**
    去掉电池栏剩下的高度
 */
#define SCREEN_WITHOUT_STATUS_HEIGHT (SCREEN_HEIGHT - [[UIApplication sharedApplication] statusBarFrame].size.height)


//============================== 适配 ==============================
/// 设计稿是5s 适配各种屏幕比例.
#define kScreenScaleWidth               [UIScreen mainScreen].bounds.size.width/320.0
#define kScreenScaleHeight              ([UIScreen mainScreen].bounds.size.height/568.0 == 1 ? \
1 : [UIScreen mainScreen].bounds.size.height/568.0)

#define kFitWidth_5(a)                  ((a) * (kScreenScaleWidth))
#define kFitHeight_5(a)                 ((a) * (kScreenScaleHeight))

/// 设计稿是6  适配各种屏幕比例.
#define kScreenNewScaleWidth            [UIScreen mainScreen].bounds.size.width/375.0
#define kScreenNewScaleHeight           ([UIScreen mainScreen].bounds.size.height/667.0 == 1 ? \
1 : [UIScreen mainScreen].bounds.size.height/667.0)

#define kFitWidth_6(a)                  ((a) * (kScreenNewScaleWidth))
#define kFitHeight_6(a)                 ((a) * (kScreenNewScaleHeight))




#endif /* YDSizeDefine_h */
