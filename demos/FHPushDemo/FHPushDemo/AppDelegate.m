#import "AppDelegate.h"
#import <FH/FH.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // when running under iOS 8 we will use the new API for APNS registration
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000
    if ([application respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        UIUserNotificationSettings* notificationSettings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:notificationSettings];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    } else {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes: (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    }
    
#else
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes: (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
#endif
    if (launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey]) {
        if ([launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey] isKindOfClass:[NSDictionary class]]) {
            NSLog(@"Was opened with notification:%@", launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey]);
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:[self pushMessageContent:launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey]] forKey:@"message_received"];
            [defaults synchronize];
        }
    }
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    [FH pushRegister:deviceToken AndSuccess:^(FHResponse *success) {
        NSLog(@"Unified Push registration successful");
    } AndFailure:^(FHResponse *failed) {
        NSLog(@"Unified Push registration Error: %@", failed.error);
    }];
    

}

// Callback called after failing to register with APNS
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"Unified Push registration Error: %@", error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    // When a message is received, send NSNotification, will be handle by registered AGViewController
    NSNotification *notification = [NSNotification notificationWithName:@"message_received" object:[self pushMessageContent:userInfo]];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    NSLog(@"UPS message received: %@", userInfo);
}

- (NSString*)pushMessageContent:(NSDictionary *)userInfo {
    NSString* content;
    if ([userInfo[@"aps"][@"alert"] isKindOfClass:[NSString class]]) {
        content = userInfo[@"aps"][@"alert"];
    } else {
        content = userInfo[@"aps"][@"alert"][@"body"];
    }
    return content;
}

@end
