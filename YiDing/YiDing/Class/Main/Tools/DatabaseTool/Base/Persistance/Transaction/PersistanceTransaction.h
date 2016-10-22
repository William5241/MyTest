//
//  PersistanceTransaction.h
//  DongAoAcc
//
//  Created by wihan on 15/11/27.
//  Copyright © 2015年 wihan. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "PersistanceQueryCommand.h"

/**
 *  specify the lock type when transaction begins.
 */
typedef NS_ENUM(NSUInteger, PersistanceTransactionLockType){
    /**
     *  默认是延期事物锁
     */
    PersistanceTransactionLockTypeDefault,
    /**
     *  延期事物锁
     */
    PersistanceTransactionLockTypeDeferred,
    /**
     *  立即事物锁
     */
    PersistanceTransactionLockTypeImmediate,
    /**
     *  独占事物锁
     */
    PersistanceTransactionLockTypeExclusive,
};

/**
 *  这个类用来执行数据库实务
 */
@interface PersistanceTransaction : NSObject

/**
 *  执行transaction
 *
 *  @param transactionBlock 实务执行的block
 *  @param queryCommand     PersistanceQueryCommand 实例
 *  @param lockType         实务执行的锁的类型（延迟，独占，及时）
 */
+ (void)performTranscationWithBlock:(void(^)(BOOL *shouldRollback))transactionBlock
                       queryCommand:(PersistanceQueryCommand *)queryCommand
                           lockType:(PersistanceTransactionLockType)lockType;

@end