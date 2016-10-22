//
//  YDHomepageDataCenter.h
//  YiDing
//
//  Created by 韩伟 on 16/10/16.
//  Copyright © 2016年 韩伟. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YDHomepageViewModel.h"

@interface YDHomepageDataCenter : NSObject

/**
 将数据保存到数据库中
 
 @param userInfo 需要保存的数据
 */
- (void)saveHomepageData:(NSDictionary *)userInfo;

/**
 1.将传入的数据插入到数据库
 2.如果有userId相同的数据则删除
 3.将新的record插入到新的数据库中
 
 @param dic 需要插入的数据
 */
- (void)homepageDataCenterInsert:(NSDictionary *)dic;

/**
 1.从数据库获取数据
 2.如果没有找到，则返回nil

 @return 返回获取的数据
 */
- (YDHomepageViewModel *)homepageDataCenterFetch;

@end
