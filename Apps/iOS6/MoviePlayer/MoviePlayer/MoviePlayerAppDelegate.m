//
//  MoviePlayerAppDelegate.m
//  MoviePlayer
//
//  Created by Clemens Wagner on 09.06.13.
//  Copyright (c) 2013 Clemens Wagner. All rights reserved.
//

#import "MoviePlayerAppDelegate.h"
#import "UIViewController+MoviePlayer.h"

@implementation MoviePlayerAppDelegate

- (BOOL)application:(UIApplication *)inApplication didFinishLaunchingWithOptions:(NSDictionary *)inOptions {
    [[NSUserDefaults standardUserDefaults] registerDefaults:@{ kBookmarks : @[] }];
    return YES;
}

@end
