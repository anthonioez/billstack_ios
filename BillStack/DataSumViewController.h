//
//  DataSumViewController.h
//  BillStack
//
//  Created by Anthonio Ez on 11/15/14.
//  Copyright (c) 2014 Unknown. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataViewDelegate.h"

@interface DataSumViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate, DataViewDelegate>

@property NSString *groupId;
@property NSString *groupTitle;
@property NSIndexPath *selectedIndexPath;

@property (nonatomic,strong) id<DataViewDelegate> delegate;

@property (weak, nonatomic) IBOutlet UINavigationItem *navItem;
@property (weak, nonatomic) IBOutlet UITableView *dataTable;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadIndicator;
@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;
@property (weak, nonatomic) IBOutlet UIView *balanceView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *detailsBar;

- (IBAction)onDetails:(id)sender;

@end
