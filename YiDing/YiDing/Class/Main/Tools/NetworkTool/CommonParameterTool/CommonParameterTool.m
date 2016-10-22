//
//  CommonParameterTool.m
//  YiDing
//
//  Created by 韩伟 on 16/10/20.
//  Copyright © 2016年 韩伟. All rights reserved.
//

#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>
#import "CommonParameterTool.h"
#import "Reachability.h"
#import "sys/sysctl.h"
#import "sys/utsname.h"

@implementation CommonParameterTool

+ (instancetype)sharedInstance {
    
    static CommonParameterTool *commonParameterTool;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        commonParameterTool = [[CommonParameterTool alloc] init];
    });
    return commonParameterTool;
}

- (instancetype) init {
    
    if ( self = [super init] ) {
        _wanIpString = @"0.0.0.0";
    }
    return self;
}

- (NSString *)curNetStatus {
    
    Reachability *curReach = [Reachability reachabilityForInternetConnection];
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    
    switch (netStatus) {
        case NotReachable: {
            return @"";
        }
            break;
        case ReachableViaWWAN: {
            //7.0
            Class telephoneNetWorkClass = (NSClassFromString(@"CTTelephonyNetworkInfo"));
            if (telephoneNetWorkClass != nil) {
                CTTelephonyNetworkInfo *telephonyNetworkInfo = [[CTTelephonyNetworkInfo alloc] init];
                
                if ([telephonyNetworkInfo respondsToSelector:@selector(currentRadioAccessTechnology)]) {
                    NSString* wlanNetwork = telephonyNetworkInfo.currentRadioAccessTechnology;
                    
                    if (wlanNetwork == nil) {
                        return @"";
                    }
                    if([wlanNetwork isEqualToString:CTRadioAccessTechnologyGPRS] ||
                       [wlanNetwork isEqualToString:CTRadioAccessTechnologyEdge]) {
                        return @"2";//2g
                    }
                    else if([wlanNetwork isEqualToString:CTRadioAccessTechnologyWCDMA] ||
                            [wlanNetwork isEqualToString:CTRadioAccessTechnologyHSDPA] ||
                            [wlanNetwork isEqualToString:CTRadioAccessTechnologyHSUPA] ||
                            [wlanNetwork isEqualToString:CTRadioAccessTechnologyCDMA1x] ||
                            [wlanNetwork isEqualToString:CTRadioAccessTechnologyCDMAEVDORev0] ||
                            [wlanNetwork isEqualToString:CTRadioAccessTechnologyCDMAEVDORevA] ||
                            [wlanNetwork isEqualToString:CTRadioAccessTechnologyCDMAEVDORevB] ||
                            [wlanNetwork isEqualToString:CTRadioAccessTechnologyeHRPD]) {
                        return @"3";// 3g
                    }
                    else if([wlanNetwork isEqualToString:CTRadioAccessTechnologyLTE]) {
                        return @"4";// 4g
                    }
                }
            }
            return @"";
        }
            break;
        case ReachableViaWiFi: {
            return @"1";
        }
            break;
        default:
            break;
    }
    return @"";
}

- (NSString *)carrierCode {
    
    //判断是否能够取得运营商
    Class telephoneNetWorkClass = (NSClassFromString(@"CTTelephonyNetworkInfo"));
    if (telephoneNetWorkClass != nil) {
        CTTelephonyNetworkInfo *telephonyNetworkInfo = [[CTTelephonyNetworkInfo alloc] init];
        //获得运营商的信息
        Class carrierClass = (NSClassFromString(@"CTCarrier"));
        if (carrierClass != nil) {
            CTCarrier *carrier = telephonyNetworkInfo.subscriberCellularProvider;
            NSString * carrierName = [carrier carrierName];
            if ([carrierName isEqualToString:@"中国移动"]) {
                return @"1";
            }else if ([carrierName isEqualToString:@"中国电信"]) {
                return @"3";
            }else if ([carrierName isEqualToString:@"中国联通"]) {
                return @"2";
            }else{
                return @"";
            }
        }
    }
    return nil;
}

