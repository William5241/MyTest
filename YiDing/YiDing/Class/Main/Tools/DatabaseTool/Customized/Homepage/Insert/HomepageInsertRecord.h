//
//  HomepageInsertRecord.h
//  YiDing
//
//  Created by 韩伟 on 16/10/16.
//  Copyright © 2016年 韩伟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomepageInsertRecord : NSObject
/**
 1.将数据插入数据库
 2.如果有userId重复的数据，则删除

 @param dic 需要插入的数据
 */
- (void)homepageInsertData:(NSDictionary *)dic;

@end
