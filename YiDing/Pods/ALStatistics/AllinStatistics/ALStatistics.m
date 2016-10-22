//
//  ALStatistics.m
//
//
//  Created by ZhangKaiChao on 16/5/10.
//  Copyright © 2016年 北京欧应信息技术有限公司. All rights reserved.
//

#import "ALStatistics.h"
#import "ALStatisticsBase+UIViewController.h"
#import "ALStatisticsBase+XHZoomingImageView.h"
#import "ALStatisticsBase+AllinRefreshView.h"
#import "ALStatisticsBase+UIControl.h"
#import "ALStatisticsBase+CustomCellImageView.h"
#import "ALStatisticsBase+UITableView.h"
#import "ALStatisticsBase+UICollectionView.h"

@interface ALStatistics ()
@property (nonatomic,weak) id delegate;
@property (nonatomic,assign) BOOL openlog;
@end

@implementation ALStatistics

/**
 *  单例
 *
 *  @return value
 */
+ (instancetype)sharedStatistic {
    @synchronized(self)
    {
        static ALStatistics * sharedStatistics = nil;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            sharedStatistics = [[super allocWithZone:NULL] init];
        });
        return sharedStatistics;
    }
}

/**
 *  开启打印日至
 */
- (void)openLog {
    _openlog = YES;
}

/**
 *  初始化统计
 *
 *  @param delegate 代理
 */
- (void)setupStatistics:(id)delegate {
    _delegate = delegate;
    [self setupWithSingleConfiguration:@[
                                         ]];
    [self setupWithAllInstanceConfiguration:@[
                                              [ALStatisticsBase statisticsVCBase],
                                              [ALStatisticsBase statisticsZoomScrollViewBase],
                                              [ALStatisticsBase statisticsListViewDragRefreshBase],
                                              [ALStatisticsBase statisticsUIControlBase],
                                              [ALStatisticsBase statisticsCustomCellImageViewBase],
                                              [ALStatisticsBase statisticsUITableViewBase],
                                              [ALStatisticsBase statisticsUICollectionViewBase]
                                              ]];
}


/**
 *  开始统计单个instance
 *
 *  @param configs 统计项
 */
- (void)setupWithSingleConfiguration:(NSArray *)arrayConfigs {
    
    for(NSDictionary * configs in arrayConfigs) {
        for (NSString *className in configs) {
            Class class = NSClassFromString(className);
            for (NSDictionary *event in configs[className]) {
                SEL selector = NSSelectorFromString(event[kEventSelector]);
                id block = event[kEventHandlerBlock];
                [MOAspects hookInstanceMethodForClass:class
                                             selector:selector
                                      aspectsPosition:MOAspectsPositionBefore
                                            hookRange:MOAspectsHookRangeSingle
                                           usingBlock:block];
            }
        }
    }
}


/**
 *  开始统计所有instance
 *
 *  @param configs 统计项
 */
- (void)setupWithAllInstanceConfiguration:(NSArray *)arrayConfigs {
    
    for(NSDictionary * configs in arrayConfigs) {
        for (NSString *className in configs) {
            Class class = NSClassFromString(className);
            for (NSDictionary *event in configs[className]) {
                SEL selector = NSSelectorFromString(event[kEventSelector]);
                id block = event[kEventHandlerBlock];
                [MOAspects hookInstanceMethodForClass:class
                                             selector:selector
                                      aspectsPosition:MOAspectsPositionBefore
                                            hookRange:MOAspectsHookRangeAll
                                           usingBlock:block];
            }
        }
    }
}

/**
 *  上传埋点数据.
 *
 *  @param dicParam 埋点数据参数
 */
- (void)startUploadStatic:(NSDictionary *)dicParam {
    
#if DEBUG
    if(_openlog){
        NSString * message = [NSString stringWithFormat:
                              @"triggerType:%@,triggerName:%@,actionId:%@,srcLocation:%@,\n"
                              "toLocation:%@,locationId:%@,refType:%@,refId:%@",
                              dicParam[kTriggerType],dicParam[kTriggerName],dicParam[kActionId],
                              dicParam[kSrcLocation],dicParam[kToLocation],dicParam[kLocationId],
                              dicParam[kRefType],dicParam[kRefId]
                              ];
        
        [ALStatisticsBase hudview].detailsLabelText = message;
        [[ALStatisticsBase hudview] show:YES];
        [[ALStatisticsBase hudview] hide:YES afterDelay:1.5];
    }
#endif

    if([_delegate conformsToProtocol:@protocol(ALStatisticUploadProtocal)] &&
       [_delegate respondsToSelector:@selector(uploadStatistics:)]) {
        [_delegate performSelector:@selector(uploadStatistics:) withObject:dicParam];
    }
}

@end
