//
//  SiteScheduleParser.m
//  SiteSchedule
//
//  Created by Clemens Wagner on 29.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SiteScheduleParser.h"
#import "NSManagedObjectContext+Tools.h"

@interface SiteScheduleParser()

@property (nonatomic, strong, readwrite) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong, readwrite) NSError *error;

@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, strong) NSMutableString *text;
@property (nonatomic, strong) NSMutableArray *stack;

@end

@implementation SiteScheduleParser

@synthesize managedObjectContext;
@synthesize error;
@synthesize dateFormatter;
@synthesize text;
@synthesize stack;

- (id)initWithManagedObjectContext:(NSManagedObjectContext *)inContext {
    self = [super init];
    if(self) {
        self.managedObjectContext = inContext;
        self.text = [NSMutableString stringWithCapacity:1024];
        self.stack = [NSMutableArray arrayWithCapacity:20];
        self.dateFormatter = [[NSDateFormatter alloc] init];
        self.dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm";
        self.dateFormatter.locale = [NSLocale currentLocale];
    }
    return self;
}

- (void)push:(id)inObject {
    [self.stack addObject:inObject];
}

- (void)pop {
    [self.stack removeLastObject];
}

- (id)top {
    return [self.stack lastObject];
}

- (id)entityWithName:(NSString *)inEntityName element:(NSString *)inName 
          attributes:(NSDictionary *)inAttributes {
    id thePredecessor = [self top];
    id theEntity = [NSEntityDescription insertNewObjectForEntityForName:inEntityName
                                                 inManagedObjectContext:self.managedObjectContext];
    
    if([theEntity respondsToSelector:@selector(siteScheduleParser:didStartElement:withPredecessor:attributes:)]) {
        [theEntity siteScheduleParser:self didStartElement:inName
                      withPredecessor:thePredecessor
                           attributes:inAttributes];
    }
    [self.managedObjectContext insertObject:theEntity];
    [self push:theEntity];
    return theEntity;
}

- (id)entityNamed:(NSString *)inName withCode:(NSString *)inCode {
    NSFetchRequest *theRequest = [NSFetchRequest fetchRequestWithEntityName:inName];
    NSArray *theResult;
    NSError *theError = nil;
    
    theRequest.predicate = [NSPredicate predicateWithFormat:@"code = %@", inCode];
    theResult = [self.managedObjectContext executeFetchRequest:theRequest error:&theError];
    if(theError == nil && theResult.count > 0) {
        return theResult[0];
    }
    else {
        self.error = theError;
        return nil;
    }
}

- (id)activityWithAttributes:(NSDictionary *)inAttributes {
    return [self entityWithName:@"Activity" element:@"activity" attributes:inAttributes];
}

- (id)contactWithAttributes:(NSDictionary *)inAttributes {
    return [self entityWithName:@"Contact" element:@"contact" attributes:inAttributes];
}

- (id)siteWithAttributes:(NSDictionary *)inAttributes {
    Site *theSite = [self entityNamed:@"Site" withCode:[inAttributes valueForKey:@"code"]];
    
    if(theSite == nil) {
        theSite = [self entityWithName:@"Site" element:@"site" attributes:inAttributes];
    }
    else {
        [self push:theSite];
        [self.managedObjectContext deleteObjects:theSite.activities];
    }
    return theSite;
}

- (id)teamWithAttributes:(NSDictionary *)inAttributes {
    Team *theTeam = [self entityNamed:@"Team" withCode:[inAttributes valueForKey:@"code"]];
    
    if(theTeam == nil) {
        theTeam = [self entityWithName:@"Team" element:@"team" attributes:inAttributes];
    }
    else {
        [self push:theTeam];
        [self.managedObjectContext deleteObjects:theTeam.contacts];
    }
    return theTeam;
}

#pragma mark NSXMLParserDelegate

- (void)parserDidStartDocument:(NSXMLParser *)inParser {
    [self.stack removeAllObjects];
    [self.managedObjectContext reset];
    self.error = nil;
}

- (void)parserDidEndDocument:(NSXMLParser *)inParser {
    if(self.error == nil) {
        NSError *theError = nil;
        
        [self.managedObjectContext save:&theError];
        self.error = theError;
    }
    else {
        [self.managedObjectContext reset];
    }
}

- (void)parser:(NSXMLParser *)inParser parseErrorOccurred:(NSError *)inParseError {
    if(self.error == nil) {
        NSLog(@"line = %d, column = %d", inParser.lineNumber, inParser.columnNumber);
        self.error = inParseError;
    }
}

- (void)parser:(NSXMLParser *)inParser foundCharacters:(NSString *)inText {
    [self.text appendString:inText];
}

