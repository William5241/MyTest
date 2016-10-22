//
//  PersistanceQueryCommand+DataManipulations.h
//  DongAoAcc
//
//  Created by wihan on 15/11/26.
//  Copyright © 2015年 wihan. All rights reserved.
//

#import "PersistanceQueryCommand.h"

@interface PersistanceQueryCommand (DataManipulations)

/**
 *  创建向表中插入list数据的command
 *
 *  @param tableName table name
 *  @param dataList  要插入的数据列表
 *
 */
- (PersistanceQueryCommand *)insertTable:(NSString *)tableName withDataList:(NSArray *)dataList;

/**
 *  创建根据相应条件更新表中记录的记录
 */
- (PersistanceQueryCommand *)updateTable:(NSString *)tableName withData:(NSDictionary *)data condition:(NSString *)condition conditionParams:(NSDictionary *)conditionParams;

/**
 *  创建根据条件删除表中内容的command
 */
- (PersistanceQueryCommand *)deleteTable:(NSString *)tableName withCondition:(NSString *)condition conditionParams:(NSDictionary *)conditionParams;

@end
