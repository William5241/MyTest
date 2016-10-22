//
//  CheckYD.m
//  YiDing
//
//  Created by zhangbin on 16/10/20.
//  Copyright © 2016年 韩伟. All rights reserved.
//

#import "CheckYD.h"
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>
#import <sys/param.h>
#import <sys/mount.h>


@implementation CheckYD
    
//判断输入的信息是否符合要求 1 字母和数字   2  中文和字母
+ (BOOL) isValidatePassWrod:(NSString *)password num:(int)num {
    
    NSString *mystring = password;
    if (num == 1) {
        //    判断密码是否 字母或数字  !#$%^&*.~,><:;+-_|'"=`(){}[]
        //     - [] /\ "这些不能用的
        
        NSString *numRegex = @"^[A-Za-z0-9^*()%&+{}_|!#~<>、:'.@,;=?$-]+$";
        
        NSPredicate * charAndnum = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", numRegex];
        
        if ([charAndnum evaluateWithObject:mystring] == YES) {
            return YES;
        }
        else{
            return NO;
        }
        
    } else if (num == 2){
        //        中文和字母  @"[a-zA-Z\u4e00-\u9fa5][a-zA-Z0-9\u4e00-\u9fa5]+"; ^([\u4e00-\u9fa5]+|([a-z]+\s?)+)$
        //        ^[a-zA-Z\u4e00-\u9fa5\\s]+$  这个是中英文组合 其中 英文之间可以有空格
        NSString *strRegex = @"^[a-zA-Z\u4e00-\u9fa5\\s]+$";
        NSPredicate *strText = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",strRegex];
        if ([strText evaluateWithObject:mystring] == YES) {
            return YES;
        }
        else{
            return NO;
        }
    }
    else if (num == 3) {
        //    判断密码是否 字母或数字  !#$%^&*.~,><:;+-_|'"=`(){}[]
        //     - [] /\ "这些不能用的
        
        NSString *numRegex = @"^[A-Za-z0-9]+$";
        
        NSPredicate * charAndnum = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", numRegex];
        
        if ([charAndnum evaluateWithObject:mystring] == YES) {
            return YES;
        }
        else{
            return NO;
        }
        
    }
    
    return YES;
}
    
//判断是否是中文
+ (BOOL) isHanzi:(NSString *)str {
    
    NSString *strRegex = @"^[\u4e00-\u9fa5]+$";
    NSPredicate *strText = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",strRegex];
    NSString *mystring = str;
    if ([strText evaluateWithObject:mystring] == YES) {
        return YES;
    }
    else{
        return NO;
    }
}
//判断是否是英文
+ (BOOL) isEnglish:(NSString *)str {
    
    NSString *strRegex = @"[A-Za-z]+$";
    NSPredicate *strText = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",strRegex];
    NSString *mystring = str;
    if ([strText evaluateWithObject:mystring] == YES) {
        return YES;
    }
    else{
        return NO;
    }
}
    
    
//判断是否是数字
+ (BOOL) isNumber:(NSString *)str {
    
    NSString *strRegex = @"^[0-9]*$";
    NSPredicate *strText = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",strRegex];
    NSString *mystring = str;
    if ([strText evaluateWithObject:mystring] == YES) {
        return YES;
    }
    else{
        return NO;
    }
}
    
//判断是否汉字与英文
+(BOOL)checkIsHanziAndIsEnglist:(NSString *)str {
    
    if([CheckYD isHanzi:str] || [CheckYD isEnglish:str] || [CheckYD isValidatePassWrod:str num:2] || [str isEqualToString:@""]){
        return YES;
    }else
    {
        return NO;
    }
}
    
    
//判断是否数字与英文
+(BOOL)checkIsNumberAndIsEnglist:(NSString *)str {
    
    if([CheckYD isNumber:str] || [CheckYD isEnglish:str] || [CheckYD isValidatePassWrod:str num:3] ||[str isEqualToString:@""]){
        return YES;
    }else
    {
        return NO;
    }
}
    
//判断邮箱是否合法
+ (BOOL) isValidateEmail:(NSString *)email {
    
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailText = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",emailRegex];
    return [emailText evaluateWithObject:email];
}
    
//判断手机号是否合法
+ (BOOL) isValidateMobile:(NSString *)mobile {
    
    //手机号以13，15，18开头，八个 \d 数字字符  ^(13[0-9]|15[0-9]|18[0|6|8|9])\d{8}$
    //    NSString *phoneRegex = @"^((13[0-9])|(14[0-9])|(15[0-9])|(19[0-9])|(18[0-9])|(17[0-9]))\\d{8}$";
    NSString *phoneRegex = @"^1[0-9]\\d{9}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:mobile];
}
    
