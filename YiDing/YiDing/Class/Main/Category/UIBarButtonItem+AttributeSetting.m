//
//  UIBarButtonItem+AttributeSetting.m
//  YiDing
//
//  Created by 韩伟 on 16/10/14.
//  Copyright © 2016年 韩伟. All rights reserved.
//

#import "UIBarButtonItem+AttributeSetting.h"

@implementation UIBarButtonItem (AttributeSetting)

+ (UIBarButtonItem *)barButtonItem_itemWithImageName:(NSString *)imageName highImageName:(NSString *)highImageName target:(id)target action:(SEL)action {
    
    UIButton *btn = [[UIButton alloc] init];
    
    //1.设置按钮的背景图片（默认/高亮）
    [btn setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:highImageName] forState:UIControlStateHighlighted];
    
    //2.设置按钮的尺寸和图片一样大，使用了UIImage的分类
    btn.size = btn.currentBackgroundImage.size;
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return [[UIBarButtonItem alloc] initWithCustomView:btn];
}

+ (UIBarButtonItem *)barButtonItem_itemWithTitle:(NSString *)title font:(UIFont *)font color:(UIColor *)color target:(id)target action:(SEL)action {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitleColor:color forState:UIControlStateNormal];
    
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = font;
    CGSize buttonSize = [title string_sizeWithFont:font];
    button.frame = CGRectMake(0, 0, button.currentImage.size.width + buttonSize.width, button.currentImage.size.height);
    
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}

+ (UIBarButtonItem *)barButtonItem_itemWithAttributeTitle:(NSAttributedString *)attributeTitle {
    
    UILabel *label = [[UILabel alloc] init];
    label.attributedText = attributeTitle;
    
    CGSize maxSize = CGSizeMake(MAXFLOAT, MAXFLOAT);
    CGSize labelSize = [attributeTitle boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    
    label.frame = CGRectMake(0, 0, labelSize.width, labelSize.height);
    
    return [[UIBarButtonItem alloc] initWithCustomView:label];
}

@end
