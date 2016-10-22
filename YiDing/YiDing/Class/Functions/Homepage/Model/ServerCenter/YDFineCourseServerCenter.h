//
//  YDFineCourseServerCenter.h
//  YiDing
//
//  Created by ALLIN on 16/10/18.
//  Copyright © 2016年 韩伟. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YDFineCourseViewModel.h"
/**
 controller需要遵守这个协议，去更新界面
 */
@protocol YDFineCourseServerCenterDelegate <NSObject>
/**
 拉去数据成功，刷新界面的代理
 */
- (void)getFineCourseDataSuccess;

/**
 拉去数据失败，刷新界面的代理
 
 @param userInfo 返回失败信息
 */
- (void)getFineCourseDataFailed:(NSDictionary *)userInfo;

@end
@interface YDFineCourseServerCenter : NSObject
//当前http请求id，可用于cancell
@property (nonatomic, assign) NSInteger currentReqId;
//首页model
@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, weak) id<YDFineCourseServerCenterDelegate> delegate;
/**
 拉取或刷新我的课程数据
 */
- (void)requestFineCourseData;
@end
