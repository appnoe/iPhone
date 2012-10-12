//
//  Card.m
//  Games
//
//  Created by Clemens Wagner on 24.04.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Card.h"

NSString * const kCardDidFlippedNotification = @"kCardDidFlippedNotification";
NSString * const kCardDidSolvedNotification = @"kCardDidSolvedNotification";

@interface Card ()

@property (nonatomic, readwrite) NSUInteger type;

@end

@implementation Card

@synthesize type;
@synthesize showsFrontSide;
@synthesize solved;
@synthesize index;

+ (id)cardWithType:(NSUInteger)inType {
    return [[[self alloc] initWithType:inType] autorelease];
}

- (id)initWithType:(NSUInteger)inType {
    self = [super init];
    if(self) {
        self.type = inType;
        self.showsFrontSide = NO;
        self.solved = NO;
    }
    return self;
}

- (void)reset {
    self.showsFrontSide = NO;
    self.solved = NO;
}

- (void)setShowsFrontSide:(BOOL)inShowsFrontSide {
    if(showsFrontSide != inShowsFrontSide) {
        showsFrontSide = inShowsFrontSide;
        [[NSNotificationCenter defaultCenter] postNotificationName:kCardDidFlippedNotification 
                                                            object:self];                              
    }
}

- (void)setSolved:(BOOL)inSolved {
    if(solved != inSolved) {
        solved = inSolved;
        if(solved) {
            [[NSNotificationCenter defaultCenter] postNotificationName:kCardDidSolvedNotification 
                                                                object:self];                                          
        }
    }
}

- (NSString *)description {
    return [NSString stringWithFormat:@"[type=%u, showsFrontSide=%d, solved=%d, index=%u",
            self.type, self.showsFrontSide, self.solved, self.index];
}

@end
