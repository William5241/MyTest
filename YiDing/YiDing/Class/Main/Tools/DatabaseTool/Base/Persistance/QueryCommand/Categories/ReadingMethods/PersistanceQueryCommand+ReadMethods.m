//
//  PersistanceQueryCommand+ReadMethods.m
//  DongAoAcc
//
//  Created by wihan on 15/11/26.
//  Copyright © 2015年 wihan. All rights reserved.
//

#import "PersistanceQueryCommand+ReadMethods.h"
#import "NSString+SQL.h"
#import "PersistanceConfiguration.h"

@implementation PersistanceQueryCommand (ReadMethods)

- (PersistanceQueryCommand *)select:(NSString *)columList isDistinct:(BOOL)isDistinct
{
    [self resetQueryCommand];
    //1.如果columList为nil，则select所有值
    if (columList == nil) {
        if (isDistinct) {
            [self.sqlString appendString:@"SELECT DISTINCT * "];
        } else {
            [self.sqlString appendString:@"SELECT * "];
        }
    //2.创建有条件的select sql
    } else {
        if (isDistinct) {
            [self.sqlString appendFormat:@"SELECT DISTINCT '%@' ", [columList safeSQLEncode]];
        } else {
            [self.sqlString appendFormat:@"SELECT '%@' ", [columList safeSQLEncode]];
        }
    }
    
    return self;
}

- (PersistanceQueryCommand *)from:(NSString *)fromList
{
    if (fromList == nil) {
        return self;
    }
    [self.sqlString appendFormat:@"FROM '%@' ", [fromList safeSQLEncode]];
    return self;
}

- (PersistanceQueryCommand *)where:(NSString *)condition params:(NSDictionary *)params
{
    if (condition == nil) {
        return self;
    }
    
    NSString *whereString = [condition stringWithSQLParams:params];
    [self.sqlString appendFormat:@"WHERE %@ ", whereString];
    
    return self;
}

- (PersistanceQueryCommand *)orderBy:(NSString *)orderBy isDESC:(BOOL)isDESC
{
    if (orderBy == nil) {
        return self;
    }
    [self.sqlString appendFormat:@"ORDER BY %@ ", [orderBy safeSQLMetaString]];
    if (isDESC) {
        [self.sqlString appendString:@"DESC "];
    } else {
        [self.sqlString appendString:@"ASC "];
    }
    return self;
}

- (PersistanceQueryCommand *)limit:(NSInteger)limit
{
    if (limit == PersistanceNoLimit) {
        return self;
    }
    [self.sqlString appendFormat:@"LIMIT %lu ", (unsigned long)limit];
    return self;
}

- (PersistanceQueryCommand *)offset:(NSInteger)offset
{
    if (offset == PersistanceNoOffset) {
        return self;
    }
    [self.sqlString appendFormat:@"OFFSET %lu ", (unsigned long)offset];
    return self;
}

- (PersistanceQueryCommand *)limit:(NSInteger)limit offset:(NSInteger)offset
{
    return [[self limit:limit] offset:offset];
}

@end
