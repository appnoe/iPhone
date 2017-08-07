//
//  Memory.m
//  Games
//
//  Created by Clemens Wagner on 24.04.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Memory.h"
#import "Card.h"

NSString * const kMemoryDidClearedNotification = @"kMemoryDidClearedNotification";
NSString * const kMemoryCardsDidSolvedNotification = @"kMemoryCardsDidSolvedNotification";

NSString * const kMemoryUserInfoCardsKey = @"kMemoryUserInfoCardsKey";

@interface Memory()

@property (nonatomic, readwrite) NSUInteger size;
@property (nonatomic, copy, readwrite) NSArray *cards;
@property (copy, readwrite) NSArray *flippedCards;
@property (nonatomic, readwrite) NSUInteger flipCount;
@property (nonatomic, readwrite) BOOL solved;

- (NSMutableArray *)createCards;

@end

@implementation Memory

@synthesize size;
@synthesize cards;
@synthesize flippedCards;
@synthesize flipCount;
@synthesize solved;

+ (id)memoryWithSize:(NSUInteger)inSize {
    return [[self alloc] initWithSize:inSize];
}

- (id)init {
    return [self initWithSize:36];
}

- (id)initWithSize:(NSUInteger)inSize {
    if(inSize % 2 == 0) {
        self = [super init];
        if(self) {
            [[NSNotificationCenter defaultCenter] addObserver:self 
                                                     selector:@selector(cardDidFlipped:) 
                                                         name:kCardDidFlippedNotification 
                                                       object:nil];
            self.size = inSize;
        }
        return self;
    }
    else {
        return nil;
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:nil object:nil];
}

- (NSUInteger)cardCount {
    return self.cards.count;
}

- (void)clear {
    NSMutableArray *theOrderedCards = [self createCards];
    NSUInteger theCount = theOrderedCards.count;
    NSMutableArray *theCards = [NSMutableArray arrayWithCapacity:theCount];
    
    while(theCount > 0) {
        NSUInteger theIndex = rand() % theCount;
        Card *theCard = [theOrderedCards objectAtIndex:theIndex];
        
        theCard.index = theCards.count;
        [theCards addObject:theCard];
        [theOrderedCards removeObjectAtIndex:theIndex];
        theCount--;
    }
    self.cards = theCards;
    [[NSNotificationCenter defaultCenter] postNotificationName:kMemoryDidClearedNotification object:self];
    self.flipCount = 0;
    if(self.solved) {
        self.solved = NO;
    }
}

- (void)addPenalty:(NSUInteger)inPenalty {
    self.flipCount += inPenalty;
}

- (NSMutableArray *)createCards {
    NSUInteger theSize = self.size;
    NSMutableArray *theCards = [NSMutableArray arrayWithCapacity:theSize];
    
    for(NSUInteger theIndex = 0; theIndex < theSize; ++theIndex) {
        [theCards addObject:[Card cardWithType:theIndex / 2]];
    }
    return theCards;
}

- (void)checkFlippedCards {
    NSArray *theCards = self.flippedCards;
    
    if(theCards.count == 2) {
        if([(Card *)[theCards objectAtIndex:0] type] == [(Card *)[theCards objectAtIndex:1] type]) {
            NSDictionary *theInfo = [NSDictionary dictionaryWithObjectsAndKeys:theCards, kMemoryUserInfoCardsKey, nil];
            [theCards enumerateObjectsUsingBlock:^(id inCard, NSUInteger inIndex, BOOL *outStop) {
                [inCard setSolved:YES];                
            }];
            [[NSNotificationCenter defaultCenter] postNotificationName:kMemoryCardsDidSolvedNotification
                                                                object:self 
                                                              userInfo:theInfo];
            self.flippedCards = nil;
            if([[self.cards valueForKeyPath:@"@sum.solved"] unsignedIntegerValue] == self.size) {
                self.solved = YES;
            }
        }
        else {
            [theCards enumerateObjectsUsingBlock:^(id inCard, NSUInteger inIndex, BOOL *outStop) {
                [inCard setShowsFrontSide:NO];                
            }];
        }
    }
}

- (void)cardDidFlipped:(NSNotification *)inNotification {
    Card *theCard = inNotification.object;
    
    if([self.cards containsObject:theCard]) {
        NSPredicate *thePredicate = [NSPredicate predicateWithFormat:@"SELF != %@", theCard];
        NSArray *theCards = [self.flippedCards filteredArrayUsingPredicate:thePredicate];

        if(theCard.showsFrontSide) {
            theCards = theCards == nil ? [NSArray arrayWithObject:theCard] : [theCards arrayByAddingObject:theCard];
            self.flipCount++;
        }
        self.flippedCards = theCards;
        if(theCards.count > 2) {
            [[theCards objectAtIndex:0] setShowsFrontSide:NO];
        }
    }
}

@end
