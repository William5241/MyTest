//
//  ViewControllerIntercepter.m
//  KoMovie
//
//  Created by hanwei on 15/6/18.
//  Copyright (c) 2015年 wihan. All rights reserved.
//

#import "ViewControllerIntercepter.h"
#import "Aspects.h"

@implementation ViewControllerIntercepter

/**
 * + (void)load 会在应用启动的时候自动被runtime调用，通过重载这个方法来实现最小的对业务方的“代码入侵”
 */
+ (void)load {
    
    [super load];
    [ViewControllerIntercepter sharedInstance];
}

+ (instancetype)sharedInstance {
    
    static dispatch_once_t onceToken;
    static ViewControllerIntercepter *sharedInstance;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[ViewControllerIntercepter alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
    
    self = [super init];
    if (self) {
        //在这里做好方法拦截,原生函数执行完后再执行这里
        [UIViewController aspect_hookSelector:@selector(viewWillAppear:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> aspectInfo, BOOL animated){
            [self viewWillAppear:animated viewController:[aspectInfo instance]];
        } error:NULL];
        
        [UIViewController aspect_hookSelector:@selector(viewWillDisappear:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> aspectInfo, BOOL animated){
            [self viewWillDisappear:animated viewController:[aspectInfo instance]];
        } error:NULL];
    }
    return self;
}

#pragma mark - fake methods
- (void)viewWillAppear:(BOOL)animated viewController:(UIViewController *)viewController {
    
    //1.你可以使用这个方法进行打日志，初始化基础业务相关的内容
    MyLog(@"[%@ viewWillAppear:%@]", [viewController class], animated ? @"YES" : @"NO");
    
    // 友盟
//    [MobClick beginLogPageView:NSStringFromClass([viewController class])];
}

- (void)viewWillDisappear:(BOOL)animated viewController:(UIViewController *)viewController {
    
    //1.你可以使用这个方法进行打日志，初始化基础业务相关的内容
    MyLog(@"[%@ viewWillAppear:%@]", [viewController class], animated ? @"YES" : @"NO");
    
//    [MobClick endLogPageView:NSStringFromClass([viewController class])];
}

@end
