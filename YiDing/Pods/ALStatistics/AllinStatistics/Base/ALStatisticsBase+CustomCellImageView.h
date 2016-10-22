//
//  ALStatisticsBase+CustomCellImageView.h
//  AllinStatistics
//
//  Created by ZhangKaiChao on 16/5/26.
//  Copyright © 2016年 北京欧应信息技术有限公司. All rights reserved.
//

/**
 * @file        ALStatisticsBase+CustomCellImageView.h
 * @brief       九宫格图片点击统计项.
 * @author      ZhangKaiChao
 * @version     1.0
 * @date        2016-05-26
 *
 */

#import "ALStatisticsBase.H"

@interface ALStatisticsBase (CustomCellImageView)

/**
 *  九宫格图片点击统计项
 *
 *  @return 业务统计数据组成的字典
 */
+ (NSDictionary *)statisticsCustomCellImageViewBase;

@end
