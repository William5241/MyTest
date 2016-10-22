//
//  CMWebViewController.h
//  YiDing
//
//  Created by 韩伟 on 16/10/17.
//  Copyright © 2016年 韩伟. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import "WebViewJavascriptBridge.h"
#import "WKWebViewJavascriptBridge.h"

typedef NS_ENUM (NSUInteger,TransformType) {
    kTransformTypePush = 0,//ViewController push进来
    kTransformTypePresent = 1//ViewController present进
};

typedef void(^WebViewCloseBlock)(void);

@interface CMWebViewController : UIViewController <UIWebViewDelegate,WKNavigationDelegate,WKUIDelegate>

//Native需要传给html页的数据
@property (nonatomic, strong) NSDictionary *webDic;
//webview需要的url
@property (nonatomic, strong) NSString *url;
//打开的方式 0：push 1：present
@property (nonatomic, strong) NSString *transformType;
//webview应该显示的title
@property (nonatomic, strong) NSString *titleStr;
//webview close后的回调
@property (nonatomic, strong) WebViewCloseBlock webViewCloseBlock;

@end
