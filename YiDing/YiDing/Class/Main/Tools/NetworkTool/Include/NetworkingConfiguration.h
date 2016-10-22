//
//  NetworkingConfiguration.h
//  KoMovie
//
//  Created by hanwei on 15/6/17.
//  Copyright (c) 2015年 kokozu. All rights reserved.
//

#ifndef KoMovie_NetworkingConfiguration_h
#define KoMovie_NetworkingConfiguration_h

typedef NS_ENUM(NSUInteger, URLResponseStatus)
{
    URLResponseStatusSuccess, //作为底层，请求是否成功只考虑是否成功收到服务器反馈。至于签名是否正确，返回的数据是否完整，由上层的RTApiBaseManager来决定。
    URLResponseStatusErrorTimeout,
    URLResponseStatusErrorNoNetwork // 默认除了超时以外的错误都是无网络错误。
};

static NSTimeInterval kNetworkingTimeoutSeconds = 30.0f;
static BOOL kShouldCache = YES;
static NSTimeInterval kCacheOutdateTimeSeconds = 60; // 1分钟的cache过期时间
static NSUInteger kCacheCountLimit = 1000; // 最多1000条cache
static NSUInteger kCountPerPage = 100; // 每一页最多请求的item数量

//首页
extern NSString * const kServiceHomepage;
//精品课程
extern NSString *const kServiceFineCourse;
//版本升级
extern NSString *const kServiceNetworkVersionCheck;
//上传图片
extern NSString *const kServiceUpLoadImage;
//正式服务器
//#define BaseUrl @"http://ios.api.allinmd.cn:18080/services/"
#define BaseUrl @"https://iosapi.allinmd.cn:18081/services/"
//测试服务器

//Suburl版本号
#define UrlCommonVersion @"V1/"

//url参数md5时加的盐
#define Md5Salt @"9538b01d8d3e4c1ab3ba450adb3bea6a" // md5的key

#define Md5H5UserIdSalt @"4b44a096eaa3c94f33845ae3c6e3d14c" //h5 userId的key

#endif
