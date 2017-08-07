//
//  AstroDroid.m
//  Kapitel2
//
//  Created by Rodewig Klaus on 12.07.12.
//  Copyright (c) 2012 Klaus M. Rodewig. All rights reserved.
//

#import "AstroDroid.h"

@implementation AstroDroid

- (instancetype)initWithID:(int)inID {
    self = [super init];
    if(self != nil){
        self.droidID = [NSString stringWithFormat:@"0xBEEFCAFE%i", inID];
    }
    NSLog(@"[+] %@.%@", self, NSStringFromSelector(_cmd));
    return self;
}

-(void)sayName{
    NSLog(@"[*] %@.%@: %@", self, NSStringFromSelector(_cmd), self.droidID);
}


@end
