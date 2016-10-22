//
//  UIImage+Reprocessing.h
//  YiDing
//
//  Created by 韩伟 on 16/10/14.
//  Copyright © 2016年 韩伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Reprocessing)

/**
 获取未经系统处理的原始image

 @param name image name

 @return 返回未经系统处理的原始image
 */
+ (UIImage *)image_getOriImage:(NSString *)name;

/**
 通过给定的颜色值及size得到对应的图片

 @param color 颜色值
 @param size  图片的尺寸大小

 @return 返回处理后的image
 */
+ (UIImage *)image_imageWithColor:(UIColor *)color size:(CGSize)size;

/**
 返回一张LeftCapWidth，TopCapWidth各0.5的拉伸的图片

 @param name 图片名称

 @return 返回处理后图片
 */
+ (UIImage *)image_resizedImageWithName:(NSString *)name;

/**
 返回一张自由拉伸的图片

 @param name 图片名称
 @param left LeftCapWidth
 @param top  TopCapWidth

 @return 返回处理后图片
 */
+ (UIImage *)image_resizedImageWithName:(NSString *)name left:(CGFloat)left top:(CGFloat)top;

@end
