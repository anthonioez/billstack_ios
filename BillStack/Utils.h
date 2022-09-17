//
//  Utils.h
//  BillStack
//
//  Created by Anthonio Ez on 6/12/14.
//  Copyright (c) 2014 Miciniti. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import <SystemConfiguration/SystemConfiguration.h>

#import <CommonCrypto/CommonDigest.h>

@interface Utils : NSObject


+ (void) message:(NSString *)title :(NSString *)message;

+ (BOOL) isValidEmail:(NSString *)checkString;

+ (NSString*) getSHA1:(NSString*)input;

+ (NSString *) dateTimeFormat: (NSDate*) date;

@end
