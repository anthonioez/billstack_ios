//
//  SignupViewController.m
//  BillStack
//
//  Created by Anthonio Ez on 10/8/14.
//  Copyright (c) 2014 Miciniti. All rights reserved.
//

#import "Settings.h"
#import "Utils.h"
#import "AppDelegate.h"
#import "SignupViewController.h"

@interface SignupViewController ()
{
    UITapGestureRecognizer *tapGesture;
    NSString *email;
    NSString *username;
    NSString *password;
}
@end

@implementation SignupViewController

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

    self.emailText.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0);
    self.userText.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0);
    self.passText.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0);
    
    [self.emailText addTarget:self  action:@selector(validate) forControlEvents:UIControlEventEditingDidEndOnExit];
    [self.userText addTarget:self  action:@selector(validate) forControlEvents:UIControlEventEditingDidEndOnExit];
    [self.passText addTarget:self action:@selector(onSignup:) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    tapGesture.cancelsTouchesInView = NO;
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
    
    CGPoint buttonOrigin = self.signupButton.frame.origin;
    buttonOrigin.y += self.signupButton.frame.size.height;
    buttonOrigin.y += visibleRect.origin.y;
    
    visibleRect.size.height -= keyboardSize.height;
    
    if (!CGRectContainsPoint(visibleRect, buttonOrigin))
    {
        CGPoint scrollPoint = CGPointMake(0.0, self.signupButton.frame.origin.y - visibleRect.size.height + self.signupButton.frame.size.height + 20);
        [self.scrollView setContentOffset:scrollPoint animated:YES];
    }
}

-(void)hideKeyboard
{
    [self.emailText resignFirstResponder];
    [self.userText resignFirstResponder];
    [self.passText resignFirstResponder];
}

-(BOOL) validate
{
    return [self onValidate:NO];
}

-(BOOL) onValidate:(BOOL)valid
{
    email       = [self.emailText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    username    = [self.userText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    password    = [self.passText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if ([email length] < 4 || ![Utils isValidEmail:email])
    {
        if([self.emailText isFirstResponder] || valid)
        {
            [Utils message:@"Signup" :@"Please enter a valid email address!"];
        }
        [self.emailText becomeFirstResponder];
        return false;
    }
        
    if ([username length] < 4)
    {
        if([self.userText isFirstResponder] || valid)
        {
            [Utils message:@"Signup" : @"Please enter a valid username (minimum of 4 characters)!"];
        }
        
        [self.userText becomeFirstResponder];
        return false;
    }
    
    if ([password length] < 4)
    {
        if([self.passText isFirstResponder] || valid)
        {
            [Utils message:@"Signup" : @"Please enter a valid password (minimum of 4 characters)!"];
        }
        
        [self.passText becomeFirstResponder];
        return false;
    }
    
    return true;
}

- (void) signupSuccess
{
    [Settings setPassword:@""];
    [Settings setUsername:username];
    
    [self onClose:nil];
    
    [self.delegate signupSuccess];
}

- (void) signupError:(NSString *)error
{
    [self.signupIndicator stopAnimating];
    
    [self.userText setText:@""];
    
    [self.userText setEnabled:YES];
    [self.passText setEnabled:YES];

    [self.signupButton setEnabled:YES];
    
    [Utils message:@"Signup" : error];
    
}

#pragma mark - Actions
- (IBAction)onClose:(id)sender
{
    [[AppDelegate rootController] popViewControllerAnimated:NO];
}

- (IBAction)onSignup:(id)sender
{
    if(![self onValidate:YES])
    {
        return;
    }
    
    [self.signupIndicator startAnimating];
    
    [self.userText setEnabled:NO];
    [self.passText setEnabled:NO];
    [self.signupButton setEnabled:NO];
    
    
    PFUser *user = [PFUser user];
    user.username   = username;
    user.password   = [Utils getSHA1:password];
    user.email      = email;
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error)
        {
            [self signupSuccess];
        }
        else
        {
            NSString *errorString = [error userInfo][@"error"];
        
            [self signupError:errorString];
        }
    }];
}

@end
