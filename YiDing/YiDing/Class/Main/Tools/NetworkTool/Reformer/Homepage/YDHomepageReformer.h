//
//  YDHomepageReformer.h
//  YiDing
//
//  Created by 韩伟 on 16/10/15.
//  Copyright © 2016年 韩伟. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "APIBaseManager.h"

@interface YDHomepageReformer : NSObject <APIManagerCallbackDataReformer>

/**
 根据serviceType来初始化Reformer

 @param serviceType API service type

 @return 返回reformer self
 */
+ (id)initHomepageReformer:(NSString *)serviceType;
@end
