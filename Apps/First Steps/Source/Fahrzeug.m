//
//  Fahrzeug.m
//  First Steps
//
//  Created by Klaus M. Rodewig on 05.01.11.
//  Copyright 2011 Klaus M. Rodewig. All rights reserved.
//

#import "Fahrzeug.h"
#import <CommonCrypto/CommonDigest.h>

@implementation Fahrzeug

- (id)init {
    NSLog(@"[+] %@", NSStringFromSelector(_cmd));
    return [self initWithPreis:[NSNumber numberWithFloat:0] 
               geschwindigkeit:0
                          name:@"Herbie" 
                       baujahr:[NSDate date]];
}

-(id)initWithPreis:(NSNumber*)inPreis 
   geschwindigkeit:(int)inGeschwindigkeit 
              name:(NSString*)inName
           baujahr:(NSDate*)inBaujahr{
    NSLog(@"[+] %@", NSStringFromSelector(_cmd));
    self = [super init];
    if (self){
        preis = inPreis;
        geschwindigkeit = inGeschwindigkeit;
        name = inName;
        baujahr = inBaujahr;
        [preis retain];
        [name retain];
        [baujahr retain];
    }    
    return self;
}

- (void)dealloc {
    NSLog(@"[+] %@", NSStringFromSelector(_cmd));
    [preis release];
    [name release];
    [baujahr release];
    [super dealloc];
}

-(NSString*)getId {
    NSLog(@"[+] %@", NSStringFromSelector(_cmd));
    NSString *theKey = [NSString stringWithFormat:@"%@%0.2f%d%@", 
                        [self name], [[self preis] floatValue], [self geschwindigkeit], [self baujahr]];
    unsigned char theCharacters[CC_SHA256_DIGEST_LENGTH];
    NSMutableString *theHash = [NSMutableString stringWithCapacity:CC_SHA256_DIGEST_LENGTH];

    CC_SHA256([theKey UTF8String],
              [theKey lengthOfBytesUsingEncoding:NSUTF8StringEncoding], 
              theCharacters);
    for (int i = 0; i < CC_SHA256_DIGEST_LENGTH; ++i) {
        [theHash appendString:[NSString stringWithFormat:@"%02x", theCharacters[i]]];
    }
    NSLog(@"[+] ID: %@", theHash);    
    return theHash;
}

#pragma mark Getter

-(NSNumber*)preis {
    NSLog(@"[+] %@", NSStringFromSelector(_cmd));
    return preis;
}

-(int)geschwindigkeit {
    NSLog(@"[+] %@", NSStringFromSelector(_cmd));
    return geschwindigkeit;
}

-(NSString*)name {
    NSLog(@"[+] %@", NSStringFromSelector(_cmd));
    return name;
}

-(NSDate*)baujahr {
    NSLog(@"[+] %@", NSStringFromSelector(_cmd));
    return baujahr;
}

#pragma mark Setter

-(void)setPreis:(NSNumber*)inPreis{
    NSLog(@"[+] %@", NSStringFromSelector(_cmd));
    [inPreis retain];
    [preis release];
    preis = inPreis;
}

-(void)setGeschwindigkeit:(int)inGeschwindigkeit{
    NSLog(@"[+] %@", NSStringFromSelector(_cmd));
    geschwindigkeit = inGeschwindigkeit;
}

-(void)setName:(NSString*)inName{
    NSLog(@"[+] %@", NSStringFromSelector(_cmd));
    [inName retain];
    [name release];
    name = inName;
}

-(void)setBaujahr:(NSDate*)inBaujahr{
    NSLog(@"[+] %@", NSStringFromSelector(_cmd));
    [inBaujahr retain];
    [baujahr release];
    baujahr = inBaujahr;
}

@end
