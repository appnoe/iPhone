//
//  NSManagedObjectContext+Tools.m
//  SiteSchedule
//
//  Created by Clemens Wagner on 30.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NSManagedObjectContext+Tools.h"

@implementation NSManagedObjectContext(Tools)

- (void)deleteObjects:(id<NSFastEnumeration>)inObjects {
    for(id theObject in inObjects) {
        [self deleteObject:theObject];
    }
}

@end
