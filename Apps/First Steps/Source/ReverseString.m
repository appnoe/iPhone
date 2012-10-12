//
//  ReverseString.m
//  First Steps
//
//  Created by Klaus M. Rodewig on 17.01.11.
//  Copyright 2011 Klaus M. Rodewig. All rights reserved.
//

#import "ReverseString.h"


@implementation NSString (ReverseString)

-(NSString*)reverse{
    NSLog(@"[+] revert: %@", self);    
    NSMutableString *theReverse = [NSMutableString stringWithCapacity:[self length]];

    for(int i = [self length]-1; i>=0; i--){
        [theReverse appendFormat:@"%C", [self characterAtIndex:i]];
    }
    NSLog(@"[+] the reverse: %@", theReverse);
    return theReverse;
}

@end
