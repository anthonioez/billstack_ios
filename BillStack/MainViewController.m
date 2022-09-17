//
//  MainViewController.m
//  BillStack
//
//  Created by Anthonio Ez on 11/15/14.
//  Copyright (c) 2014 Unknown. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewCell.h"
#import "MainViewController.h"
#import "GroupViewController.h"
#import "GroupAddViewController.h"
#import "GroupJoinViewController.h"

@interface MainViewController ()
{
    NSString* cellIdentifier;
    NSMutableArray* groups;
}
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStylePlain target:self action:@selector(onLogout:)];
    self.navItem.leftBarButtonItem = backButtonItem;
    
    [self.toolBar setClipsToBounds: YES];
    [self.navBar setBackIndicatorImage:[UIImage new]];
    [self.navBar setShadowImage: [UIImage new]];
    [self.navBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navBar.shadowImage = [UIImage new];
    self.navBar.translucent = YES;
    
    groups = [NSMutableArray new];
    
    cellIdentifier = @"MainViewCell";
    [self.dataTable registerNib:[UINib nibWithNibName:cellIdentifier bundle:nil] forCellReuseIdentifier:cellIdentifier];

    [self.dataTable setDataSource:self];
    [self.dataTable setDelegate:self];
    
    [self reload];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)onRefresh:(id)sender
{
    [self reload];
}

- (IBAction)onJoin:(id)sender
{
    GroupJoinViewController *joinController = [[GroupJoinViewController alloc] initWithNibName:@"GroupJoinViewController" bundle:nil];
    joinController.delegate = self;
    [[AppDelegate rootController] pushViewController: joinController animated:YES];
}

- (IBAction)onAdd:(id)sender
{
    GroupAddViewController *addController = [[GroupAddViewController alloc] initWithNibName:@"GroupAddViewController" bundle:nil];
    addController.delegate = self;
    [[AppDelegate rootController] pushViewController: addController animated:YES];
}

- (IBAction)onLogout:(id)sender
{
    [Settings setActive:NO];
    
    [[AppDelegate rootController] popViewControllerAnimated:YES];
}

#pragma mark - UITableView Data Source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [groups count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    
    
    MainViewCell *cell = (MainViewCell *)[self.dataTable dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell != nil)
    {
        PFObject *object = [groups objectAtIndex:row];
        if(object)
        {
            cell.titleLabel.text = object[@"name"];
        }
        return cell;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PFObject *object = [groups objectAtIndex:indexPath.row];
    if(object)
    {
//        DataViewController *dataController = [[DataViewController alloc] initWithNibName:@"DataViewController" bundle:nil];
        GroupViewController *dataController = [[GroupViewController alloc] initWithNibName:@"GroupViewController" bundle:nil];
        dataController.groupId = object.objectId;
        dataController.groupTitle = object[@"name"];
        dataController.delegate = self;
        [[AppDelegate rootController] pushViewController: dataController animated:YES];
    }
}

#pragma mark - GroupAddViewDelegate
-(void) groupCreated
{
    [self reload];
}

-(void) groupJoined
{
    [self reload];
}

-(void) groupLeft
{
    [self reload];
}

- (void) reload
{
    [self.loadIndicator startAnimating];
    PFQuery *qgroup = [PFQuery queryWithClassName:@"groups"];
    [qgroup whereKey:@"user" equalTo: [PFObject objectWithoutDataWithClassName:@"User" objectId:[Settings getUserID]]];
    [qgroup includeKey:@"user"];

    [qgroup findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
     {
         [groups removeAllObjects];
         
         if (!error)
         {
             for (PFObject *object in objects)
             {
                 if(object)
                 {
                     [groups addObject:object];
                 }
             }        
         }
         else
         {
             NSLog(@"Error: %@ %@", error, [error userInfo]);
         }
         
         PFQuery *qlist = [PFQuery queryWithClassName:@"groups_list"];
         [qlist whereKey:@"user" equalTo: [PFObject objectWithoutDataWithClassName:@"User" objectId:[Settings getUserID]]];
         [qlist includeKey:@"group"];
         [qlist includeKey:@"user"];
         
         [qlist findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
          {
              [self.loadIndicator stopAnimating];
              
              if (!error)
              {
                  for (PFObject *object in objects)
                  {
                      PFObject *grp = object[@"group"];
                      if(grp)
                      {
                          [groups addObject:grp];
                      }
                  }
              }
              else
              {
                  NSLog(@"Error: %@ %@", error, [error userInfo]);
              }
              
              [self.dataTable reloadData];
          }];         
     }];
}


@end
