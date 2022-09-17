//
//  MainViewController.h
//  BillStack
//
//  Created by Anthonio Ez on 11/15/14.
//  Copyright (c) 2014 Unknown. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainViewDelegate.h"
#import "DataViewDelegate.h"

@interface MainViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, MainViewDelegate, DataViewDelegate>

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadIndicator;
@property (weak, nonatomic) IBOutlet UITableView *dataTable;
@property (weak, nonatomic) IBOutlet UINavigationBar *navBar;
@property (weak, nonatomic) IBOutlet UINavigationItem *navItem;
@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;

- (IBAction)onRefresh:(id)sender;
- (IBAction)onAdd:(id)sender;
- (IBAction)onLogout:(id)sender;
- (IBAction)onJoin:(id)sender;

@end
