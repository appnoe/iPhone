//
//  PuzzleViewController.m
//  Games
//
//  Created by Clemens Wagner on 13.04.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PuzzleViewController.h"
#import "UIViewController+Games.h"
#import "UIImage+Subimage.h"
#import "Puzzle.h"
#import "NumberView.h"
#import <QuartzCore/QuartzCore.h>

const float kHorizontalMinimalThreshold = 0.2;
const float kVerticalMinimalThreshold = 0.2;
const float kHorizontalMaximalThreshold = 0.5;
const float kVerticalMaximalThreshold = 0.5;

@interface PuzzleViewController()<UIAccelerometerDelegate>

@property (nonatomic) PuzzleDirection lastDirection;
@property (nonatomic, strong) NSUndoManager *undoManager;

- (IBAction)handleLeftSwipe:(UISwipeGestureRecognizer *)inRecognizer;
- (IBAction)handleRightSwipe:(UISwipeGestureRecognizer *)inRecognizer;
- (IBAction)handleUpSwipe:(UISwipeGestureRecognizer *)inRecognizer;
- (IBAction)handleDownSwipe:(UISwipeGestureRecognizer *)inRecognizer;

- (void)buildView;

@end

@implementation PuzzleViewController

@synthesize undoManager;

- (void)awakeFromNib {
    [super awakeFromNib];
    self.undoManager = [[NSUndoManager alloc] init];
}

- (NSString *)game {
    return @"puzzle";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSNotificationCenter *theCenter = [NSNotificationCenter defaultCenter];

    [self setupBorderWithLayer:self.puzzleView.layer];
    [theCenter addObserver:self selector:@selector(puzzleDidTilt:) name:kPuzzleDidTiltNotification object:nil];
    [theCenter addObserver:self selector:@selector(puzzleDidTilt:) name:kPuzzleDidMoveNotification object:nil];
    self.image = [UIImage imageNamed:@"flower.jpg"];
    [self clear];
}

- (void)viewDidUnload {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super viewDidUnload];
}

- (void)viewDidAppear:(BOOL)inAnimated {
    [super viewDidAppear:inAnimated];
    CMMotionManager *theManager = self.motionManager;

    [theManager startAccelerometerUpdatesToQueue:[NSOperationQueue mainQueue]
                                     withHandler:^(CMAccelerometerData *inData, NSError *inError) {
                                         if(inData == nil) {
                                             NSLog(@"error: %@", inError);
                                         }
                                         else {
                                             [self handleAcceleration:inData.acceleration];
                                         }
                                     }];
}

- (void)viewWillDisappear:(BOOL)inAnimated {
    CMMotionManager *theManager = self.motionManager;

    [theManager stopAccelerometerUpdates];
    [super viewWillDisappear:inAnimated];
}

- (IBAction)clear {    
    [self.puzzle removeObserver:self forKeyPath:@"moveCount"];
    [self.puzzle removeObserver:self forKeyPath:@"solved"];
    [self.undoManager removeAllActions];
    self.puzzle = [Puzzle puzzleWithLength:4];
    self.puzzle.undoManager = self.undoManager;
    [self.puzzle addObserver:self forKeyPath:@"moveCount" options:0 context:nil];
    [self.puzzle addObserver:self forKeyPath:@"solved" options:0 context:nil];
    [self.scoreView setValue:0 animated:YES];
    [self buildView];
    [self shuffle];
    self.lastDirection = PuzzleNoDirection;
}

- (IBAction)shuffle {
    Puzzle *thePuzzle = self.puzzle;
    
    [thePuzzle shuffle];
}

- (IBAction)undo {
    [self.undoManager undo];
}

- (IBAction)redo {
    [self.undoManager redo];
}

- (BOOL)shouldAutorotate {
    return NO;
}

- (void)buildView {
    Puzzle *thePuzzle = self.puzzle;
    NSUInteger theLength = thePuzzle.length;
    UIView *thePuzzleView = self.puzzleView;
    CGSize theSize = thePuzzleView.frame.size;
    NSArray *theImages = [self.image splitIntoSubimagesWithRows:theLength columns:theLength];
    CGRect theFrame = CGRectMake(0.0, 0.0, theSize.width / theLength, theSize.height / theLength);
    NSUInteger theIndex = 0;
    
    for(NSUInteger theRow = 0; theRow < theLength; ++theRow) {
        theFrame.origin.y = theRow * CGRectGetHeight(theFrame);
        for(NSUInteger theColumn = 0; theColumn < theLength; ++theColumn) {
            UIImageView *theImageView = theIndex < thePuzzleView.subviews.count ? 
            (thePuzzleView.subviews)[theIndex] : nil;
            NSUInteger theItemIndex = [thePuzzle valueAtIndex:theIndex];

            theFrame.origin.x = theColumn * CGRectGetWidth(theFrame);
            if(theImageView == nil) {
                theImageView = [[UIImageView alloc] initWithFrame:theFrame];
                [thePuzzleView addSubview:theImageView];
            }
            if(theIndex == thePuzzle.freeIndex) {
                
                theImageView.backgroundColor = [UIColor darkGrayColor];
                theImageView.image = nil;
            }
            else {
                theImageView.image = theImages[theItemIndex];
            }
            theImageView.tag = theItemIndex;
            theImageView.frame = theFrame;
            theIndex++;
        }
    }
    while(theIndex < thePuzzleView.subviews.count) {
        [thePuzzleView.subviews.lastObject removeFromSuperview];
    }
}

