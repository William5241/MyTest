//
//  CheckYD.h
//  YiDing
//
//  Created by zhangbin on 16/10/20.
//  Copyright © 2016年 韩伟. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
    工具类
 */

@interface CheckYD : NSObject


//判断输入的密码是否合法
+ (BOOL) isValidatePassWrod:(NSString *)password num:(int)num;

//判断邮箱是否合法
+ (BOOL) isValidateEmail:(NSString *)email;

//判断手机号是否合法
+ (BOOL) isValidateMobile:(NSString *)mobile;

//判断字符串是否为空
+ (BOOL) isBlankString:(NSString *)string;

//判断是否汉字与英文
+ (BOOL)checkIsHanziAndIsEnglist:(NSString *)str;

//判断是否数字与英文
+ (BOOL)checkIsNumberAndIsEnglist:(NSString *)str;


//实现输入框的抖动效果
+ (void) lockAnimationForView:(UIView*)view;


//输入的用户名或密码长度的限制  strType 1.用户名  2.密码
+ (BOOL) isLengthString:(NSString *)string strType:(NSInteger)num;

//判断输入的文字长度是否在一定范围之内
+ (BOOL) isValidString:(NSString *)string withLength:(NSInteger)length;

+ (UIColor *)colorFromHexRGB:(NSString *)inColorString;

//判断是否是中文
+ (BOOL) isHanzi:(NSString *)str;
//判断是否是英文
+ (BOOL) isEnglish:(NSString *)str;
//判断是否是数字
+ (BOOL) isNumber:(NSString *)str;


//当 即将要播放视频  和下载视频时, 请求视频信息
+ (void)RequestVideoMessage:(NSDictionary *)videoDic;

//判断当前的网络是3g还是wifi
+ (NSString*)GetCurrentNetState;

// 当前网络状态
+ (NSString *)curNetStatus;

// 得到当前网络状态(包括了7)
+ (NSString *)getCurNetStatusForLog;

// 取得运营商
+ (NSString *)getCarrierCode;

// 取得运营商
+ (NSString *)carrierCode;

//查询占用的空间大小
+ (long long)spaceefPath:(NSString * )subPath;

//查询占用的空间大小
+ (NSString *)usedSpaceAndfreeSpaceSubsefPath:(NSString * )subPath;

//清除下载的缓存
+ (void)deleteDirectoryAllFilePath:(NSString *)allFilePath;

// 清除某个目录的所有东西
+ (BOOL)deleteDirectoryWithPath:(NSString *)derectoryPath;

+ (NSString *)getFileSizeString:(NSString *)size;


/**************************************判断是否是自己 还是他人**********************************/
+ (BOOL)CheckIsMy:(NSString *)LogCustomerId isOther:(NSString *)LogTempId;

/******************************************个人中心******************************************/
// 是否已经登录
+ (BOOL)isLogin;

// 是否已经认证了
+ (BOOL)isAuthed;

// 是否完善资料
+ (BOOL)isPerfectApprove;

// 是不是本vc 登录的
+ (BOOL)isVCLogin:(UIViewController *)vc;

/******************************************视频******************************************/
// 是否是本地
+ (BOOL)isLocalVideo:(NSString *)videoId;

// 是否是正在下载的
+ (BOOL)isDownLoadingVideo:(NSString *)videoId;


/******************************************评论******************************************/
// 评论是否本人评论的
+ (BOOL)isSelfReviewed:(NSString *)reviewPersonId;

// 资源是不是本人的
+ (BOOL)isSelfPuslishedRef:(NSString *)refCustomid;

//*******************计算 中文和英文**********************//

// 限制输入的长度
+ (BOOL)canChangeText:(NSString *)textCount maxTextCount:(NSInteger)maxtextCount;

// 计算输入的内容长度
+ (NSInteger)canChangeText:(NSString *)textCount maxNumberCount:(NSInteger)maxtextCount;
+ (NSInteger)canChangeText:(NSString *)textCount;

//*******************计算 数字和英文**********************//

//限制字符串的长度
+ (BOOL)canNumberText:(NSString *)textCount maxTextCount:(NSInteger)maxtextCount;
//计算输入的内容长度
+ (NSInteger)canNumberText:(NSString *)textCount maxNumberCount:(NSInteger)maxtextCount;
+ (NSInteger)canNumberText:(NSString *)textCount;
// 时间比较  NO 结束时间大于开始时间
+ (BOOL)compareFirstDate:(NSDate *)firstDate SecondDate:(NSDate *)secondDate;


//对证件号  用 * 号隐藏代替
+ (NSString *)voucherNumberStr:(NSString *)voucherNumber;

// 替换
+ (NSString *)replaceUniqeChars:(NSString *)string;

//判断是否允许使用照相机  或相册
+ (BOOL)checkPhoto;

// 总的缓存大小
+ (NSString *)spaceTotalCache;

// 视频下载空间
+ (NSString *)spaceVideoDownLoad;

// 手机剩余空间
+ (NSString *)freeDiskSpaceInBytes;

// 是否有足够的空间
+ (BOOL)hasEnoughFreeSpace;

// 避免icloud备份
+ (BOOL)addSkipBackupAttributeToItemAtPath:(NSString *) filePathString;

+ (NSString *)getStringWithString:(NSString *)textCount InRange:(NSInteger)index ;

+ (NSString *)getShareTitle:(NSString *)str andMaxCount:(NSInteger)maxCount;


@end