//判断字符串是否为空
+ (BOOL) isBlankString:(id )string {
    
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    
    if (string == nil || string == NULL) {
        return YES;
    }
    
    string = [NSString stringWithFormat:@"%@",string];
    
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] == 0 ||
        [string length] == 0) {
        return YES;
    }
    if ([string isEqualToString:@"(null)"] ||
        [string isEqualToString:@"<null>"]) {
        return YES;
    }
    
    return NO;
}
    
//添加输入框的抖动效果
+ (void)lockAnimationForView:(UIView*)view {
    
    CALayer *lbl = [view layer];
    CGPoint posLbl = [lbl position];
    CGPoint y = CGPointMake(posLbl.x-10, posLbl.y);
    CGPoint x = CGPointMake(posLbl.x+10, posLbl.y);
    CABasicAnimation * animation = [CABasicAnimation animationWithKeyPath:@"position"];
    [animation setTimingFunction:[CAMediaTimingFunction
                                  functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [animation setFromValue:[NSValue valueWithCGPoint:x]];
    [animation setToValue:[NSValue valueWithCGPoint:y]];
    [animation setAutoreverses:YES];
    [animation setDuration:0.08];
    [animation setRepeatCount:3];
    [lbl addAnimation:animation forKey:nil];
}
    
//判断输入的文字长度是否在一定范围之内
+ (BOOL) isValidString:(NSString *)string withLength:(NSInteger)length {
    
    if ([string length] > 0 && string.length <= length) {
        return YES;
    }
    return NO;
}
    
//输入的用户名或密码长度的限制  strType 1.用户名  2.密码
+ (BOOL) isLengthString:(NSString *)string strType:(NSInteger)num {
    
    if (num == 1 && [string length] > 49) {
        return NO;
    }
    else if (num == 2 && ([string length] < 6 || [string length] >20)){
        return NO;
    }
    return YES;
}
    
// 判断当前的网络是3g还是wifi
+ (NSString *)GetCurrentNetState {
    
    __block NSString* result;
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:// 没有网络连接
            case AFNetworkReachabilityStatusNotReachable:
            result=nil;
            break;
            
            case AFNetworkReachabilityStatusReachableViaWWAN:// 使用3G网络
            result=@"使用3G网络";
            break;
            
            case AFNetworkReachabilityStatusReachableViaWiFi:// 使用WiFi网络
            result=@"使用WiFi网络";
            break;
        }
    }];
    return result;
}
    
    // 得到当前网络状态
+ (NSString *)curNetStatus {
    
    Reachability *curReach = [Reachability reachabilityForInternetConnection];
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    
    switch (netStatus)
    {
        case NotReachable:
        {
            return @"";
        }
        break;
        
        case ReachableViaWWAN:
        {
            // 7.0
            Class telephoneNetWorkClass = (NSClassFromString(@"CTTelephonyNetworkInfo"));
            if (telephoneNetWorkClass != nil)
            {
                CTTelephonyNetworkInfo *telephonyNetworkInfo = [[CTTelephonyNetworkInfo alloc] init];
                
                if ([telephonyNetworkInfo respondsToSelector:@selector(currentRadioAccessTechnology)])
                {
                    NSString* wlanNetwork = telephonyNetworkInfo.currentRadioAccessTechnology;
                    
                    if (wlanNetwork == nil)
                    {
                        return @"";
                    }
                    if([wlanNetwork isEqualToString:CTRadioAccessTechnologyGPRS] ||
                       [wlanNetwork isEqualToString:CTRadioAccessTechnologyEdge])
                    {
                        return @"2";// 2g
                    }
                    else if([wlanNetwork isEqualToString:CTRadioAccessTechnologyWCDMA] ||
                            [wlanNetwork isEqualToString:CTRadioAccessTechnologyHSDPA] ||
                            [wlanNetwork isEqualToString:CTRadioAccessTechnologyHSUPA] ||
                            [wlanNetwork isEqualToString:CTRadioAccessTechnologyCDMA1x] ||
                            [wlanNetwork isEqualToString:CTRadioAccessTechnologyCDMAEVDORev0] ||
                            [wlanNetwork isEqualToString:CTRadioAccessTechnologyCDMAEVDORevA] ||
                            [wlanNetwork isEqualToString:CTRadioAccessTechnologyCDMAEVDORevB] ||
                            [wlanNetwork isEqualToString:CTRadioAccessTechnologyeHRPD])
                    {
                        return @"3";// 3g
                    }
                    else if([wlanNetwork isEqualToString:CTRadioAccessTechnologyLTE])
                    {
                        return @"4";// 4g
                    }
                }
            }
            
            return @"";
        }
        break;
        
        case ReachableViaWiFi:
        {
            return @"1";
        }
        break;
        
        default:
        break;
    }
    
    return @"";
}
    
