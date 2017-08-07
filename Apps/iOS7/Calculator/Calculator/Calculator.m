//
//  Calculator.m
//  Calculator
//
//  Created by Clemens Wagner on 25.03.14.
//  Copyright (c) 2014 Clemens Wagner. All rights reserved.
//

#import "Calculator.h"

@interface Calculator()

@property (nonatomic, strong) NSScanner *scanner;
@property (nonatomic, readwrite) NSInteger errorPosition;

@end

@implementation Calculator

- (double)calculateWithString:(NSString *)inString {
    NSScanner *theScanner = [NSScanner scannerWithString:inString];
    
    [theScanner setCharactersToBeSkipped:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    self.scanner = theScanner;
    return [self calculate];
}

- (double)calculate {
    double theResult = 0.0;
    
    if([self parseAddition:&theResult] && [self.scanner isAtEnd]) {
        self.errorPosition = -1;
    }
    else {
        self.errorPosition = self.scanner.scanLocation;
    }
    return theResult;
}

- (BOOL)parseAddition:(double *)outValue {
    if([self parseMultiplication:outValue]) {
        NSScanner *theScanner = self.scanner;
        NSCharacterSet *theSet = [NSCharacterSet characterSetWithCharactersInString:@"+-"];
        NSString *theOperator = nil;
        double theValue;
        
        while([theScanner scanCharactersFromSet:theSet intoString:&theOperator]) {
            if(theOperator.length == 1 && [self parseMultiplication:&theValue]) {
                if([theOperator isEqualToString:@"+"]) {
                    *outValue += theValue;
                }
                else {
                    *outValue -= theValue;
                }
            }
            else {
                return NO;
            }
        }
        return YES;
    }
    else {
        return NO;
    }
}

- (BOOL)parseMultiplication:(double *)outValue {
    if([self parseFactor:outValue]) {
        NSCharacterSet *theSet = [NSCharacterSet characterSetWithCharactersInString:@"*/"];
        NSScanner *theScanner = self.scanner;
        NSString *theOperator = nil;
        double theValue;

        while([theScanner scanCharactersFromSet:theSet intoString:&theOperator]) {
            if(theOperator.length == 1 && [self parseFactor:&theValue]) {
                if([theOperator isEqualToString:@"*"]) {
                    *outValue *= theValue;
                }
                else {
                    *outValue /= theValue;
                }
            }
            else {
                return NO;
            }
        }
        return YES;
    }
    else {
        return NO;
    }
}

- (BOOL)parseFactor:(double *)outValue {
    NSScanner *theScanner = self.scanner;

    if([theScanner scanDouble:outValue]) {
        return YES;
    }
    else if([theScanner scanString:@"-" intoString:NULL] && [self parseFactor:outValue]) {
        *outValue = -*outValue;
        return YES;
    }
    else if([theScanner scanString:@"(" intoString:NULL]) {
        return [self parseAddition:outValue] && [theScanner scanString:@")" intoString:NULL];
    }
    else {
        NSCharacterSet *theSet = [NSCharacterSet letterCharacterSet];
        NSString *theIdentifier = nil;

        if([theScanner scanCharactersFromSet:theSet intoString:&theIdentifier]) {
            id theValue = self.values[theIdentifier];
            
            if(theValue == nil) {
                theScanner.scanLocation -= theIdentifier.length;
                return NO;
            }
            else {
                *outValue = [theValue doubleValue];
                return YES;
            }
        }
    }
    return NO;
}

@end
