//
//  ALStatisticsBase+UIControl.m
//  AllinStatistics
//
//  Created by ZhangKaiChao on 16/5/26.
//  Copyright © 2016年 北京欧应信息技术有限公司. All rights reserved.
//

#import "ALStatisticsBase+UIControl.h"

@implementation ALStatisticsBase (UIControl)

/**
 *  UIControl统计项
 *
 *  @return 业务统计数据组成的字典
 */
+ (NSDictionary *)statisticsUIControlBase {
    return @{
             //
             kUIControl:@[
                     
                     @{
                         kEventSelector: @"sendAction:to:forEvent:",
                         kEventHandlerBlock: ^(id obj, SEL sel , id target , UIEvent * event) {
                             
                             UIControl * sender = (UIControl *)obj;
                             
                             NSString * triggerName = @"";
                             
//                             NSString * text = [obj subViewsTextForStatistics];
//                             if(text && text.length) {
//                                 triggerName = [obj subViewsTextForStatistics];
//                             } else {
                                 triggerName = [NSString stringWithFormat:@"method=%@,flag=%zd",
                                                NSStringFromSelector(sel),
                                                sender.tag];
//                             }
                             
                             NSMutableDictionary * dicStatistic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                                                   [NSString stringWithFormat:@"%zd",eTriggerTypeLeftClick],kTriggerType,
                                                                   triggerName,kTriggerName,
                                                                   @"",kActionId,
                                                                   @"",kSrcLocation,
                                                                   @"",kToLocation,
                                                                   @"",kLocationId,
                                                                   @"",kRefType,
                                                                   @"",kRefId,nil];
                             
                             if([target conformsToProtocol:@protocol(ALStatisticUIControlProtocal)] &&
                                [target respondsToSelector:@selector(statisticUIControlDic:)]) {
                                 
                                 NSDictionary * dic =
                                 [NSDictionary dictionaryWithObjectsAndKeys:NSStringFromSelector(sel),kEventSelector,obj,kEventSender, nil];
                                 
                                 NSDictionary * tDic =
                                 [target performSelector:@selector(statisticUIControlDic:) withObject:dic];
                                 
//                                 if(dicStatistic[kTriggerName] && [dicStatistic[kTriggerName] length]) {
//                                     triggerName = dicStatistic[kTriggerName];
//                                 }

                                 dicStatistic[kTriggerName] = triggerName;
                                 dicStatistic[kActionId] = tDic[kActionId];
                                 dicStatistic[kSrcLocation] = tDic[kSrcLocation];
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
