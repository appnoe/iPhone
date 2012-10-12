//
//  PuzzleViewController.m
//  Games
//
//  Created by Clemens Wagner on 13.04.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PuzzleViewController.h"
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
@property (nonatomic, retain) NSUndoManager *undoManager;

- (void)buildView;

@end

@implementation PuzzleViewController

@synthesize puzzle;
@synthesize image;
@synthesize puzzleView;
@synthesize scoreView;
@synthesize lastDirection;
@synthesize undoManager;
@synthesize managedObjectContext;

- (void)dealloc {
    self.puzzle = nil;
    self.puzzleView = nil;
    self.image = nil;
    self.scoreView = nil;
    self.undoManager = nil;
    self.managedObjectContext = nil;
    [super dealloc];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.undoManager = [[[NSUndoManager alloc] init] autorelease];
}

- (NSString *)game {
    return @"puzzle";
}

- (void)addSwipeGestureRecognizerWithDirection:(UISwipeGestureRecognizerDirection)inDirection action:(SEL)inAction {
    UISwipeGestureRecognizer *theRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:inAction];
    
    theRecognizer.direction = inDirection;
    [self.puzzleView addGestureRecognizer:theRecognizer];
    [theRecognizer release];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSNotificationCenter *theCenter = [NSNotificationCenter defaultCenter];
    
    [self setupBorderWithLayer:self.puzzleView.layer];
    [theCenter addObserver:self selector:@selector(puzzleDidTilt:) name:kPuzzleDidTiltNotification object:nil];
    [theCenter addObserver:self selector:@selector(puzzleDidTilt:) name:kPuzzleDidMoveNotification object:nil];
    self.image = [UIImage imageNamed:@"flower.jpg"];
    [self addSwipeGestureRecognizerWithDirection:UISwipeGestureRecognizerDirectionLeft 
                                          action:@selector(handleLeftSwipe:)];
    [self addSwipeGestureRecognizerWithDirection:UISwipeGestureRecognizerDirectionRight 
                                          action:@selector(handleRightSwipe:)];
    [self addSwipeGestureRecognizerWithDirection:UISwipeGestureRecognizerDirectionUp 
                                          action:@selector(handleUpSwipe:)];
    [self addSwipeGestureRecognizerWithDirection:UISwipeGestureRecognizerDirectionDown 
                                          action:@selector(handleDownSwipe:)];
    [self clear];
}

- (void)viewDidUnload {
    self.puzzleView = nil;
    self.scoreView = nil;
    self.managedObjectContext = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super viewDidUnload];
}

- (void)viewDidAppear:(BOOL)inAnimated {
    [super viewDidAppear:inAnimated];
    UIAccelerometer *theAccelerometer = [UIAccelerometer sharedAccelerometer];
    
    theAccelerometer.delegate = self;
    theAccelerometer.updateInterval = 0.05;
}

- (void)viewWillDisappear:(BOOL)inAnimated {
    UIAccelerometer *theAccelerometer = [UIAccelerometer sharedAccelerometer];

    theAccelerometer.delegate = nil;
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)inInterfaceOrientation {
    return inInterfaceOrientation == UIInterfaceOrientationPortrait;
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
            [thePuzzleView.subviews objectAtIndex:theIndex] : nil;
            NSUInteger theItemIndex = [thePuzzle valueAtIndex:theIndex];

            theFrame.origin.x = theColumn * CGRectGetWidth(theFrame);
            if(theImageView == nil) {
                theImageView = [[UIImageView alloc] initWithFrame:theFrame];
                [thePuzzleView addSubview:[theImageView autorelease]];
            }
            if(theIndex == thePuzzle.freeIndex) {
                
                theImageView.backgroundColor = [UIColor darkGrayColor];
                theImageView.image = nil;
            }
            else {
                theImageView.image = [theImages objectAtIndex:theItemIndex];
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
    NSUInteger theFromIndex = [[theInfo objectForKey:kPuzzleFromIndexKey] intValue];
    NSUInteger theToIndex = [[theInfo objectForKey:kPuzzleToIndexKey] intValue];
    UIView *thePuzzleView = self.puzzleView;
    UIView *theFromView = [thePuzzleView.subviews objectAtIndex:theFromIndex];
    UIView *theToView = [thePuzzleView.subviews objectAtIndex:theToIndex];
    
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

- (void)handleLeftSwipe:(UISwipeGestureRecognizer *)inRecognizer {
    [self handleGestureRecognizer:inRecognizer withDirection:PuzzleDirectionLeft];
}

- (void)handleRightSwipe:(UISwipeGestureRecognizer *)inRecognizer {
    [self handleGestureRecognizer:inRecognizer withDirection:PuzzleDirectionRight];
}

- (void)handleUpSwipe:(UISwipeGestureRecognizer *)inRecognizer {
    [self handleGestureRecognizer:inRecognizer withDirection:PuzzleDirectionUp];
}

- (void)handleDownSwipe:(UISwipeGestureRecognizer *)inRecognizer {
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

#pragma mark UIAccelerometerDelegate

- (void)accelerometer:(UIAccelerometer *)inAccelerometer didAccelerate:(UIAcceleration *)inAcceleration {
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
