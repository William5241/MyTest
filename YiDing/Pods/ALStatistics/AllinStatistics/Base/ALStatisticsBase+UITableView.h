//
//  ALStatisticsBase+UITableView.h
//  AllinStatistics
//
//  Created by ZhangKaiChao on 16/7/5.
//  Copyright © 2016年 北京欧应信息技术有限公司. All rights reserved.
//

/**
 * @file        ALStatisticsBase+UIWebview.h
 * @brief       用于配置UIWebview统计.
 * @author      ZhangKaiChao
 * @version     1.0
 * @date        2016-07-05
 *
 */


#import "ALStatisticsBase.h"

// 用于配置UIWebview统计.
@interface ALStatisticsBase (UITableView)

/**
 *  UIWebview统计项
 *
 *  @return 业务统计数据组成的字典
 */
+ (NSDictionary *)statisticsUITableViewBase;

@end
