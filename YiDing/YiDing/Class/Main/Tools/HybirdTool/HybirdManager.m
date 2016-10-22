//
//  HybirdManager.m
//  DongAoAcc
//
//  Created by wihan on 16/5/9.
//  Copyright © 2016年 wihan. All rights reserved.
//
/**
 *  介绍：此类为一个单例类，用来管理HTML(JS)-JSBridge-Native的逻辑与方法
 *  注意：
 *  1.JS同Native的交互采用JSON串
 *  2.启动webpage后，App会向JS请求(请求方法callHandler)这个webpage中用到的所有Native方法list。
 *  3.list中的每个item有如下字段
      scheme：后台定义的应用名称
      target：组件模块名称
      action：组件功能名称
      transformType：启动界面的方式和类型
      params：对应参数，应该是个字典
 *  4.以action为handler name，调用registerHandler来向JS注册本地Native方法
 *  5.本地方法的具体实现，通过DispatcherManager的 dispatcherFromRemote方法执行，由dispatcher调用具体的组件功能
 */
#import "HybirdManager.h"
#import "JsonToModelTool.h"
#import "DispatcherManager.h"

NSString * const kHybirdGetJSRegisterInfoHandler = @"getJSRegisterInfoHandler";
NSString * const kHybirdGetNativeInfoHandler = @"getNativeInfoHandler";
NSString * const kHybirdGetJSRegisterListKey = @"jsRegisterList";


@interface HybirdManager ()

@end

@implementation HybirdManager

+ (instancetype)sharedInstance {
    
    static HybirdManager *hybirdManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        hybirdManager = [[HybirdManager alloc] init];
    });
    return hybirdManager;
}

#pragma mark - private function
/**
 *  初始化本身的类，设置默认值
 *
 *  @return 实例
 */
- (instancetype)init {
    self = [super init];
    if (self) {
        self.jsRegisterArray = [NSMutableArray new];
    }
    return self;
}

#pragma mark - public function
- (void)hybirdGetAndRegisterJSInfo:(WebViewJavascriptBridge *)jsBridge parent:(id)parent {
    
    if (jsBridge) {
        __weak __typeof(self)weakSelf = self;
        __weak __typeof(jsBridge)weakJSBridge = jsBridge;
        __weak __typeof(id)weakParent = parent;
        [jsBridge callHandler:kHybirdGetJSRegisterInfoHandler data:nil responseCallback:^(id responseData) {
//            NSDictionary *dic = [JsonToModelTool jsonToDict:(NSString *)responseData];
            NSDictionary *dic = (NSDictionary *)responseData;
            if (dic) {
                [weakSelf.jsRegisterArray removeAllObjects];
                [weakSelf.jsRegisterArray addObjectsFromArray:dic[kHybirdGetJSRegisterListKey]];
                if (weakSelf.jsRegisterArray && weakSelf.jsRegisterArray.count) {
                    [weakSelf hybirdNativeRegisterWithJSBridge:weakJSBridge parent:weakParent jsRegisterArray:weakSelf.jsRegisterArray];
                }
            }
        }];
    }
}

- (void)hybirdGetAndRegisterWKJSInfo:(WKWebViewJavascriptBridge *)jsBridge parent:(id)parent{
    if (jsBridge) {
        __weak __typeof(self)weakSelf = self;
        __weak __typeof(jsBridge)weakJSBridge = jsBridge;
        __weak __typeof(id)weakParent = parent;
        [jsBridge callHandler:kHybirdGetJSRegisterInfoHandler data:nil responseCallback:^(id responseData) {
            //            NSDictionary *dic = [JsonToModelTool jsonToDict:(NSString *)responseData];
            NSDictionary *dic = (NSDictionary *)responseData;
            if (dic) {
                [weakSelf.jsRegisterArray removeAllObjects];
                [weakSelf.jsRegisterArray addObjectsFromArray:dic[kHybirdGetJSRegisterListKey]];
                if (weakSelf.jsRegisterArray && weakSelf.jsRegisterArray.count) {
                    [weakSelf hybirdNativeRegisterWithWKKJSBridge:weakJSBridge parent:weakParent jsRegisterArray:weakSelf.jsRegisterArray];
                }
            }
        }];
    }
}

- (void)hybirdGetJSRegisterArray:(WKWebViewJavascriptBridge *)jsBridge {
    
    if (jsBridge) {
        __weak __typeof(self)weakSelf = self;
        [jsBridge callHandler:kHybirdGetJSRegisterInfoHandler data:nil responseCallback:^(id responseData) {
//            NSDictionary *dic = [JsonToModelTool jsonToDict:(NSString *)responseData];
            NSDictionary *dic = (NSDictionary *)responseData;
            if (dic) {
                [weakSelf.jsRegisterArray removeAllObjects];
                [weakSelf.jsRegisterArray addObjectsFromArray:dic[kHybirdGetJSRegisterListKey]];
            }
        }];
    }
}

- (void)hybirdNativeRegisterWithJSBridge:(WebViewJavascriptBridge *)jsBridge parent:(id)parent jsRegisterArray:(NSArray *)jsRegisterArray {
    
    if (jsRegisterArray && jsRegisterArray.count && jsBridge) {
        for (NSDictionary *registerDic in jsRegisterArray) {
            __weak __typeof(id)weakParent = parent;
            [jsBridge registerHandler:registerDic[kDispatcherAction] handler:^(id data, WVJBResponseCallback responseCallback) {
                //1.data是JS所传的参数，这里Native用data当做params dic参数
                NSMutableDictionary *finalDic = [NSMutableDictionary dictionaryWithDictionary:registerDic];
                if (data) {
                    finalDic[kDispatcherParams] = data;
                }
                NSString *json = [JsonToModelTool dictToJson:finalDic];
                MyLog(@"hybirdNativeRegisterWithJSBridge: %@", data);
                NSDictionary *returnData = (NSDictionary *)[DispatcherManager dispatcherFromRemote:json parent:weakParent completion:nil];
                //2.如果JS提供回调，则将Native的返回值returnData返还JS
                if (responseCallback) {
                    if (returnData){
                        responseCallback(returnData);
                    }
                }
            }];
        }
    }
}

- (void)hybirdNativeRegisterWithWKKJSBridge:(WKWebViewJavascriptBridge *)jsBridge parent:(id)parent jsRegisterArray:(NSArray *)jsRegisterArray {
    
    if (jsRegisterArray && jsRegisterArray.count && jsBridge) {
        for (NSDictionary *registerDic in jsRegisterArray) {
            __weak __typeof(id)weakParent = parent;
            [jsBridge registerHandler:registerDic[kDispatcherAction] handler:^(id data, WVJBResponseCallback responseCallback) {
                //1.data是JS所传的参数，这里Native用data当做params dic参数
                NSMutableDictionary *finalDic = [NSMutableDictionary dictionaryWithDictionary:registerDic];
                if (data) {
                    finalDic[kDispatcherParams] = data;
                }
                NSString *json = [JsonToModelTool dictToJson:finalDic];
                MyLog(@"hybirdNativeRegisterWithJSBridge: %@", data);
                NSDictionary *returnData = (NSDictionary *)[DispatcherManager dispatcherFromRemote:json parent:weakParent completion:nil];
                //2.如果JS提供回调，则将Native的返回值returnData返还JS
                if (responseCallback) {
                    if (returnData){
                        responseCallback(returnData);
                    }
                }
            }];
        }
    }
}

@end
