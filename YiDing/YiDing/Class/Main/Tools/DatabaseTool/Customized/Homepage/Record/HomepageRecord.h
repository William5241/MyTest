//
//  HomepageRecord.h
//  YiDing
//
//  Created by 韩伟 on 16/10/16.
//  Copyright © 2016年 韩伟. All rights reserved.
//

#import "PersistanceRecord.h"

@interface HomepageRecord : PersistanceRecord

@property (nonatomic, strong) NSNumber *primaryKey;
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *year;

@end
