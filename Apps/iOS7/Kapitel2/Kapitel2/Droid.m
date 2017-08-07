//
//  Tier.m
//  Kapitel2
//
//  Created by Rodewig Klaus on 27.05.12.
//  Copyright (c) 2012 Klaus M. Rodewig. All rights reserved.
//

#import "Droid.h"

@implementation Droid

- (instancetype)initWithID:(int)inID {
    self = [super init];
    if(self != nil){
        self.droidID = [NSString stringWithFormat:@"0xDEADBEEF%i", inID];
    }
    NSLog(@"[+] %@.%@", self, NSStringFromSelector(_cmd));
    return self;
}

- (void)dealloc {
    NSLog(@"[+] %@.%@", self, NSStringFromSelector(_cmd));
}

-(void)sayName{
    NSLog(@"[+] %@.%@: %@", self, NSStringFromSelector(_cmd), self.droidID);
}

@end