// 得到当前网络状态
+ (NSString *)getCurNetStatusForLog {
    
    Reachability *curReach = [Reachability reachabilityForInternetConnection];
    
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    
    switch (netStatus)
    {
        case NotReachable:
        {
            return nil;
        }
        break;
        
        case ReachableViaWWAN:
        {
            // 7.0
            Class telephoneNetWorkClass = (NSClassFromString(@"CTTelephonyNetworkInfo"));
            if (telephoneNetWorkClass != nil)
            {
                CTTelephonyNetworkInfo *telephonyNetworkInfo = [[CTTelephonyNetworkInfo alloc] init];
                
                if ([telephonyNetworkInfo respondsToSelector:@selector(currentRadioAccessTechnology)])
                {
                    NSString* wlanNetwork = telephonyNetworkInfo.currentRadioAccessTechnology;
                    
                    if (wlanNetwork == nil)
                    {
                        return nil;
                    }
                    if([wlanNetwork isEqualToString:CTRadioAccessTechnologyGPRS])
                    {
                        return NSLocalizedString(@"NetStatus2GTo3G", );// 2g-3g过渡技术
                    }
                    else if([wlanNetwork isEqualToString:CTRadioAccessTechnologyEdge])
                    {
                        return NSLocalizedString(@"NetStatus2GTo3G", );// 2g-3g过渡技术
                    }
                    else if([wlanNetwork isEqualToString:CTRadioAccessTechnologyWCDMA])
                    {
                        return NSLocalizedString(@"NetStatus3G", );// 联通3g
                    }
                    else if([wlanNetwork isEqualToString:CTRadioAccessTechnologyHSDPA])
                    {
                        return NSLocalizedString(@"NetStatus3G", );// 3g-4g过渡技术
                    }
                    else if([wlanNetwork isEqualToString:CTRadioAccessTechnologyHSUPA])
                    {
                        return NSLocalizedString(@"NetStatus3G", );// 3g-4g过渡技术
                    }
                    else if([wlanNetwork isEqualToString:CTRadioAccessTechnologyCDMA1x])
                    {
                        return NSLocalizedString(@"NetStatus3G", );// 3g
                    }
                    else if([wlanNetwork isEqualToString:CTRadioAccessTechnologyCDMAEVDORev0])
                    {
                        return NSLocalizedString(@"NetStatus3G", );// 标准3g
                    }
                    else if([wlanNetwork isEqualToString:CTRadioAccessTechnologyCDMAEVDORevA])
                    {
                        return NSLocalizedString(@"NetStatus3G", );// 电信3g
                    }
                    else if([wlanNetwork isEqualToString:CTRadioAccessTechnologyCDMAEVDORevB])
                    {
                        return NSLocalizedString(@"NetStatus3G", );// 电信3g 升级版
                    }
                    else if([wlanNetwork isEqualToString:CTRadioAccessTechnologyeHRPD])
                    {
                        return NSLocalizedString(@"NetStatus3G", );// 3g-4g过渡技术
                    }
                    else if([wlanNetwork isEqualToString:CTRadioAccessTechnologyLTE])
                    {
                        return NSLocalizedString(@"NetStatus4G",);// 4g
                    }
                    return nil;
                }
            }
            
            return NSLocalizedString(@"NetStatus2G3G", );
        }
        break;
        
        case ReachableViaWiFi:
        {
            return NSLocalizedString(@"NetStatusWifi", );
        }
        break;
        
        default:
        break;
    }
    
    return nil;
}

// 取得运营商
+ (NSString *)getCarrierCode {
    
    // 判断是否能够取得运营商
    Class telephoneNetWorkClass = (NSClassFromString(@"CTTelephonyNetworkInfo"));
    if (telephoneNetWorkClass != nil)
    {
        CTTelephonyNetworkInfo *telephonyNetworkInfo = [[CTTelephonyNetworkInfo alloc] init];
        
        // 获得运营商的信息
        Class carrierClass = (NSClassFromString(@"CTCarrier"));
        if (carrierClass != nil)
        {
            CTCarrier *carrier = telephonyNetworkInfo.subscriberCellularProvider;
            NSString * carrierName = [carrier carrierName];
            return carrierName;
        }
    }
    
    return nil;
}
    
    // 取得运营商
