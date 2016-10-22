//
//  PersistanceQueryCommand+ReadMethods.h
//  DongAoAcc
//
//  Created by wihan on 15/11/26.
//  Copyright © 2015年 wihan. All rights reserved.
//

#import "PersistanceQueryCommand.h"

@interface PersistanceQueryCommand (ReadMethods)

/**
 *  创建select部分的内容
 *
 *  @param columList  选择的column key值list
 *  @param isDistinct YES 排重
 */
- (PersistanceQueryCommand *)select:(NSString *)columList isDistinct:(BOOL)isDistinct;

/**
 *  创建from部分的内容
 *  @param fromList FROM部分的list
 */
- (PersistanceQueryCommand *)from:(NSString *)fromList;

/**
 *  创建where部分的内容
 *  @param condition where条件
 *  @param params    where值
 */
- (PersistanceQueryCommand *)where:(NSString *)condition params:(NSDictionary *)params;

/**
 *  创建order部分的内容
 *  @param orderBy order部分的string
 *  @param isDESC  YES, 降序, NO, 升序
 */
- (PersistanceQueryCommand *)orderBy:(NSString *)orderBy isDESC:(BOOL)isDESC;

/**
 *  创建limit部分的内容
 *  @param limit 限制数
 */
- (PersistanceQueryCommand *)limit:(NSInteger)limit;

/**
 *  创建offset部分的内容
 *  @param offset offset
 */
- (PersistanceQueryCommand *)offset:(NSInteger)offset;

/**
 *  创建处理limit和offset部分的内容
 */
- (PersistanceQueryCommand *)limit:(NSInteger)limit offset:(NSInteger)offset;

@end
