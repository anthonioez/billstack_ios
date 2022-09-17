//
//  GroupAddViewController.h
//  BillStack
//
//  Created by Anthonio Ez on 11/15/14.
//  Copyright (c) 2014 Unknown. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainViewDelegate.h"

@interface GroupAddViewController : UIViewController

@property (nonatomic,strong) id <MainViewDelegate> delegate;

@property (weak, nonatomic) IBOutlet UINavigationItem *navItem;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITextField *nameText;
@property (weak, nonatomic) IBOutlet UITextField *passText;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *saveIndicator;

- (BOOL) validate;

- (IBAction)onSave:(id)sender;
@end
