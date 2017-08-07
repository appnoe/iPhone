//
//  HTTPContentRange.m
//  SiteSchedule
//
//  Created by Clemens Wagner on 07.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HTTPContentRange.h"

HTTPContentRange HTTPContentRangeFromString(NSString *inString) {
    NSRange theRange = NSMakeRange(NSNotFound, 0);
    NSUInteger theEndPosition = 0;
    NSUInteger theSize = 0;
    const char *theString = [inString cStringUsingEncoding:NSISOLatin1StringEncoding];
    
    if(sscanf(theString, "bytes %u - %u / %u", &theRange.location, &theEndPosition, &theSize) == 3) {
        theRange.length = theEndPosition + 1 - theRange.location;
    }
    return HTTPContentRangeMake(theRange, theSize);
}

NSString *NSStringFromHTTPContentRange(HTTPContentRange inRange) {
    return [NSString stringWithFormat:@"bytes %u-%u/%u", inRange.range.location,
            inRange.range.location + inRange.range.length - 1, inRange.size];
}