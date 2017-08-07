//
//  Model.m
//  Kapitel2
//
//  Created by Rodewig Klaus on 11.05.12.
//  Copyright (c) 2012 Klaus M. Rodewig. All rights reserved.
//

#import "Model.h"
#import "Droid.h"
#import "ProtocolDroid.h"
#import "AstroDroid.h"
#import "Wookiee.h"

@interface Model()

@property (copy, readwrite) NSString *name;

@end

@implementation Model {
@private
    NSMutableArray *objects;
}

@synthesize status;
@synthesize name;
@synthesize creation;

- (instancetype)init {
    self = [super init];
    if (self) {
        self.creation = [NSDate date];
        objects = [[NSMutableArray alloc] init];
    }
    return self;
}

-(instancetype)initWithName:(NSString *)inName {
    self = [self init];
    if(self) {
        self.name = inName;
    }
    return self;
}

- (int)countOfObjects {
    return (int)[objects count];
}

- (void)listDroids {
    Wookiee *theWookiee = [[Wookiee alloc] initWithName:@"Chewbacca"];
    
    [objects addObject:theWookiee];
    NSLog(@"[+] Current droids (%d):", [self countOfObjects]);
    for(id anItem in objects) {
        [anItem sayName];
    }
}

- (void)updateDroids:(int)inValue {
    [self willChangeValueForKey:@"countOfObjects"];
    if(inValue > [objects count]) {
        int theRemainder = inValue % 3;
        Droid *theDroid;
        
        if(theRemainder == 0) {
            theDroid = [[Droid alloc] initWithID:inValue];
        }
        else if(theRemainder == 1) {
            theDroid = [[ProtocolDroid alloc] initWithID:inValue];
        }
        else {
            theDroid = [[AstroDroid alloc] initWithID:inValue];
        }
        self.status = theDroid.droidID;
        [objects addObject:theDroid];
    }
    else if (inValue < [objects count]) {
        [objects removeLastObject];
    }
    [self didChangeValueForKey:@"countOfObjects"];
}

@end

