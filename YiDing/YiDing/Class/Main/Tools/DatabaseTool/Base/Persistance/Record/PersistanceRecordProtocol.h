//
//  PersistanceRecordProtocol.h
//  DongAoAcc
//
//  Created by wihan on 15/11/25.
//  Copyright © 2015年 wihan. All rights reserved.
//

#ifndef PersistanceRecordProtocol_h
#define PersistanceRecordProtocol_h

#import <Foundation/Foundation.h>

@class PersistanceTable;
@protocol PersistanceTableProtocol;

/**
 *  PersistanceTable将会把获取的数据转换成一个对象。这个对象必须遵守这个协议。也就是说只有遵循这个协议的对象才能存入表中。
 *
 *  @warning key的名字一定要和column的名字相同。
 */
@protocol PersistanceRecordProtocol <NSObject>

@required
/**
 *  根据表名和column信息，将record转化成dictionary
 *
 *  @warning record中的属性有可能多与表column的数量
 *
 *  @param table 遵循协议的表实例
 *
 *  @return 记录数据的dictionary
 */
- (NSDictionary *)dictionaryRepresentationWithTable:(PersistanceTable <PersistanceTableProtocol> *)table;

/**
 *  根据你的dic配置你的record
 *
 *  @param dictionary 从表中获取的dic数据
 */
- (void)objectRepresentationWithDictionary:(NSDictionary *)dictionary;

/**
 *  PersistanceTable可以通过这个方法设置data，即可以为业务层定义的record设置相应属性值，也可以用于merge record
 *
 *  @param value 获取的data
 *  @param key   key
 *
 *  @return return YES if success.
 */
- (BOOL)setPersistanceValue:(id)value forKey:(NSString *)key;

/**
 *  merge record
 *
 *  @param record merge的record
 *  @param shouldOverride if YES, 这个数据将会覆盖已有数据
 *
 *  @return 返回merge之后的数据
 */
- (NSObject <PersistanceRecordProtocol> *)mergeRecord:(NSObject <PersistanceRecordProtocol> *)record shouldOverride:(BOOL)shouldOverride;

@optional

/**
 *  如果你希望这个record可以被merge，那么这里应该返回所有可用的keys
 *
 *  @return 返回可用的key listlist.
 */
- (NSArray *)availableKeyList;

@end


#endif /* PersistanceRecordProtocol_h */
