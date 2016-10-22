//
//  CommonParameterTool.h
//  YiDing
//
//  Created by 韩伟 on 16/10/20.
//  Copyright © 2016年 韩伟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommonParameterTool : NSObject

@property (nonatomic, copy, readwrite) NSString *wanIpString;

+ (instancetype)sharedInstance;

/**
 得到当前网络状态
 
 @return 返回当前网络状态
 */
- (NSString *)curNetStatus;

/**
 取得运营商
 
 @return 返回运营商名字
 */
- (NSString *)carrierCode;

/**
 通过访问指定url获取ip地址
 
 @return 返回包含ip,城市id，城市名称的dic
 */
- (NSDictionary *)deviceWANIPAdress;

/**
 获取公网ip地址
 */
- (void)getWANIpString;

/**
 返回设备硬件信息
 */
- (NSString *)getDeviceHardwareString;
@end
