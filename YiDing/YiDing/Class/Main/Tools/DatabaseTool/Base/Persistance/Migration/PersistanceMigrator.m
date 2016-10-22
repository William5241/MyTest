//
//  PersistanceMigrator.m
//  DongAoAcc
//
//  Created by wihan on 15/11/28.
//  Copyright © 2015年 wihan. All rights reserved.
//

/**
 * 数据库迁移：
   建立数据库版本节点，迁移的时候一个一个跑过去。
   注意如下问题：
       1.根据版本，记录每一版数据库的改变，并将改变封装成对象
       2.记录好当前数据库的版本，便于跟迁移记录做比对
       3.在启动数据库时执行迁移操作，如果迁移失败，提供一些降级方案
       4.不会在主线程做版本迁移的事情
       5.SQLite差不多在执行每一个SQL的时候，内部都是走的一个Transaction。当某一版的SQL数量特别多的时候，建议在版本迁移的方法里面自己建立一个Transaction，然后把相关的SQL都包起来，这样SQLite执行这些SQL的时候速度就会快一点
 */

#import "PersistanceMigrator.h"

#import "PersistanceQueryCommand.h"

#import "PersistanceTable+Insert.h"
#import "PersistanceTable+Find.h"
#import "PersistanceTable+Update.h"

#import "PersistanceVersionRecord.h"
#import "PersistanceVersionTable.h"
#import "PersistanceConfiguration.h"

@interface PersistanceMigrator ()

@property (nonatomic, weak) id<PersistanceMigratorProtocol> child;
@property (nonatomic, strong) PersistanceVersionTable *versionTable;
@property (nonatomic, weak) PersistanceDataBase *database;

@end

@implementation PersistanceMigrator

#pragma mark - life cycle
- (instancetype)init {
    
    self = [super init];
    if (self && [self conformsToProtocol:@protocol(PersistanceMigratorProtocol)]) {
        self.child = (id<PersistanceMigratorProtocol>)self;
    } else {
        NSException *exception = [NSException exceptionWithName:@"PersistanceMigrator init error" reason:@"the child class must conforms to protocol: <PersistanceMigratorProtocol>" userInfo:nil];
        @throw exception;
    }
    return self;
}

#pragma mark - public methods
- (void)createVersionTableWithDatabase:(PersistanceDataBase *)database {
    
    self.database = database;
    PersistanceVersionRecord *record = [[PersistanceVersionRecord alloc] init];
    record.databaseVersion = [[self.child migrationVersionList] lastObject];
    [self.versionTable insertRecord:record error:NULL];
}

- (BOOL)databaseShouldMigrate:(PersistanceDataBase *)database {
    
    self.database = database;
    //1.获取versionTable的最新插入记录，并得到当前版本key（currentVersion）
    PersistanceVersionRecord *latestRecord = (PersistanceVersionRecord *)[self.versionTable findLatestRecordWithError:NULL];
    NSString *currentVersion = latestRecord.databaseVersion;
    //2.根据当前版本key，到VersionList中找到版本index
    NSUInteger index = [[self.child migrationVersionList] indexOfObject:currentVersion];
    //3.如果当前版本index，判断是不是最新的版本，如果是则不需要迁移，否则需要迁移
    if (index == [[self.child migrationVersionList] count] - 1) {
        return NO;
    }
    return YES;
}

- (void)databasePerformMigrate:(PersistanceDataBase *)database
{
    self.database = database;
    NSError *error = nil;
    //1.获得versionTable种最新记录
    PersistanceVersionRecord *latestRecord = (PersistanceVersionRecord *)[self.versionTable findLatestRecordWithError:&error];
    if (error) {
        return;
    }
    
    BOOL shouldPerformMigration = NO;
    NSArray *versionList = [self.child migrationVersionList];
    NSDictionary *migrationObjectContainer = [self.child migrationStepDictionary];
    //2.轮训versionList检测每一个版本是否需要数据迁移
    for (NSString *version in versionList) {
        if (shouldPerformMigration) {
            //2.1创建符合PersistanceMigrationStep协议的对象
            id<PersistanceMigrationStep> step = [[migrationObjectContainer[version] alloc] init];
            error = nil;
            //2.2根据command向上迁移
            [step goUpWithQueryCommand:self.versionTable.queryCommand error:&error];
            //2.3如果出错再向下迁移
            if (error) {
                error = nil;
                [step goDownWithQueryCommand:self.versionTable.queryCommand error:&error];
                break;
            } else {
                //2.4如果迁移成功，更新versionTable
                latestRecord.databaseVersion = version;
                error = nil;
                [self.versionTable updateRecord:latestRecord error:&error];
            }
        }
        
        //2.5检测当前version如果是最新版本，那么需要设置执行数据库迁移，这样下一个版本将执行迁移
        if ([version isEqualToString:latestRecord.databaseVersion]) {
            shouldPerformMigration = YES;
        }
    }
}

#pragma mark - getters and setters
- (PersistanceVersionTable *)versionTable {
    
    if (_versionTable == nil) {
        _versionTable = [[PersistanceVersionTable alloc] initWithDatabase:self.database];
    }
    return _versionTable;
}

@end
