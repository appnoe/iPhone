//
//  GamesTests.m
//  GamesTests
//
//  Created by Clemens Wagner on 11.04.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PuzzleTests.h"
#import "Puzzle.h"

@interface PuzzleTests()

@property (nonatomic, retain) Puzzle *puzzle;
@property (nonatomic, retain) NSNotification *notification;

@end

@implementation PuzzleTests

@synthesize puzzle;
@synthesize notification;

- (void)setUp {
    [super setUp];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(puzzleDidTilt:) name:kPuzzleDidTiltNotification object:nil];
    self.notification = nil;
}

- (void)tearDown {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.notification = nil;
    self.puzzle = nil;
    [super tearDown];
}

- (void)puzzleDidTilt:(NSNotification *)inNotification {
    self.notification = inNotification;
}

- (void)checkNotificationWithName:(NSString *)inName fromIndex:(NSUInteger)inFromIndex toIndex:(NSUInteger)inToIndex {
    NSDictionary *theUserInfo = self.notification.userInfo;
    NSUInteger theFromIndex = [[theUserInfo valueForKey:kPuzzleFromIndexKey] unsignedIntValue];
    NSUInteger theToIndex = [[theUserInfo valueForKey:kPuzzleToIndexKey] unsignedIntValue];
    
    STAssertNotNil(self.notification, @"notification is nil");
    STAssertNotNil(theUserInfo, @"userInfo is nil");
    STAssertTrue(self.puzzle == self.notification.object, @"invalid puzzle");
    STAssertEquals(inName, self.notification.name, @"invalid name %@ != %@", inName, self.notification.name);
    STAssertTrue(inFromIndex == theFromIndex, @"invalid from index: %u != %u", inFromIndex, theFromIndex);
    STAssertTrue(inToIndex == theToIndex, @"invalid from index: %u != %u", inToIndex, theToIndex);
    self.notification = nil;
}

- (void)testCreation {
    self.puzzle = [Puzzle puzzleWithLength:4];
    STAssertTrue(self.puzzle.length == 4, @"invalid length = %d", self.puzzle.length);
    STAssertTrue(self.puzzle.size == 16, @"invalid size = %d", self.puzzle.size);
    for(NSUInteger i = 0; i < self.puzzle.size; ++i) {
        NSUInteger theValue = [self.puzzle valueAtIndex:i];
        
        STAssertTrue(theValue == i, @"invalid value %d at index %d", theValue, i);
    }
    STAssertTrue(self.puzzle.solved, @"puzzle not solved");
}

- (void)testComplexMove {
    static NSUInteger theValues[] = { 0, 1, 2, 3, 4, 15, 6, 7, 8, 5, 9, 11, 12, 13, 10, 14 };
    
    self.puzzle = [Puzzle puzzleWithLength:4];
    STAssertTrue([self.puzzle tiltToDirection:PuzzleDirectionRight], @"Can't tilt right.");
    [self checkNotificationWithName:kPuzzleDidTiltNotification fromIndex:14 toIndex:15];
    STAssertTrue([self.puzzle tiltToDirection:PuzzleDirectionDown], @"Can't tilt down.");
    [self checkNotificationWithName:kPuzzleDidTiltNotification fromIndex:10 toIndex:14];
    STAssertTrue([self.puzzle tiltToDirection:PuzzleDirectionRight], @"Can't tilt right.");
    [self checkNotificationWithName:kPuzzleDidTiltNotification fromIndex:9 toIndex:10];
    STAssertTrue([self.puzzle tiltToDirection:PuzzleDirectionDown], @"Can't tilt down.");
    [self checkNotificationWithName:kPuzzleDidTiltNotification fromIndex:5 toIndex:9];
    STAssertTrue(self.puzzle.freeIndex == 5, @"invalid free index: %u", self.puzzle.freeIndex);
    for(NSUInteger i = 0; i < self.puzzle.size; ++i) {
        NSUInteger theValue = [self.puzzle valueAtIndex:i];
        
        STAssertTrue(theValue == theValues[i], @"invalid value %d (%d) at index %d", 
                     theValue, theValues[i], i);
    }
}

- (void)testInvalidMoves {
    self.puzzle = [Puzzle puzzleWithLength:4];
    STAssertFalse([self.puzzle tiltToDirection:PuzzleDirectionLeft], @"tilt left.");
    STAssertNil(self.notification, @"notification sent");
    STAssertTrue(self.puzzle.solved, @"puzzle not solved");
    STAssertFalse([self.puzzle tiltToDirection:PuzzleDirectionUp], @"tilt up.");    
    STAssertNil(self.notification, @"notification sent");
    STAssertTrue(self.puzzle.solved, @"puzzle not solved");
}

- (void)testTilt {
    self.puzzle = [Puzzle puzzleWithLength:4];
    STAssertTrue([self.puzzle tiltToDirection:PuzzleDirectionDown], @"tilt to down failed");
    STAssertTrue(self.puzzle.freeIndex == 11, @"invalid free index %d", self.puzzle.freeIndex);
    STAssertTrue([self.puzzle valueAtIndex:15] == 11, @"invalid value %d at index 15", [self.puzzle valueAtIndex:15]);
    STAssertTrue([self.puzzle valueAtIndex:11] == 15, @"invalid value %d at index 11", [self.puzzle valueAtIndex:11]);
    STAssertFalse([self.puzzle tiltToDirection:PuzzleDirectionLeft], @"tilt to right not failed");
    STAssertTrue(self.puzzle.freeIndex == 11, @"invalid free index %d", self.puzzle.freeIndex);
    STAssertTrue([self.puzzle valueAtIndex:15] == 11, @"invalid value %d at index 15", [self.puzzle valueAtIndex:15]);
    STAssertTrue([self.puzzle valueAtIndex:11] == 15, @"invalid value %d at index 11", [self.puzzle valueAtIndex:11]);
    STAssertTrue([self.puzzle tiltToDirection:PuzzleDirectionRight], @"tilt to left failed");
    STAssertTrue(self.puzzle.freeIndex == 10, @"invalid free index %d", self.puzzle.freeIndex);
    STAssertTrue([self.puzzle valueAtIndex:15] == 11, @"invalid value %d at index 15", [self.puzzle valueAtIndex:15]);
    STAssertTrue([self.puzzle valueAtIndex:11] == 10, @"invalid value %d at index 11", [self.puzzle valueAtIndex:11]);
    STAssertTrue([self.puzzle valueAtIndex:10] == 15, @"invalid value %d at index 10", [self.puzzle valueAtIndex:10]);
}

@end
