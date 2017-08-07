//
//  YouTubeAppDelegate.h
//  YouTubePlayer
//
//  Created by Clemens Wagner on 04.05.13.
//  Copyright (c) 2013 Clemens Wagner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"

@interface YouTubeAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong, readonly) Reachability *reachability;

@end
