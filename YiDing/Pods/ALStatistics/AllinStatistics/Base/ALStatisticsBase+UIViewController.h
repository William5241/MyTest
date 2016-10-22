//
//  ALStatisticsBase+UIViewController.h
//  AllinStatistics
//
//  Created by ZhangKaiChao on 16/5/19.
//  Copyright © 2016年 北京欧应信息技术有限公司. All rights reserved.
//

/**
 * @file        AllinStatisticsBase+UIViewController.h
 * @brief       pv统计项.
 * @author      ZhangKaiChao
 * @version     1.0
 * @date        2016-05-10
 *
 */

#import "ALStatisticsBase.h"

/// 配置vc统计项.
@interface ALStatisticsBase (UIViewController)

/**
 *  vc统计项
 *
 *  @return 业务统计数据组成的字典
 */
+ (NSDictionary *)statisticsVCBase;

@end
