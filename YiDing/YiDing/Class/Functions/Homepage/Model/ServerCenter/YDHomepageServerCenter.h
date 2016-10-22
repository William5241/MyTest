//
//  YDHomepageServerCenter.h
//  YiDing
//
//  Created by 韩伟 on 16/10/15.
//  Copyright © 2016年 韩伟. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YDHomepageViewModel.h"
/**
 controller需要遵守这个协议，去更新界面
 */
@protocol YDHomepageServerCenterDelegate <NSObject>
/**
 拉去数据成功，刷新界面的代理
 */
- (void)getHomepageDataSuccess;

/**
 拉去数据失败，刷新界面的代理

 @param userInfo 返回失败信息
 */
- (void)getHomepageDataFailed:(NSDictionary *)userInfo;

@end

@interface YDHomepageServerCenter : NSObject

//当前http请求id，可用于cancell
@property (nonatomic, assign) NSInteger currentReqId;
//首页model
@property (nonatomic, strong) YDHomepageViewModel *homepageViewModel;

@property (nonatomic, weak) id<YDHomepageServerCenterDelegate> delegate;

/**
 拉取或刷新我的课程数据
 */
- (void)requestHomepageData;

@end
