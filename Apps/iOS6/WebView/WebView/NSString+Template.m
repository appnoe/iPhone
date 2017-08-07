//
//  NSString+Template.m
//  WebView
//
//  Created by Clemens Wagner on 27.04.13.
//  Copyright (c) 2013 Clemens Wagner. All rights reserved.
//

#import "NSString+Template.h"

@implementation NSString(Template)

static NSString * const kStartToken = @"${";
static NSString * const kEndToken = @"}$";

- (NSString *)stringWithValuesOfObject:(id)inObject {
    NSScanner *theScanner = [NSScanner scannerWithString:self];
    NSMutableString *theResult = [NSMutableString string];
    NSString *theString = nil;

    if([theScanner scanUpToString:kStartToken intoString:&theString]) {
        [theResult appendString:theString];
    }
    while([theScanner scanString:kStartToken intoString:NULL]) {
        if([theScanner scanUpToString:kEndToken intoString:&theString]) {
            if([theScanner scanString:kEndToken intoString:NULL]) {
                id theValue = [inObject valueForKey:theString];

                theString = theValue == nil ? @"" : [theValue description];
            }
            [theResult appendString:theString];
        }
        if([theScanner scanUpToString:kStartToken intoString:&theString]) {
            [theResult appendString:theString];
        }
    }
    return [theResult copy];
}

- (NSString *)stringByEscapingSpecialXMLCharacters {
    NSMutableString *theResult = [NSMutableString string];
    NSUInteger theLength = [self length];

    for(NSUInteger i = 0; i < theLength; ++i) {
        unichar theCharacter = [self characterAtIndex:i];

        switch (theCharacter) {
            case '&':
                [theResult appendString:@"&amp;"];
                break;
            case '<':
                [theResult appendString:@"&lt;"];
                break;
            case '>':
                [theResult appendString:@"&gt;"];
                break;
            case '\'':
                [theResult appendString:@"&apos;"];
                break;
            case '"':
                [theResult appendString:@"&quot;"];
                break;
            default:
                [theResult appendFormat:@"%C", theCharacter];
                break;
        }
    }
    return [theResult copy];
}

@end
