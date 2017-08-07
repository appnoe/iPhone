//
//  Annotation.m
//  SiteSchedule
//
//  Created by Clemens Wagner on 14.07.12.
//
//

#import "Annotation.h"

@interface Annotation()

@property (nonatomic, readwrite, strong) id objectId;
@property (nonatomic, readwrite) CLLocationCoordinate2D coordinate;
@property (nonatomic, readwrite, copy) NSString *title;
@property (nonatomic, readwrite, copy) NSString *subtitle;

@end

@implementation Annotation

@synthesize objectId;
@synthesize coordinate;
@synthesize title;
@synthesize subtitle;

- (id)initWithSite:(Site *)inSite {
    self = [super init];
    if(self) {
        self.objectId = inSite.objectID;
        self.coordinate = inSite.coordinate;
        self.title = inSite.name;
        self.subtitle = inSite.city;
    }
    return self;
}

@end
