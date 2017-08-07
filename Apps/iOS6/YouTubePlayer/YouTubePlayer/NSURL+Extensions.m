//
//  NSURL+Extensions.m
//  YouTubePlayer
//
//  Created by Clemens Wagner on 08.06.13.
//  Copyright (c) 2013 Clemens Wagner. All rights reserved.
//

#import "NSURL+Extensions.h"
#import "NSString+Extensions.h"

@implementation NSURL(Extensions)

- (NSDictionary *)queryParametersWithEncoding:(NSStringEncoding)inEncoding {
    NSMutableDictionary *theParameters = [NSMutableDictionary dictionary];
    NSArray *theTuples = [self.query componentsSeparatedByString:@"&"];
    
    for(NSString *theItem in theTuples) {
        NSArray *theTuple = [theItem componentsSeparatedByString:@"="];
        NSString *theKey = [theTuple[0] stringByReplacingPercentEscapesUsingEncoding:inEncoding];
        NSString *theValue = [theTuples count] < 2 ? @"" : [theTuple[1] stringByReplacingPercentEscapesUsingEncoding:inEncoding];
        NSArray *theValues = [theParameters objectForKey:theKey];

        if(theValues == nil) {
            theValues = @[theValue];
        }
        else {
            theValues = [theValues arrayByAddingObject:theValue];
        }
        [theParameters setValue:theValues forKey:theKey];
    }
    return [theParameters copy];
}

@end
