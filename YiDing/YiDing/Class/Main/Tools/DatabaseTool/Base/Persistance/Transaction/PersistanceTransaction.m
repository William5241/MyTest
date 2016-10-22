//
//  PersistanceTransaction.m
//  DongAoAcc
//
//  Created by wihan on 15/11/27.
//  Copyright © 2015年 wihan. All rights reserved.
//

/**
 * 事物（Transaction）说明：
   使用BEGIN命令手动启动事务，这样启动的事务会在下一条COMMIT或ROLLBACK命令之前一直有效；但若数据库关闭 或出现错误且选用ROLLBACK冲突判定算法时，数据库也会ROLLBACK。
   在SQLite 3.0.8或更高版本中，事务可以是延迟的，即时的或者独占的
   “延迟的”：即是说在数据库第一次被访问之前不获得锁；这样就会延迟事务，BEGIN语句本身不做任何事情；直到初次读取或访问数据库时才获取锁；对数据库的初次读取创建一个SHARED锁 ，初次写入创建一个RESERVED锁；由于锁的获取被延迟到第一次需要时，别的线程或进程可以在当前线程执行BEGIN语句之后创建另外的事务 写入数据库。
   “即时的”：执行BEGIN命令后立即获取RESERVED锁，而不等数据库被使用；在执行BEGIN IMMEDIATE之后， 你可以确保其它的线程或进程不能写入数据库或执行BEGIN IMMEDIATE或BEGIN EXCLUSIVE，但其它进程可以读取数据库
   “独占事务”：所有的数据库获取EXCLUSIVE锁，在执行BEGIN EXCLUSIVE之后，你可以确保在当前事务结束前没有任何其它线程或进程 能够读写数据库。
   SQLite 3.0.8的默认行为是创建“延迟事务”
   执行COMMIT可能会返回SQLITE_BUSY错误代码。这就是说有另外一个线程或进程获取了数据库的读取锁，并阻止数据库被改变。当COMMIT获得该错误代码时，事务依然是活动的，并且在COMMIT可以在当前读取的线程读取结束后再次试图读取数据库。
   事物回滚：如果实务执行失败，则从新执行
 */
#import "PersistanceTransaction.h"

@implementation PersistanceTransaction

+ (void)performTranscationWithBlock:(void (^)(BOOL *))transactionBlock queryCommand:(PersistanceQueryCommand *)queryCommand lockType:(PersistanceTransactionLockType)lockType
{
    if (queryCommand == nil || transactionBlock == nil) {
        return;
    }
    
    [queryCommand resetQueryCommand];
    switch (lockType) {
        //独占事物
        case PersistanceTransactionLockTypeExclusive:
        {
            [queryCommand.sqlString appendString:@"BEGIN EXCLUSIVE TRANSACTION"];
            break;
        }
        //及时事物
        case PersistanceTransactionLockTypeImmediate:
        {
            [queryCommand.sqlString appendString:@"BEGIN IMMEDIATE TRANSACTION"];
            break;
        }
        //延迟事物
        case PersistanceTransactionLockTypeDeferred:
        case PersistanceTransactionLockTypeDefault:
        default:
        {
            [queryCommand.sqlString appendString:@"BEGIN DEFERRED TRANSACTION"];
            break;
        }
    }
    [queryCommand executeWithError:NULL];
    //是否回滚通过block带回来
    BOOL shouldRollback = NO;
    transactionBlock(&shouldRollback);
    
    if (shouldRollback) {
        [queryCommand resetQueryCommand];
        [queryCommand.sqlString appendString:@"ROLLBACK TRANSACTION"];
        [queryCommand executeWithError:NULL];
    } else {
        [queryCommand resetQueryCommand];
        [queryCommand.sqlString appendString:@"COMMIT TRANSACTION"];
        [queryCommand executeWithError:NULL];
    }
}

@end
