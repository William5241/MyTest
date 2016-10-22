//
//  CMWebViewController.m
//  YiDing
//
//  Created by 韩伟 on 16/10/17.
//  Copyright © 2016年 韩伟. All rights reserved.
//

#import "CMWebViewController.h"
#import "HybirdManager.h"
#import "JsonToModelTool.h"

@interface CMWebViewController ()

@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) WKWebView *wkWebView;
@property (nonatomic, strong) WebViewJavascriptBridge *jsBridge;
@property (nonatomic, strong) WKWebViewJavascriptBridge *wkJsBridge;
@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, assign) NSUInteger loadCount;

@end

@implementation CMWebViewController

#pragma mark – life cycle
- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self setupViews];
    [self setupLayout];
    [self setupData];
    [self setupNavBarBack];//默认不带关闭
    [self setupNotification];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    
    if (kIOS8x) {
        [self.wkWebView removeObserver:self forKeyPath:@"estimatedProgress"];
    }
}

#pragma mark – private functions
#pragma mark – private 初始化
/**
 初始化子views
 */
- (void)setupViews {
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view setTranslatesAutoresizingMaskIntoConstraints:NO];
#warning test
    [self.view addSubview:self.webView];
    [self loadExamplePage:self.webView];
//    if (kIOS8x) {
//        [self.view insertSubview:self.wkWebView belowSubview:self.progressView];
//        [self.wkWebView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
//    }else{
//        [self.view insertSubview:self.webView belowSubview:self.progressView];
//    }
}

/**
 设置页面frame
 */
- (void)setupLayout{
}

/**
 设置导航栏内容带关闭
 */
- (void)setupNavBarClose {
    
    UIBarButtonItem *backBtn = [UIBarButtonItem barButtonItem_itemWithImageName:@"btn_back_nor" highImageName:@"btn_back_pre" target:self action:@selector(back)];
    
    UIButton* right = [UIButton buttonWithType:UIButtonTypeCustom];
    right.frame = CGRectMake(0, 0, 50, 40);
    [right setImage:[UIImage imageNamed:@"btn_close_nor"] forState:UIControlStateNormal];
    [right addTarget:self
              action:@selector(closeWebPage)
    forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *closeBtn = [[UIBarButtonItem alloc] initWithCustomView:right];
    
    self.navigationItem.leftBarButtonItems = @[backBtn,closeBtn];
}

/**
 设置导航栏只有返回
 */
- (void)setupNavBarBack {
    
    //1.导航栏的返回按钮
    self.navigationItem.leftBarButtonItems =@[[UIBarButtonItem barButtonItem_itemWithImageName:@"btn_back_nor" highImageName:@"btn_back_pre" target:self action:@selector(back)]];
    self.navigationItem.title = self.titleStr;
}

/**
 初始化页面数据
 */
- (void)setupData {
    
    [self setupWebViewData];
}

/**
 * 初始化webview数据
 */
- (void)setupWebViewData {
    
    //1.开启日志，方便调试
    [WebViewJavascriptBridge enableLogging];
    //2.移除所有cache
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    //3.注册公共参数的JS
    [self returnCommonParams];
    //4.将JS获取需要注册的Native list，进行注册
    if (kIOS8x) {
        [[HybirdManager sharedInstance] hybirdGetAndRegisterWKJSInfo:self.wkJsBridge parent:self];
        [self.wkWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
    }else{
        [[HybirdManager sharedInstance] hybirdGetAndRegisterJSInfo:self.jsBridge parent:self];
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
    }
}

/**
 设置页面通知
 */
- (void)setupNotification {
}

#pragma mark – private h5/js的数据处理
/**
 加载本地html文件

 @param webView <#webView description#>
 */
- (void)loadExamplePage:(UIWebView*)webView {
    
    NSString* htmlPath = [[NSBundle mainBundle] pathForResource:@"ExampleApp" ofType:@"html"];
    NSString* appHtml = [NSString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];
    NSURL *baseURL = [NSURL fileURLWithPath:htmlPath];
    [webView loadHTMLString:appHtml baseURL:baseURL];
}

- (void)returnCommonParams {
    
#warning demo data
    self.webDic = @{@"userId":@"123456",@"type":@"app"};
    __weak __typeof(self)weakSelf = self;
    if (kIOS8x) {
        
        [self.wkJsBridge registerHandler:@"returnCommonParams" handler:^(id data, WVJBResponseCallback responseCallback) {
            //1.data是JS所传的参数，这里Native用data当做params dic参数
            if (responseCallback) {
                if (weakSelf.webDic){
                    responseCallback([JsonToModelTool dictToJson:weakSelf.webDic]);
                }
            }
        }];
    }else{
        [self.jsBridge registerHandler:@"returnCommonParams" handler:^(id data, WVJBResponseCallback responseCallback) {
            if (responseCallback) {
                if (weakSelf.webDic){
                    responseCallback([JsonToModelTool dictToJson:weakSelf.webDic]);
                }
            }
        }];
    }
}

- (void)callHandler {
    
#warning demo data
    self.webDic = @{@"userId":@"123456",@"type":@"app"};
    
    if (kIOS8x) {
        [self.wkJsBridge callHandler:@"getAppUserInfoTransToM" data:[JsonToModelTool dictToJson:self.webDic] responseCallback:^(id response) {
            NSLog(@"testJavascriptHandler responded: %@", response);
        }];
    }else{
        [self.jsBridge callHandler:@"getAppUserInfoTransToM" data:[JsonToModelTool dictToJson:self.webDic] responseCallback:^(id response) {
            NSLog(@"testJavascriptHandler responded: %@", response);
        }];
    }
}

/**
 计算webView进度条
 
 @param loadCount 进度数字
 */
- (void)setLoadCount:(NSUInteger)loadCount {
    
    _loadCount = loadCount;
    if (loadCount == 0) {
        [self.progressView setProgress:1 animated:YES];
        [self performSelector:@selector(delayMethod) withObject:nil afterDelay:1.0f];
    }else {
        self.progressView.hidden = NO;
        CGFloat oldP = self.progressView.progress;
        CGFloat newP = (1.0 - oldP) / (loadCount + 1) + oldP;
        if (newP > 0.95) {
            newP = 0.95;
        }
        [self.progressView setProgress:newP animated:YES];
    }
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView {
    
    self.loadCount ++;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    if ([self.webView canGoBack]) {
        [self setupNavBarClose];
    }else{
        [self setupNavBarBack];
    }
    self.loadCount --;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    
    self.loadCount --;
    //异常页面处理
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    [self.webView reload];
}

#pragma mark - WKNavigationDelegate
/**
 添加此方法，可以将wkwebview跳转到AppStore
 */
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
    [self.progressView setProgress:0 animated:NO];
    if ([webView.URL.absoluteString hasPrefix:@"https://itunes.apple.com"]) {
        [[UIApplication sharedApplication] openURL:navigationAction.request.URL];
        decisionHandler(WKNavigationActionPolicyCancel);
    }else {
        decisionHandler(WKNavigationActionPolicyAllow);
    }
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
    
    if ([self.wkWebView canGoBack]) {
        [self setupNavBarClose];
    }else{
        [self setupNavBarBack];
    }
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error{
    //异常页面处理
}

// 计算wkWebView进度条

/**
 wkWebView进度条计算
 */
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    if (object == self.wkWebView && [keyPath isEqualToString:@"estimatedProgress"]) {
        CGFloat newprogress = [[change objectForKey:NSKeyValueChangeNewKey] doubleValue];
        if (newprogress == 1) {
            [self.progressView setProgress:1 animated:YES];
            [self performSelector:@selector(delayMethod) withObject:nil afterDelay:1.0f];
        }else {
            self.progressView.hidden = NO;
            [self.progressView setProgress:newprogress animated:YES];
        }
    }
}

#pragma mark - WKUIDelegate
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:message message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        completionHandler(YES);
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        completionHandler(NO);
    }]];
    [self presentViewController:alertController animated:YES completion:^{}];
}

- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:message message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        completionHandler();
    }]];
    [self presentViewController:alertController animated:YES completion:^{}];
}

#pragma mark - event response
- (void)delayMethod {
    
    self.progressView.hidden = YES;
}

- (void)back {
    
    if (kIOS8x) {
        if ([self.wkWebView canGoBack]) {
            [self.wkWebView goBack];
        }else{
            [self closeWebPage];
        }
    }else{
        if ([self.webView canGoBack]) {
            [self.webView goBack];
        }else{
            [self closeWebPage];
        }
    }
}

- (void)closeWebPage {
    
    if (self.webViewCloseBlock) {
        self.webViewCloseBlock();
    }
    if (kIOS8x) {
        self.wkJsBridge = nil;
    }else{
        self.jsBridge = nil;
    }
    switch ([self.transformType integerValue]) {
        case kTransformTypePush:
            [self.navigationController popViewControllerAnimated:YES];
            break;
        case kTransformTypePresent:
            [self dismissViewControllerAnimated:YES completion:nil];
        default:
            break;
    }
}

- (void)reloadCurrentPage {
    
    if (kIOS8x) {
        [self.wkWebView reload];
    }else{
        [self.webView reload];
    }
}

- (void)reloadWebView {
    
    [self reloadCurrentPage];
}

#pragma mark – getters and setters
- (UIWebView *)webView {
    
    if (_webView == nil) {
        _webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
        _webView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        _webView.scalesPageToFit = YES;
        _webView.backgroundColor = [UIColor yellowColor];
        _webView.delegate = self;
    }
    return _webView;
}

- (WKWebView *)wkWebView {
    
    if (_wkWebView == nil) {
        _wkWebView = [[WKWebView alloc] initWithFrame: self.view.bounds];
        _wkWebView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        _wkWebView.backgroundColor = [UIColor whiteColor];
        _wkWebView.UIDelegate = self;
        _wkWebView.navigationDelegate = self;
    }
    return _wkWebView;
}

- (UIProgressView *)progressView {
    
    if (_progressView == nil) {
        _progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 0, PHONE_WIDTH, 0)];
        _progressView.tintColor = kCommonRGBColor(84, 199, 252);
        _progressView.trackTintColor = [UIColor whiteColor];
    }
    return _progressView;
}

- (WebViewJavascriptBridge *)jsBridge {
    
    if (_jsBridge == nil) {
        _jsBridge = [WebViewJavascriptBridge bridgeForWebView:self.webView];
        [_jsBridge setWebViewDelegate:self];
    }
    return _jsBridge;
}

- (WKWebViewJavascriptBridge *)wkJsBridge {
    
    if (_wkJsBridge == nil) {
        _wkJsBridge = [WKWebViewJavascriptBridge bridgeForWebView:self.wkWebView];
        [_wkJsBridge setWebViewDelegate:self];
    }
    return _wkJsBridge;
}

@end
