//
//  PersistanceAsyncExecutor.h
//  DongAoAcc
//
//  Created by wihan on 15/11/27.
//  Copyright © 2015年 wihan. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  异步多线程执行器
 */
@interface PersistanceAsyncExecutor : NSObject

+ (instancetype)sharedInstance;

/**
 *  执行数据库异步操作
 *
 *  你必须使用在block中创建的表，而不要使用在block之外创建的表实例
 *
 *  @param action  执行的block
 *  @param shouldWaitUntilDone YES, 这个方法不会结束，知道block执行完毕.
 */
- (void)performAsyncAction:(void (^)(void))action shouldWaitUntilDone:(BOOL)shouldWaitUntilDone;

@end
