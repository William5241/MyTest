//
//  PersistanceVersionTable.h
//  DongAoAcc
//
//  Created by wihan on 15/11/28.
//  Copyright © 2015年 wihan. All rights reserved.
//

#import "PersistanceTable.h"
#import "PersistanceDataBase.h"

/**
 *  这个version table用做数据库迁移
 */
@interface PersistanceVersionTable : PersistanceTable <PersistanceTableProtocol>

- (instancetype)initWithDatabase:(PersistanceDataBase *)database;

@end
