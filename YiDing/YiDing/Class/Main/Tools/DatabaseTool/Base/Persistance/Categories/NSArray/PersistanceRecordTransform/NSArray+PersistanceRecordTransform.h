//
//  NSArray+PersistanceRecordTransform.h
//  DongAoAcc
//
//  Created by wihan on 15/11/27.
//  Copyright © 2015年 wihan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PersistanceRecord.h"

/**
 *  主要负责将数组中的item根据class转成相应的object
 */
@interface NSArray (PersistanceRecordTransform)

/**
 *  将数组中的items根据指定的classType转换成object，而classType必须遵循<PersistanceRecordProtocol>协议，如果classType没有遵循这个协议，将返回空数组而不是nil
 */
- (NSArray *)transformSQLItemsToClass:(Class<PersistanceRecordProtocol>)classType;

@end
