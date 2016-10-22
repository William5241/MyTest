//
//  ALStatisticsBase+AllinRefreshView.h
//  AllinStatistics
//
//  Created by ZhangKaiChao on 16/5/19.
//  Copyright © 2016年 北京欧应信息技术有限公司. All rights reserved.
//

/**
 * @file        ALStatisticsBase+AllinRefreshView.h
 * @brief       配置列表上下拉统计项.
 * @author      ZhangKaiChao
 * @version     1.0
 * @date        2016-05-10
 *
 */

#import "ALStatisticsBase.h"

/// 配置列表上下拉统计项.
@interface ALStatisticsBase (AllinRefreshView)

/**
 *  列表上下拉统计项
 *
 *  @return value
 */
+ (NSDictionary *)statisticsListViewDragRefreshBase;

@end
