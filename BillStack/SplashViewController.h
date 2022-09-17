//
//  SplashViewController.h
//  BillStack
//
//  Created by Anthonio Ez on 6/11/14.
//  Copyright (c) 2014 Miciniti. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SplashViewDelegate.h"

@interface SplashViewController : UIViewController<SplashViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *signupButton;

- (IBAction)onLogin:(id)sender;
- (IBAction)onSignup:(id)sender;
@end
