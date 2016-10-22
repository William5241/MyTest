//
//  PersistanceDataBase.m
//  DongAoAcc
//
//  Created by wihan on 15/11/25.
//  Copyright © 2015年 wihan. All rights reserved.
//

#import "PersistanceDataBase.h"
#import "PersistanceConfiguration.h"
#import "PersistanceMigrator.h"
#import "NSString+ReqularExpression.h"

@interface PersistanceDataBase ()

@property (nonatomic, assign) sqlite3 *database;
@property (nonatomic, copy) NSString *databaseName;
@property (nonatomic, copy) NSString *databaseFilePath;
//数据库迁移对象
@property (nonatomic, strong) PersistanceMigrator *migrator;

@end

@implementation PersistanceDataBase

#pragma mark - life cycle
- (instancetype)initWithDatabaseName:(NSString *)databaseName error:(NSError *__autoreleasing *)error
{
    self = [super init];
    if (self) {
        self.databaseName = databaseName;
        self.databaseFilePath = [[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:databaseName];
        
        BOOL isFileExists = [[NSFileManager defaultManager] fileExistsAtPath:self.databaseFilePath];
        
        const char *path = [self.databaseFilePath UTF8String];
        //1.创建并打开数据库连接
        //SQLITE_OPEN_CREATE and SQLITE_OPEN_READWRITE:创建并打开数据库，并有读写权限
        //SQLITE_OPEN_FULLMUTEX:设置数据库为serialized模式，serialized是由一个串行队列来执行所有的操作，对于使用者来说除了响应速度会慢一些
        //SQLITE_OPEN_SHAREDCACHE:创建shared-cache模式，这样一个线程建立多个连接到同一个数据库上，所有连接共享一个single data and schema cache；这样可以减少内存使用和系统io需求
        int result = sqlite3_open_v2(path, &_database,
                                     SQLITE_OPEN_CREATE |
                                     SQLITE_OPEN_READWRITE |
                                     SQLITE_OPEN_FULLMUTEX |
                                     SQLITE_OPEN_SHAREDCACHE,
                                     NULL);
        
        //2.对错误的error处理
        if (result != SQLITE_OK && error) {
            PersistanceErrorCode errorCode = PersistanceErrorCodeOpenError;
            NSString *sqliteErrorString = [NSString stringWithCString:sqlite3_errmsg(self.database) encoding:NSUTF8StringEncoding];
            NSString *errorString = [NSString stringWithFormat:@"open database at %@ failed with error:\n %@", self.databaseFilePath, sqliteErrorString];
            if (isFileExists == NO) {
                errorCode = PersistanceErrorCodeCreateError;
                errorString = [NSString stringWithFormat:@"create database at %@ failed with error:\n %@", self.databaseFilePath, [NSString stringWithCString:sqlite3_errmsg(self.database) encoding:NSUTF8StringEncoding]];
            }
            
            *error = [NSError errorWithDomain:kPersistanceErrorDomain code:errorCode userInfo:@{NSLocalizedDescriptionKey:errorString}];
            [self closeDatabase];
            return nil;
        }
        
        //3.数据迁移处理
        if (isFileExists == NO) {
            [self.migrator createVersionTableWithDatabase:self];
        } else {
            if ([self.migrator databaseShouldMigrate:self]) {
                [self.migrator databasePerformMigrate:self];
            }
        }
    }
    return self;
}

- (void)dealloc {
    
    [self closeDatabase];
}

#pragma mark - public methods
- (void)closeDatabase {
    
//    [self.database close];
    sqlite3_close_v2(self.database);
    self.database = 0x00;
    self.databaseFilePath = nil;
}

#pragma mark - getters and setters
- (PersistanceMigrator *)migrator {
    
    if (_migrator == nil) {
        //1.获取plist文件内容
        NSString *persistanceConfigurationPlistPath = [[NSBundle mainBundle] pathForResource:kPersisatanceConfigurationFileName ofType:@"plist"];
        NSDictionary *persistanceConfigurationPlist = [NSDictionary dictionaryWithContentsOfFile:persistanceConfigurationPlistPath];
        __block Class migratorClass = NULL;
        //2.根据plist文件中定义的表名，获取指定的迁移表名，从而创建迁移对象
        [persistanceConfigurationPlist enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull pattern, NSString * _Nonnull migartorClassName, BOOL * _Nonnull stop) {
            if ([self.databaseName isMatchWithRegularExpression:pattern]) {
                migratorClass = NSClassFromString(migartorClassName);
            }
        }];
        if (migratorClass != NULL) {
            _migrator = [[migratorClass alloc] init];
        }
    }
    return _migrator;
}

@end

