//
//  DataItem.h
//  BillStack
//
//  Created by Anthonio Ez on 12/3/14.
//  Copyright (c) 2014 Unknown. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataItem : NSObject

@property NSString *objectId;
@property NSString *title;
@property NSNumber *amount;
@property NSDate *timestamp;

@end
