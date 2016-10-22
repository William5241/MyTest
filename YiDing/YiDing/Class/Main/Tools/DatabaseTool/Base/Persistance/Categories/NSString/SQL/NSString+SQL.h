//
//  NSString+SafeSQL.h
//  DongAoAcc
//
//  Created by wihan on 15/11/27.
//  Copyright © 2015年 wihan. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  有关SQL的类别
 */
@interface NSString (SQL)

/**
 *  对string进行处理，即：(') to (\') , (\) to (\\) , 移除所有的 (;)
 */
- (NSString *)safeSQLEncode;

/**
 *  转换成原始string
 */
- (NSString *)safeSQLDecode;

/**
 *  去除string中的(`) 和 (')
 */
- (NSString *)safeSQLMetaString;

/**
 *  将传入的dic参数，放入指定的string中；string中的key以冒号(:)开始，这个方法将会根据参数进行替换，生成终极string
 *
 *  例如:
 *
 *  NSString *foo = @"hello :bar";
 *  NSDictionary *params = @{
 *      @"bar":@"world"
 *  };
 *
 *  返回 @"hello world"
 */
- (NSString *)stringWithSQLParams:(NSDictionary *)params;

@end
