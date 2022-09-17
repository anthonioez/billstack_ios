//
//  DataSumViewController.m
//  BillStack
//
//  Created by Anthonio Ez on 11/15/14.
//  Copyright (c) 2014 Unknown. All rights reserved.
//

#import "AppDelegate.h"
#import "DataViewCell.h"
#import "DataSumViewController.h"
#import "DataAddViewController.h"
#import "DataItem.h"

@interface DataSumViewController ()
{
    NSMutableArray *data;
    NSString *cellIdentifier;
}
@end

@implementation DataSumViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(onClose:)];
    self.navItem.leftBarButtonItem = backButtonItem;
    self.navItem.title = self.groupTitle;
    
    data = [NSMutableArray new];
    
    cellIdentifier = @"DataViewCell";
    [self.dataTable registerNib:[UINib nibWithNibName:cellIdentifier bundle:nil] forCellReuseIdentifier:cellIdentifier];
    
    [self.dataTable setDataSource:self];
    [self.dataTable setDelegate:self];
    
    [self reload];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITableView Data Source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [data count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    
    
    DataViewCell *cell = (DataViewCell *)[self.dataTable dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell != nil)
    {
        DataItem *object = [data objectAtIndex:row];
        if(object)
        {
            [cell.titleLabel setText: object.title];
            [cell.amountLabel setText: [NSString stringWithFormat:@"%.02f", [object.amount floatValue]]];
            
            int count = (int)[self.dataTable numberOfRowsInSection:0];
            count--;
            if(row == count)
            {
                [cell.descLabel setText: (count == 0 ? @"No transactions" : [NSString stringWithFormat:@"%d transactions", count])];
            }
            else
            {
                [cell.descLabel setText: [Utils dateTimeFormat: object.timestamp]];
            }
        }
        return cell;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

#pragma mark - UITableViewDelegate
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

// cells are movable
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [data count] > 1;
}

// Swipe to delete.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        self.selectedIndexPath = indexPath;
        
        [self deleteConfirm];
    }
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1)
    {
        [self deleteEntry: self.selectedIndexPath];
    }
}

#pragma mark - Actions
- (IBAction)onClose:(id)sender
{
    [[AppDelegate rootController] popViewControllerAnimated:YES];
}

- (void) dataError:(NSString *)error
{
    [self.loadIndicator stopAnimating];
    
    [Utils message:@"Expenses" : error];
}

- (void) reload
{
    [self.loadIndicator startAnimating];
    PFQuery *query = [PFQuery queryWithClassName:@"data"];
    [query whereKey:@"group" equalTo: [PFObject objectWithoutDataWithClassName:@"groups" objectId: self.groupId]];
    [query includeKey:@"user"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
     {
         [self.loadIndicator stopAnimating];
         [data removeAllObjects];
         
         if (!error)
         {
             float total = 0;
             
             for (PFObject *object in objects)
             {
                 if(object)
                 {
                     float value = [object[@"amount"] floatValue];
                     total += value;
                     
                     DataItem *item = [DataItem new];
                     item.objectId = object.objectId;
                     item.title = object[@"title"];
                     item.amount = object[@"amount"];
                     item.timestamp = object.updatedAt;
                     
                     [data addObject: item];
                 }
             }
             
             DataItem *totalitem = [DataItem new];
             totalitem.objectId = nil;
             totalitem.title = @"Total";
             totalitem.amount = [NSNumber numberWithFloat: total];
             
             [data addObject: totalitem];
             
             [self.balanceLabel setText: [NSString stringWithFormat:@"%.02f", total]];
         }
         else
         {
             NSLog(@"Error: %@ %@", error, [error userInfo]);
             
             NSString *errorString = [error userInfo][@"error"];
             
             [self dataError:errorString];
         }
         
         [self.dataTable reloadData];
     }];
}

- (IBAction)onDetails:(id)sender
{
    if([self.balanceView isHidden])
    {
        [self.balanceView setHidden: NO];
        [self.dataTable setHidden: YES];
        
        [self.detailsBar setTitle: @"Details"];
    }
    else
    {
        [self.balanceView setHidden: YES];
        [self.dataTable setHidden: NO];

        [self.detailsBar setTitle: @"Balance"];
    }
}


#pragma mark - Functions
- (void) deleteConfirm
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [actionSheet addButtonWithTitle:@"Delete Transaction"];
    
    [actionSheet showInView:self.view];
}

- (void) deleteEntry:(NSIndexPath *)indexPath
{
    if(indexPath == nil) return;
    
    DataItem *item = [data objectAtIndex: indexPath.row];
    if(item)
    {
        [self.loadIndicator startAnimating];
        
        PFObject *dataObject = [PFObject objectWithoutDataWithClassName:@"data" objectId: item.objectId];
        [dataObject deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
        {
            [self.loadIndicator startAnimating];
            
            if (!error)
            {
                [data removeObjectAtIndex: indexPath.row];
                
                [self.dataTable deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
            }
            else
            {
                NSString *errorString = [error userInfo][@"error"];
                
                [Utils message:@"Transaction" : errorString];

            }
        }];
    }
    
    self.selectedIndexPath = nil;
}

- (void) addSuccess
{
    [self onClose:nil];
    
    [self.delegate dataAdded];
}

@end
