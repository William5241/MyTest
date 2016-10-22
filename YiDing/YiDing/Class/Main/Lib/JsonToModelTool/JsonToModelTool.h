//
//  JsonToModelTool.h
//  Exam
//
//  Created by zhanghb on 15/8/8.
//  Copyright (c) 2015年 wihan. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface JsonToModelTool : NSObject
+ (NSString *)dictToJson:(NSDictionary *)dict;
+ (NSDictionary *)jsonToDict:(NSString *)json;
@end
