//
//  PersistanceTable.m
//  DongAoAcc
//
//  Created by wihan on 15/11/25.
//  Copyright © 2015年 wihan. All rights reserved.
//

#import "PersistanceTable.h"
#import "objc/runtime.h"
#import "PersistanceQueryCommand.h"
#import "PersistanceQueryCommand+SchemaManipulations.h"

@interface PersistanceTable ()

@property (nonatomic, strong, readwrite) PersistanceQueryCommand *queryCommand;

@end

@implementation PersistanceTable

#pragma mark - life cycle
- (instancetype)init {
    
    self = [super init];
    //检测table是否遵循PersistanceTableProtocol协议
    if (self && [self conformsToProtocol:@protocol(PersistanceTableProtocol)]) {
        self.child = (PersistanceTable <PersistanceTableProtocol> *)self;
    } else {
        NSException *exception = [NSException exceptionWithName:@"PersistanceTable init error" reason:@"the child class must conforms to protocol: <PersistanceTableProtocol>" userInfo:nil];
        @throw exception;
    }
    
    return self;
}

- (instancetype)initWithQueryCommand:(PersistanceQueryCommand *)queryCommand {
    
    self = [self init];
    if (self) {
        self.queryCommand = queryCommand;
        if ([self.child respondsToSelector:@selector(modifyDatabaseName:)]) {
            [self.child modifyDatabaseName:queryCommand.database.databaseName];
        }
    }
    return self;
}

#pragma mark - public methods
- (BOOL)executeSQL:(NSString *)sqlString error:(NSError *__autoreleasing *)error {
    
    [self.queryCommand resetQueryCommand];
    [self.queryCommand.sqlString appendString:sqlString];
    return [self.queryCommand executeWithError:error];
}

- (NSArray *)fetchWithSQL:(NSString *)sqlString error:(NSError *__autoreleasing *)error {
    
    [self.queryCommand resetQueryCommand];
    [self.queryCommand.sqlString appendString:sqlString];
    return [self.queryCommand fetchWithError:error];
}

#pragma mark - method to override
- (BOOL)isCorrectToInsertRecord:(NSObject <PersistanceRecordProtocol> *)record {
    
    return YES;
}

- (BOOL)isCorrectToUpdateRecord:(NSObject <PersistanceRecordProtocol> *)record {
    
    return YES;
}

#pragma mark - getters and setters
- (PersistanceQueryCommand *)queryCommand {
    
    if (_queryCommand == nil) {
        //1.初始化数据库
        _queryCommand = [[PersistanceQueryCommand alloc] initWithDatabaseName:[self.child databaseName]];
        //2.创建数据库表
        [[_queryCommand createTable:[self.child tableName] columnInfo:[self.child columnInfo]] executeWithError:NULL];
    }
    return _queryCommand;
}

@end
