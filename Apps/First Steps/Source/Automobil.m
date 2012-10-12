//
//  Automobil.m
//  First Steps
//
//  Created by Klaus M. Rodewig on 17.01.11.
//  Copyright 2011 Klaus M. Rodewig. All rights reserved.
//

#import "Automobil.h"
#import <CommonCrypto/CommonDigest.h>

@implementation Automobil

- (id)init {
    NSLog(@"[+] %@", NSStringFromSelector(_cmd));
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)dealloc {
    NSLog(@"[+] %@", NSStringFromSelector(_cmd));
    [hauptUntersuchung release];
    [super dealloc];
}

-(NSString*)getId {
    NSLog(@"[+] %@", NSStringFromSelector(_cmd));
    NSString *theKey = [NSString stringWithFormat:@"%@%0.2f%d%@", 
                        [self name], [[self preis] floatValue], [self geschwindigkeit], [self baujahr]];
    unsigned char theCharacters[CC_SHA512_DIGEST_LENGTH];
    NSMutableString *theHash = [NSMutableString stringWithCapacity:CC_SHA512_DIGEST_LENGTH];
    
    CC_SHA512([theKey UTF8String],
              [theKey lengthOfBytesUsingEncoding:NSUTF8StringEncoding], 
              theCharacters);
    for (int i = 0; i < CC_SHA512_DIGEST_LENGTH; ++i) {
        [theHash appendString:[NSString stringWithFormat:@"%02x", theCharacters[i]]];
    }
    NSLog(@"[+] ID 512: %@", theHash);    
    return theHash;
}

#pragma mark Getter

- (NSDate *)hauptUntersuchung {
    return hauptUntersuchung;
}

- (unsigned int)anzahlTueren {
    return anzahlTueren;
}

- (double)leistung {
    return leistung;
}

#pragma mark Setter

- (void)setHauptUntersuchung:(NSDate *)inDate {
    [inDate retain];
    [hauptUntersuchung release];
    hauptUntersuchung = inDate;
}

- (void)setAnzahlTueren:(unsigned int)inTueren {
    anzahlTueren = inTueren;
}

- (void)setLeistung:(double)inLeistung {
    leistung = inLeistung;
}

@end
