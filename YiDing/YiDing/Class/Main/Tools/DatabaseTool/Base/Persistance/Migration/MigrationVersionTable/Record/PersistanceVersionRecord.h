//
//  PersistanceVersionRecord.h
//  DongAoAcc
//
//  Created by wihan on 15/11/28.
//  Copyright © 2015年 wihan. All rights reserved.
//

#import "PersistanceRecord.h"

/**
 *  这个version record用于数据迁移
 */
@interface PersistanceVersionRecord : PersistanceRecord

/**
 *  数据库中record的主键
 */
@property (nonatomic, copy) NSNumber *identifier;

/**
 *  在数据库中record的version key
 */
@property (nonatomic, copy) NSString *databaseVersion;

@end
