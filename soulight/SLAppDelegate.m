//
//  SLAppDelegate.m
//  soulight
//
//  Created by Ming Z. on 14-5-17.
//  Copyright (c) 2014年 i0xbean. All rights reserved.
//

#import "SLAppDelegate.h"
#import "SLTextDataProvider.h"

#import <iflyMSC/IFlySpeechUser.h>

#import <DDTTYLogger.h>


@interface SLAppDelegate () 

@end

@implementation SLAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
//    [[SLTextDataProvider sharedInstance] debugAppendDataWithDays:5];
    
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    
    [[DDTTYLogger sharedInstance] setColorsEnabled:YES];
    [[DDTTYLogger sharedInstance] setForegroundColor:[UIColor blueColor] backgroundColor:nil forFlag:LOG_FLAG_INFO];
    
    DDLogError(@"Broken sprocket detected!");
    DDLogCWarn(@"fdsd");
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    
    self.homeVC = [[SLHomeViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:_homeVC];
    
    self.historyVC = [[SLHistoryViewController alloc] init];
    self.shareVC = [[SLShareViewController alloc] init];
    
    self.sideMenu=
    [[RESideMenu alloc] initWithContentViewController:nav
                               leftMenuViewController:_historyVC
                              rightMenuViewController:_shareVC];
    _sideMenu.backgroundImage = [UIImage imageNamed:@"bg.jpg"];
    _sideMenu.menuPreferredStatusBarStyle = 1; // UIStatusBarStyleLightContent
    _sideMenu.delegate = _homeVC;
    _sideMenu.contentViewShadowColor = [UIColor blackColor];
    _sideMenu.contentViewShadowOffset = CGSizeMake(0, 0);
    _sideMenu.contentViewShadowOpacity = 0.6;
    _sideMenu.contentViewShadowRadius = 12;
    _sideMenu.contentViewShadowEnabled = YES;
    
    self.window.rootViewController = _sideMenu;
    
    
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    [[SLTextDataProvider sharedInstance] save];
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
