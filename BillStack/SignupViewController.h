//
//  SignupViewController.h
//  BillStack
//
//  Created by Anthonio Ez on 10/8/14.
//  Copyright (c) 2014 Miciniti. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SplashViewDelegate.h"

@interface SignupViewController : UIViewController

@property (weak, nonatomic) IBOutlet UINavigationItem *navItem;

@property (nonatomic,strong) id<SplashViewDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *signupIndicator;
@property (weak, nonatomic) IBOutlet UITextField *emailText;
@property (weak, nonatomic) IBOutlet UITextField *userText;
@property (weak, nonatomic) IBOutlet UITextField *passText;
@property (weak, nonatomic) IBOutlet UIButton *signupButton;

- (BOOL) validate;

- (IBAction)onSignup:(id)sender;
- (IBAction)onClose:(id)sender;
@end