- (void)parser:(NSXMLParser *)inParser didStartElement:(NSString *)inName 
  namespaceURI:(NSString *)inNamespaceURI 
 qualifiedName:(NSString *)inQualifiedName 
    attributes:(NSDictionary *)inAttributes {
    NSString *theName = [NSString stringWithFormat:@"%@WithAttributes:", inName];
    SEL theSelector = NSSelectorFromString(theName);
    
    [self.text deleteCharactersInRange:NSMakeRange(0, self.text.length)];
    if([self respondsToSelector:theSelector]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [self performSelector:theSelector withObject:inAttributes];
#pragma clang diagnostic pop        
    }
    else {
        id theTop = self.top;
        
        if([theTop respondsToSelector:@selector(siteScheduleParser:didStartElement:attributes:)]) {
            [theTop siteScheduleParser:self didStartElement:inName attributes:inAttributes];
        }
    }
}

- (void)parser:(NSXMLParser *)inParser didEndElement:(NSString *)inName 
  namespaceURI:(NSString *)inNamespaceURI 
 qualifiedName:(NSString *)inQualifiedName {
    id theTop = self.top;
    
    if([theTop respondsToSelector:@selector(siteScheduleParser:didEndElement:)]) {
        [theTop siteScheduleParser:self didEndElement:inName];
    }
}

@end

@implementation Activity(SiteScheduleParser)

- (void)siteScheduleParser:(SiteScheduleParser *)inParser 
           didStartElement:(NSString *)inName
           withPredecessor:(id)inPredecessor
                attributes:(NSDictionary *)inAttributes {
    self.site = inPredecessor;
    self.start = [inParser.dateFormatter dateFromString:[inAttributes valueForKey:@"start"]];
    self.end = [inParser.dateFormatter dateFromString:[inAttributes valueForKey:@"end"]];
    self.team = [inParser entityNamed:@"Team" withCode:[inAttributes valueForKey:@"team"]];
}
                
- (void)siteScheduleParser:(SiteScheduleParser *)inParser 
             didEndElement:(NSString *)inName {
    if([inName isEqualToString:@"activity"]) {
        self.details = inParser.text;
        [inParser pop];
    }
}

@end

@implementation Contact(SiteScheduleParser)

- (void)siteScheduleParser:(SiteScheduleParser *)inParser 
           didStartElement:(NSString *)inName
           withPredecessor:(id)inPredecessor
                attributes:(NSDictionary *)inAttributes {
    self.team = inPredecessor;
    self.phone = inAttributes[@"phone"];
    self.isHead = [inAttributes[@"isHead"] isEqualToString:@"YES"];
}

- (void)siteScheduleParser:(SiteScheduleParser *)inParser 
             didEndElement:(NSString *)inName {
    if([inName isEqualToString:@"contact"]) {
        self.name = inParser.text;
        [inParser pop];
    }
}

@end

@implementation Site(SiteScheduleParser)

- (void)siteScheduleParser:(SiteScheduleParser *)inParser 
           didStartElement:(NSString *)inName
           withPredecessor:(id)inPredecessor
                attributes:(NSDictionary *)inAttributes {
    self.code = [inAttributes valueForKey:@"code"];
}

- (void)siteScheduleParser:(SiteScheduleParser *)inParser 
           didStartElement:(NSString *)inName
                attributes:(NSDictionary *)inAttributes {
    if([inName isEqualToString:@"city"]) {
        self.zip = [inAttributes valueForKey:@"zip"];
    }
}

- (void)siteScheduleParser:(SiteScheduleParser *)inParser 
             didEndElement:(NSString *)inName {
    BOOL theClearFlag = NO;
    
    if([inName isEqualToString:@"site"]) {
        [inParser pop];
    }
    else if([inName isEqualToString:@"name"]) {
        self.name = inParser.text;
    }
    else if([inName isEqualToString:@"street"]) {
        self.street = inParser.text;
        theClearFlag = YES;
    }
    else if([inName isEqualToString:@"city"]) {
        self.city = inParser.text;
        theClearFlag = YES;
    }
    else if([inName isEqualToString:@"countryCode"]) {
        self.countryCode = inParser.text;
        theClearFlag = YES;
    }
    if(theClearFlag) {
        self.latitude = nil;
        self.longitude = nil;
    }
}

@end

@implementation Team(SiteScheduleParser)

- (void)siteScheduleParser:(SiteScheduleParser *)inParser 
           didStartElement:(NSString *)inName
           withPredecessor:(id)inPredecessor
                attributes:(NSDictionary *)inAttributes {
    self.code = [inAttributes valueForKey:@"code"];
}

- (void)siteScheduleParser:(SiteScheduleParser *)inParser 
             didEndElement:(NSString *)inName {
    if([inName isEqualToString:@"team"]) {
        [inParser pop];
    }
    else if([inName isEqualToString:@"name"]) {
        self.name = inParser.text;
    }
}

@end