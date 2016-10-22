//
//  PersistanceQueryCommand+Status.m
//  DongAoAcc
//
//  Created by wihan on 15/11/27.
//  Copyright © 2015年 wihan. All rights reserved.
//

#import "PersistanceQueryCommand+Status.h"
#import <sqlite3.h>

@implementation PersistanceQueryCommand (Status)

- (NSNumber *)lastInsertRowId
{
    return @(sqlite3_last_insert_rowid(self.database.database));
}

- (NSNumber *)rowsChanged
{
    return @(sqlite3_changes(self.database.database));
}

@end
