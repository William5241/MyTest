//
//  YDFineCourseCell.m
//  YiDing
//
//  Created by ALLIN on 16/10/18.
//  Copyright © 2016年 韩伟. All rights reserved.
//

#import "YDFineCourseCell.h"
#import "YDFineCourseViewModel.h"
#import "UIImageView+WebCache.h"
@interface YDFineCourseCell()
@property (nonatomic,strong) UILabel * titleLabel;
@property (nonatomic,strong) UILabel * personMessageLabel;
@property (nonatomic,strong) UILabel * categoryLabel;
//@property (nonatomic,strong) UILabel * titleLabel;
@property (nonatomic,strong) UIImageView * imageV;


@end
#define LeftDistance 20
#define TopDistance 10
#define BottomDistance 10
#define Distance 10
#define MaxWidth 200
#define CellHeight 80
#define CellWidth SCREEN_WIDTH

@implementation YDFineCourseCell
+ (YDFineCourseCell *)cellWithTableview:(UITableView *)tableView {
    
    static NSString *identifier = @"YDHomepageCell";
    YDFineCourseCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        //使用系统自带的样式
        
        cell = [[YDFineCourseCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
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
- (void)setUpViews{
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.personMessageLabel];
    [self.contentView addSubview:self.categoryLabel];
    
    [self.contentView addSubview:self.imageV];
}
- (void)setObject:(id)object{
    _object = object;
    YDFineCourseViewModel *model = (YDFineCourseViewModel *)object;
//    model.nameString = @"许奕";
//    model.titleString = @"骨骼－手术";
//    model.categoryString = @"骨骼";
//    model.hospitalNameString = @"中日合作医院";
    model.pictureUrlString = @"http://k.sinaimg.cn/n/sports/transform/20161019/lBCD-fxwvxzf6952342.jpg/w5707b7.jpg";
    self.titleLabel.text = model.titleString;
    self.personMessageLabel.text = [NSString stringWithFormat:@"%@  %@",model.nameString,model.hospitalNameString];
//
    self.categoryLabel.text = model.categoryString;
    [self.imageV sd_setImageWithURL:[NSURL URLWithString:model.pictureUrlString] placeholderImage:nil];
    
}
- (void)setupLayout{
    
}
#pragma mark- 懒加载
- (UILabel *)titleLabel{
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(LeftDistance, TopDistance, MaxWidth, 20)];
    }
    return _titleLabel;
}
- (UILabel *)personMessageLabel{
    if (_personMessageLabel == nil) {
        _personMessageLabel = [[UILabel alloc]initWithFrame:CGRectMake(LeftDistance, CGRectGetMaxY(_titleLabel.frame)+Distance, MaxWidth, 10)];
        _personMessageLabel.font = [UIFont systemFontOfSize:14];
        _personMessageLabel.textColor = [UIColor lightGrayColor];
    }
    return _personMessageLabel;
}
- (UILabel *)categoryLabel{
    if (_categoryLabel == nil) {
        _categoryLabel = [[UILabel alloc]initWithFrame:CGRectMake(LeftDistance, CGRectGetMaxY(_personMessageLabel.frame)+Distance, MaxWidth, 10)];
        _categoryLabel.textColor = [UIColor lightGrayColor];
        _categoryLabel.font = [UIFont systemFontOfSize:14];
    }
    return _categoryLabel;
}
- (UIImageView *)imageV{
    if (_imageV == nil) {
        _imageV = [[UIImageView alloc]initWithFrame:CGRectMake(LeftDistance + MaxWidth, TopDistance, PHONE_WIDTH - 20 - LeftDistance - MaxWidth, CellHeight - TopDistance - BottomDistance)];
    }
    return _imageV;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
