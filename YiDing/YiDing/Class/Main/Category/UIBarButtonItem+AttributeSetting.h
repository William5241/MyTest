//
//  UIBarButtonItem+AttributeSetting.h
//  YiDing
//
//  Created by 韩伟 on 16/10/14.
//  Copyright © 2016年 韩伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (AttributeSetting)

/**
 为bar button item设置image等相关属性
 
 @param imageName     normal image
 @param highImageName high light image
 @param target        button target
 @param action        button action
 
 @return 返回设置后的BarButtonItem
 */
+ (UIBarButtonItem *)barButtonItem_itemWithImageName:(NSString *)imageName highImageName:(NSString *)highImageName target:(id)target action:(SEL)action;

/**
 为bar button item设置title等相关属性
 
 @param title  title for display
 @param font   font for title
 @param color  color for title
 @param target button target
 @param action button action
 
 @return 返回设置后的BarButtonItem
 */
+ (UIBarButtonItem *)barButtonItem_itemWithTitle:(NSString *)title font:(UIFont *)font color:(UIColor *)color target:(id)target action:(SEL)action;

/**
 返回一个带有attributeTitle的UIBarButtonItem
 
 @param attributeTitle attribute
 
 @return 返回一个带有attributeTitle的UIBarButtonItem
 */
+ (UIBarButtonItem *)barButtonItem_itemWithAttributeTitle:(NSAttributedString *)attributeTitle;

@end
