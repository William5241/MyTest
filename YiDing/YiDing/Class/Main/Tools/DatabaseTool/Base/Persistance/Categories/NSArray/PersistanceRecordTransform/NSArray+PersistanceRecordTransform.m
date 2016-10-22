//
//  NSArray+PersistanceRecordTransform.m
//  DongAoAcc
//
//  Created by wihan on 15/11/27.
//  Copyright © 2015年 wihan. All rights reserved.
//

#import "NSArray+PersistanceRecordTransform.h"

@implementation NSArray (PersistanceRecordTransform)

- (NSArray *)transformSQLItemsToClass:(Class)classType
{
    NSMutableArray *recordList = [[NSMutableArray alloc] init];
    if ([self count] > 0) {
        //数组中的item属于dic
        [self enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull recordInfo, NSUInteger idx, BOOL * _Nonnull stop) {
            //1.根据classType，初始化record
            id <PersistanceRecordProtocol> record = [[classType alloc] init];
            //2.将dic转换成对应的classType的record
            if ([record respondsToSelector:@selector(objectRepresentationWithDictionary:)]) {
                [record objectRepresentationWithDictionary:recordInfo];
                [recordList addObject:record];
            }
        }];
    }
    return recordList;
}

@end
