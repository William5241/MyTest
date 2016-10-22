//
//  Persistance.h
//  DongAoAcc
//
//  Created by wihan on 15/11/27.
//  Copyright © 2015年 wihan. All rights reserved.
//

#ifndef Persistance_h
#define Persistance_h

#import "PersistanceConfiguration.h"
#import "PersistanceMarcos.h"

#import "PersistanceDatabasePool.h"
#import "PersistanceMigrator.h"
#import "PersistanceCriteria.h"
#import "PersistanceTransaction.h"
#import "PersistanceAsyncExecutor.h"

#import "PersistanceDataBase.h"

#import "PersistanceRecordProtocol.h"
#import "PersistanceRecord.h"

#import "PersistanceTable.h"
#import "PersistanceTable+Find.h"
#import "PersistanceTable+Delete.h"
#import "PersistanceTable+Insert.h"
#import "PersistanceTable+Update.h"

#import "PersistanceQueryCommand.h"
#import "PersistanceQueryCommand+ReadMethods.h"
#import "PersistanceQueryCommand+DataManipulations.h"
#import "PersistanceQueryCommand+SchemaManipulations.h"

extern NSString * const kPersistanceDataBaseCheckMigrationNotification;

#endif /* Persistance_h */
