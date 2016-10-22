//
//  CMGuidePageViewController.m
//  YiDing
//
//  Created by 韩伟 on 16/10/15.
//  Copyright © 2016年 韩伟. All rights reserved.
//

#import "CMGuidePageViewController.h"

#define kCMGuidePageImageCount    3

@interface CMGuidePageViewController ()

@property(nonatomic, strong)UIPageControl *pageControl;

@end

@implementation CMGuidePageViewController

#pragma mark – life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    //1.添加UIScrollView
    [self setupScrollView];
    //2.添加pageControl
    //    [self setupPageControl];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark – private function
/**
 添加UIScrollView
 */
- (void)setupScrollView {
    //1.添加UIScrollView
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.frame = self.view.bounds;
    scrollView.delegate = self;
    scrollView.pagingEnabled = YES;
    [self.view addSubview:scrollView];
    
    //2.添加图片
    CGFloat imageW = scrollView.width;
    CGFloat imageH = scrollView.height;
    for (NSUInteger i=0; i<kCMGuidePageImageCount; i++) {
        UIImageView *imageView = [[UIImageView alloc]init];
        NSString *name = [NSString stringWithFormat:@"guide_page_%lu",i+1];
        //2.1需要手动去加载iphone4英寸对应的-480h@2x图片
        if (FourInch) {
            name = [name stringByAppendingString:@"-480h"];
        }
        imageView.image = [UIImage imageNamed:name];
        [scrollView addSubview:imageView];

        imageView.y = 0;
        imageView.width = imageW;
        imageView.height = imageH;
        imageView.x = i*imageW;
        
        if(i == kCMGuidePageImageCount-1) {
            [self setupLastImageView:imageView];
        }
    }
    
    //3.设置活动范围
    scrollView.contentSize = CGSizeMake(kCMGuidePageImageCount*imageW, 0);
    scrollView.backgroundColor = kCommonRGBColor(246, 246, 246);
    scrollView.showsHorizontalScrollIndicator = NO;
    //    scrollView.pagingEnabled=YES;
    scrollView.bounces = NO;
}

/**
 添加pageControl
 */
- (void)setupPageControl {
    
    UIPageControl *pageControl = [[UIPageControl alloc]init];
    pageControl.numberOfPages = kCMGuidePageImageCount;
    pageControl.centerX = self.view.width*0.5;
    pageControl.centerY = self.view.height-30;
    [self.view addSubview:pageControl];
    
    //1.设置圆点的颜色
    pageControl.currentPageIndicatorTintColor = kCommonRGBColor(253, 98, 42);
    pageControl.pageIndicatorTintColor = kCommonRGBColor(189, 189, 189);
    self.pageControl = pageControl;
}

/**
 设置最后一个UIImageView,在上面添加两个按钮

 @param imageView 传入最后一个imageView
 */
-(void)setupLastImageView:(UIImageView *)imageView {

    imageView.userInteractionEnabled = YES;
    [self setupStarButton:imageView];
}

/**
 为制定页设置开始按钮

 @param imageView 需要设定开始按钮的imageView
 */
- (void)setupStarButton:(UIImageView *)imageView {
    
    //1.添加开始按钮
    UIButton *startButton = [[UIButton alloc] init];
    [imageView addSubview:startButton];
    
    //2.设置背景图片
    [startButton setBackgroundImage:[UIImage imageNamed:@"button_enter_normal"] forState:UIControlStateNormal];
    [startButton setBackgroundImage:[UIImage imageNamed:@"button_enter_hover"] forState:UIControlStateHighlighted];
    
    //3.设置frame
    startButton.size = startButton.currentBackgroundImage.size;
    startButton.centerX = self.view.centerX;
    //注意：这是为了适配3.5inch和4.0inch
    startButton.centerY = self.view.height * 0.8;
    
    //4.设置文字
    [startButton setTitle:@"立即体验" forState:UIControlStateNormal];
    [startButton setTitleColor:kCommonRGBColor(255, 255, 255) forState:UIControlStateNormal];
    [startButton addTarget:self action:@selector(start) forControlEvents:UIControlEventTouchUpInside];
}

/**
 启动主控制器
 */
- (void)start {

    [kKQAppDelegate.window setRootViewController:kKQAppDelegate.tabBarViewController];
}

#pragma mark - UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    double doublePage = scrollView.contentOffset.x/scrollView.width;
    int intPage = (int)(doublePage + 0.5);
    self.pageControl.currentPage = intPage;
}

#pragma mark - overload
- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
