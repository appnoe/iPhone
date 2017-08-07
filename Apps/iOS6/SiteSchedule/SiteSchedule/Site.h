//
//  Site.h
//  Shop
//
//  Created by Clemens Wagner on 29.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <CoreLocation/CoreLocation.h>

@interface Site : NSManagedObject

@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *street;
@property (nonatomic, copy) NSString *zip;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *countryCode;
@property (nonatomic, strong) NSSet *activities;
@property (nonatomic, strong) NSNumber *latitude;
@property (nonatomic, strong) NSNumber *longitude;

@property (nonatomic) CLLocationCoordinate2D coordinate;

- (NSDictionary *)address;
- (BOOL)hasCoordinates;

@end

@interface Site (CoreDataGeneratedAccessors)

- (void)addActivitiesObject:(NSManagedObject *)value;
- (void)removeActivitiesObject:(NSManagedObject *)value;
- (void)addActivities:(NSSet *)values;
- (void)removeActivities:(NSSet *)values;

@end
