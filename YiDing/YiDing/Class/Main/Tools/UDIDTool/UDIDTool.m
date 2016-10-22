//
//  UDIDTool.m
//  Exam
//
//  Created by wihan on 15/7/16.
//  Copyright (c) 2015年 wihan. All rights reserved.
//

#import "UDIDTool.h"
#import <Security/Security.h>
#include <sys/socket.h>
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>

static const char kKeychainUDIDItemIdentifier[]  = "UUID";
static const char kKeychainUDIDAccessGroup[] =
"DD2RH94G6B.com.dongao.app.MainClient";

@implementation UDIDTool

#pragma mark – public function
+ (NSString*)UDID {
    
    NSString *udid = [UDIDTool getUDIDFromKeyChain];
    if (!udid) {
        NSString *sysVersion = [UIDevice currentDevice].systemVersion;
        CGFloat version = [sysVersion floatValue];
        
        if (version >= 7.0) {
            udid = [UDIDTool _UDID_iOS7];
        }
        else if (version >= 2.0) {
            udid = [UDIDTool _UDID_iOS6];
        }
        [UDIDTool settUDIDToKeyChain:udid];
    }
    return udid;
}

#pragma mark – private function
/**
 iOS 6.0 use wifi's mac address

 @return mac address
 */
+ (NSString*)_UDID_iOS6 {
    
    return [UDIDTool getMacAddress];
}

/**
 iOS 7.0 use udid
 
 @return udid
 */
+ (NSString*)_UDID_iOS7 {
    
    return [[UIDevice currentDevice].identifierForVendor UUIDString];
}

+ (NSString *)getMacAddress {
    
    int                 mgmtInfoBase[6];
    char                *msgBuffer = NULL;
    size_t              length;
    unsigned char       macAddress[6];
    struct if_msghdr    *interfaceMsgStruct;
    struct sockaddr_dl  *socketStruct;
    NSString            *errorFlag = nil;
    
    mgmtInfoBase[0] = CTL_NET;
    mgmtInfoBase[1] = AF_ROUTE;
    mgmtInfoBase[2] = 0;
    mgmtInfoBase[3] = AF_LINK;
    mgmtInfoBase[4] = NET_RT_IFLIST;
    
    if ((mgmtInfoBase[5] = if_nametoindex("en0")) == 0)
        errorFlag = @"if_nametoindex failure";
    else {
        if (sysctl(mgmtInfoBase, 6, NULL, &length, NULL, 0) < 0)
            errorFlag = @"sysctl mgmtInfoBase failure";
        else {
            if ((msgBuffer = malloc(length)) == NULL)
                errorFlag = @"buffer allocation failure";
            else {
                if (sysctl(mgmtInfoBase, 6, msgBuffer, &length, NULL, 0) < 0)
                    errorFlag = @"sysctl msgBuffer failure";
            }
        }
    }

    if (errorFlag != NULL) {
        MyLog(@"Error: %@", errorFlag);
        if (msgBuffer) {
            free(msgBuffer);
        }
        return errorFlag;
    }
    
    interfaceMsgStruct = (struct if_msghdr *) msgBuffer;
    
    socketStruct = (struct sockaddr_dl *) (interfaceMsgStruct + 1);

    memcpy(&macAddress, socketStruct->sdl_data + socketStruct->sdl_nlen, 6);
 
    NSString *macAddressString = [NSString stringWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X",
                                  macAddress[0], macAddress[1], macAddress[2],
                                  macAddress[3], macAddress[4], macAddress[5]];
    MyLog(@"Mac Address: %@", macAddressString);
    
    free(msgBuffer);
    
    return macAddressString;
}

+ (NSString*)getUDIDFromKeyChain {
    
    NSMutableDictionary *dictForQuery = [[NSMutableDictionary alloc] init];
    [dictForQuery setValue:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];
    
    [dictForQuery setValue:[NSString stringWithUTF8String:kKeychainUDIDItemIdentifier]
                    forKey:(__bridge id)kSecAttrDescription];
    
    NSData *keychainItemID = [NSData dataWithBytes:kKeychainUDIDItemIdentifier
                                            length:strlen(kKeychainUDIDItemIdentifier)];
    [dictForQuery setObject:keychainItemID forKey:(__bridge id)kSecAttrGeneric];
    
    NSString *accessGroup = [NSString stringWithUTF8String:kKeychainUDIDAccessGroup];
    if (accessGroup != nil) {
#if TARGET_IPHONE_SIMULATOR
        
#else
        [dictForQuery setObject:accessGroup forKey:(__bridge id)kSecAttrAccessGroup];
#endif
    }
    
    [dictForQuery setValue:(id)kCFBooleanTrue forKey:(__bridge id)kSecMatchCaseInsensitive];
    [dictForQuery setValue:(__bridge id)kSecMatchLimitOne forKey:(__bridge id)kSecMatchLimit];
    [dictForQuery setValue:(id)kCFBooleanTrue forKey:(__bridge id)kSecReturnData];
    
    OSStatus queryErr   = noErr;
    NSData   *udidValue = nil;
    NSString *udid      = nil;
    queryErr = SecItemCopyMatching((__bridge CFDictionaryRef)dictForQuery, (void *)&udidValue);
    
    NSMutableDictionary *dict = nil;
    [dictForQuery setValue:(id)kCFBooleanTrue forKey:(__bridge id)kSecReturnAttributes];
    queryErr = SecItemCopyMatching((__bridge CFDictionaryRef)dictForQuery, (void *)&dict);
    
    if (queryErr == errSecItemNotFound) {
        MyLog(@"KeyChain Item: %@ not found!!!", [NSString stringWithUTF8String:kKeychainUDIDItemIdentifier]);
    }
    else if (queryErr != errSecSuccess) {
        MyLog(@"KeyChain Item query Error!!! Error code:%d", (int)queryErr);
    }
    if (queryErr == errSecSuccess) {
        MyLog(@"KeyChain Item: %@", udidValue);
        
        if (udidValue) {
            udid = [NSString stringWithUTF8String:udidValue.bytes];
        }
    }

    return udid;
}