+ (NSString *)carrierCode {

    // 判断是否能够取得运营商
    Class telephoneNetWorkClass = (NSClassFromString(@"CTTelephonyNetworkInfo"));
    if (telephoneNetWorkClass != nil)
    {
        CTTelephonyNetworkInfo *telephonyNetworkInfo = [[CTTelephonyNetworkInfo alloc] init];
        
        // 获得运营商的信息
        Class carrierClass = (NSClassFromString(@"CTCarrier"));
        if (carrierClass != nil)
        {
            CTCarrier *carrier = telephonyNetworkInfo.subscriberCellularProvider;
            NSString * carrierName = [carrier carrierName];
            if ([carrierName isEqualToString:@"中国移动"]) {
                return @"1";
            }else if ([carrierName isEqualToString:@"中国电信"]) {
                return @"3";
            }else if ([carrierName isEqualToString:@"中国联通"]) {
                return @"2";
            }else{
                return @"";
            }
        }
    }
    
    return nil;
}
    
+ (UIColor *)colorFromHexRGB:(NSString *)inColorString {
    
    UIColor *result = nil;
    unsigned int colorCode = 0;
    unsigned char redByte, greenByte, blueByte;
    
    if (nil != inColorString)
    {
        NSScanner *scanner = [NSScanner scannerWithString:inColorString];
        (void) [scanner scanHexInt:&colorCode]; // ignore error
    }
    redByte = (unsigned char) (colorCode >> 16);
    greenByte = (unsigned char) (colorCode >> 8);
    blueByte = (unsigned char) (colorCode); // masks off high bits
    result = [UIColor
              colorWithRed: (float)redByte / 0xff
              green: (float)greenByte/ 0xff
              blue: (float)blueByte / 0xff
              alpha:1.0];
    return result;
}
    
+ (void)RequestVideoMessage:(NSDictionary *)videoDic{
    //    videoIdList          视频ID列表（1397797383729，1397797385734）
    //    videoAttFormat       视频格式（mp4或者flv）
    //    videoAttType         视频附件类型：2-视频......
    //    videoAttHeight      视频高度（960）
    //    videoAttWeight     视频宽度（640）
    //    firstResult          0
    //    maxResult            视频ID列表的长度
    
    /*
     NSString * videoId = [NSString stringWithFormat:@"%@",[videoDic objectForKey:@"videoId"]];
     NSString * str = [NSString stringWithFormat:@"?queryJson={\"videoIdList\":\"%@\",\"videoAttFormat\":\"mp4\",\"videoAttType\":\"2\",\"videoAttWidth\":\"%@\",\"videoAttHeight\":\"%@\",\"firstResult\":\"0\",\"maxResult\":\"100\"}",videoId,videoWidth,videoHeight,nil];
     
     //可以完善写  等功能差不多了 在解决此问题（可以将id做成唯一的标示把url包起）
     void(^VideoAddressMessageBlock)(NSArray *) =^(NSArray *videoMessageArray){
     MyLog(@"videoMessageArray  =====> %@",videoMessageArray);
     //111 url
     */
}
    
    
+ (long long)fileSizeAtPath:(NSString*)filePath {
    
    NSFileManager*manager = [NSFileManager defaultManager];
    if([manager fileExistsAtPath:filePath]){
        return[[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}
    
+ (long long)folderSizeAtPath2:(NSString*)folderPath {
    
    NSFileManager *manager = [NSFileManager defaultManager];
    
    if(![manager fileExistsAtPath:folderPath]) return 0;
    
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    
    NSString *fileName;
    
    long long folderSize = 0;
    
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        NSString*
        fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    
    return
    folderSize;
    
}
    
+ (long long)spaceefPath:(NSString * )subPath {
    
    return [self folderSizeAtPath2:subPath];
}
    
//查询占用的空间大小
+ (NSString *)usedSpaceAndfreeSpaceSubsefPath:(NSString * )subPath {
    
    long long fileSize = [self folderSizeAtPath2:subPath];
    
    NSString *str = nil;
    if (fileSize/1024.0/1024.0 > 1024) {
        str= [NSString stringWithFormat:@"%0.fG",fileSize/1024.0/1024.0/1024.0];
    } else {
        str= [NSString stringWithFormat:@"%0.fMB",fileSize/1024.0/1024.0];
    }
    
    return str;
}

    //清除下载的缓存
+ (void)deleteDirectoryAllFilePath:(NSString *)allFilePath {
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:allFilePath error:nil];
}
    
    // 清除某个目录的所有文件
+ (BOOL)deleteDirectoryWithPath:(NSString *)derectoryPath {

    // 所有文件路径数组
    NSArray * files = [[NSFileManager defaultManager] subpathsAtPath:derectoryPath];
    for (NSString * path in files) {
        
        NSError * error = nil;
        NSString * cachPath = [derectoryPath stringByAppendingPathComponent:path];
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:cachPath]) {
            [[NSFileManager defaultManager] removeItemAtPath:cachPath error:&error];//删除
            
            //            if (error) {
            //                return NO;
            //            }
        }
    }
    return YES;
}
    
