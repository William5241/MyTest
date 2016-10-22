//
//  UIView+Frames.h
//  YiDing
//
//  Created by zhangbin on 16/10/19.
//  Copyright © 2016年 韩伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Frames)

    
// coordinator getters
- (CGFloat)height;
- (CGFloat)width;
- (CGFloat)x;
- (CGFloat)y;
- (CGSize)size;
- (CGPoint)origin;
- (CGFloat)centerX;
- (CGFloat)centerY;
- (CGFloat)bottom;
- (CGFloat)right;
    
- (void)setX:(CGFloat)x;
- (void)setY:(CGFloat)y;
    
// height
- (void)setHeight:(CGFloat)height;
- (void)heightEqualToView:(UIView *)view;
    
// width
- (void)setWidth:(CGFloat)width;
- (void)widthEqualToView:(UIView *)view;
    
// center
- (void)setCenterX:(CGFloat)centerX;
- (void)setCenterY:(CGFloat)centerY;
- (void)centerXEqualToView:(UIView *)view;
- (void)centerYEqualToView:(UIView *)view;
    
// top, bottom, left, right
- (void)top:(CGFloat)top FromView:(UIView *)view;
- (void)bottom:(CGFloat)bottom FromView:(UIView *)view;
- (void)left:(CGFloat)left FromView:(UIView *)view;
- (void)right:(CGFloat)right FromView:(UIView *)view;
    
- (void)topInContainer:(CGFloat)top shouldResize:(BOOL)shouldResize;
- (void)bottomInContainer:(CGFloat)bottom shouldResize:(BOOL)shouldResize;
- (void)leftInContainer:(CGFloat)left shouldResize:(BOOL)shouldResize;
- (void)rightInContainer:(CGFloat)right shouldResize:(BOOL)shouldResize;
    
- (void)topEqualToView:(UIView *)view;
- (void)bottomEqualToView:(UIView *)view;
- (void)leftEqualToView:(UIView *)view;

/**
 右边位置相等

 @param view 相等的View
 */
- (void)rightEqualToView:(UIView *)view;
    
// size
/**
 设置View的大小

 @param size Size
 */
- (void)setSize:(CGSize)size;
    
/**
 大小和某一View相等

 @param view Size需要相等的View
 */
- (void)sizeEqualToView:(UIView *)view;
    
// imbueset
/**
    宽度和父View相等
 */
- (void)fillWidth;
    
/**
 跟父View等高
 */
- (void)fillHeight;
    
/**
 填充父View
 */
- (void)fill;

/**
 最顶部的view
 
 @return 返回此view所在的最上层View
 */
- (UIView *)topSuperView;
    
@end
