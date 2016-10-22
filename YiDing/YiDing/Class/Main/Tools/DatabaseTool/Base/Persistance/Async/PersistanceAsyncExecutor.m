//
//  PersistanceAsyncExecutor.m
//  DongAoAcc
//
//  Created by wihan on 15/11/27.
//  Copyright © 2015年 wihan. All rights reserved.
//

#import "PersistanceAsyncExecutor.h"

@interface PersistanceAsyncExecutor ()
//统一在这个队列中处理异步操作，最大并发数为1
@property (nonatomic, strong) NSOperationQueue *operationQueue;

@end

@implementation PersistanceAsyncExecutor

#pragma mark - public methods
+ (instancetype)sharedInstance {
    
    static PersistanceAsyncExecutor *executor = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        executor = [[PersistanceAsyncExecutor alloc] init];
    });
    return executor;
}

- (void)performAsyncAction:(void (^)(void))action shouldWaitUntilDone:(BOOL)shouldWaitUntilDone {
    
    __block BOOL shouldWait = shouldWaitUntilDone;
    
    NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
        action();
        shouldWait = NO;
    }];
    
    [self.operationQueue addOperation:operation];
    //如果shouldWait为YES,则需要等待operation执行完成，将shouldWait设置成NO在退出等待循环
    while (shouldWait) {
    }
}

#pragma mark - getters and setters
- (NSOperationQueue *)operationQueue {
    
    if (_operationQueue == nil) {
        _operationQueue = [[NSOperationQueue alloc] init];
        _operationQueue.maxConcurrentOperationCount = 1;
    }
    return _operationQueue;
}

@end