- (NSDictionary *)deviceWANIPAdress {
    
    //1.发起获取外网ip地址的请求
    NSError *error;
    NSURL *ipURL = [NSURL URLWithString:@"https://pv.sohu.com/cityjson?ie=utf-8"];
    NSMutableString *ip = [NSMutableString stringWithContentsOfURL:ipURL encoding:NSUTF8StringEncoding error:&error];
    //2.判断返回字符串是否为所需数据
    if ([ip hasPrefix:@"var returnCitySN = "]) {
        //2.1对字符串进行处理，然后进行json解析
        //2.2删除字符串多余字符串
        NSRange range = NSMakeRange(0, 19);
        [ip deleteCharactersInRange:range];
        NSString * nowIp =[ip substringToIndex:ip.length-1];
        //2.3将字符串转换成二进制进行Json解析
        NSData * data = [nowIp dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        return dict;
    }
    return nil;
}

- (void)getWANIpString {
    
    NSDictionary *ipDic = [self deviceWANIPAdress];
    if (ipDic && ipDic[@"cip"]) {
        self.wanIpString = ipDic[@"cip"];
    }
    else {
        self.wanIpString = @"0.0.0.0";
    }
}

- (NSString *)getDeviceHardwareString {
    
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone 2G (A1203)";
    if ([platform isEqualToString:@"iPhone1,2"]) return @"iPhone 3G (A1241/A1324)";
    if ([platform isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS (A1303/A1325)";
    if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone 4 (A1332)";
    if ([platform isEqualToString:@"iPhone3,2"]) return @"iPhone 4 (A1332)";
    if ([platform isEqualToString:@"iPhone3,3"]) return @"iPhone 4 (A1349)";
    if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4S (A1387/A1431)";
    if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5 (A1428)";
    if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5 (A1429/A1442)";
    if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone 5c (A1456/A1532)";
    if ([platform isEqualToString:@"iPhone5,4"]) return @"iPhone 5c (A1507/A1516/A1526/A1529)";
    if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone 5s (A1453/A1533)";
    if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5s (A1457/A1518/A1528/A1530)";
    if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus (A1522/A1524)";
    if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone 6 (A1549/A1586)";
    
    if ([platform isEqualToString:@"iPod1,1"])   return @"iPod Touch 1G (A1213)";
    if ([platform isEqualToString:@"iPod2,1"])   return @"iPod Touch 2G (A1288)";
    if ([platform isEqualToString:@"iPod3,1"])   return @"iPod Touch 3G (A1318)";
    if ([platform isEqualToString:@"iPod4,1"])   return @"iPod Touch 4G (A1367)";
    if ([platform isEqualToString:@"iPod5,1"])   return @"iPod Touch 5G (A1421/A1509)";
    
    if ([platform isEqualToString:@"iPad1,1"])   return @"iPad 1G (A1219/A1337)";
    
    if ([platform isEqualToString:@"iPad2,1"])   return @"iPad 2 (A1395)";
    if ([platform isEqualToString:@"iPad2,2"])   return @"iPad 2 (A1396)";
    if ([platform isEqualToString:@"iPad2,3"])   return @"iPad 2 (A1397)";
    if ([platform isEqualToString:@"iPad2,4"])   return @"iPad 2 (A1395+New Chip)";
    if ([platform isEqualToString:@"iPad2,5"])   return @"iPad Mini 1G (A1432)";
    if ([platform isEqualToString:@"iPad2,6"])   return @"iPad Mini 1G (A1454)";
    if ([platform isEqualToString:@"iPad2,7"])   return @"iPad Mini 1G (A1455)";
    
    if ([platform isEqualToString:@"iPad3,1"])   return @"iPad 3 (A1416)";
    if ([platform isEqualToString:@"iPad3,2"])   return @"iPad 3 (A1403)";
    if ([platform isEqualToString:@"iPad3,3"])   return @"iPad 3 (A1430)";
    if ([platform isEqualToString:@"iPad3,4"])   return @"iPad 4 (A1458)";
    if ([platform isEqualToString:@"iPad3,5"])   return @"iPad 4 (A1459)";
    if ([platform isEqualToString:@"iPad3,6"])   return @"iPad 4 (A1460)";
    
    if ([platform isEqualToString:@"iPad4,1"])   return @"iPad Air (A1474)";
    if ([platform isEqualToString:@"iPad4,2"])   return @"iPad Air (A1475)";
    if ([platform isEqualToString:@"iPad4,3"])   return @"iPad Air (A1476)";
    if ([platform isEqualToString:@"iPad4,4"])   return @"iPad Mini 2G (A1489)";
    if ([platform isEqualToString:@"iPad4,5"])   return @"iPad Mini 2G (A1490)";
    if ([platform isEqualToString:@"iPad4,6"])   return @"iPad Mini 2G (A1491)";
    
    if ([platform isEqualToString:@"i386"])      return @"iPhone Simulator";
    if ([platform isEqualToString:@"x86_64"])    return @"iPhone Simulator";
    return platform;
}

@end
