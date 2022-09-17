//
//  Settings.m
//  vpn
//
//  Created by Anthonio Ez on 10/10/14.
//  Copyright (c) 2014 Miciniti. All rights reserved.
//

#import "Settings.h"

@implementation Settings

+ (void) setActive:(BOOL)lid
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSNumber numberWithBool:lid] forKey:SETTING_ACTIVE];
}

+ (BOOL) getActive
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSNumber *data = [defaults valueForKey:SETTING_ACTIVE];
    if(data == nil)
        return false;
    else
        return [data boolValue];
}

+ (void) setUsername:(NSString*)username
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:username forKey:SETTING_USERNAME];
}

+ (NSString*) getUsername
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    return [defaults valueForKey:SETTING_USERNAME];
}


+ (void) setUserID:(NSString*)userid
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject: userid forKey: SETTING_USERID];
}

+ (NSString*) getUserID
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    return [defaults valueForKey: SETTING_USERID];
}


+ (void) setPassword:(NSString*)password
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:password forKey:SETTING_PASSWORD];
}

+ (NSString*) getPassword
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    return [defaults valueForKey:SETTING_PASSWORD];
}
@end
