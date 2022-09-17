//
//  GroupJoinViewController.m
//  BillStack
//
//  Created by Anthonio Ez on 11/15/14.
//  Copyright (c) 2014 Unknown. All rights reserved.
//

#import "AppDelegate.h"
#import "GroupJoinViewController.h"

@interface GroupJoinViewController ()
{
    UITapGestureRecognizer *tapGesture;
    
    NSString *groupname;
    NSString *password;
}

@end

@implementation GroupJoinViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(onClose:)];
    self.navItem.leftBarButtonItem = backButtonItem;
    
    self.nameText.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0);
    self.passText.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0);
    
    [self.nameText addTarget:self  action:@selector(validate) forControlEvents:UIControlEventEditingDidEndOnExit];
    [self.passText addTarget:self action:@selector(onJoin:) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    tapGesture.cancelsTouchesInView = NO;
    
    [self.nameText setText:@""];
    [self.passText setText:@""];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    CGPoint buttonOrigin = self.joinButton.frame.origin;
    buttonOrigin.y += self.joinButton.frame.size.height;
    buttonOrigin.y += visibleRect.origin.y;
    
    visibleRect.size.height -= keyboardSize.height;
    
    if (!CGRectContainsPoint(visibleRect, buttonOrigin))
    {
        CGPoint scrollPoint = CGPointMake(0.0, self.joinButton.frame.origin.y - visibleRect.size.height + self.joinButton.frame.size.height + 20);
        [self.scrollView setContentOffset:scrollPoint animated:YES];
    }
}

-(void)hideKeyboard
{
    [self.nameText resignFirstResponder];
    [self.passText resignFirstResponder];
}

-(BOOL) validate
{
    return [self onValidate:NO];
}

-(BOOL) onValidate:(BOOL)valid
{
    groupname    = [self.nameText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    password    = [self.passText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if ([groupname length] < 4)
    {
        if([self.nameText isFirstResponder] || valid)
        {
            [Utils message:@"Group" : @"Please enter a valid group name (minimum of 4 characters)!"];
        }
        
        [self.nameText becomeFirstResponder];
        return false;
    }
    
    if ([password length] < 4)
    {
        if([self.passText isFirstResponder] || valid)
        {
            [Utils message:@"Group" : @"Please enter a valid group password (minimum of 4 characters)!"];
        }
        
        [self.passText becomeFirstResponder];
        return false;
    }
    
    return true;
}

- (void) joinSuccess
{
    [self onClose:nil];
    
    [self.delegate groupJoined];
}

- (void) joinError:(NSString *)error
{
    [self.joinIndicator stopAnimating];
    
    [self.passText setText:@""];
    
    [self.nameText setEnabled:YES];
    [self.passText setEnabled:YES];
    
    [self.joinButton setEnabled:YES];
    
    [Utils message:@"Group" : error];
    
}

#pragma mark - Actions
- (IBAction)onClose:(id)sender
{
    [[AppDelegate rootController] popViewControllerAnimated:TRUE];
}

- (IBAction)onJoin:(id)sender
{
    if(![self onValidate:YES])
    {
        return;
    }
    
    [self.joinIndicator startAnimating];
    
    [self.nameText setEnabled:NO];
    [self.passText setEnabled:NO];
    [self.joinButton setEnabled:NO];
    
    PFQuery *query = [PFQuery queryWithClassName:@"groups"];
    [query whereKey:@"name" equalTo:groupname];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error)
        {
            BOOL found = false;
            NSString *pass = [Utils getSHA1:password];
            for (PFObject *object in objects)
            {
                NSString *pwd = object[@"password"];
                if([pwd isEqualToString:pass])
                {
                    found = TRUE;
                    [self joinGroup:object.objectId];
                }
            }
            
            if(!found)
            {
                [self joinError: @"Incorrect group name or password!"];
            }
        }
        else
        {
            NSString *errorString = [error userInfo][@"error"];
            
            [self joinError:errorString];
        }
    }];
}

- (void) joinGroup:(NSString *)groupId
{
    PFObject *groupListObject = [PFObject objectWithClassName:@"groups_list"];
    groupListObject[@"user"]        = [PFObject objectWithoutDataWithClassName:@"User" objectId:[Settings getUserID]];
    groupListObject[@"group"]       = [PFObject objectWithoutDataWithClassName:@"groups" objectId:groupId];
    groupListObject[@"status"]      = [NSNumber numberWithInt:1];
    
    [groupListObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error)
        {
            [self joinSuccess];
        }
        else
        {
            NSString *errorString = [error userInfo][@"error"];
            
            [self joinError:errorString];
        }
    }];
}


@end
