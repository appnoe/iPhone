//
//  NSManagedObjectContext+Tools.h
//  SiteSchedule
//
//  Created by Clemens Wagner on 30.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObjectContext (Tools)

- (void)deleteObjects:(id<NSFastEnumeration>)inObjects;

@end
