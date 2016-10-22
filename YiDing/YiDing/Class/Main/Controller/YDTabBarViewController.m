//
//  YDTabBarViewController.m
//  YiDing
//
//  Created by 韩伟 on 16/10/15.
//  Copyright © 2016年 韩伟. All rights reserved.
//

#import "YDTabBarViewController.h"
#import "YDUINavigationViewController.h"
#import "Dispatcher+HomepageActions.h"
#import "Dispatcher+ProfileActions.h"
#import "Dispatcher+ClassifyActions.h"
#import "Dispatcher+WebViewActions.h"

@interface YDTabBarViewController ()

@end

@implementation YDTabBarViewController

#pragma mark – life cycle
- (void)viewDidLoad {
    
    [super viewDidLoad];
    //1.添加首页
    UIViewController * homepageVC = [[Dispatcher sharedInstance] dispatcher_viewControllerForHomepage:nil];
    [self addOneChildVc:homepageVC title:@"首页" imageName:@"tab_homepage_n" selectedImageName:@"tab_homepage_h"];
    //2.添加分类
    UIViewController * classifyVC = [[Dispatcher sharedInstance] dispatcher_viewControllerForClassify:nil];
    [self addOneChildVc:classifyVC title:@"分类" imageName:@"tab_classify_n" selectedImageName:@"tab_classify_h"];
    //3.添加我的
    UIViewController * profileVC = [[Dispatcher sharedInstance] dispatcher_viewControllerForWebView:nil];
    [self addOneChildVc:profileVC title:@"我的" imageName:@"tab_profile_n" selectedImageName:@"tab_profile_h"];
    
    //4.设置tab bar背景
    self.tabBar.opaque = YES;
    [self.tabBar setBackgroundColor:[UIColor whiteColor]];
    self.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark – private function
/**
 添加一个子控制器
 
 @param childVc           子控制对象
 @param title             标题
 @param imageName         正常图标
 @param selectedImageName 选中图标
 */
- (void)addOneChildVc:(UIViewController *)childVc title:(NSString *)title imageName:(NSString *)imageName selectedImageName:(NSString *)selectedImageName {
    
    //1.设置子控制器的背景颜色
    childVc.view.backgroundColor = [UIColor whiteColor];
    //2.设置标题
    childVc.title = title;
    //3.设置正常图标
    childVc.tabBarItem.image = [UIImage imageNamed:imageName];
    //4.设置选中时的图标
    UIImage *selectedImage = [UIImage imageNamed:selectedImageName];
    //5.声明这张图片用原图(别渲染)
    if (kIOS7) {
        selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    childVc.tabBarItem.selectedImage = selectedImage;
    
    //6.设置tabbar字体颜色
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:kCommonRGBColor(102, 102, 102), NSForegroundColorAttributeName, [UIFont systemFontOfSize:12], NSFontAttributeName, nil] forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:                                                         [NSDictionary dictionaryWithObjectsAndKeys:kCommonRGBColor(255, 118, 102),NSForegroundColorAttributeName, [UIFont systemFontOfSize:12], NSFontAttributeName, nil]forState:UIControlStateSelected];
    
    //7.添加为tabbar控制器的子控制器
    YDUINavigationViewController *nav = [[YDUINavigationViewController alloc] initWithRootViewController:childVc];
    
    //添加子控制器到tabbar
    [self addChildViewController:nav];
}

#pragma mark – UITabBarControllerDelegate
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
}

#pragma mark – overload
/**
 这里返回哪个值，就看你想支持那几个方向了。这里必须和后面plist文件里面的一致
 */
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    
    return (interfaceOrientation == UIDeviceOrientationPortrait);
}

/**
 是否支持转屏
 */
- (BOOL)shouldAutorotate {
    
    return NO;
}

@end
