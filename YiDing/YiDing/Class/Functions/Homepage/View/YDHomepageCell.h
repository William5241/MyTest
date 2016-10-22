//
//  YDHomepageCell.h
//  YiDing
//
//  Created by 韩伟 on 16/10/15.
//  Copyright © 2016年 韩伟. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YDHomepageViewModel.h"

#define kHomepageCellH     30.0f

@interface YDHomepageCell : UITableViewCell
/**
 创建reuse的cell

 @param tableView cell所属的tableView

 @return 返回cell self
 */
+ (instancetype)cellWithTableview:(UITableView *)tableView;

/**
 设置数据属性
 */
@property (nonatomic, strong) id object;

@end
