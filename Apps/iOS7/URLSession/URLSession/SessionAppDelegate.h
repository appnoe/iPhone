//
//  SessionAppDelegate.h
//  URLSession
//
//  Created by Clemens Wagner on 09.06.14.
//  Copyright (c) 2014 Clemens Wagner. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SessionAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

- (void)sessionEventsCompleted;

@end
