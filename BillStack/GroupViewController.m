//
//  GroupViewController.m
//  BillStack
//
//  Created by Anthonio Ez on 12/3/14.
//  Copyright (c) 2014 Unknown. All rights reserved.
//

#import "AppDelegate.h"
#import "GroupViewController.h"
#import "DataSumViewController.h"
#import "DataAddViewController.h"

@interface GroupViewController ()

@end

@implementation GroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(onClose:)];
    self.navItem.leftBarButtonItem = backButtonItem;
    self.navItem.title = self.groupTitle;
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Actions
- (IBAction)onClose:(id)sender
{
    [[AppDelegate rootController] popViewControllerAnimated:YES];
}


- (IBAction)onTotal:(id)sender
{
    DataSumViewController *dataController = [[DataSumViewController alloc] initWithNibName:@"DataSumViewController" bundle:nil];
    dataController.groupId = self.groupId;
    dataController.groupTitle = self.groupTitle;
    dataController.delegate = self;
    [[AppDelegate rootController] pushViewController: dataController animated:YES];
}

- (IBAction)onSub:(id)sender
{
    DataAddViewController *addController = [[DataAddViewController alloc] initWithNibName:@"DataAddViewController" bundle:nil];
    addController.delegate = self;
    addController.sign = false;
    addController.groupId = self.groupId;
    [[AppDelegate rootController] pushViewController: addController animated:YES];
}

- (IBAction)onAdd:(id)sender
{
    DataAddViewController *addController = [[DataAddViewController alloc] initWithNibName:@"DataAddViewController" bundle:nil];
    addController.delegate = self;
    addController.sign = true;
    addController.groupId = self.groupId;
    [[AppDelegate rootController] pushViewController: addController animated:YES];
}

- (IBAction)onLeave:(id)sender
{
    [self.loadIndicator startAnimating];
    
    PFQuery *query = [PFQuery queryWithClassName:@"groups_list"];
    [query whereKey:@"group" equalTo:[PFObject objectWithoutDataWithClassName:@"groups" objectId: self.groupId]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error)
        {
            BOOL found = false;
            for (PFObject *object in objects)
            {
                PFObject *user = object[@"user"];
                if(user)
                {
                    if([user.objectId isEqualToString:[Settings getUserID]])
                    {
                        found = YES;
                        [object deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
                         {
                             [self.loadIndicator stopAnimating];
                             
                             if (!error)
                             {
                                 [self dataLeft];
                             }
                             else
                             {
                                 NSString *errorString = [error userInfo][@"error"];
                                 
                                 [self dataError:errorString];
                             }
                         }];
                    }
                }
            }
            
            if(!found)
            {
                [self.loadIndicator stopAnimating];
                
                [self dataError: @"Group data not found!"];
            }
        }
        else
        {
            NSString *errorString = [error userInfo][@"error"];
            
            [self dataError:errorString];
        }
    }];
}


- (void) dataError:(NSString *)error
{
    [self.loadIndicator stopAnimating];
    
    [Utils message:@"Group" : error];
}

- (void) dataLeft
{
    [Utils message:@"Group" : @"You have successfully left the group!"];
    
    [self onClose:nil];
    
    [self.delegate groupLeft];
}
@end
