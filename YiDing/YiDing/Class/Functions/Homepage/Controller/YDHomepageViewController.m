//
//  YDHomepageViewController.m
//  YiDing
//
//  Created by 韩伟 on 16/10/14.
//  Copyright © 2016年 韩伟. All rights reserved.
//

#import "YDHomepageViewController.h"
#import <MJRefresh.h>
#import "YDFineCourseViewController.h"
#import "Target_FineCourse.h"
@interface YDHomepageViewController ()

//主页面tableView
@property (nonatomic, strong) UITableView *mainTableView;
//主页面tableView Handle
@property (nonatomic, strong) YDHomepageMainTableViewHandle *mainTableViewHandle;
//获取网络数据的center
@property (nonatomic, strong) YDHomepageServerCenter *homepageServerCenter;

@end

@implementation YDHomepageViewController

#pragma mark – life cycle
- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self setupViews];
    [self setupNavBar];
    [self setupData];
    [self setupNotification];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.backgroundColor = [UIColor lightGrayColor];
    btn.frame = CGRectMake(PHONE_WIDTH - 100, PHONE_HEIGH - 200, 80, 40);
    [btn addTarget:self action:@selector(goToFineCourse) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:@"精品课程" forState:UIControlStateNormal];
    [self.view addSubview:btn];

}
- (void)goToFineCourse{
    YDFineCourseViewController *fineCourseVc = (YDFineCourseViewController *) [[[Target_FineCourse alloc]init] action_nativeFineCourseViewController:nil];
    
    [self.navigationController pushViewController:fineCourseVc animated:YES];
    
}
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self.mainTableView.mj_header beginRefreshing];
    
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark – event response
#pragma mark – CEMyCourseMainTableViewHandleDelegate
- (void)tableViewCellConfigure:(id) cell item:(id)item indexPath:(NSIndexPath *)indexPath {
    
    MyLog(@"做想做的事");
}

- (void)tableViewDidSelect:(id)data {
    
    MyLog(@"做想做的事");
//    if (data && [data isKindOfClass:[CECourseListItemModel class]]) {
//    }
}

#pragma mark – YDHomepageServerCenterDelegate
- (void)getHomepageDataSuccess {
    //1.Server拉取成功的处理
    [self.mainTableView reloadData];
    [self endLoadData];
}

- (void)getHomepageDataFailed:(NSDictionary *)userInfo  {
    //1.Server拉取失败的处理
    [self.mainTableView reloadData];
    [self endLoadData];
}

#pragma mark – private
#pragma mark – private 初始化
/**
 初始化通知
 */
- (void)setupNotification {
}

/**
 初始化navigation bar
 */
- (void)setupNavBar {
    
    //1.设置left button
//        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage getOriImage:@"nav_home_button_left"] style:UIBarButtonItemStylePlain target:self action:@selector(leftAction)];
    //2.设置标题
    self.navigationItem.title = @"首页";
}

/**
 初始化views
 */
- (void)setupViews {
    
    //1.设置view的相关属性
    [self.view setTranslatesAutoresizingMaskIntoConstraints:NO];
    self.view.backgroundColor = [UIColor greenColor];
    if (kIOS7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    //2.添加views
    [self.view addSubview:self.mainTableView];
}

/**
 初始化数据
 */
- (void)setupData {
}

/**
 根据类型初始化空界面

 @param type 空界面类型
 */
- (void)setupExceptionView:(int)type {
}

#pragma mark – private 网络数据处理
- (void)loadDataSourceRefresh {
    //下拉刷新采取强制刷新
    [self loadHomepageDataForceUpdate];
}

/**
 * 强制刷新，由于有缓存机制，因此通过增加forceUpdate字段控制缓存使用
 * 目前首页都采取强制刷新，因为需要更新解锁内容
 */
- (void)loadHomepageDataForceUpdate {
    
    [self.homepageServerCenter requestHomepageData];
}

/**
 刷新结束调用
 */
- (void)endLoadData {
    [self.mainTableView.mj_header endRefreshing];
}

#pragma mark – getters and setters
- (UITableView *)mainTableView {
    
    if (_mainTableView == nil) {
        _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, PHONE_WIDTH, PHONE_HEIGH-kNavigationBarHeight-kStatusBarHeight)];
        _mainTableView.delegate = self.mainTableViewHandle;
        _mainTableView.dataSource = self.mainTableViewHandle;
        _mainTableView.backgroundColor = kCommonRGBColor(242, 242, 242);
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        __weak typeof(self) _self = self;
        _mainTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [_self loadDataSourceRefresh];
        }];

    }
    return _mainTableView;
}

- (YDHomepageServerCenter *)homepageServerCenter {
    
    if (_homepageServerCenter == nil) {
        _homepageServerCenter = [[YDHomepageServerCenter alloc] init];
        _homepageServerCenter.delegate = self;
    }
    return _homepageServerCenter;
}
@end
