//
//  YDFineCourseManager.h
//  YiDing
//
//  Created by ALLIN on 16/10/18.
//  Copyright © 2016年 韩伟. All rights reserved.
//

#import "APIBaseManager.h"

@interface YDFineCourseManager : APIBaseManager
- (instancetype)initFineCourse:(NSDictionary *)params finished:(FinishDownLoadBlock)block;

@end
