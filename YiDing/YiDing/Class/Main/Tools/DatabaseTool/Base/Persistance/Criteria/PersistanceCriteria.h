//
//  PersistanceCriteria.h
//  DongAoAcc
//
//  Created by wihan on 15/11/27.
//  Copyright © 2015年 wihan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PersistanceQueryCommand.h"

/**
 *  criteria是一个对象，可以用来帮助你很方便的创建各种sql的对象
 */
@interface PersistanceCriteria : NSObject

/**
 *  用(,)隔开的table or table list
 */
@property (nonatomic, copy) NSString *select;

/**
 *  WHERE条件
 */
@property (nonatomic, copy) NSString *whereCondition;

/**
 *  WHERE条件的参数 dic
 */
@property (nonatomic, copy) NSDictionary *whereConditionParams;

/**
 *  排列顺序的key
 */
@property (nonatomic, copy) NSString *orderBy;

/**
 *  YES, 降序 NO, 升序
 */
@property (nonatomic, assign) BOOL isDESC;

/**
 *  查询限制次数
 */
@property (nonatomic, assign) NSInteger limit;

/**
 *  offset
 */
@property (nonatomic, assign) NSInteger offset;

/**
 *  YES, 降序, NO, 升序
 */
@property (nonatomic, assign) BOOL isDistinct;

/**
 *  生成SQL select语句
 *
 *  @param queryCommand PersistanceQueryCommand 实例
 *  @param tableName    名字用(,)分割
 */
- (PersistanceQueryCommand *)applyToSelectQueryCommand:(PersistanceQueryCommand *)queryCommand tableName:(NSString *)tableName;

/**
 *  生成SQL DELETE 语句
 *
 *  @param queryCommand PersistanceQueryCommand 实例
 *  @param tableName    表名字
 */
- (PersistanceQueryCommand *)applyToDeleteQueryCommand:(PersistanceQueryCommand *)queryCommand tableName:(NSString *)tableName;

@end