+ (BOOL)settUDIDToKeyChain:(NSString*)udid {
    
    NSMutableDictionary *dictForAdd = [[NSMutableDictionary alloc] init];
    
    [dictForAdd setValue:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];
    [dictForAdd setValue:[NSString stringWithUTF8String:kKeychainUDIDItemIdentifier] forKey:(__bridge NSString *)(kSecAttrDescription)];
    
    [dictForAdd setValue:@"UUID" forKey:(__bridge id)kSecAttrGeneric];
    
    [dictForAdd setObject:@"" forKey:(__bridge id)kSecAttrAccount];
    [dictForAdd setObject:@"" forKey:(__bridge id)kSecAttrLabel];
    
    NSString *accessGroup = [NSString stringWithUTF8String:kKeychainUDIDAccessGroup];
    if (accessGroup != nil) {
#if TARGET_IPHONE_SIMULATOR
        
#else
        [dictForAdd setObject:accessGroup forKey:(__bridge id)kSecAttrAccessGroup];
#endif
    }
    
    const char *udidStr = [udid UTF8String];
    NSData *keyChainItemValue = [NSData dataWithBytes:udidStr length:strlen(udidStr)];
    [dictForAdd setValue:keyChainItemValue forKey:(__bridge id)kSecValueData];
    
    OSStatus writeErr = noErr;
    if ([UDIDTool getUDIDFromKeyChain]) {
        [UDIDTool updateUDIDInKeyChain:udid];
        return YES;
    }
    else {
        writeErr = SecItemAdd((__bridge CFDictionaryRef)dictForAdd, NULL);
        if (writeErr != errSecSuccess) {
            MyLog(@"Add KeyChain Item Error!!! Error Code:%d", (int)writeErr);
            return NO;
        }
        else {
            MyLog(@"Add KeyChain Item Success!!!");
            return YES;
        }
    }

    return NO;
}

+ (BOOL)removeUDIDFromKeyChain {
    
    NSMutableDictionary *dictToDelete = [[NSMutableDictionary alloc] init];
    
    [dictToDelete setValue:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];
    
    NSData *keyChainItemID = [NSData dataWithBytes:kKeychainUDIDItemIdentifier length:strlen(kKeychainUDIDItemIdentifier)];
    [dictToDelete setValue:keyChainItemID forKey:(__bridge id)kSecAttrGeneric];
    
    OSStatus deleteErr = noErr;
    deleteErr = SecItemDelete((__bridge CFDictionaryRef)dictToDelete);
    if (deleteErr != errSecSuccess) {
        MyLog(@"delete UUID from KeyChain Error!!! Error code:%d", (int)deleteErr);
        return NO;
    }
    else {
        MyLog(@"delete success!!!");
    }

    return YES;
}

+ (BOOL)updateUDIDInKeyChain:(NSString*)newUDID {
    
    NSMutableDictionary *dictForQuery = [[NSMutableDictionary alloc] init];
    
    [dictForQuery setValue:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];
    
    NSData *keychainItemID = [NSData dataWithBytes:kKeychainUDIDItemIdentifier
                                            length:strlen(kKeychainUDIDItemIdentifier)];
    [dictForQuery setValue:keychainItemID forKey:(__bridge id)kSecAttrGeneric];
    [dictForQuery setValue:(id)kCFBooleanTrue forKey:(__bridge id)kSecMatchCaseInsensitive];
    [dictForQuery setValue:(__bridge id)kSecMatchLimitOne forKey:(__bridge id)kSecMatchLimit];
    [dictForQuery setValue:(id)kCFBooleanTrue forKey:(__bridge id)kSecReturnAttributes];
    
    NSDictionary *queryResult = nil;
    SecItemCopyMatching((__bridge CFDictionaryRef)dictForQuery, (void *)&queryResult);
    if (queryResult) {
        
        NSMutableDictionary *dictForUpdate = [[NSMutableDictionary alloc] init];
        [dictForUpdate setValue:[NSString stringWithUTF8String:kKeychainUDIDItemIdentifier] forKey:(__bridge NSString *)(kSecAttrDescription)];
        [dictForUpdate setValue:keychainItemID forKey:(__bridge id)kSecAttrGeneric];
        
        const char *udidStr = [newUDID UTF8String];
        NSData *keyChainItemValue = [NSData dataWithBytes:udidStr length:strlen(udidStr)];
        [dictForUpdate setValue:keyChainItemValue forKey:(__bridge id)kSecValueData];
        
        OSStatus updateErr = noErr;

        NSMutableDictionary *updateItem = [NSMutableDictionary dictionaryWithDictionary:queryResult];

        [updateItem setObject:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];
        
        updateErr = SecItemUpdate((__bridge CFDictionaryRef)updateItem, (__bridge CFDictionaryRef)dictForUpdate);
        if (updateErr != errSecSuccess) {
            MyLog(@"Update KeyChain Item Error!!! Error Code:%d", (int)updateErr);

            return NO;
        }
        else {
            MyLog(@"Update KeyChain Item Success!!!");

            return YES;
        }
    }

    return NO;
}

@end
