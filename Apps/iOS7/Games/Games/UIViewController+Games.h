//
//  UIViewController+Games.h
//  Games
//
//  Created by Clemens Wagner on 19.08.13.
//  Copyright (c) 2013 Cocoaneheads. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GamesAppDelegate.h"

@interface UIViewController (Games)

- (GamesAppDelegate *)applicationDelegate;
- (NSManagedObjectContext *)managedObjectContext;
- (CMMotionManager *)motionManager;

@end
