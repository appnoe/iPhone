//
//  UIViewController+SiteSchedule.h
//  SiteSchedule
//
//  Created by Clemens Wagner on 29.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SiteScheduleAppDelegate.h"

@interface UIViewController(SiteSchedule)

- (SiteScheduleAppDelegate *)applicationDelegate;
- (NSManagedObjectContext *)newManagedObjectContext;

@end
