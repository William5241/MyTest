//
//  YDCommonDefine.h
//  YiDing
//
//  Created by zhangbin on 16/10/19.
//  Copyright © 2016年 韩伟. All rights reserved.
//

#ifndef YDCommonDefine_h
#define YDCommonDefine_h


#pragma mark -Debug
/// 线上线下开关   1线上  0线下.
#define ON_LINE 0

#ifdef DEBUG //调试状态, 打开LOG功能
#define MyLog(s,...) NSLog( @"%@ \r\n Class: %@   Line: %d ", \
[NSString stringWithFormat:(s), ##__VA_ARGS__],  \
[[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__ )

#define debugMethod() NSLog(@"%s", __func__)
#else //发布状态, 关闭LOG功能
#define MyLog(...)
#endif//DEBUG

//是否为iOS7以上版本
#define kIOS7 ([[UIDevice currentDevice].systemVersion doubleValue] >= 7.0)

//是否为iOS8以上版本
#define kIOS8x ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0)

//获取当前AppDelegate
#define kKQAppDelegate ((AppDelegate *)[UIApplication sharedApplication].delegate)

//是否为iphone4英寸
#define FourInch ([UIScreen mainScreen].bounds.size.height == 480.0)

//当前版本号
#define kCurrentVersion ([[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"])

/// 版本号是不是低于 x.
#define kSYSTEM_VERSION_LESS_THAN(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)

//App id
#define kAppId @"747773996"



//Appstore url
#define kAppstoreUrl ([NSString stringWithFormat:@"http://itunes.apple.com/lookup?id=%@", kAppId])

//BundleID
#define kBundleID ([[NSBundle mainBundle] bundleIdentifier])

//Device
#define kDevice ([[UIDevice currentDevice] model])

//Color
#define kCommonRGBColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
/// 通过RGB 可以设置alpha .
#define kCommonRGBAColor(r, g, b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

//NavigationBar高度
#define kNavigationBarHeight 44.0f

//StatusBar高度
#define kStatusBarHeight 20.0f

//应用名称，后台统计使用
#define kAppName @"da-kq-app"

//Iphone为0
#define kDeviceType @"0"

//用来判断是ios/android/h5
#define kAppSiteType 5

#define kOSVersion [UIDevice currentDevice].systemName

#define kDeviceSystemInfo [NSString stringWithFormat:@"%@%@",[UIDevice currentDevice].systemName,[UIDevice currentDevice].systemVersion]

//归档/解档.
#define OBJC_STRING(x) @#x
#define Decode(x) self.x = [aDecoder decodeObjectForKey:OBJC_STRING(x)]
#define Encode(x) [aCoder encodeObject:self.x forKey:OBJC_STRING(x)]



/// weakSelf.
#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;

#pragma mark -userDefine
/// NSUserDefaults.
#define kYDUserDefault            [NSUserDefaults standardUserDefaults]



#pragma mark -path

/// doc沙盒.
#define kDocPath         [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, \
NSUserDomainMask, YES) objectAtIndex:0]

/// cache沙盒.
#define kCachPath        [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, \
NSUserDomainMask, YES) objectAtIndex:0]

/// temp沙盒.
#define kTmpPath          NSTemporaryDirectory()



#warning 用户信息
/// 登录类型.
#define kLogin_Type                     @"logself.loginType"
/// 是否是手机注册的.
#define kLog_IsMobile                   @"log_isCheckMobile"
/// 用户id.
#define kLog_CustomerId                  @"customerId"
/// 用户临时id.
#define kLog_TempId                      @"tempId"
/// 头像url.
#define kLogo_Url                        @"logo_url"
/// 是否上传过真实头像.
#define kIsLog_URL                       @"islog_url"
/// 登录密码.
#define kLog_Passwd                      @"log_passwd"
/// 登录邮箱.
#define kLog_Email                       @"log_email"
/// 是否是coas.
#define kLog_UniteFlagCAOS               @"log_uniteFlagCaos"
/// coas用户名.
#define kLog_UniteNameCAOS               @"log_uniteNameCaos"
/// 用户手机号.
#define kLog_Mobile                      @"log_mobile"
/// 认证状态.
#define kLog_AuthState                   @"Log_authState"
/// 用户姓名.
#define kLog_DoctorName                  @"doctor_name"
/// 姓.
#define kLog_LastName                    @"lastName"
/// 名.
#define kLog_FirstName                   @"firstName"
/// 完善资料.
#define kLog_PerfectApprove              @"perfect_approvePass"
/// 医院.
#define kLog_ApproveCompany              @"approve_company"
/// 医院id.
#define kLog_ApproveCompanyID            @"approve_companyId"
/// 专业领域.
#define kLog_ApproveAreasExpertise       @"approve_areasExpertise"
/// 职称.
#define kLog_Approve_MedicalTitle        @"approve_medicalTitle"
/// job.
#define kLog_ApproveTimeInJob            @"Approve_timeInJob"
/// city.
#define kLog_SaveCity                    @"save_city"
/// 关注数目.
#define kLog_AttentionNum               @"attentionNum"
/// 粉丝数目.
#define kLog_FansNum                    @"fansNum"
/// 浏览数目.
#define kLog_SubscribNum                @"subscribNum"
/// 本地视频数目.
#define kLog_LocalVideoNum              @"localVideoNum"
/// 他人点赞数目.
#define kLog_OtherPraiseNum             @"otherPraiseNum"
/// 发布的病例数目.
#define kLog_casePublishNum             @"casePublishNum"
/// 发布的话题数目.
#define kLog_topicPublishNum            @"topicPublishNum"
/// 发布的视频数目.
#define kLog_videoPublishNum            @"videoPublishNum"
/// 评论数目.
#define kLog_reviewNum                  @"reviewNum"
/// 收藏数目.
#define kLog_collectNum                 @"collectNum"
/// 浏览记录.
#define kLog_scanRecord                 @"scanRecord"
/// 是否有动态.
#define kLog_allTrends                  @"allTrends"
/// 草稿箱数目.
#define kLog_draftNum                   @"draftNum"
/// 用户角色.
#define kLog_customerRole               @"customerRole"
/// 性别 PC端同步到APP需要用到.
#define kLog_sex                        @"sex"
/// 年龄.
#define kLog_age                        @"log_age"
/// 是否跳过上传头像.
#define kLog_skipUploadPhoto            @"log_skipUploadPhoto"
/// 是否不再提示上传头像
#define kLog_unNoticeUploadPhoto        @"log_unNoticeUploadPhoto"
/// 微信授权的token.
#define kWeChat_access_token            @"access_token"
/// 微信授权的unionid.
#define kWeChat_uionid                  @"unionid"
/// 微信授权的 openid.
#define kWecChat_openid                 @"openid"
/// 是否绑定微信.
#define kLog_uniteFlagWeChat            @"log_uniteFlagWeixin"


#endif /* YDCommonDefine_h */

