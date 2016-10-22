//
//  YDMobMenager.m
//  YiDing
//
//  Created by zhangbin on 16/10/19.
//  Copyright © 2016年 韩伟. All rights reserved.
//

#import "YDMobMenager.h"
#import <UMMobClick/MobClick.h>

@implementation YDMobMenager

+ (void)registerApp {

    UMAnalyticsConfig * config = [[UMAnalyticsConfig alloc] init];
    config.appKey = kUMengAppkey(ON_LINE);
    config.ePolicy = REALTIME;
    
    [MobClick startWithConfigure:config];
    [MobClick setAppVersion:XcodeAppVersion];
//    [MobClick setLogEnabled:NO];// 上线时 删除此方法
    [MobClick setCrashReportEnabled:YES];// 崩溃日志  默认yes
    [MobClick setEncryptEnabled:NO];// 是否对日志进行加密
    [MobClick setBackgroundTaskEnabled:YES];// 是否支持后台模式  默认 yes
    [MobClick setLatency:0];// 日志是否延迟发送
}
    
@end
