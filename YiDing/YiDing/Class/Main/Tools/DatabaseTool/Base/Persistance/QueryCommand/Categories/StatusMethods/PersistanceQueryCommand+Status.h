//
//  PersistanceQueryCommand+Status.h
//  DongAoAcc
//
//  Created by wihan on 15/11/27.
//  Copyright © 2015年 wihan. All rights reserved.
//

#import "PersistanceQueryCommand.h"

@interface PersistanceQueryCommand (Status)

/**
 *  返回最后一个insert的row id
 */
- (NSNumber *)lastInsertRowId;

/**
 *  返回最后一个insert的row id
 */
- (NSNumber *)rowsChanged;

@end
