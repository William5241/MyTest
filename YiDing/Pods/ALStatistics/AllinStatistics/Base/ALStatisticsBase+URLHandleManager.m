//
//  ALStatisticsBase+URLHandleManager.m
//  AllinStatistics
//
//  Created by ZhangKaiChao on 16/7/6.
//  Copyright © 2016年 北京欧应信息技术有限公司. All rights reserved.
//

#import "ALStatisticsBase+URLHandleManager.h"

@implementation ALStatisticsBase (URLHandleManager)

/**
 *  URL打开app统计项
 *
 *  @return value
 */
+ (NSDictionary *)statisticsURLOpenBase {
    return @{
             kURLHandleManager:@[
                     
                     @{
                         kEventSelector: @"handleOpenURL:",
                         kEventHandlerBlock: ^( NSURL  * url) {
                             
                             NSString * triggerType = [NSString stringWithFormat:@"%zd",eTriggerTypeEnterV];
                             NSString * triggerName = [NSString stringWithFormat:@"method=handleOpenURL:"];

                             NSMutableDictionary * dicStatistic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                                                   triggerType,kTriggerType,
                                                                   triggerName,kTriggerName,
                                                                   @"",kActionId,
                                                                   [url absoluteString],kSrcLocation,
                                                                   @"",kToLocation,
                                                                   @"",kLocationId,
                                                                   @"",kRefType,
                                                                   @"",kRefId,nil];
                             
                             [[ALStatistics sharedStatistic] startUploadStatic:dicStatistic];
                             
                         }
                         }
                     ]
             
             };
}

@end
