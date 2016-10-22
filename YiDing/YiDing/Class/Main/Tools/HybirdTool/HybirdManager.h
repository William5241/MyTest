//
//  HybirdManager.h
//  DongAoAcc
//
//  Created by wihan on 16/5/9.
//  Copyright © 2016年 wihan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WKWebViewJavascriptBridge.h"
#import "WebViewJavascriptBridge.h"
//Handler
//Native获取JS中需要注册的Native方法list的handler name
extern NSString * const kHybirdGetJSRegisterInfoHandler;
//JS获取Native传入的参数
extern NSString * const kHybirdGetNativeInfoHandler;

//Key
//Native获取JS中需要注册的Native方法list的Key值
extern NSString * const kHybirdGetJSRegisterListKey;

@interface HybirdManager : NSObject

@property (nonatomic, strong) NSMutableArray *jsRegisterArray;//html页面需要注册的Native方法列表数组

+ (instancetype)sharedInstance;

/**
 *  1.调用JS方法，获取html页面需要注册的Native 方法list
    2.根据list，向JS注册这些Native方法
    3.根据target-action规则，调用具体的组件功能
 *
 *  @param jsBridge 指定webview的桥接实例
 *  @param parent   webview所在的controller
 */
- (void)hybirdGetAndRegisterJSInfo:(WebViewJavascriptBridge *)jsBridge parent:(id)parent;
/**
 *
 *  @param jsBridge 指定WKWebview的桥接实例
 *  @param parent   WKWebview所在的controller
 */
- (void)hybirdGetAndRegisterWKJSInfo:(WKWebViewJavascriptBridge *)jsBridge parent:(id)parent;


/**
 *  通过jsBridge调用callHandler来获取html页面需要注册的Native 方法list
 *
 *  @param jsBridge 指定webview的桥接实例
 */
- (void)hybirdGetJSRegisterArray:(WKWebViewJavascriptBridge *)jsBridge;

/**
 *  1.根据list，向JS注册这些Native方法
    2.根据target-action规则，调用具体的组件功能
 *
 *  @param jsBridge        指定webview的桥接实例
 *  @param parent          webview所在的controller
 *  @param jsRegisterArray html页面需要注册的Native 方法list
 */
- (void)hybirdNativeRegisterWithJSBridge:(WebViewJavascriptBridge *)jsBridge parent:(id)parent jsRegisterArray:(NSArray *)jsRegisterArray;

/**
 *  @param jsBridge        指定WKWebview的桥接实例
 *  @param parent          WKWebview所在的controller
 *  @param jsRegisterArray html页面需要注册的Native 方法list
 */
- (void)hybirdNativeRegisterWithWKKJSBridge:(WKWebViewJavascriptBridge *)jsBridge parent:(id)parent jsRegisterArray:(NSArray *)jsRegisterArray;
@end
