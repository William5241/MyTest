//
//  CustomizedMigrator.m
//  DongAoAcc
//
//  Created by wihan on 15/11/30.
//  Copyright © 2015年 wihan. All rights reserved.
//

#import "CustomizedMigrator.h"

#import "PersistanceConfiguration.h"
#import "CustomizedMigrationStep0_0.h"

@implementation CustomizedMigrator

#pragma mark - PersistanceMigratorProtocol
- (NSDictionary *)migrationStepDictionary {
    
    return @{
             //第一次提交设置版本位0.0
             @"0.0":[CustomizedMigrationStep0_0 class]
             };
}

- (NSArray *)migrationVersionList {
    
    return @[kPersistanceInitVersion, @"0.0"];
}

@end
