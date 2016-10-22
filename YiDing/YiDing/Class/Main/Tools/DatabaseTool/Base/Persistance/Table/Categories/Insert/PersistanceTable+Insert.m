//
//  PersistanceTable+Insert.m
//  DongAoAcc
//
//  Created by wihan on 15/11/26.
//  Copyright © 2015年 wihan. All rights reserved.
//

#import "PersistanceTable+Insert.h"
#import "PersistanceDatabasePool.h"
#import "PersistanceConfiguration.h"

#import "PersistanceQueryCommand.h"
#import "PersistanceQueryCommand+SchemaManipulations.h"
#import "PersistanceQueryCommand+ReadMethods.h"
#import "PersistanceQueryCommand+DataManipulations.h"
#import "PersistanceQueryCommand+Status.h"

#import "objc/runtime.h"
#import <sqlite3.h>

@implementation PersistanceTable (Insert)

- (BOOL)insertRecordList:(NSArray<NSObject <PersistanceRecordProtocol> *> *)recordList error:(NSError *__autoreleasing *)error
{
    __block BOOL isSuccess = YES;
    
    //1.如果record list为nil则返回YES
    if (recordList == nil) {
        return isSuccess;
    }
    //2.将record转成dic保存入insertList中
    NSMutableArray *insertList = [[NSMutableArray alloc] init];
    __block NSUInteger errorRecordIndex = 0;
    [recordList enumerateObjectsUsingBlock:^(NSObject <PersistanceRecordProtocol> * _Nonnull record, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([self.child isCorrectToInsertRecord:record]) {
            [insertList addObject:[record dictionaryRepresentationWithTable:self.child]];
        } else {
            isSuccess = NO;
            errorRecordIndex = idx;
            *stop = YES;
        }
    }];
    
    //3.如果设置insertList成功，则插入记录
    if (isSuccess) {
        if ([[self.queryCommand insertTable:[self.child tableName] withDataList:insertList] executeWithError:error]) {
            //3.1插入成功，check插入行数是否与insertList相同，如果不同则返回error
            NSInteger changedRowsCount = [[self.queryCommand rowsChanged] integerValue];
            if (changedRowsCount != [insertList count]) {
                isSuccess = NO;
                if (error) {
                    *error = [NSError errorWithDomain:kPersistanceErrorDomain
                                                 code:PersistanceErrorCodeRecordNotAvailableToInsert
                                             userInfo:@{
                                                        NSLocalizedDescriptionKey:[NSString stringWithFormat:@"there is %lu records to save, but only %ld saved, you should check error", (unsigned long)[insertList count], (long)changedRowsCount],
                                                        kPersistanceErrorUserinfoKeyErrorRecord:insertList
                                                        }];
                }
            }
        } else {
            isSuccess = NO;
        }
    } else {
        if (error) {
            *error = [self errorWithRecord:recordList[errorRecordIndex]];
        }
    }
    
    return isSuccess;
}

- (BOOL)insertRecord:(NSObject <PersistanceRecordProtocol> *)record error:(NSError *__autoreleasing *)error
{
    BOOL isSuccessed = YES;
    
    if (record) {
        if ([self.child isCorrectToInsertRecord:record]) {
            //将record转换成dic插入表中
            if ([[self.queryCommand insertTable:[self.child tableName] withDataList:@[[record dictionaryRepresentationWithTable:self.child]]] executeWithError:error]) {
                //如果插入成功，则是这主键值，如果失败则进行error处理
                if ([[self.queryCommand rowsChanged] integerValue] > 0) {
                    if (![record setPersistanceValue:[self.queryCommand lastInsertRowId] forKey:[self.child primaryKeyName]]) {
                        isSuccessed = NO;
                        if (error) {
                            *error = [NSError errorWithDomain:kPersistanceErrorDomain
                                                         code:PersistanceErrorCodeFailedToSetKeyForValue
                                                     userInfo:@{
                                                                NSLocalizedDescriptionKey:[NSString stringWithFormat:@"failed to set value[%@] with key[%@] in record[%@]", [self.child primaryKeyName], [self.queryCommand lastInsertRowId], record]
                                                                }];
                        }
                    }
                } else {
                    isSuccessed = NO;
                    if (error) {
                        *error = [self errorWithRecord:record];
                    }
                }
            } else {
                isSuccessed = NO;
            }
        } else {
            isSuccessed = NO;
            if (error) {
                *error = [self errorWithRecord:record];
            }
        }
    }
    
    return isSuccessed;
}

- (NSError *)errorWithRecord:(NSObject <PersistanceRecordProtocol> *)record
{
    return [NSError errorWithDomain:kPersistanceErrorDomain
                               code:PersistanceErrorCodeRecordNotAvailableToInsert
                           userInfo:@{
                                      NSLocalizedDescriptionKey:[NSString stringWithFormat:@"\n\n%@\n is failed to pass validation, and can not insert", [record dictionaryRepresentationWithTable:self.child]],
                                      kPersistanceErrorUserinfoKeyErrorRecord:record
                                      }];
}

@end
