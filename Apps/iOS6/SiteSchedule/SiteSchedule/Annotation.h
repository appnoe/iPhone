//
//  Annotation.h
//  SiteSchedule
//
//  Created by Clemens Wagner on 14.07.12.
//
//

#import <MapKit/MapKit.h>
#import "Model.h"

@interface Annotation : NSObject<MKAnnotation>

- (id)initWithSite:(Site *)inSite;

@property (nonatomic, strong, readonly) id objectId;

@end
