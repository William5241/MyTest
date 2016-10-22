//
//  YDHomepageManager.h
//  YiDing
//
//  Created by 韩伟 on 16/10/15.
//  Copyright © 2016年 韩伟. All rights reserved.
//

#import "APIBaseManager.h"

@interface YDHomepageManager : APIBaseManager <APIManager, APIManagerApiCallBackDelegate, APIManagerParamSourceDelegate, APIManagerValidator>

- (instancetype)initHomepage:(NSDictionary *)params finished:(FinishDownLoadBlock)block;
@end
