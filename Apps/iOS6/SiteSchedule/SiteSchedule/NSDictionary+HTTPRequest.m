//
//  NSDictionary+Extensions.m
//
//  Created by Clemens Wagner on 01.05.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "NSDictionary+HTTPRequest.h"
#import "NSDateFormatter+Extensions.h"
#import "NSString+URLTools.h"

@implementation NSDictionary(HTTPRequest)

+(id)dictionaryWithHeaderFieldsForURL:(NSURL *)inURL {
    NSDictionary *theResult = nil;

    if([@"http" isEqualToString:[inURL scheme]] || [@"https" isEqualToString:[inURL scheme]]) {
        NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:inURL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:3.0];
        NSURLResponse *theResponse = nil;
        NSError *theError = nil;
    
        [theRequest setHTTPMethod:@"HEAD"];
        [NSURLConnection sendSynchronousRequest:theRequest returningResponse:&theResponse error:&theError];
        if(theError == nil && [theResponse respondsToSelector:@selector(allHeaderFields)]) {            
            theResult = [(id)theResponse allHeaderFields];
        }
    }
    NSLog(@"dictionaryWithHeaderFieldsForURL:%@ -> %@", inURL, theResult);
    return theResult;
}

- (NSDate *)lastModified {
    NSString *theDate = self[@"Last-Modified"];
    
    return [NSDateFormatter dateForRFC1123String:theDate];
}

- (NSString *)contentType {
    return self[@"Content-Type"];
}

- (long long)contentLength {
    NSString *theLength = self[@"Content-Length"];
    
    return [theLength longLongValue];
}

- (HTTPContentRange)contentRange {
    NSString *theRange = [self valueForKey:@"Content-Range"];
    
    if(theRange == nil) {
        return HTTPContentRangeMakeFull(self.contentLength);
    }
    else {
        return HTTPContentRangeFromString(theRange);
    }
}

- (NSString *)parameterStringWithEncoding:(NSStringEncoding)inEncoding {
    NSMutableString *theParameters = [NSMutableString stringWithCapacity:256];
    NSString *theSeparator = @"";
    
    for(NSString *theName in self) {
        NSString *theEncodedName = [theName encodedStringForURLWithEncoding:inEncoding];
        id theValue = [self valueForKey:theName];
        
        if([theValue conformsToProtocol:@protocol(NSFastEnumeration)]) {
            for(id theCollectionValue in theValue) {
                NSString *theItem = [theCollectionValue description];
                
                [theParameters appendFormat:@"%@%@=%@",
                 theSeparator, theEncodedName,
                 [theItem encodedStringForURLWithEncoding:inEncoding]];
                theSeparator = @"&";
            }
        }
        else {
            theValue = [theValue description];
            [theParameters appendFormat:@"%@%@=%@",
             theSeparator, theEncodedName,
             [theValue encodedStringForURLWithEncoding:inEncoding]];            
            theSeparator = @"&";
        }
    }
    return [theParameters copy];
}

@end