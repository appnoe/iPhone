//
//  Activity.h
//  Shop
//
//  Created by Clemens Wagner on 29.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Site, Team;

@interface Activity : NSManagedObject

@property (nonatomic, copy) NSString *details;
@property (nonatomic, strong) NSDate *start;
@property (nonatomic, strong) NSDate *end;
@property (nonatomic, strong) Site *site;
@property (nonatomic, strong) Team *team;

@end
