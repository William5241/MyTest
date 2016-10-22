//
//  CustomizedMigrationStep0_0.m
//  DongAoAcc
//
//  Created by wihan on 16/2/16.
//  Copyright © 2016年 wihan. All rights reserved.
//

#import "CustomizedMigrationStep0_0.h"

@implementation CustomizedMigrationStep0_0

- (BOOL)goUpWithQueryCommand:(PersistanceQueryCommand *)queryCommand error:(NSError *__autoreleasing *)error {
    //version0_0 do nothing
    return NO;
}

- (BOOL)goDownWithQueryCommand:(PersistanceQueryCommand *)queryCommand error:(NSError *__autoreleasing *)error {
    //version0_0 do nothing
    return NO;
}

@end
