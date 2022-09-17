//
//  AppDelegate.h
//  BillStack
//
//  Created by Anthonio Ez on 11/15/14.
//  Copyright (c) 2014 Unknown. All rights reserved.
//

//username: justin.depalma@me.com Password: Billstacker101

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

#import "Utils.h"
#import "Settings.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;


+ (UINavigationController*) rootController;

@end

