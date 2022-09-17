//
//  DataAddViewController.m
//  BillStack
//
//  Created by Anthonio Ez on 11/15/14.
//  Copyright (c) 2014 Unknown. All rights reserved.
//

#import "AppDelegate.h"
#import "DataAddViewController.h"

@interface DataAddViewController ()
{
    UITapGestureRecognizer *tapGesture;
    
    NSString *title;
    NSString *amount;
    
}
@end

@implementation DataAddViewController

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.bgImage setImage: [UIImage imageNamed: (self.sign ? @"rich.png" : @"poor.png")]];
    
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(onClose:)];
    self.navItem.leftBarButtonItem = backButtonItem;
    self.navItem.title = (self.sign ? @"Add" : @"Subtract");
    
//    self.titleText.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0);
//    self.amountText.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0);
    
    [self.titleText addTarget:self  action:@selector(validate) forControlEvents:UIControlEventEditingDidEndOnExit];
    [self.amountText addTarget:self action:@selector(onAdd:) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    tapGesture.cancelsTouchesInView = NO;
    
    [self.titleText setText:@""];
    [self.amountText setText:@""];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.view addGestureRecognizer:tapGesture];
 }

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.view removeGestureRecognizer:tapGesture];
   
}

-(void)hideKeyboard
{
    [self.titleText resignFirstResponder];
    [self.amountText resignFirstResponder];
}

-(BOOL) validate
{
    return [self onValidate:NO];
}

-(BOOL) onValidate:(BOOL)valid
{
    title    = [self.titleText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    amount    = [self.amountText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if ([title length] < 4)
    {
        if([self.titleText isFirstResponder] || valid)
        {
            [Utils message:@"Expense" : @"Please enter a valid expense title (minimum of 4 characters)!"];
        }
        
        [self.titleText becomeFirstResponder];
        return false;
    }
    
    if ([amount length] < 2)
    {
        if([self.amountText isFirstResponder] || valid)
        {
            [Utils message:@"Expense" : @"Please enter a valid expense amount (minimum of 2 characters)!"];
        }
        
        [self.amountText becomeFirstResponder];
        return false;
    }
    
    return true;
}

- (void) addSuccess
{
    [self onClose:nil];
    
    [self.delegate dataAdded];
}

- (void) addError:(NSString *)error
{
    [self.addIndicator stopAnimating];
    
    [self.titleText setEnabled:YES];
    [self.amountText setEnabled:YES];
    
    [self.addButton setEnabled:YES];
    
    [Utils message:@"Expense" : error];
    
}

#pragma mark - Actions
- (IBAction)onClose:(id)sender
{
    [[AppDelegate rootController] popViewControllerAnimated:TRUE];
}

- (IBAction)onAdd:(id)sender {
    if(![self onValidate:YES])
    {
        return;
    }
    
    [self.addIndicator startAnimating];
    
    [self.titleText setEnabled:NO];
    [self.amountText setEnabled:NO];
    [self.addButton setEnabled:NO];
    
    PFObject *dataObject = [PFObject objectWithClassName:@"data"];
    dataObject[@"title"]       = title;
    dataObject[@"amount"]      = [NSNumber numberWithFloat: fabsf([amount floatValue]) * (self.sign ? 1 : -1)];
    dataObject[@"user"]        = [PFObject objectWithoutDataWithClassName:@"User" objectId:[Settings getUserID]];
    dataObject[@"group"]       = [PFObject objectWithoutDataWithClassName:@"groups" objectId: self.groupId];
    dataObject[@"status"]      = [NSNumber numberWithInt:1];
    
//    [dataObject saveEventually:^(BOOL succeeded, NSError *error)
    [dataObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
    {
        if (!error)
        {
            [self addSuccess];
        }
        else
        {
            NSString *errorString = [error userInfo][@"error"];
            
            [self addError:errorString];
        }
    }];
}
@end
