//
//  AppDelegate.m
//  Brush
//
//  Created by Jeff Merola on 9/23/12.
//  Copyright (c) 2012 SDD_Team. All rights reserved.
//

#import "BrushAppDelegate.h"

#define TESTING 1

@implementation BrushAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [TestFlight takeOff:@"f8ab3108d2a02bf989afc349c796fea2_MTM1NTUyMjAxMi0wOS0yNCAxMjoxNzoxMS44NjQ5NDY"];
#ifdef TESTING
    [TestFlight setDeviceIdentifier:[[UIDevice currentDevice] uniqueIdentifier]];
#endif
    
    // Initialize cocos2d director
    CCDirector *director = (CCDirector *)[CCDirector sharedDirector];
    director.wantsFullScreenLayout = NO;
    director.projection = kCCDirectorProjection2D;
    director.animationInterval = 1.0 / 60.0;
    director.displayStats = YES;
    [director enableRetinaDisplay:YES];
    
    return YES;
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

@end
