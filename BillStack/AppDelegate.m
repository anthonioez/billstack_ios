//
//  AppDelegate.m
//  BillStack
//
//  Created by Anthonio Ez on 11/15/14.
//  Copyright (c) 2014 Unknown. All rights reserved.
//

#import "AppDelegate.h"
#import "SplashViewController.h"
#import "SignupViewController.h"
#import "LoginViewController.h"

static UINavigationController *rootNavController;

@interface AppDelegate ()

@end

@implementation AppDelegate

+ (UINavigationController*) rootController
{
    return rootNavController;
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    SplashViewController *splashController = [[SplashViewController alloc] initWithNibName:@"SplashViewController" bundle:nil];
    
    rootNavController = [[UINavigationController alloc] initWithRootViewController:splashController];
    rootNavController.navigationBarHidden = YES;
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
    self.window.backgroundColor = [UIColor blackColor];
    [self.window setRootViewController:rootNavController];
    [self.window makeKeyAndVisible];
    
    [Parse setApplicationId:@"cD05lHKSB96Qma11xH5P29NDJeLj6PaDp1NI6cBD" clientKey:@"HK7pc6UL2imGpF4BkAlqtumwrAiZUS2vKSphp4eF"];

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

@end
