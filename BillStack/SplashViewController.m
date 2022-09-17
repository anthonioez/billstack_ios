//
//  SplashViewController.m
//  BillStack
//
//  Created by Anthonio Ez on 6/11/14.
//  Copyright (c) 2014 Miciniti. All rights reserved.
//

#import "SplashViewController.h"
#import "AppDelegate.h"
#import "SignupViewController.h"
#import "LoginViewController.h"
#import "MainViewController.h"

@interface SplashViewController ()
{

}
@end

@implementation SplashViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
        [self.loginButton setHidden: YES];
        [self.signupButton setHidden: YES];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self performSelector:@selector(nextView) withObject:nil afterDelay:1.0];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    if([Settings getActive])
    {
        [self.loginButton setHidden: YES];
        [self.signupButton setHidden: YES];
    }
    else
    {
        [self.loginButton setHidden: NO];
        [self.signupButton setHidden: NO];
    }
}

- (void) nextView
{
    if([Settings getActive])
    {
        [self startApp];
    }
}

- (IBAction)onLogin:(id)sender
{
    LoginViewController *loginController = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    loginController.delegate = self;
    [[AppDelegate rootController] pushViewController: loginController animated:YES];
}

- (IBAction)onSignup:(id)sender
{
    SignupViewController *signupController = [[SignupViewController alloc] initWithNibName:@"SignupViewController" bundle:nil];
    signupController.delegate = self;
    [[AppDelegate rootController] pushViewController: signupController animated:YES];
}

- (void) loginSuccess
{
    [self startApp];
}

- (void) signupSuccess
{
    [self onLogin:nil];
}

- (void) startApp
{
    MainViewController *mainController = [[MainViewController alloc] initWithNibName:@"MainViewController" bundle:nil];
    [[AppDelegate rootController] pushViewController: mainController animated:YES];
}

@end
