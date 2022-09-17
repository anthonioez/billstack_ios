//
//  GroupViewController.h
//  BillStack
//
//  Created by Anthonio Ez on 12/3/14.
//  Copyright (c) 2014 Unknown. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataViewDelegate.h"

@interface GroupViewController : UIViewController<DataViewDelegate>

@property NSString *groupId;
@property NSString *groupTitle;

@property (nonatomic,strong) id<DataViewDelegate> delegate;
@property (weak, nonatomic) IBOutlet UINavigationBar *navBar;
@property (weak, nonatomic) IBOutlet UINavigationItem *navItem;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadIndicator;

- (IBAction)onAdd:(id)sender;
- (IBAction)onSub:(id)sender;
- (IBAction)onTotal:(id)sender;

- (IBAction)onLeave:(id)sender;
@end
