//
//  PersistanceConfiguration.h
//  DongAoAcc
//
//  Created by wihan on 15/11/27.
//  Copyright © 2015年 wihan. All rights reserved.
//

#ifndef PersistanceConfiguration_h
#define PersistanceConfiguration_h

#import <Foundation/Foundation.h>

static NSString * kPersistanceErrorDomain = @"kPersistanceErrorDomain";

/**
 *  error code in CTPersistance
 */
typedef NS_ENUM(NSUInteger, PersistanceErrorCode){
    /**
     *  打开数据库错
     */
    PersistanceErrorCodeOpenError,
    /**
     *  创建数据库错
     */
    PersistanceErrorCodeCreateError,
    /**
     *  查询数据库错
     */
    PersistanceErrorCodeQueryStringError,
    /**
     *  不可用记录插入错
     */
    PersistanceErrorCodeRecordNotAvailableToInsert,
    /**
     *  不可用记录更新错
     */
    PersistanceErrorCodeRecordNotAvailableToUpdate,
    /**
     *  错误的key
     */
    PersistanceErrorCodeFailedToSetKeyForValue,
};

static NSString * kPersistanceErrorUserinfoKeyErrorRecord = @"kPersistanceErrorUserinfoKeyErrorRecord";

static NSString * kPersistanceVersionTableName = @"kPersistanceVersionTableName";
static NSString * kPersistanceInitVersion = @"kPersistanceInitVersion";

static NSInteger PersistanceNoLimit = -1;
static NSInteger PersistanceNoOffset = -1;

static NSString * kPersisatanceConfigurationFileName = @"PersistanceConfiguration";

#endif /* PersistanceConfiguration_h */
