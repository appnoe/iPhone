//
//  Puzzle.m
//  Games
//
//  Created by Clemens Wagner on 11.04.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Puzzle.h"

NSString * const kPuzzleDidTiltNotification = @"kPuzzleDidTiltNotification";
NSString * const kPuzzleDidMoveNotification = @"kPuzzleDidMoveNotification";
NSString * const kPuzzleDirectionKey = @"kPuzzleDirectionKey";
NSString * const kPuzzleFromIndexKey = @"kPuzzleFromIndexKey";
NSString * const kPuzzleToIndexKey = @"kPuzzleToIndexKey";

PuzzleDirection PuzzleDirectionRevert(PuzzleDirection inDirection) {
    return inDirection ^ 0x2;
}

@interface Puzzle()

@property (nonatomic, readwrite) NSUInteger length;
@property (nonatomic, readwrite) NSUInteger *items;
@property (nonatomic, readwrite) NSUInteger freeIndex;
@property (nonatomic, readwrite) NSUInteger moveCount;
@property (nonatomic, readwrite) BOOL solved;

- (void)clear;
- (BOOL)tiltToDirection:(PuzzleDirection)inDirection withCountOffset:(int)inOffset;

@end

@implementation Puzzle {
@private
    NSInteger offsets[4];
}

@synthesize length;
@synthesize items;
@synthesize freeIndex;
@synthesize moveCount;
@synthesize undoManager;
@synthesize solved;

+ (id)puzzleWithLength:(NSUInteger)inLength {
    return [[self alloc] initWithLength:inLength];
}

- (id)initWithLength:(NSUInteger)inLength {
    self = [super init];
    if(self) {
        self.length = inLength;
        self.items = calloc(inLength * inLength, sizeof(NSUInteger));
        offsets[PuzzleDirectionUp] = (NSInteger)inLength;
        offsets[PuzzleDirectionRight] = -1;
        offsets[PuzzleDirectionDown] = -(NSInteger)inLength;
        offsets[PuzzleDirectionLeft] = 1;
        [self clear];
    }
    return self;
}

- (void)dealloc {
    free(self.items);
    self.items = NULL;
    self.undoManager = nil;
}

- (void)checkSolved {
    NSUInteger theSize = self.size;
    BOOL theFlag = YES;
    
    for(NSUInteger i = 0; i < theSize; ++i) {
        if(self.items[i] != i) {
            theFlag = NO;
            break;
        }
    }
    if(theFlag != self.solved) {
        self.solved = theFlag;
    }
}

- (NSUInteger)size {
    return self.length * self.length;
}

- (void)clear {
    NSUInteger theSize = self.size;

    for(NSUInteger i = 0; i < theSize; ++i) {
        self.items[i] = i;
    }
    self.freeIndex = theSize - 1;
    self.moveCount = 0;
    [self.undoManager removeAllActionsWithTarget:self];
    [self checkSolved];
}

- (PuzzleDirection)tiltDirectionForIndex:(NSUInteger)inIndex {
    NSUInteger theFreeIndex = self.freeIndex;
    
    if(inIndex == theFreeIndex) {
        return PuzzleNoDirection;
    }
    else if([self rowOfIndex:theFreeIndex isEqualToRowOfIndex:inIndex]) {
        return inIndex < theFreeIndex ? PuzzleDirectionRight : PuzzleDirectionLeft;
    }
    else {
        return inIndex < theFreeIndex ? PuzzleDirectionDown : PuzzleDirectionUp;
    }
}

- (NSUInteger)nextIndex {
    NSUInteger theSize = self.size;
    NSUInteger theIndex = 0;
    PuzzleDirection theDirection = PuzzleNoDirection;
    
    while(theDirection == PuzzleNoDirection) {
        theIndex = rand() % theSize;
        theDirection = [self tiltDirectionForIndex:theIndex];
    }
    return theIndex;
}

- (void)shuffle {
    NSUInteger theSize = self.size;

    for(NSUInteger i = 0; i < 4 * theSize; ++i) {
        NSUInteger theShuffleIndex = self.nextIndex;
        PuzzleDirection theDirection = [self tiltDirectionForIndex:theShuffleIndex];
        
        while(theDirection != PuzzleNoDirection) {
            [self tiltToDirection:theDirection withCountOffset:0];
            theDirection = [self tiltDirectionForIndex:theShuffleIndex];
        }
    }
    self.moveCount = 0;
    [self checkSolved];
    [self.undoManager removeAllActionsWithTarget:self];
}

