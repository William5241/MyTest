//
//  ALStatisticsBase+UITableView.m
//  AllinStatistics
//
//  Created by ZhangKaiChao on 16/7/5.
//  Copyright © 2016年 北京欧应信息技术有限公司. All rights reserved.
//

#import "ALStatisticsBase+UITableView.h"
@implementation ALStatisticsBase (UITableView)

/**
 *  UITableView统计项
 *
 *  @return 业务统计数据组成的字典
 */
+ (NSDictionary *)statisticsUITableViewBase {
    return @{
             //
             kUITableView:@[
                     
                     @{
                         kEventSelector: @"setDelegate:",
                         kEventHandlerBlock: ^(UITableView * tableView,id delegate) {
                             
                             if(!delegate)
                             {
                                 return ;
                             }
                             Class class = [delegate class];
                             
                             SEL selector = NSSelectorFromString(@"tableView:didSelectRowAtIndexPath:");
                             
                             if([delegate conformsToProtocol:@protocol(UITableViewDelegate)] &&
                                [delegate respondsToSelector:selector]) {
                                 
                                 /// 避免因为继承问题导致的替换方法错误引起的崩溃.
                                 Method originalMethod =
                                 class_getInstanceMethod(class, selector);
                                 if(class_addMethod(class, selector,
                                                    method_getImplementation(originalMethod),
                                                    method_getTypeEncoding(originalMethod))) {
                                 }
                                 
                                 Method baseTargetMethod = class_getInstanceMethod(class, @selector(ORIGtableView:didSelectRowAtIndexPath:));
                                 IMP baseTargetMethodIMP = method_getImplementation(baseTargetMethod);
                                 if (baseTargetMethodIMP) {
                                     class_addMethod(class, NSSelectorFromString(@"swizzling_didSelectRowAtIndexPath"), baseTargetMethodIMP, "v@:@@");
                                     
                                 } else {
                                     BOOL added = class_addMethod(class, NSSelectorFromString(@"swizzling_didSelectRowAtIndexPath"),(IMP)swizzling_didSelectRowAtIndexPath,"v@:@@");
                                     if(added) {
                                         Method dis_originalMethod = class_getInstanceMethod(class, NSSelectorFromString(@"swizzling_didSelectRowAtIndexPath"));
                                         Method dis_swizzledMethod = class_getInstanceMethod(class, selector);
                                         method_exchangeImplementations(dis_swizzledMethod,dis_originalMethod);
                                     }
                                 }
                             }
                         }
                         }
                     
                     ]
             };
}

/**
 *  进行埋点
 *
 *  @param self      UITableview的代理类
 *  @param _cmd      替换后的方法
 *  @param tableView tableView参数
 *  @param indexpath indexpath 参数
 */
void swizzling_didSelectRowAtIndexPath(id self, SEL _cmd, id tableView, id indexpath)
{
    SEL selector = NSSelectorFromString(@"swizzling_didSelectRowAtIndexPath");
    ((void(*)(id, SEL,id, id))objc_msgSend)(self, selector, tableView, indexpath);
    
    NSIndexPath * indexPath = (NSIndexPath *)indexpath;
    
    NSString * triggerName = @"";
//    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexpath];
//    NSString * text = [[cell contentView] subViewsTextForStatistics];
//    if(text && text.length) {
//        triggerName = [[cell contentView] subViewsTextForStatistics];
//    } else {
        triggerName = [NSString stringWithFormat:@"path=%@,method=%@,section=%zd,row=%zd",
                       NSStringFromClass([self class]),
                       NSStringFromSelector(_cmd),
                       indexPath.section,
                       indexPath.row];
//    }
    
    NSMutableDictionary * dicStatistic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                          [NSString stringWithFormat:@"%zd",eTriggerTypeLeftClick],kTriggerType,
                                          triggerName,kTriggerName,
                                          @"",kActionId,
                                          NSStringFromClass([self class]),kSrcLocation,
                                          @"",kToLocation,
                                          @"",kLocationId,
                                          @"",kRefType,
                                          @"",kRefId,nil];
    
    if([self conformsToProtocol:@protocol(ALStatisticUITableViewProtocal)] &&
       [self respondsToSelector:@selector(statisticUITableViewDic:)]) {
        
        NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:
         NSStringFromSelector(_cmd),kEventSelector,tableView,kEventSender,indexpath,kIndexPath, nil];
        
        NSDictionary * tDic = [self performSelector:@selector(statisticUITableViewDic:) withObject:dic];
        
//        if(tDic[kTriggerName] && [tDic[kTriggerName] length]) {
//            triggerName = tDic[kTriggerName];
//        }
        
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


@end
