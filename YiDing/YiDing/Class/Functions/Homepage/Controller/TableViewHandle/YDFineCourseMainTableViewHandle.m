//
//  YDFineCourseMainTableViewHandle.m
//  YiDing
//
//  Created by ALLIN on 16/10/18.
//  Copyright © 2016年 韩伟. All rights reserved.
//

#import "YDFineCourseMainTableViewHandle.h"
#import "YDFineCourseCell.h"
#import "YDFineCourseViewModel.h"
//#import "ALReviewImageVC.h"
//#import "ALReviewImageModel.h"
#import "YDFineCourseViewController.h"
@implementation YDFineCourseMainTableViewHandle
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.items.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *myCourseCell = nil;

    if (self.items && self.items.count) {
        YDFineCourseCell * cell = [YDFineCourseCell cellWithTableview:tableView];
        myCourseCell = cell;
        YDFineCourseViewModel *model = [self itemAtIndexPath:indexPath];
        cell.object = model;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        //2.设置代理
        if (self.delegate && [self.delegate respondsToSelector:@selector(tableViewCellConfigure:item:indexPath:)]) {
            id item = [self itemAtIndexPath:indexPath];
            [self.delegate tableViewCellConfigure:cell item:item indexPath:indexPath];
        }

    }
    return myCourseCell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.items && self.items.count) {
        return 80  ;
    }
    return 0;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    NSMutableArray *array = [NSMutableArray array];
//    for (int i = 0; i < self.items.count; i++) {
//        ALReviewImageModel *model = [[ALReviewImageModel alloc]init];
//        model.stringUrl = @"http://k.sinaimg.cn/n/sports/transform/20161019/lBCD-fxwvxzf6952342.jpg/w5707b7.jpg";
//        model.stringDesc = @"踢足球往哪踢";
//        [array addObject:model];
//    }
//    ALReviewImageVC *vc = [[ALReviewImageVC alloc]init];
//    vc.arraySelectedPhotos = array;
//    [((YDFineCourseViewController *)self.delegate).navigationController pushViewController:vc animated:YES];
}
- (id)itemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.items && self.items.count) {
        return self.items[indexPath.row];
    }
    return nil;
}
@end
