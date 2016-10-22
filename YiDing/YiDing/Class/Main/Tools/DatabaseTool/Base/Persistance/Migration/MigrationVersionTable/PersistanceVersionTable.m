//
//  PersistanceVersionTable.m
//  DongAoAcc
//
//  Created by wihan on 15/11/28.
//  Copyright © 2015年 wihan. All rights reserved.
//

#import "PersistanceVersionTable.h"
#import "PersistanceConfiguration.h"
#import "PersistanceVersionRecord.h"
#import "PersistanceQueryCommand.h"
#import "PersistanceQueryCommand+SchemaManipulations.h"

@interface PersistanceVersionTable ()

@property (nonatomic, weak) PersistanceDataBase *database;
@property (nonatomic, strong) NSString *databaseName;
@property (nonatomic, strong) PersistanceQueryCommand *queryCommand;

@end

@implementation PersistanceVersionTable

@synthesize queryCommand = _queryCommand;

#pragma mark - life cycle
- (instancetype)initWithDatabase:(PersistanceDataBase *)database {
    
    self = [super init];
    if (self) {
        self.database = database;
        self.databaseName = database.databaseName;
    }
    return self;
}

#pragma mark - PersistanceTableProtocol
- (NSString *)tableName {
    
    return kPersistanceVersionTableName;
}

- (NSDictionary *)columnInfo {
    
    return @{
             @"identifier":@"INTEGER PRIMARY KEY AUTOINCREMENT",
             @"databaseVersion":@"TEXT"
             };
}

- (NSString *)primaryKeyName {
    
    return @"identifier";
}

- (Class)recordClass {
    
    return [PersistanceVersionRecord class];
}

#pragma mark - getters and setters
- (PersistanceQueryCommand *)queryCommand {
    
    if (_queryCommand == nil) {
        _queryCommand = [[PersistanceQueryCommand alloc] initWithDatabase:self.database];
        [[_queryCommand createTable:[self.child tableName] columnInfo:[self.child columnInfo]] executeWithError:NULL];
    }
    return _queryCommand;
}

@end
