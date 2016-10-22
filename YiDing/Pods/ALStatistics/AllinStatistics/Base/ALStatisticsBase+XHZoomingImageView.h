//
//  ALStatisticsBase+XHZoomingImageView.h
//  AllinStatistics
//
//  Created by ZhangKaiChao on 16/5/19.
//  Copyright © 2016年 北京欧应信息技术有限公司. All rights reserved.
//

/**
 * @file        ALStatisticsBase+XHZoomingImageView.h
 * @brief       用于配置图片缩放统计项.
 * @author      ZhangKaiChao
 * @version     1.0
 * @date        2016-05-10
 *
 */

#import "ALStatisticsBase.h"

/// 配置缩放图片统计项.
@interface ALStatisticsBase (XHZoomingImageView)

/**
 *  缩放图片统计项
 *
 *  @return 业务统计数据组成的字典
 */
+ (NSDictionary *)statisticsZoomScrollViewBase;

@end
