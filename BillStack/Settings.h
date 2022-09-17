//
//  Settings.h
//  Streetwize Entertainment
//
//  Created by Anthonio Ez on 10/10/14.
//  Copyright (c) 2014 Miciniti. All rights reserved.
//

#import <Foundation/Foundation.h>

#define SETTING_ACTIVE          @"active"
#define SETTING_USERID          @"userid"
#define SETTING_USERNAME        @"username"
#define SETTING_PASSWORD        @"password"

@interface Settings : NSObject

+ (void) setActive:(BOOL)lid;
+ (BOOL) getActive;

+ (void) setUserID:(NSString*)userid;
+ (NSString*) getUserID;

+ (void) setUsername:(NSString*)username;
+ (NSString*) getUsername;

+ (void) setPassword:(NSString*)password;
+ (NSString*) getPassword;

@end
