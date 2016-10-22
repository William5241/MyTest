//
//  ALStatisticsBase.h
//
//
//  Created by ZhangKaiChao on 16/5/10.
//  Copyright © 2016年 北京欧应信息技术有限公司. All rights reserved.
//

/**
 * @file        ALStatisticsBase.h
 * @brief       用于配置统计项.
 * @author      ZhangKaiChao
 * @version     1.0
 * @date        2016-05-10
 *
 */

/**
 触发方式
 */
typedef enum StatisticTriggerType {
    /**
     *  左击.
     */
    eTriggerTypeLeftClick = 1,
    /**
     *  右击.
     */
    eTriggerTypeRightClick = 2,
    /**
     *  上滑动.
     */
    eTriggerTypeUpScroll = 3,
    /**
     *  下滑动.
     */
    eTriggerTypeDownScroll = 4,
    /**
     *  左滑动.
     */
    eTriggerTypeLeftScroll = 5,
    /**
     *  右滑动.
     */
    eTriggerTypeRightScroll = 6,
    /**
     *  上拉加载.
     */
    eTriggerTypeUpLoad = 7,
    /**
     *  下拉加载.
     */
    eTriggerTypeDownLoad = 8,
    /**
     *  页面打开.
     */
    eTriggerTypeEnterV = 9,
    /**
     *  页面关闭.
     */
    eTriggerTypeExitV = 10,
    /**
     *  图片缩放.
     */
    eTriggerTypeScalImg = 16,
}StatisticTriggerType;

/**
 资源类型 1-视频，2-文库，3-会议，4-话题 ,6-标签，7-病例，8-评论
 */
typedef enum StatisticRefType {
    /**
     *  视频.
     */
    eStatisticRefTypeVideo = 1,
    /**
     *  文库.
     */
    eStatisticRefTypeDoc = 2,
    /**
     *  会议.
     */
    eStatisticRefTypeConference = 3,
    /**
     *  话题.
     */
    eStatisticRefTypeTopic = 4,
    /**
     *  标签.
     */
    eStatisticRefTypeTag = 6,
    /**
     *  病例.
     */
    eStatisticRefTypeCase = 7,
    /**
     *  评论.
     */
    eStatisticRefTypeReview = 8,
    /**
     *  医师.
     */
    eStatisticRefTypeUser = 9,
}StatisticRefType;



#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ALStatisticsConst.h"
#import "ALStatisticProtocal.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import "ALStatistics.h"
#import "MBProgressHUD.h"

/// 统计用 获取视图上文本信息.
@interface UIView (statistic)

/**
 *  统计用 获取视图上文本信息.
 *
 *  @return value
 */
- (NSString *)subViewsTextForStatistics;

@end


/// 配置统计项.
@interface ALStatisticsBase : NSObject

/**
 *  统计项.
 *
 *  @return value
 */
+ (NSDictionary *)statisticsBase;

/**
 *  hudview.
 *
 *  @return hudview
 */
+ (MBProgressHUD *)hudview;

@end