+ (NSString *)getFileSizeString:(NSString *)size {

    if([size floatValue] >= 1024*1024)
    {
        //大于1M，则转化成M单位的字符串
        return [NSString stringWithFormat:@"%1.2fM",[size floatValue]/1024/1024];
    }
    else if([size floatValue] >= 1024&&[size floatValue]<1024*1024)
    {
        //不到1M,但是超过了1KB，则转化成KB单位
        return [NSString stringWithFormat:@"%1.2fK",[size floatValue]/1024];
    }
    else
    {
        //剩下的都是小于1K的，则转化成B单位
        return [NSString stringWithFormat:@"%1.2fB",[size floatValue]];
    }
}
    
/**
 *  是否是医站授权登录
 *
 *  @return value
 */
//+ (BOOL)checkIfMedplusAppAuthLogin {
//    NSURL * openUrl = [kKQAppDelegate jumpUrl];
//    if(openUrl) {}
//    return NO;
//}
    
    /**************************************判断是否是自己 还是他人**********************************/
+ (BOOL)CheckIsMy:(id)LogCustomerId isOther:(id)LogTempId {
    
    if ([[NSString stringWithFormat:@"%@",LogCustomerId] isEqualToString:[NSString stringWithFormat:@"%@",LogTempId]]) {
        return YES;
    } else {
        return NO;
    }
}

    
/******************************************个人中心******************************************/
// 是否已经登录
+ (BOOL)isLogin {
    
    NSString *customID = [kYDUserDefault objectForKey:kLog_CustomerId];
    if(customID && [customID isKindOfClass:[NSString class]])
    {
        return ![CheckYD isBlankString:customID];
    }
    return NO;
}
    
    // 是否已经认证了
+ (BOOL)isAuthed {
    
    NSString *authState = [NSString stringWithFormat:@"%@",[kYDUserDefault  objectForKey:kLog_AuthState]];
    return ([authState isEqualToString:NSLocalizedString(@"LoginAuthBusinessConfirm", )] ||
            [authState isEqualToString:NSLocalizedString(@"LoginAuthPass", )]);
}
    
    // 是否完善资料
+ (BOOL)isPerfectApprove {
    
    NSString * perfectApprove = [kYDUserDefault  objectForKey:kLog_PerfectApprove];
    return [perfectApprove isEqualToString:NSLocalizedString(@"PerfectApprovePass", )];
}
    
    // 是不是本vc 登录的
+ (BOOL)isVCLogin:(UIViewController *)vc {

#warning ====
//    if([[[VCManager shareManage] logVCName] isEqualToString:NSStringFromClass([vc class])])
//    {
//        return YES;
//    }
    return NO;
}

    /******************************************视频******************************************/
    // 是否是本地
+ (BOOL)isLocalVideo:(NSString *)videoId {

#warning 等待DownloadManager
//    NSArray *arrayVideoDownloaded = [[DownloadManager sharedDownloadManager] arrayDownLoadedSessionModals];
//    for(DownloadModal *modal in arrayVideoDownloaded)
//    {
//        if([modal.stringSourseId isEqualToString:[NSString stringWithFormat:@"%@",videoId]] &&
//           [[modal stringCustomId] isEqualToString:[DataManager customerId]])
//        {
//            return YES;
//        }
//    }
    return NO;
}
    
    // 是否是正在下载的
+ (BOOL)isDownLoadingVideo:(NSString *)videoId {
#warning 等待DownloadManager
//    NSArray *arrayVideoDownload = [[DownloadManager sharedDownloadManager] arrayDownLoadSessionModals];
//    for(DownloadModal *modal in arrayVideoDownload)
//    {
//        if([modal.stringSourseId isEqualToString:[NSString stringWithFormat:@"%@",videoId]] &&
//           [[modal stringCustomId] isEqualToString:[DataManager customerId]])
//        {
//            return YES;
//        }
//    }
    return NO;
}
    
