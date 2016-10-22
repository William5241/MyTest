//
//  ALStatistics.H
//  AllinCommon
//
//  Created by ZhangKaiChao on 16/5/10.
//  Copyright © 2016年 北京欧应信息技术有限公司. All rights reserved.
//

/**
 * @file        ALStatistics.h
 * @brief       用于统计,每个要统计的类必须遵守相应协议 ALStatisticProtocal.h.
 * @author      ZhangKaiChao
 * @version     1.0
 * @date        2016-05-10
 *
 */

#import <Foundation/Foundation.h>
#import "AlStatisticsConst.h"
#import "AlStatisticsBase.h"
#import "MOAspects.h"

/// 统计分析.
@interface ALStatistics : NSObject

/**
 *  单例
 *
 *  @return value
 */
+ (instancetype)sharedStatistic;

/**
*  初始化统计
*
*  @param delegate 代理
*/
- (void)setupStatistics:(id)delegate;

/**
 *  开启打印日至
 */
- (void)openLog;


/**
 *  上传埋点数据.
 *
 *  @param dicParam 埋点数据参数
 */
- (void)startUploadStatic:(NSDictionary *)dicParam;

@end
