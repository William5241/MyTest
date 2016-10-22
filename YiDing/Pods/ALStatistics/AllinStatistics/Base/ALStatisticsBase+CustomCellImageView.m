//
//  ALStatisticsBase+CustomCellImageView.m
//  AllinStatistics
//
//  Created by ZhangKaiChao on 16/5/26.
//  Copyright © 2016年 北京欧应信息技术有限公司. All rights reserved.
//

#import "ALStatisticsBase+CustomCellImageView.h"

@implementation ALStatisticsBase (CustomCellImageView)

/**
 *  九宫格图片点击统计项
 *
 *  @return 业务统计数据组成的字典
 */
+ (NSDictionary *)statisticsCustomCellImageViewBase {
    return @{
             
             kCustomCellImageView:@[
                     
                     @{
                         kEventSelector: @"gatherImageTap:",
                         kEventHandlerBlock: ^(id obj, UIGestureRecognizer * gestureRecognizer) {

                             NSString * triggerName = @"method=gatherImageTap:";

                             NSMutableDictionary * dicStatistic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                                                   [NSString stringWithFormat:@"%zd",eTriggerTypeLeftClick],kTriggerType,
                                                                   triggerName,kTriggerName,
                                                                   @"",kActionId,
                                                                   @"",kSrcLocation,
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
