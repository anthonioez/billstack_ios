//
//  DataAddViewController.h
//  BillStack
//
//  Created by Anthonio Ez on 11/15/14.
//  Copyright (c) 2014 Unknown. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataViewDelegate.h"

@interface DataAddViewController : UIViewController

@property BOOL sign;
@property NSString *groupId;
@property (nonatomic,strong) id<DataViewDelegate> delegate;

@property (weak, nonatomic) IBOutlet UINavigationItem *navItem;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *addIndicator;
@property (weak, nonatomic) IBOutlet UITextField *titleText;
@property (weak, nonatomic) IBOutlet UITextField *amountText;
@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (weak, nonatomic) IBOutlet UIImageView *bgImage;

- (IBAction)onAdd:(id)sender;
@end
