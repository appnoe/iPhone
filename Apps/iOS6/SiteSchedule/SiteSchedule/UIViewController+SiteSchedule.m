//
//  UIViewController+SiteSchedule.m
//  SiteSchedule
//
//  Created by Clemens Wagner on 29.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UIViewController+SiteSchedule.h"

@implementation UIViewController(SiteSchedule)

- (SiteScheduleAppDelegate *)applicationDelegate {
    return [[UIApplication sharedApplication] delegate];
}

- (NSManagedObjectContext *)newManagedObjectContext {
    NSManagedObjectContext *theContext = [[NSManagedObjectContext alloc] init];
    
    theContext.persistentStoreCoordinator = self.applicationDelegate.storeCoordinator;
    return theContext;
}

@end
