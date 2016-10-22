//
//  YDHomepageMainTableViewHandle.h
//  YiDing
//
//  Created by 韩伟 on 16/10/15.
//  Copyright © 2016年 韩伟. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol YDHomepageMainTableViewHandleDelegate <NSObject>

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

@interface YDHomepageMainTableViewHandle : NSObject <UITableViewDataSource, UITableViewDelegate >

//传入的数据list
@property (nonatomic, strong) NSArray* items;
@property (nonatomic, assign) UITableViewCellStyle tableViewStyle;
@property (nonatomic, weak) id<YDHomepageMainTableViewHandleDelegate> delegate;


/**
 根据items数据，进行初始化

 @param items 传入的数据items

 @return 返回self对象
 */
- (id)initWithItems:(NSArray *)items;

/**
 根据items数据和tableViewStyle，进行初始化

 @param items          传入的数据items
 @param tableViewStyle tableViewStyle

 @return 返回self对象
 */
- (id)initWithItems:(NSArray *)items
     tableViewStyle:(UITableViewCellStyle)tableViewStyle;

/**
 根据indexPath，返回指定的item数据

 @param indexPath index

 @return 返回指定的item数据
 */
- (id)itemAtIndexPath:(NSIndexPath *)indexPath;

@end
