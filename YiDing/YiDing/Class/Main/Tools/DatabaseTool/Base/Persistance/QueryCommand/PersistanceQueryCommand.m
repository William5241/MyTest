//
//  PersistanceQueryCommand.m
//  DongAoAcc
//
//  Created by wihan on 15/11/26.
//  Copyright © 2015年 wihan. All rights reserved.
//

#import "PersistanceQueryCommand.h"
#import "PersistanceDataBase.h"
#import "PersistanceDatabasePool.h"
#import "PersistanceConfiguration.h"

@interface PersistanceQueryCommand ()

@property (nonatomic, weak) PersistanceDataBase *database;
@property (nonatomic, strong) NSString *databaseName;
@property (nonatomic, strong) NSMutableString *sqlString;

@property (nonatomic, assign) BOOL isInTransaction;

@end

@implementation PersistanceQueryCommand

#pragma mark - public methods
- (instancetype)initWithDatabase:(PersistanceDataBase *)database {
    
    self = [super init];
    if (self) {
        self.database = database;
    }
    return self;
}

- (instancetype)initWithDatabaseName:(NSString *)databaseName {
    
    self = [super init];
    if (self) {
        self.databaseName = databaseName;
    }
    return self;
}

- (PersistanceQueryCommand *)resetQueryCommand {
    
    self.sqlString = nil;
    return self;
}

- (BOOL)executeWithError:(NSError *__autoreleasing *)error
{
    BOOL isSuccess = YES;
    
    sqlite3_stmt *statement;
    const char *query = [[NSString stringWithFormat:@"%@;", self.sqlString] UTF8String];
#ifdef DEBUG
    NSLog(@"\n\n\n\n\n=========================\n\nCTPersistance SQL String is:\n%@\n\n=========================\n\n\n\n\n", [NSString stringWithCString:query encoding:NSUTF8StringEncoding]);
#endif
    //1.执行sql语句（insert，delete，update...），如果失败，需要用sqlite3_finalize释放sqlite3_stmt对象，以防止内存泄露
    int result = sqlite3_prepare_v2(self.database.database, query, -1, &statement, NULL);
    
    //2.错误处理
    if (result != SQLITE_OK && error) {
        const char *errorMsg = sqlite3_errmsg(self.database.database);
        NSError *generatedError = [NSError errorWithDomain:kPersistanceErrorDomain code:PersistanceErrorCodeQueryStringError userInfo:@{NSLocalizedDescriptionKey:[NSString stringWithFormat:@"\n======================\nQuery Error: \n Origin Query is : %@\n Error Message is: %@\n======================\n", self.sqlString, [NSString stringWithCString:errorMsg encoding:NSUTF8StringEncoding]]}];
        *error = generatedError;
        sqlite3_finalize(statement);
        return NO;
    }
    
    //3.通过sqlite3_step命令，处理返回结果
    result = sqlite3_step(statement);
    
    if (result != SQLITE_DONE && error) {
        const char *errorMsg = sqlite3_errmsg(self.database.database);
        NSError *generatedError = [NSError errorWithDomain:kPersistanceErrorDomain code:PersistanceErrorCodeQueryStringError userInfo:@{NSLocalizedDescriptionKey:[NSString stringWithFormat:@"\n======================\nQuery Error: \n Origin Query is : %@\n Error Message is: %@\n======================\n", self.sqlString, [NSString stringWithCString:errorMsg encoding:NSUTF8StringEncoding]]}];
        *error = generatedError;
        sqlite3_finalize(statement);
        return NO;
    }
    
    //4.释放对象的资源。
    sqlite3_finalize(statement);

    return isSuccess;
}

