//
//  UIImage+Reprocessing.m
//  YiDing
//
//  Created by 韩伟 on 16/10/14.
//  Copyright © 2016年 韩伟. All rights reserved.
//

#import "UIImage+Reprocessing.h"

@implementation UIImage (Reprocessing)

+ (UIImage *)image_getOriImage:(NSString *)name {
    
    UIImage *oriImage = [UIImage imageNamed:name];
    if (oriImage) {
        oriImage = [oriImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    return oriImage;
}

+ (UIImage *)image_imageWithColor:(UIColor *)color size:(CGSize)size {
    
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context,color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

+ (UIImage *)image_resizedImageWithName:(NSString *)name {
    
    return [self image_resizedImageWithName:name left:0.5 top:0.5];
}

+ (UIImage *)image_resizedImageWithName:(NSString *)name left:(CGFloat)left top:(CGFloat)top {
    
    UIImage *image = [self imageNamed:name];
    return [image stretchableImageWithLeftCapWidth:image.size.width * left topCapHeight:image.size.height * top];
}

@end
