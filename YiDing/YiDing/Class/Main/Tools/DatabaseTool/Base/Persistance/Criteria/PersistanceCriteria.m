//
//  PersistanceCriteria.m
//  DongAoAcc
//
//  Created by wihan on 15/11/27.
//  Copyright © 2015年 wihan. All rights reserved.
//

#import "PersistanceCriteria.h"
#import "PersistanceConfiguration.h"
#import "PersistanceQueryCommand+ReadMethods.h"
#import "PersistanceQueryCommand+DataManipulations.h"

@implementation PersistanceCriteria

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.limit = PersistanceNoLimit;
        self.offset = PersistanceNoOffset;
    }
    return self;
}

- (PersistanceQueryCommand *)applyToSelectQueryCommand:(PersistanceQueryCommand *)queryCommand tableName:(NSString *)tableName
{
    //select字句，从哪个表中选择，执行什么样的条件，遵循什么顺序，做什么限制
    [queryCommand select:self.select isDistinct:self.isDistinct];
    [queryCommand from:tableName];
    [queryCommand where:self.whereCondition params:self.whereConditionParams];
    [queryCommand orderBy:self.orderBy isDESC:self.isDESC];
    [queryCommand limit:self.limit offset:self.offset];
    return queryCommand;
}

- (PersistanceQueryCommand *)applyToDeleteQueryCommand:(PersistanceQueryCommand *)queryCommand tableName:(NSString *)tableName
{
    return [queryCommand deleteTable:tableName withCondition:self.whereCondition conditionParams:self.whereConditionParams];
}

@end