- (NSArray <NSDictionary *> *)fetchWithError:(NSError *__autoreleasing *)error
{
    NSMutableArray *resultsArray = [[NSMutableArray alloc] init];
    sqlite3_stmt *statement;
    const char *query = [[NSString stringWithFormat:@"%@;", self.sqlString] UTF8String];
#ifdef DEBUG
    NSLog(@"\n\n\n\n\n=========================\n\nCTPersistance SQL String is:\n%@\n\n=========================\n\n\n\n\n", [NSString stringWithCString:query encoding:NSUTF8StringEncoding]);
#endif
    //1.执行sql语句（查询），如果失败，需要用sqlite3_finalize释放sqlite3_stmt对象，以防止内存泄露
    int returnCode = sqlite3_prepare_v2(self.database.database, query, -1, &statement, NULL);
    
    //2.处理error
    if (returnCode != SQLITE_OK && error) {
        const char *errorMsg = sqlite3_errmsg(self.database.database);
        *error = [NSError errorWithDomain:kPersistanceErrorDomain code:PersistanceErrorCodeQueryStringError userInfo:@{NSLocalizedDescriptionKey:[NSString stringWithFormat:@"\n\n\n======================\nQuery Error: \n Origin Query is : %@\n Error Message is: %@\n======================\n\n\n", self.sqlString, [NSString stringWithCString:errorMsg encoding:NSUTF8StringEncoding]]}];
        sqlite3_finalize(statement);
        return resultsArray;
    }
    
    //3.通过sqlite3_step命令查询语句。sqlite3_step执行正确的返回值只有SQLITE_DONE，对于SELECT查询而言，如果有数据则返回SQLITE_ROW，当到达结果集末尾时则返回SQLITE_DONE。这里循环遍历，查询结果
    while (sqlite3_step(statement) == SQLITE_ROW) {
        //3.1得到查询项的列数
        int columns = sqlite3_column_count(statement);
        NSMutableDictionary *result = [[NSMutableDictionary alloc] initWithCapacity:columns];
        //3.2遍历所有列
        for (int i = 0; i<columns; i++) {
            //3.2.1得到列的名字
            const char *name = sqlite3_column_name(statement, i);
            
            NSString *columnName = [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
            //3.2.2得到列的类型，并根据不同类型进行处理
            int type = sqlite3_column_type(statement, i);
            
            switch (type) {
                //存NSNumber
                case SQLITE_INTEGER:
                {
                    int value = sqlite3_column_int(statement, i);
                    [result setObject:[NSNumber numberWithInt:value] forKey:columnName];
                    break;
                }
                //存NSNumber
                case SQLITE_FLOAT:
                {
                    float value = sqlite3_column_double(statement, i);
                    [result setObject:[NSNumber numberWithFloat:value] forKey:columnName];
                    break;
                }
                //存NSString
                case SQLITE_TEXT:
                {
                    const char *value = (const char*)sqlite3_column_text(statement, i);
                    [result setObject:[NSString stringWithCString:value encoding:NSUTF8StringEncoding] forKey:columnName];
                    break;
                }
                //存NSData
                case SQLITE_BLOB:
                {
                    int bytes = sqlite3_column_bytes(statement, i);
                    if (bytes > 0) {
                        const void *blob = sqlite3_column_blob(statement, i);
                        if (blob != NULL) {
                            [result setObject:[NSData dataWithBytes:blob length:bytes] forKey:columnName];
                        }
                    }
                    break;
                }
                //存NSNull
                case SQLITE_NULL:
                    [result setObject:[NSNull null] forKey:columnName];
                    break;
                //存NSString
                default:
                {
                    const char *value = (const char *)sqlite3_column_text(statement, i);
                    [result setObject:[NSString stringWithCString:value encoding:NSUTF8StringEncoding] forKey:columnName];
                    break;
                }
            }
        }
        [resultsArray addObject:result];
    }
    //4.释放statement
    sqlite3_finalize(statement);
    
    return resultsArray;
}

#pragma mark - getters and setters
- (NSMutableString *)sqlString {
    
    if (_sqlString == nil) {
        _sqlString = [[NSMutableString alloc] init];
    }
    return _sqlString;
}

- (PersistanceDataBase *)database {
    
    if (_database == nil) {
        //创建数据库实例
        _database = [[PersistanceDatabasePool sharedInstance] databaseWithName:self.databaseName];
    }
    return _database;
}

@end
