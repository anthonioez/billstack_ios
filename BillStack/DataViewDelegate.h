//
//  DataViewDelegate.h
//  BillStack
//
//  Created by Anthonio Ez on 11/15/14.
//  Copyright (c) 2014 Unknown. All rights reserved.
//


@protocol DataViewDelegate <NSObject>

@optional
- (void) groupLeft;
- (void) dataAdded;

@end