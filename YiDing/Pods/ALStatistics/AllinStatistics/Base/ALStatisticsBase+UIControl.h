//
//  ALStatisticsBase+UIControl.h
//  AllinStatistics
//
//  Created by ZhangKaiChao on 16/5/26.
//  Copyright © 2016年 北京欧应信息技术有限公司. All rights reserved.
//

/**
 * @file        ALStatisticsBase+UIControl.h
 * @brief       用于配置control统计项 (UIControl UIButton UITextfield).
 * @author      ZhangKaiChao
 * @version     1.0
 * @date        2016-05-26
 *
 */

#import "ALStatisticsBase.h"

/// 用于配置control统计项.
@interface ALStatisticsBase (UIControl)

/**
 *  UIControl统计项
 *
 *  @return 业务统计数据组成的字典
 */
+ (NSDictionary *)statisticsUIControlBase;

@end
