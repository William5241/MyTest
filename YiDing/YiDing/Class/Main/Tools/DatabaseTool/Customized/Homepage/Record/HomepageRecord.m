//
//  HomepageRecord.m
//  YiDing
//
//  Created by 韩伟 on 16/10/16.
//  Copyright © 2016年 韩伟. All rights reserved.
//

#import "HomepageRecord.h"

@implementation HomepageRecord

#pragma mark - PersistanceRecordProtocol
- (NSArray *)availableKeyList {
    
    return @[@"primaryKey", @"userId", @"year"];
}

@end
