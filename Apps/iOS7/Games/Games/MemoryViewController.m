//
//  MemoryViewController.m
//  Games
//
//  Created by Clemens Wagner on 23.04.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MemoryViewController.h"
#import "Card.h"
#import "Memory.h"
#import "CardView.h"
#import <QuartzCore/QuartzCore.h>

const NSUInteger kMemoryRows = 6;
const NSUInteger kMemoryColumns = 6;
const NSUInteger kMemorySize = 6 * 6;

@interface MemoryViewController()

@property (nonatomic, strong, readwrite) Memory *memory;

- (void)updateViewFromModel;

@end

@interface CardView(MemoryViewController)

- (void)updateWithCard:(Card *)inCard;

@end

@implementation MemoryViewController

- (void)dealloc {
    [self.memory removeObserver:self forKeyPath:@"flipCount"];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    NSNotificationCenter *theCenter = [NSNotificationCenter defaultCenter];
    
    self.memory = [Memory memoryWithCountOfCards:kMemorySize];
    [theCenter addObserver:self selector:@selector(memoryDidCleared:) name:kMemoryDidClearedNotification object:nil];
    [theCenter addObserver:self selector:@selector(cardDidFlipped:) name:kCardDidFlippedNotification object:nil];
    [theCenter addObserver:self selector:@selector(cardsDidSolved:) name:kMemoryCardsDidSolvedNotification object:nil];
    [self.memory addObserver:self forKeyPath:@"flipCount" options:NSKeyValueObservingOptionNew context:nil];
    [self.memory addObserver:self forKeyPath:@"solved" options:NSKeyValueObservingOptionNew context:nil];
}

- (NSString *)game {
    return @"memory";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIView *theView = self.memoryView;
    CGSize theSize = theView.frame.size;
    CGRect theFrame = CGRectMake(0.0, 0.0, theSize.width / kMemoryColumns, theSize.height / kMemoryRows);
    SEL theAction = @selector(cardTouched:);
    CardView *theCardView;

    [self setupBorderWithLayer:theView.layer];
    for(NSUInteger theRow = 0; theRow < kMemoryRows; ++theRow) {
        theFrame.origin.y = theRow * theSize.height / kMemoryRows;
        for(NSUInteger theColumn = 0; theColumn < kMemoryColumns; ++theColumn) {            
            theFrame.origin.x = theColumn * theSize.width / kMemoryColumns;
            theCardView = [[CardView alloc] initWithFrame:theFrame];
            theCardView.tag = theRow * kMemoryRows + theColumn;
            [theView addSubview:theCardView];
            [theCardView addTarget:self action:theAction forControlEvents:UIControlEventTouchUpInside];
        }
    }
    [self.memory clear];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)inInterfaceOrientation {
    return inInterfaceOrientation == UIInterfaceOrientationPortrait;
}

- (void)updateViewFromModel {
    NSArray *theCards = self.memory.cards;
    NSArray *theViews = self.memoryView.subviews;
    NSUInteger theSize = theCards.count;
    
    for(NSUInteger theIndex = 0; theIndex < theSize; ++theIndex) {
        Card *theCard = theCards[theIndex];
        CardView *theCardView = theViews[theIndex];
        
        [theCardView updateWithCard:theCard]; 
    }
}

- (IBAction)cardTouched:(id)inCardView {
    Card *theCard = (self.memory.cards)[[inCardView tag]];
    
    theCard.showsFrontSide = !theCard.showsFrontSide;
}

- (void)memoryDidCleared:(NSNotification *)inNotification {
    [self updateViewFromModel];    
}

- (void)cardDidFlipped:(NSNotification *)inNotification {
    Card *theCard = inNotification.object;
    CardView *theView = (self.memoryView.subviews)[theCard.index];
    
    [theView showFrontSide:theCard.showsFrontSide withAnimationCompletion:^(BOOL inFinished) {
        [self.memory checkFlippedCards];
    }];
}

- (void)cardsDidSolved:(NSNotification *)inNotification {
    NSArray *theCards = (inNotification.userInfo)[kMemoryUserInfoCardsKey];
    
    [UIView animateWithDuration:0.75
                     animations:^{
                         for(Card *theCard in theCards) {
                             CardView *theView = (self.memoryView.subviews)[theCard.index];

                             theView.transform = CGAffineTransformScale(CGAffineTransformMakeRotation(M_PI), 0.1, 0.1);
                         }        
                     }
                     completion:^(BOOL inFinished) {
                         for(Card *theCard in theCards) {
                             CardView *theView = (self.memoryView.subviews)[theCard.index];
                             
                             theView.hidden = theCard.solved;
                             theView.transform = CGAffineTransformIdentity;
                         }                         
                     }];
}

- (IBAction)clear {
    [self.memory clear];
}

- (void)showCardView:(BOOL)inShow atIndex:(NSUInteger)inIndex {
    NSArray *theViews = self.memoryView.subviews;
    UIViewAnimationOptions theOptions = inShow ? UIViewAnimationOptionTransitionCurlUp : UIViewAnimationOptionTransitionCurlDown;
    
    if(inIndex < theViews.count) {
        Card *theCard = (self.memory.cards)[inIndex];
        CardView *theView = theViews[inIndex];
        
        [UIView transitionWithView:theView duration:0.25
                           options:theOptions
                        animations:^{
                            theView.showsFrontSide = inShow || theCard.showsFrontSide;
                        } 
                        completion:^(BOOL inFinished) {
                            [self showCardView:inShow atIndex:inIndex + 1];
                            if(inIndex == 0 && inShow) {
                                [self showCardView:NO atIndex:0];
                            }
                        }];
    }
}

- (IBAction)help {
    [self showCardView:YES atIndex:0];
    [self.memory addPenalty:self.memory.cardCount / 2.0];
}

- (void)observeValueForKeyPath:(NSString *)inKeyPath ofObject:(id)inObject change:(NSDictionary *)inChanges context:(void *)inContext {
    if(inObject == self.memory && [@"flipCount" isEqualToString:inKeyPath]) {
        [self.scoreView setValue:self.memory.flipCount animated:YES];
    }
    else if([@"solved" isEqualToString:inKeyPath]) {
        if(self.memory.solved) {
            [self saveScore:self.memory.flipCount];
        }
    }
}

@end

@implementation CardView(MemoryViewController)

- (void)updateWithCard:(Card *)inCard {
    self.type = inCard.type;
    self.hidden = inCard.solved;
    self.showsFrontSide = inCard.showsFrontSide;
}

@end

