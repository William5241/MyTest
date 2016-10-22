//
//  YDFineCourseReformer.h
//  YiDing
//
//  Created by ALLIN on 16/10/18.
//  Copyright © 2016年 韩伟. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "APIBaseManager.h"

@interface YDFineCourseReformer : NSObject<APIManagerCallbackDataReformer>
+ (id)initFineCourseReformer:(NSString *)serviceType;

@end
