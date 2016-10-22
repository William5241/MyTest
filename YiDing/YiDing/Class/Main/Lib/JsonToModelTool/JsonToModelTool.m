//
//  JsonToModelTool.m
//  Exam
//
//  Created by zhanghb on 15/8/8.
//  Copyright (c) 2015年 wihan. All rights reserved.
//

#import "JsonToModelTool.h"

@implementation JsonToModelTool

+ (NSString *)dictToJson:(NSDictionary *)dict
{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&parseError];
    NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return jsonStr;
}

+ (NSDictionary *)jsonToDict:(NSString *)json
{
    NSData *jsonData = [json dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    return dict;
}

@end
