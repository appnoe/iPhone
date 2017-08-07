//
//  HTTPContentRange.h
//  SiteSchedule
//
//  Created by Clemens Wagner on 07.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef struct _HTTPContentRange {
    NSRange range;
    NSUInteger size;
} HTTPContentRange;

NS_INLINE HTTPContentRange HTTPContentRangeMake(NSRange inRange, NSUInteger inSize) {
    HTTPContentRange theRange;
    
    theRange.range = inRange;
    theRange.size = inSize;
    return theRange;
}

NS_INLINE HTTPContentRange HTTPContentRangeMakeFull(NSUInteger inSize) {
    HTTPContentRange theRange;
    
    theRange.range = NSMakeRange(0, inSize);
    theRange.size = inSize;
    return theRange;
}

HTTPContentRange HTTPContentRangeFromString(NSString *inString);
NSString *NSStringFromHTTPContentRange(HTTPContentRange inRange);