// 获取视频信息
#warning 等待DownloadManager
//+ (DownloadModal *)downloadVideoInfo:(NSString *)videoId {
//    
//    NSArray *arrayVideoDownloaded = [[DownloadManager sharedDownloadManager] arrayDownLoadedSessionModals];
//    for(DownloadModal *modal in arrayVideoDownloaded)
//    {
//        if([modal.stringSourseId isEqualToString:[NSString stringWithFormat:@"%@",videoId]] &&
//           [[modal stringCustomId] isEqualToString:[DataManager customerId]])
//        {
//            return modal;
//        }
//    }
//    return nil;
//}

/******************************************评论******************************************/
// 评论是否本人评论的
+ (BOOL)isSelfReviewed:(NSString *)reviewPersonId {
    
    NSString *customID = [kYDUserDefault  objectForKey:kLog_CustomerId];
    return [[customID description] isEqualToString:[reviewPersonId description]];
}
    
// 资源是不是本人的
+ (BOOL)isSelfPuslishedRef:(NSString *)refCustomid {
    
    NSString *customID = [kYDUserDefault  objectForKey:kLog_CustomerId];
    
    return [[customID description] isEqualToString:[refCustomid description]];
}
    
//*******************计算 中文和英文**********************//
// 限制字符串的长度
+ (BOOL)canChangeText:(NSString *)textCount maxTextCount:(NSInteger)maxtextCount {
    
    // 字符串长度为空
    if((self == nil) || ([textCount length] == 0))
    {
        return YES;
    }

    NSInteger characterLen = [CheckYD canChangeText:textCount];
    
    if(characterLen <= maxtextCount)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

// 计算输入的内容长度
+ (NSInteger)canChangeText:(NSString *)textCount maxNumberCount:(NSInteger)maxtextCount {
    
    // 字符串长度为空
    NSInteger characterLen = 0;
    for(NSInteger i = 0; i < [textCount length]; i++)
    {
        unichar character = [textCount characterAtIndex:i];
        
        // 中文
        if((character >= 0x4e00) && (character <= 0x9fbb))
        {
            // 一个中文算2个长度
            characterLen += 2;
        }
        else
        {
            characterLen += 1;
        }
    }
    
    return maxtextCount-characterLen;
}

+ (NSInteger)canChangeText:(NSString *)textCount {
   
    // 字符串长度为空
    BOOL wordNum = YES;  //开关 单数开始计数,2个非中文字符计数-1
    
    NSInteger characterLen = 0;
    for(NSInteger i = 0; i < [textCount length]; i++)
    {
        unichar character = [textCount characterAtIndex:i];
        
        if(!((character >= 0x4e00) && (character <= 0x9fbb))) //改变开关状态
        {
            wordNum = !wordNum;
        }
        
        if((character >= 0x4e00) && (character <= 0x9fbb)) //中文
        {
            // 一个中文算2个长度
            //            characterLen += 2;
            characterLen += 1;
        }
        else //英文
        {
            //            characterLen += 1;
            characterLen += (wordNum ? 1 : 0 );
        }
    }
    return characterLen;
}
    
    
+ (NSString *)getStringWithString:(NSString *)textCount InRange:(NSInteger)index {
    
    // 字符串长度为空
    BOOL wordNum = YES;  //开关 单数开始计数,2个非中文字符计数-1
    
    NSInteger characterLen = 0;
    for(NSInteger i = 0; i < [textCount length]; i++)
    {
        unichar character = [textCount characterAtIndex:i];
        
        if(!((character >= 0x4e00) && (character <= 0x9fbb))) //改变开关状态
        {
            wordNum = !wordNum;
        }
        
        if((character >= 0x4e00) && (character <= 0x9fbb)) //中文
        {
            // 一个中文算2个长度
            //            characterLen += 2;
            characterLen += 1;
        }
        else  //英文
        {
            //            characterLen += 1;
            characterLen += (wordNum ? 1 : 0 );
        }
        
        if (characterLen > index) {
            return [textCount substringToIndex: index];
        }
    }
    
    return textCount;
    
}
    

// 分享时限制汉字占用两个字符，英文和数字占用一个字符

+ (NSString *)getShareTitle:(NSString *)str andMaxCount:(NSInteger)maxCount {
    
    NSInteger index;
    index =  [self shareTitleText:str maxCount:maxCount];
    NSString * str1 = [[NSString alloc] init];
    if (str && [str length] > 0) {
        str1 = [str substringToIndex:index+1];
    }else
    {
        str1 = @"看图讨论";
    }
    NSInteger indexOri;
    indexOri = [self shareNetText:str];
    if (indexOri > maxCount) {
        str1 = [NSString stringWithFormat:@"%@...",[str substringToIndex:index]];
    }
    return str1;
}


// 原始长度
+ (NSInteger)shareNetText:(NSString *)text {
    
    // 字符串长度为空
    NSInteger characterLen = 0;
    for(NSInteger i = 0; i < [text length]; i++)
    {
        unichar character = [text characterAtIndex:i];
        
        // 中文
        if((character >= 0x4e00) && (character <= 0x9fbb))
        {
            // 一个中文算2个长度
            characterLen += 2;
        }
        else
        {
            characterLen += 1;
        }
    }
    return characterLen;
}




+ (NSInteger)shareTitleText:(NSString *)text maxCount:(NSInteger)maxCount {
  
    // 字符串长度为空
    NSInteger index = 0;
    NSInteger characterLen = 0;
    for(NSInteger i = 0; i < [text length]; i++)
    {
        unichar character = [text characterAtIndex:i];
        
        // 中文
        if((character >= 0x4e00) && (character <= 0x9fbb))
        {
            // 一个中文算2个长度
            characterLen += 2;
        }
        else
        {
            characterLen += 1;
        }
        
        if (characterLen > maxCount) {
            index = i;
            break;
        }else {
            
            index = i;
        }
    }
    return index;
}




//*******************计算 数字和英文**********************//

//限制字符串的长度
+ (BOOL)canNumberText:(NSString *)textCount maxTextCount:(NSInteger)maxtextCount {
    
    // 字符串长度为空
    
    if((self == nil) || ([textCount length] == 0))
    {
        return YES;
    }
    
    NSInteger characterLen = 0;
    for(NSInteger i = 0; i < [textCount length]; i++)
    {
        characterLen += 1;
    }
    
    if(characterLen <= maxtextCount)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

//计算输入的内容长度
+ (NSInteger)canNumberText:(NSString *)textCount maxNumberCount:(NSInteger)maxtextCount {
    
    // 字符串长度为空
    
    NSInteger characterLen = 0;
    for(NSInteger i = 0; i < [textCount length]; i++)
    {
        characterLen += 1;
    }
    return characterLen;
}

+ (NSInteger)canNumberText:(NSString *)textCount {
    
    // 字符串长度为空
    NSInteger characterLen = 0;
    for(NSInteger i = 0; i < [textCount length]; i++)
    {
        characterLen += 1;
    }
    
    return characterLen;
}

// 时间比较  NO 结束时间大于开始时间
+ (BOOL)compareFirstDate:(NSDate *)firstDate SecondDate:(NSDate *)secondDate {
    
    NSTimeInterval _fitstDate = [firstDate timeIntervalSince1970]*1;
    NSTimeInterval _secondDate = [secondDate timeIntervalSince1970]*1;
    if (_fitstDate - _secondDate > 0) {
        return YES;
    }
    else {
        return NO;
    }
    
}


//对证件号  用 * 号隐藏代替
+ (NSString *)voucherNumberStr:(NSString *)voucherNumber {
    
    NSMutableString * numStr = [NSMutableString stringWithFormat:@"%@",voucherNumber];
    if ([numStr length] == 24) {
        [numStr replaceCharactersInRange:NSMakeRange(4, [numStr length]-4) withString:@"*******************"];
    }
    else if ([numStr length] == 27){
        [numStr replaceCharactersInRange:NSMakeRange(4, [numStr length]-4) withString:@"**********************"];
    }
    else if([numStr length] > 5){
        [numStr replaceCharactersInRange:NSMakeRange(4, [numStr length]-4) withString:@"**********"];
    }
    else{
        return voucherNumber;
    }
    return numStr;
    
}

// 替换
+ (NSString *)replaceUniqeChars:(NSString *)string {
    
    string = [string stringByReplacingOccurrencesOfString:@"<br>" withString:@"\n"];
    string = [string stringByReplacingOccurrencesOfString:@"</br>" withString:@"\n"];
    string = [string stringByReplacingOccurrencesOfString:@"<br />" withString:@"\n"];
    string = [string stringByReplacingOccurrencesOfString:@"<br/>" withString:@"\n"];
    string = [string stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
    return string;
}

    //判断是否允许使用照相机
+ (BOOL)checkPhoto {
    
    // 是否在设置里面关闭了相机
    BOOL isCameraDeviceAvailable = YES;
    
    isCameraDeviceAvailable = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
    isCameraDeviceAvailable = [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
    MyLog(@"%f",[[UIDevice currentDevice].systemVersion doubleValue]);
    
#ifdef __IPHONE_7_0
    
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus != AVAuthorizationStatusAuthorized)
    {
        isCameraDeviceAvailable = NO;
    }
#endif
    [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    return isCameraDeviceAvailable;
}
    
// 总的缓存大小
+ (NSString *)spaceTotalCache {

    long long kTmpSize = [CheckYD spaceefPath:kTmpPath];
    long long kCacheSize = [CheckYD spaceefPath:kCachPath];
    long long kDocSize = [CheckYD spaceefPath:kDocPath];
    
    NSString *kTotalSize = nil;
    CGFloat totalSize = kTmpSize +
    kCacheSize + kDocSize;
    if (totalSize/1024.0/1024.0/1024.0 > 1) {
        kTotalSize= [NSString stringWithFormat:@"%0.fG",totalSize/1024.0/1024.0/1024.0];
    } else {
        kTotalSize= [NSString stringWithFormat:@"%0.fMB",totalSize/1024.0/1024.0];
    }
    return kTotalSize;
}


// 视频下载空间
+ (NSString *)spaceVideoDownLoad {
#warning 等待视频 
    
    return nil;
//
//    NSString *kTotalVideoDownLoadSize = nil;
//    CGFloat videoDownloadingSize = 0;
//    for(DownloadModal *modal in [[DownloadManager sharedDownloadManager] arrayDownLoadSessionModals])
//    {
//        if([[modal stringCustomId] isEqualToString:[DataManager customerId]])
//        {
//            videoDownloadingSize += [modal.curloadSize floatValue];
//        }
//    }
//    NSString *kVideoDownloadingSize = [NSString stringWithFormat:@"%f",videoDownloadingSize];
//    CGFloat kVideoDownloadedSize = [CheckYD spaceefPath:[NSString stringWithFormat:@"%@/%@",[kDocPath stringByAppendingString:kVedioListPath],[DataManager customerId]]];
//    kTotalVideoDownLoadSize = [NSString stringWithFormat:@"%.f",[kVideoDownloadingSize floatValue] + kVideoDownloadedSize];
//    if ([kTotalVideoDownLoadSize floatValue]/1024.0/1024.0/1024.0 > 1) {
//        kTotalVideoDownLoadSize= [NSString stringWithFormat:@"%0.fG",[kTotalVideoDownLoadSize floatValue]/1024.0/1024.0/1024.0];
//    } else {
//        kTotalVideoDownLoadSize= [NSString stringWithFormat:@"%0.fMB",[kTotalVideoDownLoadSize floatValue]/1024.0/1024.0];
//    }
//    return kTotalVideoDownLoadSize;
}

// 手机剩余空间
+ (NSString *)freeDiskSpaceInBytes {

    struct statfs buf;
    long long freespace = -1;
    if(statfs("/private/var", &buf) >= 0)
    {
        freespace = (long long)(buf.f_bsize * buf.f_bfree);
    }
    
    if (freespace/1024.0/1024.0 > 1024) {
        return [NSString stringWithFormat:@"%0.fG",freespace/1024.0/1024.0/1024.0];
    } else {
        return [NSString stringWithFormat:@"%0.fMB",freespace/1024.0/1024.0];
    }
}

+ (BOOL)hasEnoughFreeSpace {

    NSString *spaceRemained = [CheckYD freeDiskSpaceInBytes];
    double spaceRemainedValue = 0.;// k
    if([spaceRemained hasSuffix:@"MB"])
    {
        spaceRemainedValue = [spaceRemained floatValue] * 1024;
    }
    if([spaceRemained hasSuffix:@"G"])
    {
        spaceRemainedValue = [spaceRemained floatValue] * 1024 * 1024;
    }
    
    if(spaceRemainedValue <= 50*1024)
    {
        return NO;
    }
    return YES;
}

// 避免icloud备份
+ (BOOL)addSkipBackupAttributeToItemAtPath:(NSString *) filePathString {

    NSURL* URL= [NSURL fileURLWithPath: filePathString];
    assert([[NSFileManager defaultManager] fileExistsAtPath: [URL path]]);
    
    NSError *error = nil;
    BOOL success = [URL setResourceValue: [NSNumber numberWithBool: YES]
                                  forKey: NSURLIsExcludedFromBackupKey error: &error];
    if(!success){
        MyLog(@"Error excluding %@ from backup %@", [URL lastPathComponent], error);
    }
    return success;
}

@end
