//
//  LoginViewController.h
//  Streetwize Entertainment
//
//  Created by Anthonio Ez on 10/8/14.
//  Copyright (c) 2014 Miciniti. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SplashViewDelegate.h"


@interface LoginViewController : UIViewController

@property (weak, nonatomic) IBOutlet UINavigationItem *navItem;

@property (nonatomic,strong) id<SplashViewDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loginIndicator;
@property (weak, nonatomic) IBOutlet UITextField *userText;
@property (weak, nonatomic) IBOutlet UITextField *passText;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

- (BOOL) validate;

//- (BOOL) onValidate:(BOOL)valid;

- (IBAction)onLogin:(id)sender;
- (IBAction)onClose:(id)sender;

@end
