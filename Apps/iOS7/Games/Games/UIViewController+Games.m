//
//  UIViewController+Games.m
//  Games
//
//  Created by Clemens Wagner on 19.08.13.
//  Copyright (c) 2013 Cocoaneheads. All rights reserved.
//

#import "UIViewController+Games.h"

@implementation UIViewController(Games)

- (GamesAppDelegate *)applicationDelegate {
    return [[UIApplication sharedApplication] delegate];
}

- (NSManagedObjectContext *)managedObjectContext {
    return self.applicationDelegate.managedObjectContext;
}

- (CMMotionManager *)motionManager {
    return self.applicationDelegate.motionManager;
}

@end