- (BOOL)rowOfIndex:(NSUInteger)inFromIndex isEqualToRowOfIndex:(NSUInteger)inToIndex {
    NSUInteger theLength = self.length;
    NSUInteger theSize = self.size;

    return inFromIndex < theSize && inToIndex < theSize && (inFromIndex / theLength) == (inToIndex / theLength);
}

- (BOOL)columnOfIndex:(NSUInteger)inFromIndex isEqualColumnOfIndex:(NSUInteger)inToIndex {
    NSUInteger theLength = self.length;
    NSUInteger theSize = self.size;
    
    return inFromIndex < theSize && inToIndex < theSize && (inFromIndex % theLength) == (inToIndex % theLength);
}

- (void)swapItemFromIndex:(NSUInteger)inFromIndex toIndex:(NSUInteger)inToIndex {
    NSUInteger *theItems = self.items;
    NSUInteger theValue = theItems[inToIndex];
    
    theItems[inToIndex] = theItems[inFromIndex];
    theItems[inFromIndex] = theValue;
}

- (void)postNotificationNamed:(NSString *)inName 
                withDirection:(PuzzleDirection)inDirection 
                    fromIndex:(NSUInteger)inFromIndex 
                      toIndex:(NSUInteger)inToIndex {
    NSDictionary *theInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithUnsignedInteger:inDirection], kPuzzleDirectionKey,
                             [NSNumber numberWithUnsignedInteger:inFromIndex], kPuzzleFromIndexKey,
                             [NSNumber numberWithUnsignedInteger:inToIndex], kPuzzleToIndexKey,
                             nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:inName object:self userInfo:theInfo];
}

- (BOOL)tiltToDirection:(PuzzleDirection)inDirection withCountOffset:(int)inOffset {
    if(inDirection != PuzzleNoDirection) {
        NSUInteger theFreeIndex = self.freeIndex;
        NSUInteger theIndex = theFreeIndex + offsets[inDirection];
        
        if([self rowOfIndex:theFreeIndex isEqualToRowOfIndex:theIndex] || 
           [self columnOfIndex:theFreeIndex isEqualColumnOfIndex:theIndex]) {
            PuzzleDirection theReverseDirection = PuzzleDirectionRevert(inDirection);
            Puzzle *thePuzzle = [self.undoManager prepareWithInvocationTarget:self];
            
            self.moveCount += inOffset;            
            [self swapItemFromIndex:theFreeIndex toIndex:theIndex];
            [self postNotificationNamed:kPuzzleDidTiltNotification 
                          withDirection:inDirection 
                              fromIndex:theIndex 
                                toIndex:theFreeIndex];
            self.freeIndex = theIndex;
            [thePuzzle tiltToDirection:theReverseDirection withCountOffset:-inOffset];
            return YES;
        }
    }
    return NO;
}


- (BOOL)tiltToDirection:(PuzzleDirection)inDirection {
    if([self tiltToDirection:inDirection withCountOffset:1]) {
        [self checkSolved];
        return YES;
    }
    else {
        return NO;
    }
}

- (BOOL)moveItemAtIndex:(NSUInteger)inIndex toDirection:(PuzzleDirection)inDirection {
    if(inDirection != PuzzleNoDirection) {
        NSUInteger theFreeIndex = self.freeIndex;
        NSUInteger theIndex = theFreeIndex + offsets[inDirection];
        
        if(inIndex == theIndex) {
            PuzzleDirection theReverseDirection = PuzzleDirectionRevert(inDirection);
            Puzzle *thePuzzle = [self.undoManager prepareWithInvocationTarget:self];

            self.moveCount++;
            [self swapItemFromIndex:theFreeIndex toIndex:theIndex];
            self.freeIndex = inIndex;
            [self postNotificationNamed:kPuzzleDidMoveNotification withDirection:inDirection fromIndex:inIndex toIndex:theFreeIndex];
            [thePuzzle tiltToDirection:theReverseDirection withCountOffset:-1];
            [self checkSolved];
            return YES;
        }
    }
    return NO;
}

- (NSUInteger)valueAtIndex:(NSUInteger)inIndex {
    return self.items[inIndex];
}

@end
