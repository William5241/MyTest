//
//  ALStatisticsBase+AllinRefreshView.m
//  AllinStatistics
//
//  Created by ZhangKaiChao on 16/5/19.
//  Copyright © 2016年 北京欧应信息技术有限公司. All rights reserved.
//

#import "ALStatisticsBase+AllinRefreshView.h"
#import "MJRefreshComponent.h"

@implementation ALStatisticsBase (AllinRefreshView)

/**
 *  列表上下拉统计项
 *
 *  @return value
 */
+ (NSDictionary *)statisticsListViewDragRefreshBase {
    return @{
             kMJRefreshComponent:@[
                     
                     @{
                         kEventSelector: @"beginRefreshing",
                         kEventHandlerBlock: ^( MJRefreshComponent * refreshView ) {
                             
                             NSString * triggerType = @"";
                             NSString * className = NSStringFromClass([refreshView class]);
                             if ([className isEqualToString:@"AllinHeaderRefresh"] ||
                                 [className isEqualToString:@"MDPHeaderRefresh"]) {
                                 // 下拉
                                 triggerType = [NSString stringWithFormat:@"%zd",eTriggerTypeDownLoad];
                             }else if ([className isEqualToString:@"AllinFooterRefresh"] ||
                                       [className isEqualToString:@"MDPFooterRefresh"]) {
                                 // 上拉
                                 triggerType = [NSString stringWithFormat:@"%zd",eTriggerTypeUpLoad];
                             }
                             
                             NSString * triggerName = @"method=beginRefreshing";
                             NSMutableDictionary * dicStatistic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                                                   triggerType,kTriggerType,
                                                                   triggerName,kTriggerName,
                                                                   @"",kActionId,
                                                                   @"",kSrcLocation,
                                                                   @"",kToLocation,
                                                                   @"",kLocationId,
                                                                   @"",kRefType,
                                                                   @"",kRefId,nil];
                             
                             if([refreshView conformsToProtocol:@protocol(ALStatisticRefreshViewProtocal)] &&
                                [refreshView respondsToSelector:@selector(statisticRefreshViewDic:)]) {
                                 
                                 NSDictionary * dic =
                                 [NSDictionary dictionaryWithObjectsAndKeys:@"beginRefreshing",kEventSelector,refreshView,kEventSender, nil];
                                 
                                 NSDictionary * tDic =
                                 [refreshView performSelector:@selector(statisticRefreshViewDic:) withObject:dic];
                                 
                                 dicStatistic[kTriggerName] = triggerName;
                                 dicStatistic[kActionId] = tDic[kActionId];
                                 dicStatistic[kToLocation] = tDic[kToLocation];
                                 dicStatistic[kLocationId] = tDic[kLocationId];
                                 dicStatistic[kRefType] = tDic[kRefType];
                                 dicStatistic[kRefId] = tDic[kRefId];
                             }
                             
                             [[ALStatistics sharedStatistic] startUploadStatic:dicStatistic];

                         }
                         }
                     ]
             
             };
}

@end
