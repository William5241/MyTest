//
//  PersistanceDatabasePool.m
//  DongAoAcc
//
//  Created by wihan on 15/11/25.
//  Copyright © 2015年 wihan. All rights reserved.
//

#import "PersistanceDatabasePool.h"

@interface PersistanceDatabasePool ()

@property (nonatomic, strong) NSMutableDictionary *databaseList;

@end

@implementation PersistanceDatabasePool

#pragma mark - life cycle
- (void)dealloc {
    
    [self closeAllDatabase];
}

#pragma mark - public methods
+ (instancetype)sharedInstance {
    
    static PersistanceDatabasePool *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[PersistanceDatabasePool alloc] init];
    });
    return sharedInstance;
}

- (PersistanceDataBase *)databaseWithName:(NSString *)databaseName {
    
    if (databaseName == nil) {
        return nil;
    }
    
    if (self.databaseList[databaseName] == nil) {
        self.databaseList[databaseName] = [[PersistanceDataBase alloc] initWithDatabaseName:databaseName error:NULL];
    }
    
    return self.databaseList[databaseName];
}

- (void)closeAllDatabase {
    
    [self.databaseList enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull databaseName, PersistanceDataBase * _Nonnull database, BOOL * _Nonnull stop) {
        if ([database isKindOfClass:[PersistanceDataBase class]]) {
            [database closeDatabase];
        }
    }];
    [self.databaseList removeAllObjects];
}

- (void)closeDatabaseWithName:(NSString *)databaseName {
    PersistanceDataBase *database = self.databaseList[databaseName];
    [database closeDatabase];
    [self.databaseList removeObjectForKey:databaseName];
}

#pragma mark - getters and setters
- (NSMutableDictionary *)databaseList {
    
    if (_databaseList == nil) {
        _databaseList = [[NSMutableDictionary alloc] init];
    }
    return _databaseList;
}

@end
