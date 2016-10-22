//
//  YDFineCourseReformer.m
//  YiDing
//
//  Created by ALLIN on 16/10/18.
//  Copyright © 2016年 韩伟. All rights reserved.
//

#import "YDFineCourseReformer.h"
#import "APIBaseManager.h"
#import "YDFineCourseViewModel.h"
@interface YDFineCourseReformer ()

@property (nonatomic, copy, readwrite) NSString *serviceType;

@end
@implementation YDFineCourseReformer
#pragma mark - init
- (id)initWithSubType:(NSString *)serviceType {
    
    if (self = [super init]) {
        _serviceType = serviceType;
    }
    return self;
}

+ (id)initFineCourseReformer:(NSString *)serviceType {
    
    return [[self alloc] initWithSubType:serviceType];
}

#pragma mark - APIManagerCallbackDataReformer
- (id)manager:(APIBaseManager *)manager reformData:(NSDictionary *)data {
    
    if([self.serviceType isEqualToString:kServiceFineCourse]){
        if (data) {
            
            NSMutableDictionary *resultDic = [NSMutableDictionary new];
            resultDic[@"code"] = data[@"responseStatus"];

            if (data[@"body"]) {
                [resultDic addEntriesFromDictionary:data[@"body"]];
            }
            if ([data[@"responseData"] objectForKey:@"data_list"]) {
                NSArray *dataArray = [data[@"responseData"] objectForKey:@"data_list"];//resultDic[@"result"]
                NSMutableArray *array = [NSMutableArray array];
                for (NSDictionary *dict in dataArray) {
                    YDFineCourseViewModel *model = [[YDFineCourseViewModel alloc]init];
                    model.nameString =[NSString stringWithFormat:@"%@%@", [dict[@"publish_customer"] objectForKey:@"lastName"],[dict[@"publish_customer"] objectForKey:@"firstName"]];
                    model.titleString = [dict[@"case_baseinfo"] objectForKey:@"caseName"];
                    model.hospitalNameString = [dict[@"publish_customer"] objectForKey:@"company"];
                    model.categoryString = [dict[@"publish_customer"] objectForKey:@"areasExpertiseShow"];
                    model.pictureUrlString = [dict[@"publish_customer_logo"] objectForKey:@"logoUrl"];
                    [array addObject:model];
                }
                resultDic[@"result"] = array;
                
            }
            
            return resultDic;
        }
    }
    
    return nil;
}@end
