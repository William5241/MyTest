//
//  PersistanceTable+Insert.h
//  DongAoAcc
//
//  Created by wihan on 15/11/26.
//  Copyright © 2015年 wihan. All rights reserved.
//

#import "PersistanceTable.h"
#import "PersistanceRecord.h"

@interface PersistanceTable (Insert)

/**
 *  插入一个record list
 *
 *  如果插入失败错误信息记录在error中，key是kPersistanceErrorUserinfoKeyErrorRecord
 *
 *  如果record list为nil或者空，则返回yes，且error为nil
 *
 *  @param recordList 要插入的record list
 *
 *  @return return YES 插入成功
 */
- (BOOL)insertRecordList:(NSArray <NSObject <PersistanceRecordProtocol> *> *)recordList error:(NSError **)error;

/**
 *  插入一个record
 *
 *  如果插入失败错误信息记录在error中，key是kPersistanceErrorUserinfoKeyErrorRecord
 *
 *  如果record list为nil或者空，则返回yes，且error为nil
 *
 *  @param record 要插入的record
 *
 *  @return return YES 插入成功
 */
- (BOOL)insertRecord:(NSObject <PersistanceRecordProtocol> *)record error:(NSError **)error;

@end

