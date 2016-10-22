//
//  YDShareManage.h
//  YiDing
//
//  Created by zhangbin on 16/10/19.
//  Copyright © 2016年 韩伟. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ShareSDK/ShareSDK.h>

@class ActionItem;
@interface YDShareManage : NSObject < UIAlertViewDelegate
>
+ (void)registerAppkey;
+ (void)shareSinaWithItem:(ActionItem *)item;
+ (void)shareWechatWithItem:(ActionItem *)item type:(NSInteger)type;
+ (void)shareQQWithItem:(ActionItem *)item;
+ (void)shareQQZoneWithItem:(ActionItem *)item;
+ (void)shareSMSZoneWithItem:(ActionItem *)item;
    
+ (void)cancelAuthWithType:(SSDKPlatformType)type;
    
+ (NSString *)shareTitle:(ActionItem *)item shareType:(SSDKPlatformType)shareType;
+ (NSString *)checkMaxTitle:(NSString *)shareTitle;
    
+ (NSString *)shareSinaContentStringWithItem:(ActionItem *)item;
+ (NSString *)shareQQContentStringWithItem:(ActionItem *)item;
+ (NSString *)shareQQSpaceContentStringWithItem:(ActionItem *)item;
+ (NSString *)shareWechatContent:(ActionItem *)item shareType:(SSDKPlatformType)shareType;
+ (void)shareMailWithItem:(ActionItem *)item;

@end
