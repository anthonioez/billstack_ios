//
//  DataViewCell.h
//  BillStack
//
//  Created by Anthonio Ez on 11/15/14.
//  Copyright (c) 2014 Unknown. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DataViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;

@end
