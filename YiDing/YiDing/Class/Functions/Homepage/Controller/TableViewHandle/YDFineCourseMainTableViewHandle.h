//
//  YDFineCourseMainTableViewHandle.h
//  YiDing
//
//  Created by ALLIN on 16/10/18.
//  Copyright © 2016年 韩伟. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol YDFineCourseMainTableViewHandleDelegate <NSObject>

@optional
/**
 用来处理cellForRowAtIndexPath中的代理
 
 @param cell      传入需要处理的cell
 @param item      传入需要处理的数据
 @param indexPath 传入需要处理的indexPath
 */
- (void)tableViewCellConfigure:(id) cell item:(id)item indexPath:(NSIndexPath *)indexPath;

/**
 用来处理didSelectRowAtIndexPath中的代理
 
 @param data 传入需要处理的数据
 */
- (void)tableViewDidSelect:(id)data;

@end
@interface YDFineCourseMainTableViewHandle : NSObject<UITableViewDelegate,UITableViewDataSource>
//传入的数据list
@property (nonatomic, strong) NSArray* items;
@property (nonatomic, assign) UITableViewCellStyle tableViewStyle;
@property (nonatomic, weak) id<YDFineCourseMainTableViewHandleDelegate> delegate;


@end
