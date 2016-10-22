//
//  YDFineCourseViewController.m
//  YiDing
//
//  Created by ALLIN on 16/10/18.
//  Copyright © 2016年 韩伟. All rights reserved.
//

#import "YDFineCourseViewController.h"
#import "YDFineCourseMainTableViewHandle.h"
#import "YDFineCourseServerCenter.h"
#import "MJRefresh.h"
@interface YDFineCourseViewController ()<YDFineCourseServerCenterDelegate>
@property (nonatomic,strong) UITableView *mainTableView;
@property (nonatomic,strong) YDFineCourseServerCenter * serverCenter;
@property (nonatomic,strong) YDFineCourseMainTableViewHandle *mainTableViewHandle;
@end

@implementation YDFineCourseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupData];
    [self setupViews];
    [self setupNavbar];
    [self setupNotification];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.mainTableView.header beginRefreshing];
}
- (void)setupViews{
    self.automaticallyAdjustsScrollViewInsets = NO;
    if (kIOS7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    self.view.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.mainTableView];
}
- (void)setupNotification{

}
- (void)setupNavbar{
    self.navigationItem.title = @"精品课程";
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem barButtonItem_itemWithImageName:@"" highImageName:@"" target:self action:@selector(backToLastPage)];
}
- (void)setupData{
//    NSMutableArray *array = [NSMutableArray array];
//    for (int i = 0; i < 10; i++) {
//        YDFineCourseViewModel *model = [[YDFineCourseViewModel alloc]init];
//        [array addObject:model];
//    }
//    self.mainTableViewHandle.items = array;
}
- (void)backToLastPage{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark- YDFineCourseServerCenterDelegate

- (void)getFineCourseDataSuccess {
    self.mainTableViewHandle.items = self.serverCenter.dataArray;
    //1.Server拉取成功的处理
    [self.mainTableView reloadData];
    [self endLoadData];
}

- (void)getFineCourseDataFailed:(NSDictionary *)userInfo{
    //1.Server拉取失败的处理
    [self.mainTableView reloadData];
    [self endLoadData];
}
/**
 刷新结束调用
 */
- (void)endLoadData {
    [self.mainTableView.header endRefreshing];
}
#pragma mark – private 网络数据处理
- (void)loadDataSourceRefresh {
    //下拉刷新采取强制刷新
    [self loadFineCourseDataForceUpdate];
}

/**
 * 强制刷新，由于有缓存机制，因此通过增加forceUpdate字段控制缓存使用
 * 目前首页都采取强制刷新，因为需要更新解锁内容
 */
- (void)loadFineCourseDataForceUpdate {
    
    [self.serverCenter requestFineCourseData];
}
#pragma mark- 懒加载
- (UITableView *)mainTableView{
    if (_mainTableView == nil) {
        _mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, PHONE_WIDTH, PHONE_HEIGH - kNavigationBarHeight - kStatusBarHeight)];
        _mainTableView.delegate = self.mainTableViewHandle;
        _mainTableView.dataSource = self.mainTableViewHandle;
        _mainTableView.tableFooterView = [[UIView alloc]init];
        _mainTableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [self loadDataSourceRefresh];
        }];
    }
    return _mainTableView;
}
- (YDFineCourseServerCenter *)serverCenter{
    if (_serverCenter == nil) {
        _serverCenter = [[YDFineCourseServerCenter alloc]init];
        _serverCenter.delegate = self;
    }
    return _serverCenter;
}
- (YDFineCourseMainTableViewHandle *)mainTableViewHandle{
    if (_mainTableViewHandle == nil) {
        _mainTableViewHandle = [[YDFineCourseMainTableViewHandle alloc]init];
        _mainTableViewHandle.delegate = self;
    }
    return _mainTableViewHandle;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
