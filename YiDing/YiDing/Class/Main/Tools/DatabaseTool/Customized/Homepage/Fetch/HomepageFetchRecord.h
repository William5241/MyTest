//
//  HomepageFetchRecord.h
//  YiDing
//
//  Created by 韩伟 on 16/10/16.
//  Copyright © 2016年 韩伟. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HomepageTable.h"

@interface HomepageFetchRecord : NSObject
/**
 1.根据keyDic值找到相应的data
 2.如果没找到返回nil

 @return 返回HomepageRecord
 */
- (HomepageRecord *)homepageFetchData;

@end
