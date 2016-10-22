//
//  ALStatisticsBase+UIViewController.m
//  AllinStatistics
//
//  Created by ZhangKaiChao on 16/5/19.
//  Copyright © 2016年 北京欧应信息技术有限公司. All rights reserved.
//

#import "ALStatisticsBase+UIViewController.h"

@implementation ALStatisticsBase (UIViewController)

/**
 *  vc统计项
 *
 *  @return 业务统计数据组成的字典
 */
+ (NSDictionary *)statisticsVCBase {
    return @{
             // vc
             kUIViewController:@[
                     
                     @{
                         kEventSelector: @"viewWillAppear:",
                         kEventHandlerBlock: ^(UIViewController *controller,
                                              BOOL animated ) {
                             
                             NSString * className = NSStringFromClass([controller class]);
                             if(([controller isKindOfClass:NSClassFromString(@"ALBaseVC")] &&
                                 [className isEqualToString:@"ALBaseVC"] == NO) ||
                                ([controller isKindOfClass:NSClassFromString(@"MDPBaseClassVC")] &&
                                 [className isEqualToString:@"MDPBaseClassVC"] == NO)) {

                                 NSString * triggerName = @"method=viewWillAppear:";

                                 NSMutableDictionary * dicStatistic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                                                       [NSString stringWithFormat:@"%zd",eTriggerTypeEnterV],kTriggerType,
                                                                       triggerName,kTriggerName,
                                                                       @"",kActionId,
                                                                       @"",kSrcLocation,
                                                                       className,kToLocation,
                                                                       @"",kLocationId,
                                                                       @"",kRefType,
                                                                       @"",kRefId,nil];
                                 [[ALStatistics sharedStatistic] startUploadStatic:dicStatistic];
                                 
                             }
                         }
                         },
                     
                     @{
                         kEventSelector: @"viewWillDisappear:",
                         kEventHandlerBlock: ^(UIViewController *controller,
                                              BOOL animated ) {
                             
                             NSString * className = NSStringFromClass([controller class]);
                             if(([controller isKindOfClass:NSClassFromString(@"ALBaseVC")] &&
                                 [className isEqualToString:@"ALBaseVC"] == NO) ||
                                ([controller isKindOfClass:NSClassFromString(@"MDPBaseClassVC")] &&
                                 [className isEqualToString:@"MDPBaseClassVC"] == NO)) {
                                 
                                 NSString * triggerName = @"method=viewWillDisappear:";

                                 NSMutableDictionary * dicStatistic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                                                       [NSString stringWithFormat:@"%zd",eTriggerTypeExitV],kTriggerType,
                                                                       triggerName,kTriggerName,
                                                                       @"",kActionId,
                                                                       className,kSrcLocation,
                                                                       @"",kToLocation,
                                                                       @"",kLocationId,
                                                                       @"",kRefType,
                                                                       @"",kRefId,nil];
                                 [[ALStatistics sharedStatistic] startUploadStatic:dicStatistic];

                             }
                         }
                         }
                     ]

             };
}

@end
