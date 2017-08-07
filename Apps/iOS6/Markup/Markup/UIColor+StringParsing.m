//
//  UIColor+StringParsing.m
//  Markup
//
//  Created by Clemens Wagner on 03.01.13.
//  Copyright (c) 2013 Clemens Wagner. All rights reserved.
//

#import "UIColor+StringParsing.h"

@implementation UIColor(StringParsing)

#pragma clang diagnostic ignored "-Warc-performSelector-leaks"

+ (UIColor *)colorWithString:(NSString *)inString {
    if(inString == nil) {
        return nil;
    }
    else {
        NSScanner *theScanner = [NSScanner scannerWithString:inString];
        UIColor *theColor = nil;

        if([theScanner scanString:@"#" intoString:NULL]) {
            unsigned theValue;

            if([theScanner scanHexInt:&theValue]) {
                CGFloat theComponents[3];

                for(int i = 0; i < 3; ++i) {
                    theComponents[i] = (theValue & 0xFF) / 255.0;
                    theValue >>= 8;
                }
                theColor = [self colorWithRed:theComponents[2]
                                        green:theComponents[1]
                                         blue:theComponents[0]
                                        alpha:1.0];
            }
        }
        else {
            NSString *theName = [NSString stringWithFormat:@"%@Color", inString];
            SEL theSelector = NSSelectorFromString(theName);

            if([self respondsToSelector:theSelector]) {
                theColor = [self performSelector:theSelector];
            }
        }
        return theColor;
    }
}

+ (id)oliveColor {
    return [UIColor colorWithRed:0.5 green:0.7 blue:0.2 alpha:1.0];
}

@end
