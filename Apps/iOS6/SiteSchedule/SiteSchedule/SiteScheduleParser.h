//
//  SiteScheduleParser.h
//  SiteSchedule
//
//  Created by Clemens Wagner on 29.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Model.h"

@interface SiteScheduleParser : NSObject<NSXMLParserDelegate>

@property (nonatomic, strong, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong, readonly) NSError *error;

- (id)initWithManagedObjectContext:(NSManagedObjectContext *)inContext;

@end

@protocol SiteScheduleParseable<NSObject>

@optional

- (void)siteScheduleParser:(SiteScheduleParser *)inParser
           didStartElement:(NSString *)inName
           withPredecessor:(id)inPredecessor
                attributes:(NSDictionary *)inAttributes;
- (void)siteScheduleParser:(SiteScheduleParser *)inParser
           didStartElement:(NSString *)inName
                attributes:(NSDictionary *)inAttributes;
- (void)siteScheduleParser:(SiteScheduleParser *)inParser 
             didEndElement:(NSString *)inName;

@end