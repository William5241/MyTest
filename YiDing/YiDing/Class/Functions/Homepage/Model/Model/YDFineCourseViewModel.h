//
//  YDFineCourseViewModel.h
//  YiDing
//
//  Created by ALLIN on 16/10/18.
//  Copyright © 2016年 韩伟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YDFineCourseViewModel : NSObject
/// 标题
@property (nonatomic,copy) NSString * titleString;
///作者名字
@property (nonatomic,copy) NSString * nameString;
///所属医院
@property (nonatomic,copy) NSString * hospitalNameString;
///所属类型
@property (nonatomic,copy) NSString * categoryString;
///浏览次数
@property (nonatomic,copy) NSString * readNumberString;
///评论次数
@property (nonatomic,copy) NSString * reponseNumberString;
///图片的url
@property (nonatomic,copy) NSString * pictureUrlString;
///
@property (nonatomic,assign) CGFloat cellHeight;


@end
