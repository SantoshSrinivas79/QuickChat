//
//  AppDelegate.m
//  QuickChat
//
//  Created by Taylor on 12/2/13.
//  Copyright (c) 2013 Taylor Beck. All rights reserved.
//

#import "AppDelegate.h"
#import <Parse/Parse.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [Parse setApplicationId:@"rq5UdInJk9NQf3DlxEmoaR9KZV3cdIYpnDQ03pev"
                  clientKey:@"uL5klT9lAcauLmdpxZ3MBh22giI6bOq2n8aUxulE"];
    
    //[application registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeSound];
    
    [self customizeUserInterface];
    
    return YES;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
   //[PFPush storeDeviceToken:deviceToken];
   //[PFPush subscribeToChannelInBackground:@""];
    
    //PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    //[currentInstallation setDeviceTokenFromData:deviceToken];
    //currentInstallation.channels = @[@"global"];
    //[currentInstallation saveInBackground];
    
   // NSLog(@"didRegisterForRemoteNotificationsWithDeviceToken");
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    //NSLog(@"Did fail to register for push, %@", error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
   // NSLog(@"Push Notification Received!");
   // [PFPush handlePush:userInfo];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


#pragma mark - Helper Methods

- (void)customizeUserInterface
{
    // Customize Navigation Bar
    //[[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:0.553 green:0.435 blue:0.718 alpha:1.0]];
    
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"backgroundLightOrange"] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance]setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, [UIFont fontWithName:@"Arial-Bold" size:40.0], NSFontAttributeName, nil]];
    [[UINavigationBar appearance]setTintColor:[UIColor whiteColor]];
    
    // Customize Tab Bar
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
    
    UITabBarController *tabBarController = (UITabBarController *)self.window.rootViewController;
    
    UITabBar *tabBar = tabBarController.tabBar;
    
    UITabBarItem *tabInbox = [tabBar.items objectAtIndex:0];
    UITabBarItem *tabCamera = [tabBar.items objectAtIndex:1];
    UITabBarItem *tabFriends = [tabBar.items objectAtIndex:2];
    
    
    [tabInbox setImage:[[UIImage imageNamed:@"inbox"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [tabCamera setImage:[[UIImage imageNamed:@"camera"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [tabFriends setImage:[[UIImage imageNamed:@"friends"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];  
}

@end