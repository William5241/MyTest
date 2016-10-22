//
//  AppDelegate.m
//  YiDing
//
//  Created by 韩伟 on 16/10/12.
//  Copyright © 2016年 韩伟. All rights reserved.
//

#import "AppDelegate.h"
#import "FirstEntryManager.h"
#import "CommonParameterTool.h"
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
#import "YDMobMenager.h"

@interface AppDelegate () <UNUserNotificationCenterDelegate>

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc]init];
    self.window.frame = [UIScreen mainScreen].bounds;
    
    //1.根据是否第一次计入，加载root
    [FirstEntryManager firstEnterHandle];
    //2.获取公网ip
    [[CommonParameterTool sharedInstance] getWANIpString];
    
    // 2.开启推送
    [self startNotificationCenter:launchOptions];
    
    // 注册友盟
    [YDMobMenager registerApp];
    
    [self.window makeKeyAndVisible];
    return YES;
}
// 开启推送通知
- (void)startNotificationCenter :(NSDictionary *)launchOptions {
    
    if(kSYSTEM_VERSION_LESS_THAN(@"10.0") == NO) {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert
                                                 | UNAuthorizationOptionBadge
                                                 | UNAuthorizationOptionSound)
                              completionHandler:^(BOOL granted, NSError * _Nullable error) {
                                  if (granted) {
                                      /// 点击允许.
                                      [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
                                          [[UIApplication sharedApplication] registerForRemoteNotifications];
                                      }];
                                  } else {
                                      /// 点击不允许.
                                  }
                              }];
    } else if(kSYSTEM_VERSION_LESS_THAN(@"8.0") == NO &&
              [[UIApplication sharedApplication] respondsToSelector:@selector(registerForRemoteNotifications)]) {
        UIUserNotificationSettings *settings =
        [UIUserNotificationSettings settingsForTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound |UIRemoteNotificationTypeAlert)
                                          categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    } else {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
         UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge];
    }
}

#pragma mark 推送处理
#ifdef __IPHONE_8_0
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    [application registerForRemoteNotifications];
}
#endif

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    NSMutableString *deviceTokenString = [[NSMutableString alloc] init];
    NSInteger length = [deviceToken length];
    const void *deviceBytes = [deviceToken bytes];
    for(NSInteger i = 0; i < length; i++)
    {
        [deviceTokenString appendFormat:@"%02.2hhx", ((char *)deviceBytes)[i]];
    }
    // 存储并发送给服务器
//    [AllinUserDefault  setObject:deviceTokenString forKey:NSLocalizedString(@"DeviceToken", )];
//    [AllinUserDefault  synchronize];
    
//    [PushManager sendDeviceToken:deviceTokenString];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
//    debugLog(@"Regist fail%@",error);
}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    if (userInfo != nil)
    {
//        [PushManager startHandleMessage:userInfo];
    }
}

#ifdef __IPHONE_10_0
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    /// 应用在前台收到通知.
    /// 如果需要在应用在前台也展示通知.
    /// completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert);
    UNNotificationRequest * request = notification.request;
    UNNotificationContent * content = request.content;
    NSDictionary * userInfo = [content userInfo];
    if (userInfo != nil)
    {
//        [PushManager startHandleMessage:userInfo];
    }
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    /// 点击通知进入应用.
    UNNotification * notification = response.notification;
    UNNotificationRequest * request = notification.request;
    UNNotificationContent * content = request.content;
    NSDictionary * userInfo = [content userInfo];
    if (userInfo != nil)
    {
//        [PushManager startHandleMessage:userInfo];
    }
}
#endif

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark – getters and setters
- (YDTabBarViewController *)tabBarViewController {
    
    if (_tabBarViewController == nil) {
        _tabBarViewController = [[YDTabBarViewController alloc] init];
    }
    return _tabBarViewController;
}

@end
