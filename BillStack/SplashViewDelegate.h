//
//  SplashViewDelegate.h
//  BillStack
//
//  Created by Anthonio Ez on 6/16/14.
//  Copyright (c) 2014 Miciniti. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SplashViewDelegate <NSObject>

@required
- (void) loginSuccess;
- (void) signupSuccess;


@end