- (CGRect)frameForItemAtIndex:(NSUInteger)inIndex {
    CGSize theSize = self.puzzleView.frame.size;
    NSUInteger theLength = self.puzzle.length;
    NSUInteger theRow = inIndex / theLength;
    NSUInteger theColumn = inIndex % theLength;
    
    theSize.width /= theLength;
    theSize.height /= theLength;
    return CGRectMake(theColumn * theSize.width, theRow * theSize.height, theSize.width, theSize.height);
}

- (void)puzzleDidTilt:(NSNotification *)inNotification {
    NSDictionary *theInfo = inNotification.userInfo;
    NSUInteger theFromIndex = [theInfo[kPuzzleFromIndexKey] intValue];
    NSUInteger theToIndex = [theInfo[kPuzzleToIndexKey] intValue];
    UIView *thePuzzleView = self.puzzleView;
    UIView *theFromView = (thePuzzleView.subviews)[theFromIndex];
    UIView *theToView = (thePuzzleView.subviews)[theToIndex];
    
    [thePuzzleView exchangeSubviewAtIndex:theFromIndex withSubviewAtIndex:theToIndex];
    [UIView animateWithDuration:0.4 
                     animations:^{
                         theFromView.frame = [self frameForItemAtIndex:theToIndex];
                         theToView.frame = [self frameForItemAtIndex:theFromIndex];
                     }];
}

- (void)handleGestureRecognizer:(UIGestureRecognizer *)inRecognizer withDirection:(PuzzleDirection)inDirection {
    UIView *thePuzzleView = self.puzzleView;
    Puzzle *thePuzzle = self.puzzle;
    CGPoint thePoint = [inRecognizer locationInView:thePuzzleView];
    NSUInteger theLength = thePuzzle.length;
    CGSize theViewSize = thePuzzleView.frame.size;
    NSUInteger theRow = thePoint.y * theLength / theViewSize.height;
    NSUInteger theColumn = thePoint.x * theLength / theViewSize.width;
    NSUInteger theIndex = theRow * theLength + theColumn;
    
    [thePuzzle moveItemAtIndex:theIndex toDirection:inDirection];
}

- (IBAction)handleLeftSwipe:(UISwipeGestureRecognizer *)inRecognizer {
    [self handleGestureRecognizer:inRecognizer withDirection:PuzzleDirectionLeft];
}

- (IBAction)handleRightSwipe:(UISwipeGestureRecognizer *)inRecognizer {
    [self handleGestureRecognizer:inRecognizer withDirection:PuzzleDirectionRight];
}

- (IBAction)handleUpSwipe:(UISwipeGestureRecognizer *)inRecognizer {
    [self handleGestureRecognizer:inRecognizer withDirection:PuzzleDirectionUp];
}

- (IBAction)handleDownSwipe:(UISwipeGestureRecognizer *)inRecognizer {
    [self handleGestureRecognizer:inRecognizer withDirection:PuzzleDirectionDown];
}

- (void)observeValueForKeyPath:(NSString *)inKeyPath ofObject:(id)inObject change:(NSDictionary *)inChanges context:(void *)inContext {
    if(inObject == self.puzzle) {
        if([@"moveCount" isEqualToString:inKeyPath]) {
            [self.scoreView setValue:self.puzzle.moveCount animated:YES];
        }
        else if([@"solved" isEqualToString:inKeyPath]) {
            BOOL theFlag = self.puzzle.solved;
            UIView *theView = self.puzzleView;
            
            theView.userInteractionEnabled = !theFlag;
            if(theFlag) {
                theView.alpha = 0.75;
                [self saveScore:self.puzzle.moveCount];
            }
            else {
                theView.alpha = 1.0;
            }
        }
    }
}

- (void)handleAcceleration:(CMAcceleration)inAcceleration {
    float theX = inAcceleration.x;
    float theY = inAcceleration.y;
    
    if(self.lastDirection == PuzzleNoDirection) {
        Puzzle *thePuzzle = self.puzzle;

        if(fabs(theX) > kHorizontalMaximalThreshold) {
            self.lastDirection = theX < 0 ? PuzzleDirectionLeft : PuzzleDirectionRight;
        }
        else if(fabs(theY) > kVerticalMaximalThreshold) {
            self.lastDirection = theY < 0 ? PuzzleDirectionDown : PuzzleDirectionUp;
        }
        [thePuzzle tiltToDirection:self.lastDirection];
    }
    else if(fabs(theX) < kHorizontalMinimalThreshold && fabs(theY) < kVerticalMinimalThreshold) {
        self.lastDirection = PuzzleNoDirection;
    }
}

@end
