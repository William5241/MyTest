//
//  PersistanceTable+Update.m
//  DongAoAcc
//
//  Created by wihan on 15/11/26.
//  Copyright © 2015年 wihan. All rights reserved.
//

#import "PersistanceTable+Update.h"
#import "PersistanceQueryCommand+DataManipulations.h"
#import <UIKit/UIKit.h>

@implementation PersistanceTable (Update)

- (void)updateRecord:(NSObject <PersistanceRecordProtocol> *)record error:(NSError **)error
{
    [self updateKeyValueList:[record dictionaryRepresentationWithTable:self.child] primaryKeyValue:[record valueForKey:[self.child primaryKeyName]] error:error];
}

- (void)updateRecordList:(NSArray <NSObject <PersistanceRecordProtocol> *> *)recordList error:(NSError **)error
{
    [recordList enumerateObjectsUsingBlock:^(NSObject <PersistanceRecordProtocol> * _Nonnull record, NSUInteger idx, BOOL * _Nonnull stop) {
        [self updateRecord:record error:error];
        if (*error) {
            *stop = YES;
        }
    }];
}

- (void)updateValue:(id)value forKey:(NSString *)key whereCondition:(NSString *)whereCondition whereConditionParams:(NSDictionary *)whereConditionParams error:(NSError **)error
{
    if (key && value) {
        [self updateKeyValueList:@{key:value} whereCondition:whereCondition whereConditionParams:whereConditionParams error:error];
    }
}

- (BOOL)updateKeyValueList:(NSDictionary *)keyValueList whereCondition:(NSString *)whereCondition whereConditionParams:(NSDictionary *)whereConditionParams error:(NSError **)error
{
    return [[self.queryCommand updateTable:[self.child tableName] withData:keyValueList condition:whereCondition conditionParams:whereConditionParams] executeWithError:error];
}

- (void)updateValue:(id)value forKey:(NSString *)key primaryKeyValue:(NSNumber *)primaryKeyValue error:(NSError **)error
{
    if (key && value) {
        NSString *whereCondition = [NSString stringWithFormat:@"%@ = :primaryKeyValue", [self.child primaryKeyName]];
        NSDictionary *whereConditionParams = NSDictionaryOfVariableBindings(primaryKeyValue);
        [self updateKeyValueList:@{key:value} whereCondition:whereCondition whereConditionParams:whereConditionParams error:error];
    }
}

- (void)updateValue:(id)value forKey:(NSString *)key primaryKeyValueList:(NSArray <NSNumber *> *)primaryKeyValueList error:(NSError **)error
{
    if (key && value) {
        NSString *primaryKeyValueListString = [primaryKeyValueList componentsJoinedByString:@","];
        NSString *whereCondition = [NSString stringWithFormat:@"%@ IN (:primaryKeyValueListString)", [self.child primaryKeyName]];
        NSDictionary *whereConditionParams = NSDictionaryOfVariableBindings(primaryKeyValueListString);
        [self updateKeyValueList:@{key:value} whereCondition:whereCondition whereConditionParams:whereConditionParams error:error];
    }
}

- (void)updateKeyValueList:(NSDictionary *)keyValueList primaryKeyValue:(NSNumber *)primaryKeyValue error:(NSError **)error
{
    NSString *whereCondition = [NSString stringWithFormat:@"%@ = :primaryKeyValue", [self.child primaryKeyName]];
    NSDictionary *whereConditionParams = NSDictionaryOfVariableBindings(primaryKeyValue);
    [self updateKeyValueList:keyValueList whereCondition:whereCondition whereConditionParams:whereConditionParams error:error];
}

- (void)updateKeyValueList:(NSDictionary *)keyValueList primaryKeyValueList:(NSArray <NSNumber *> *)primaryKeyValueList error:(NSError **)error
{
    //1.创建update string和value
    NSString *primaryKeyValueListString = [primaryKeyValueList componentsJoinedByString:@","];
    NSString *whereCondition = [NSString stringWithFormat:@"%@ IN (:primaryKeyValueListString)", [self.child primaryKeyName]];
    NSDictionary *whereConditionParams = NSDictionaryOfVariableBindings(primaryKeyValueListString);
    //2.进行更新操作
    [self updateKeyValueList:keyValueList whereCondition:whereCondition whereConditionParams:whereConditionParams error:error];
}

@end

