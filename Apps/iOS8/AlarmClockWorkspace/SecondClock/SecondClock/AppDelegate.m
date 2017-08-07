//
//  AppDelegate.m
//  SecondClock
//
//  Created by Clemens Wagner on 19.08.14.
//  Copyright (c) 2014 Clemens Wagner. All rights reserved.
//

#import "AppDelegate.h"
#import "NSBundle+DynamicLoading.h"

#define USE_DYNAMIC_LOADING 0

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)inApplication didFinishLaunchingWithOptions:(NSDictionary *)inOptions {
#if USE_DYNAMIC_LOADING
    if([NSBundle allowsLoadingOfEmbeddedFrameworks]) {
        [NSBundle embeddedFrameworkWithName:@"AlarmClockFramework"];
    }
#endif
    NSLog(@"ClockView loaded: %d", NSClassFromString(@"ClockView") != NULL);
    return YES;
}

@end
