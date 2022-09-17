//
//  LoginViewController.m
//  BillStack
//
//  Created by Anthonio Ez on 10/8/14.
//  Copyright (c) 2014 Miciniti. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "SignupViewController.h"
#import "Utils.h"

@interface LoginViewController ()
{
    UITapGestureRecognizer *tapGesture;
    NSString *username;
    NSString *password;
}
@end

@implementation LoginViewController

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(onClose:)];
    self.navItem.leftBarButtonItem = backButtonItem;
   
    self.userText.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0);
    self.passText.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0);
    
    [self.userText addTarget:self  action:@selector(validate) forControlEvents:UIControlEventEditingDidEndOnExit];
    [self.passText addTarget:self action:@selector(onLogin:) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    tapGesture.cancelsTouchesInView = NO;
    
    [self.userText setText: [Settings getUsername]];
    [self.passText setText:@""];   //TODO remove
    
    [self.userText setText:@"anthonioez"];
    [self.passText setText:@"billstack"];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.view addGestureRecognizer:tapGesture];
    [self.scrollView addGestureRecognizer:tapGesture];
   
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.view removeGestureRecognizer:tapGesture];
    [self.scrollView removeGestureRecognizer:tapGesture];

    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    [self.scrollView setContentOffset:CGPointZero animated:YES];
}

- (void)keyboardDidShow:(NSNotification *)notification
{
    NSDictionary* info = [notification userInfo];
    CGSize keyboardSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    CGRect visibleRect = self.scrollView.frame;

    CGPoint buttonOrigin = self.loginButton.frame.origin;
    buttonOrigin.y += self.loginButton.frame.size.height;
    buttonOrigin.y += visibleRect.origin.y;
    
    visibleRect.size.height -= keyboardSize.height;
    
    if (!CGRectContainsPoint(visibleRect, buttonOrigin))
    {
        CGPoint scrollPoint = CGPointMake(0.0, self.loginButton.frame.origin.y - visibleRect.size.height + self.loginButton.frame.size.height + 20);
        [self.scrollView setContentOffset:scrollPoint animated:YES];
    }
}

-(void)hideKeyboard
{
    [self.userText resignFirstResponder];
    [self.passText resignFirstResponder];
}


-(BOOL) validate
{
    return [self onValidate:NO];
}

-(BOOL) onValidate:(BOOL) valid
{
    username = [self.userText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    password = [self.passText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if ([username length] < 4)
    {
        if([self.userText isFirstResponder] || valid)
        {
            [Utils message:@"Login" : @"Please enter your username (minimum of 4 characters)!"];
        }
        [self.userText becomeFirstResponder];
        return false;
    }
    
    
    if ([password length] < 4)
    {
        if([self.passText isFirstResponder] || valid)
        {
            [Utils message:@"Login" : @"Please enter your password (minimum of 4 characters)!"];
        }
        
        [self.passText becomeFirstResponder];
        return false;
    }
    
    return true;
}

- (void) loginSuccess:(NSString *)userid
{
    [Settings setActive: YES];
    [Settings setUserID: userid];
    [Settings setUsername: username];
    [Settings setPassword: password];
    
    [self onClose:nil];

    [self.delegate loginSuccess];
}

- (void) loginError:(NSString *)error
{
    [self.loginIndicator stopAnimating];
    
    [self.passText setText:@""];
    
    [self.userText setEnabled:YES];
    [self.passText setEnabled:YES];
    [self.loginButton setEnabled:YES];
    
    [Utils message:@"Login" : error];
}

#pragma mark - Actions
- (IBAction)onClose:(id)sender
{
    [self.navigationController popViewControllerAnimated:NO];
}

- (IBAction)onLogin:(id)sender
{
    if(![self onValidate:YES])
    {
        return;
    }
    
    [self.loginIndicator startAnimating];
    
    [self.userText setEnabled:NO];
    [self.passText setEnabled:NO];
    [self.loginButton setEnabled:NO];


    [PFUser logInWithUsernameInBackground:username password: [Utils getSHA1:password]
        block:^(PFUser *user, NSError *error) {
            if (user)
            {
                [self loginSuccess:user.objectId];
            }
            else
            {
                NSString *errorString = [error userInfo][@"error"];
                
                [self loginError:errorString];
            }
        }];
}
@end

