//
//  YDHomepageCell.m
//  YiDing
//
//  Created by 韩伟 on 16/10/15.
//  Copyright © 2016年 韩伟. All rights reserved.
//

#import "YDHomepageCell.h"

@interface YDHomepageCell ()

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UILabel *mainTitle;

@end

@implementation YDHomepageCell

#pragma mark – life cycle
+ (YDHomepageCell *)cellWithTableview:(UITableView *)tableView {
    
    static NSString *identifier = @"YDHomepageCell";
    YDHomepageCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        //使用系统自带的样式
        cell = [[YDHomepageCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUpViews];
    }
    return self;
}

#pragma mark – private methods
/**
 初始化并添加子view
 */
- (void)setUpViews {
    
    [self.contentView addSubview:self.bgView];
    [self.bgView addSubview:self.mainTitle];
}

/**
 设置相关数据
 */
- (void)setUpData {
    
    self.contentView.backgroundColor = kCommonRGBColor(242, 242, 242);
    
    if (_object) {
        //根据object数据进行设置
        self.mainTitle.text = @"test";
        }
}

/**
 设置views的layout
 */
- (void)setUpLayout {
    
    self.frame = CGRectMake(0, 0, PHONE_WIDTH, kHomepageCellH);
    self.contentView.frame = self.frame;
    self.bgView.frame = CGRectMake(0, 0, PHONE_WIDTH, kHomepageCellH);
    self.mainTitle.frame = self.bgView.frame;
}

#pragma mark - setter and getter
- (void)setObject:(id)object {
    
    if ([object isKindOfClass:[YDHomepageViewModel class]]) {
        _object = (YDHomepageViewModel *)object;
        [self setUpData];
        [self setUpLayout];
    }
}

- (UIView *)bgView {
    
    if (_bgView == nil) {
        _bgView = [[UIView alloc] initWithFrame:CGRectZero];
        _bgView.backgroundColor = [UIColor whiteColor];
    }
    return _bgView;
}

- (UILabel *)mainTitle {
    
    if (_mainTitle == nil) {
        _mainTitle = [[UILabel alloc] initWithFrame:CGRectZero];
        _mainTitle.backgroundColor = [UIColor clearColor];
        _mainTitle.font = [UIFont systemFontOfSize:16.0f];
        _mainTitle.textColor = kCommonRGBColor(51, 51, 51);
        _mainTitle.textAlignment = NSTextAlignmentLeft;
    }
    return _mainTitle;
}

@end
