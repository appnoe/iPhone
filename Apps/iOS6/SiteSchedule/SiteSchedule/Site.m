//
//  Site.m
//  Shop
//
//  Created by Clemens Wagner on 29.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Site.h"
#import <CoreLocation/CoreLocation.h>
#import <AddressBook/AddressBook.h>

@implementation Site

@dynamic code;
@dynamic name;
@dynamic street;
@dynamic zip;
@dynamic city;
@dynamic countryCode;
@dynamic activities;
@dynamic latitude;
@dynamic longitude;

- (CLLocationCoordinate2D)coordinate {
    return CLLocationCoordinate2DMake(self.latitude.doubleValue, self.longitude.doubleValue);
}

- (void)setCoordinate:(CLLocationCoordinate2D)inCoordinate {
    self.latitude = @(inCoordinate.latitude);
    self.longitude = @(inCoordinate.longitude);
}

- (NSDictionary *)address {
    return @{(id)kABPersonAddressZIPKey: self.zip,
            (id)kABPersonAddressCityKey: self.city,
            (id)kABPersonAddressCountryCodeKey: self.countryCode,
            (id)kABPersonAddressStreetKey: self.street};
}

- (BOOL)hasCoordinates {
    return self.latitude != nil && self.longitude != nil;
}

@end
