//
//  NetworkTool.h
//  KoMovie
//
//  Created by hanwei on 15/6/17.
//  Copyright (c) 2015年 wihan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "URLResponse.h"

typedef void(^ResponseCallback)(URLResponse *response);

@interface NetworkTool : NSObject

+ (instancetype)sharedInstance;

- (NSInteger)callGETWithParams:(NSDictionary *)params serviceIdentifier:(NSString *)servieIdentifier methodName:(NSString *)methodName success:(ResponseCallback)success fail:(ResponseCallback)fail;
- (NSInteger)callPOSTWithParams:(NSDictionary *)params serviceIdentifier:(NSString *)servieIdentifier methodName:(NSString *)methodName success:(ResponseCallback)success fail:(ResponseCallback)fail;

- (NSInteger)callRestfulGETWithParams:(NSDictionary *)params serviceIdentifier:(NSString *)servieIdentifier methodName:(NSString *)methodName success:(ResponseCallback)success fail:(ResponseCallback)fail;
- (NSInteger)callRestfulPOSTWithParams:(NSDictionary *)params serviceIdentifier:(NSString *)servieIdentifier methodName:(NSString *)methodName success:(ResponseCallback)success fail:(ResponseCallback)fail;
- (NSInteger)callRestfulPUTWithParams:(NSDictionary *)params serviceIdentifier:(NSString *)servieIdentifier methodName:(NSString *)methodName success:(ResponseCallback)success fail:(ResponseCallback)fail;
- (NSInteger)uploadFileWithUrl: (NSString *)url
                    postParams: (NSDictionary *)postParams
                      oriImage: (UIImage *)oriImage
                       success: (ResponseCallback)success
                          fail: (ResponseCallback)fail;

- (void)cancelRequestWithRequestID:(NSNumber *)requestID;
- (void)cancelRequestWithRequestIDList:(NSArray *)requestIDList;

@end
