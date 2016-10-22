//
//  YDHomepageMainTableViewHandle.m
//  YiDing
//
//  Created by 韩伟 on 16/10/15.
//  Copyright © 2016年 韩伟. All rights reserved.
//

#import "YDHomepageMainTableViewHandle.h"
#import "YDHomepageCell.h"

@implementation YDHomepageMainTableViewHandle

#pragma mark - Initializer
- (id)initWithItems:(NSArray*)items {
    
    self = [super init];
    if (!self) {
        return nil;
    }
    return [self initWithItems:items tableViewStyle:UITableViewCellStyleDefault];
}

- (id)initWithItems:(NSArray *)items
     tableViewStyle:(UITableViewCellStyle)tableViewStyle {
    
    self = [super init];
    if (!self) {
        return nil;
    }
    _items = items;
    _tableViewStyle = tableViewStyle;
    return self;
}

#pragma mark - UITableViewDelegate
- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath {
    
    UITableViewCell *myCourseCell = nil;
    if (self.items && self.items.count) {
        //1.对cell的初始化
        YDHomepageCell *cell = [YDHomepageCell cellWithTableview:tableView];
        YDHomepageViewModel *homepageViewModel = [YDHomepageViewModel new];
        cell.object = homepageViewModel;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //2.设置代理
        if (self.delegate && [self.delegate respondsToSelector:@selector(tableViewCellConfigure:item:indexPath:)]) {
            id item = [self itemAtIndexPath:indexPath];
            [self.delegate tableViewCellConfigure:cell item:item indexPath:indexPath];
        }
        
        myCourseCell = cell;
    }
    return myCourseCell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    NSInteger secCount = 0;
    if (self.items && self.items.count) {
        secCount = self.items.count;
    }
    return secCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.items && self.items.count) {
        return 30.0f;
    }
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //1.处理代理
    if (self.delegate && [self.delegate respondsToSelector:@selector(tableViewDidSelect:)]) {
        [self.delegate tableViewDidSelect:nil];
    }
}

#pragma mark - Public Functions
- (id)itemAtIndexPath:(NSIndexPath*)indexPath {
    
    if (self.items && self.items.count) {
        return self.items[(NSUInteger)indexPath.section];
    }
    return nil;
}

@end
