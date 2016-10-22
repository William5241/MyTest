//
//  ALStatisticsBase+XHZoomingImageView.m
//  AllinStatistics
//
//  Created by ZhangKaiChao on 16/5/19.
//  Copyright © 2016年 北京欧应信息技术有限公司. All rights reserved.
//

#import "ALStatisticsBase+XHZoomingImageView.h"

@implementation ALStatisticsBase (XHZoomingImageView)

/**
 *  缩放图片统计项
 *
 *  @return 业务统计数据组成的字典
 */
+ (NSDictionary *)statisticsZoomScrollViewBase {
    return @{
             //
             @"XHZoomingImageView":@[
                     
                     @{
                         kEventSelector: @"scrollViewDidEndZooming:withView:atScale:",
                         kEventHandlerBlock: ^( UIScrollView *scrollView ) {

                             NSString * triggerName = [NSString stringWithFormat:@"method=scrollViewDidEndZooming:withView:atScale:"];

                             NSMutableDictionary * dicStatistic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                                                   [NSString stringWithFormat:@"%zd",eTriggerTypeScalImg],kTriggerType,
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
