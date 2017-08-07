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

@property (nonatomic, readwrite) NSUInteger countOfCards;
@property (nonatomic, copy, readwrite) NSArray *cards;
@property (copy, readwrite) NSArray *flippedCards;
@property (nonatomic, readwrite) NSUInteger flipCount;
@property (nonatomic, readwrite) BOOL solved;

- (NSMutableArray *)createCards;

@end

@implementation Memory

+ (instancetype)memoryWithCountOfCards:(NSUInteger)inSize {
    return [[self alloc] initWithCountOfCards:inSize];
}

- (instancetype)init {
    return [self initWithCountOfCards:36];
}

- (instancetype)initWithCountOfCards:(NSUInteger)inSize {
    if(inSize % 2 == 0) {
        self = [super init];
        if(self) {
            [[NSNotificationCenter defaultCenter] addObserver:self 
                                                     selector:@selector(cardDidFlipped:) 
                                                         name:kCardDidFlippedNotification 
                                                       object:nil];
            self.countOfCards = inSize;
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
        NSUInteger theIndex = drand48() * theCount;
        Card *theCard = theOrderedCards[theIndex];
        
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
    NSUInteger theSize = self.countOfCards;
    NSMutableArray *theCards = [NSMutableArray arrayWithCapacity:theSize];
    
    for(NSUInteger theIndex = 0; theIndex < theSize; ++theIndex) {
        [theCards addObject:[Card cardWithType:theIndex / 2]];
    }
    return theCards;
}

- (void)checkFlippedCards {
    NSArray *theCards = self.flippedCards;
    
    if(theCards.count == 2) {
        if([(Card *)theCards[0] type] == [(Card *)theCards[1] type]) {
            NSDictionary *theInfo = @{kMemoryUserInfoCardsKey: theCards};
            [theCards enumerateObjectsUsingBlock:^(id inCard, NSUInteger inIndex, BOOL *outStop) {
                [inCard setSolved:YES];                
            }];
            [[NSNotificationCenter defaultCenter] postNotificationName:kMemoryCardsDidSolvedNotification
                                                                object:self 
                                                              userInfo:theInfo];
            self.flippedCards = nil;
            if([[self.cards valueForKeyPath:@"@sum.solved"] unsignedIntegerValue] == self.countOfCards) {
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
            theCards = theCards == nil ? @[theCard] : [theCards arrayByAddingObject:theCard];
            self.flipCount++;
        }
        self.flippedCards = theCards;
        if(theCards.count > 2) {
            [theCards[0] setShowsFrontSide:NO];
        }
    }
}

@end
