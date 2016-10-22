//
//  PersistanceRecord.m
//  DongAoAcc
//
//  Created by wihan on 15/11/25.
//  Copyright © 2015年 wihan. All rights reserved.
//

#import "PersistanceRecord.h"
#import "objc/runtime.h"
#import "NSString+SQL.h"
#import "PersistanceTable.h"

@implementation PersistanceRecord

#pragma mark - PersistanceRecordProtocol
- (NSDictionary *)dictionaryRepresentationWithTable:(PersistanceTable<PersistanceTableProtocol> *)table {
    
    unsigned int count = 0;
    //1.将当前对象的所有属性保存在properties中，并在count中保存属性个数
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    
    NSMutableDictionary *propertyList = [[NSMutableDictionary alloc] init];
    //2.遍历每一个属性，并以属性名为key，属性值为值保存到propertyList中，如果属性值为nil则保存为NSNull
    while (count --> 0) {
        NSString *key = [NSString stringWithUTF8String:property_getName(properties[count])];
        id value = [self valueForKey:key];
        if (value == nil) {
            propertyList[key] = [NSNull null];
        } else {
            propertyList[key] = value;
        }
    }
    free(properties);
    
    //3.遍历table.columnInfo，以columnName为key，从propertyList中找到对应的值，存入dictionaryRepresentation并返回；这里record中的属性的数量，有可能多与表的column数量
    NSMutableDictionary *dictionaryRepresentation = [[NSMutableDictionary alloc] init];
    [table.columnInfo enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull columnName, NSString * _Nonnull columnDescription, BOOL * _Nonnull stop) {
        if (propertyList[columnName]) {
            dictionaryRepresentation[columnName] = propertyList[columnName];
        }
    }];
    
    return dictionaryRepresentation;
}

- (void)objectRepresentationWithDictionary:(NSDictionary *)dictionary
{
    //将传入的dic，保存如record object中
    [dictionary enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSString * _Nonnull value, BOOL * _Nonnull stop) {
        [self setPersistanceValue:value forKey:key];
    }];
}

- (BOOL)setPersistanceValue:(id)value forKey:(NSString *)key
{
    BOOL result = YES;
    //1.拼出setter方法，如：key=“name”，则结果为setName
    NSString *setter = [NSString stringWithFormat:@"set%@%@:", [[key substringToIndex:1] capitalizedString], [key substringFromIndex:1]];
    //2.如果有这个setter（setName）方法
    if ([self respondsToSelector:NSSelectorFromString(setter)]) {
        //2.1如果是string，则先处理成sql string再保存
        if ([value isKindOfClass:[NSString class]]) {
            [self setValue:[value safeSQLDecode] forKey:key];
        //2.2如果是NSNull，则保存nil
        } else if ([value isKindOfClass:[NSNull class]]) {
            [self setValue:nil forKey:key];
        //2.3否则直接保存
        } else {
            [self setValue:value forKey:key];
        }
    } else {
        result = NO;
    }
    
    return result;
}

- (NSObject<PersistanceRecordProtocol> *)mergeRecord:(NSObject<PersistanceRecordProtocol> *)record shouldOverride:(BOOL)shouldOverride
{
    if ([self respondsToSelector:@selector(availableKeyList)]) {
        //1.获得自定义record的属性列表
        NSArray *availableKeyList = [self availableKeyList];
        [availableKeyList enumerateObjectsUsingBlock:^(NSString * _Nonnull key, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([record respondsToSelector:NSSelectorFromString(key)]) {
                id recordValue = [record valueForKey:key];
                //1.1如果覆盖，则保存这个值
                if (shouldOverride) {
                    [self setPersistanceValue:recordValue forKey:key];
                //1.2如果不覆盖，则判断是否有这个值，没有再保存
                } else {
                    id selfValue = [self valueForKey:key];
                    if (selfValue == nil) {
                        [self setPersistanceValue:recordValue forKey:key];
                    }
                }
            }
        }];
    }
    return self;
}

@end
