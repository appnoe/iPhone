//
//  BookmarksViewController.m
//  MoviePlayer
//
//  Created by Clemens Wagner on 09.06.13.
//  Copyright (c) 2013 Clemens Wagner. All rights reserved.
//

#import "BookmarksViewController.h"
#import "UIViewController+MoviePlayer.h"
#import "MovieCell.h"
#import <QuartzCore/QuartzCore.h>
#import <MediaPlayer/MediaPlayer.h>

static const CGFloat kAngle = 1.5 * M_PI / 180.0;

@interface BookmarksViewController ()<UIGestureRecognizerDelegate>

@property (nonatomic, strong) CALayer *selectionLayer;
@property (nonatomic) CGPoint panOffset;
@property (nonatomic, strong) NSIndexPath *panIndexPath;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *deleteButton;
@property (nonatomic, copy) NSArray *items;

- (IBAction)toggleDelete:(UIBarButtonItem *)inButton;
- (IBAction)handlePanGesture:(UIPanGestureRecognizer *)inRecognizer;

@end

@implementation BookmarksViewController

- (void)viewWillAppear:(BOOL)inAnimated {
    [super viewWillAppear:inAnimated];
    self.items = self.bookmarks;
    [[NSNotificationCenter defaultCenter] addObserverForName:MPMoviePlayerThumbnailImageRequestDidFinishNotification
                                                      object:nil
                                                       queue:[NSOperationQueue mainQueue]
                                                  usingBlock:^(NSNotification *inNotification) {
                                                      NSDictionary *theInfo = inNotification.userInfo;
                                                      UIImage *theImage = theInfo[MPMoviePlayerThumbnailImageKey];
                                                      NSTimeInterval theTime = [theInfo[MPMoviePlayerThumbnailTimeKey] doubleValue];

                                                      [self updateImage:theImage withTime:theTime];
                                                  }];
    [self.collectionView reloadData];
}

- (void)viewWillDisappear:(BOOL)inAnimated {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super viewWillDisappear:inAnimated];
}

- (void)updateImage:(UIImage *)inImage withTime:(NSTimeInterval)inTime {
    NSUInteger theIndex = [self nearestIndexForTime:inTime];

    if(theIndex != NSNotFound) {
        NSIndexPath *thePath = [NSIndexPath indexPathForRow:theIndex inSection:0];
        MovieCell *theCell = (MovieCell *)[self.collectionView cellForItemAtIndexPath:thePath];

        theCell.image = inImage;
    }
}

- (NSUInteger)nearestIndexForTime:(NSTimeInterval)inTime {
    double theDelta = MAXFLOAT;
    NSUInteger theNearestIndex = NSNotFound;
    NSUInteger theIndex = 0;

    for(id theValue in self.bookmarks) {
        double theCurrentDelta = fabs(inTime - [theValue doubleValue]);

        if(theCurrentDelta < theDelta) {
            theDelta = theCurrentDelta;
            theNearestIndex = theIndex;
        }
        ++theIndex;
    }
    NSLog(@"nearestIndexForTime:%.3f (delta = %.6f)", inTime, theDelta);
    return theNearestIndex;
}

- (BOOL)deleteMode {
    return self.deleteButton.tintColor != nil;
}

- (CAAnimation *)deleteAnimation {
    CABasicAnimation *theAnimation = [CABasicAnimation animation];

    theAnimation.fromValue = @(-kAngle);
    theAnimation.toValue = @(kAngle);
    theAnimation.repeatCount = MAXFLOAT;
    theAnimation.duration = 0.125;
    theAnimation.autoreverses = YES;
    theAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    return theAnimation;
}

- (IBAction)toggleDelete:(UIBarButtonItem *)inButton {
    self.deleteButton.tintColor = self.deleteMode ? nil : [UIColor redColor];
    CAAnimation *theAnimation = self.deleteMode ? [self deleteAnimation] : nil;

    for(UICollectionViewCell *theCell in self.collectionView.visibleCells) {
        if(theAnimation == nil) {
            [theCell.layer removeAllAnimations];
        }
        else {
            [theCell.layer addAnimation:theAnimation forKey:@"transform.rotation.z"];
        }
    }
}

- (void)exchangeValueFromIndex:(NSInteger)inFromIndex withValueAtIndex:(NSInteger)inToIndex {
    if(inFromIndex != inToIndex) {
        NSMutableArray *theItems = [self.items mutableCopy];

        [theItems exchangeObjectAtIndex:inFromIndex withObjectAtIndex:inToIndex];
        [self.collectionView moveItemAtIndexPath:[NSIndexPath indexPathForRow:inFromIndex inSection:0]
                                     toIndexPath:[NSIndexPath indexPathForRow:inToIndex inSection:0]];
        [theItems insertObject:theItems[inFromIndex] atIndex:inToIndex];
        if(inFromIndex < inToIndex) {
            [theItems removeObjectAtIndex:inFromIndex];
        }
        else {
            [theItems removeObjectAtIndex:inFromIndex - 1];
        }
        self.items = theItems;
        [self setBookmarks:self.items];
    }
}


- (CALayer *)selectionLayerForCell:(UICollectionViewCell *)inCell {
    CALayer *theLayer = [CALayer layer];
    CGFloat theScale = [[UIScreen mainScreen] scale];
    CGRect theFrame = inCell.frame;
    UIImage *theImage;

    UIGraphicsBeginImageContextWithOptions(theFrame.size, NO, theScale);
    [inCell.layer renderInContext:UIGraphicsGetCurrentContext()];
    theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    theLayer.frame = theFrame;
    theLayer.contents = (__bridge id)(theImage.CGImage);
    theLayer.opacity = 0.5;
    theLayer.zPosition = 1.0;
    return theLayer;
}

- (IBAction)handlePanGesture:(UIPanGestureRecognizer *)inRecognizer {
    UICollectionView *theView = self.collectionView;
    CGPoint thePoint = [inRecognizer locationInView:theView];
    NSIndexPath *theIndexPath = [self.collectionView indexPathForItemAtPoint:thePoint];

    switch(inRecognizer.state) {
        case UIGestureRecognizerStateBegan: {
            UICollectionViewCell *theCell = [theView cellForItemAtIndexPath:theIndexPath];
            CGPoint theOrigin;

            self.selectionLayer = [self selectionLayerForCell:theCell];
            [theView.layer addSublayer:self.selectionLayer];
            theOrigin = self.selectionLayer.frame.origin;
            self.panOffset = CGPointMake(theOrigin.x - thePoint.x, theOrigin.y - thePoint.y);
            self.panIndexPath = theIndexPath;
            break;
        }
        case UIGestureRecognizerStateChanged: {
            UICollectionViewCell *theCell = [theView cellForItemAtIndexPath:theIndexPath];
            CGPoint theOrigin = CGPointMake(thePoint.x + self.panOffset.x, thePoint.y + self.panOffset.y);
            CGRect theFrame = self.selectionLayer.frame;

            theCell.highlighted = YES;
            theFrame.origin = theOrigin;
            [CATransaction begin];
            [CATransaction setAnimationDuration:0.0];
            self.selectionLayer.frame = theFrame;
            [CATransaction commit];
            break;
        }
        case UIGestureRecognizerStateEnded: {
            if(theIndexPath != nil) {
                [self exchangeValueFromIndex:self.panIndexPath.row withValueAtIndex:theIndexPath.row];
            }
        }
        case UIGestureRecognizerStateCancelled:
            [self.selectionLayer removeFromSuperlayer];
            self.selectionLayer = nil;
            break;
        default:
            break;
    };
}

#pragma mark UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)inRecognizer {
    CGPoint thePoint = [inRecognizer locationInView:self.collectionView];
    NSIndexPath *theIndexPath = [self.collectionView indexPathForItemAtPoint:thePoint];

    return theIndexPath != nil;
}

#pragma mark UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)inCollectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)inCollectionView numberOfItemsInSection:(NSInteger)inSection {
    return [self.items count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)inCollectionView cellForItemAtIndexPath:(NSIndexPath *)inIndexPath {
    MovieCell *theCell = [inCollectionView dequeueReusableCellWithReuseIdentifier:@"movie" forIndexPath:inIndexPath];
    NSTimeInterval theTime = [self.items[inIndexPath.row] doubleValue];

    theCell.text = [NSString stringWithFormat:@"%d:%02d,%03ds",
                    (int)(theTime / 60), (int)theTime % 60, (int)(theTime * 1000) % 1000];
    theCell.image = nil;
    [self.delegate bookmarksViewController:self needsImageAtTime:theTime];
    if(self.deleteMode) {
        CAAnimation *theAnimation = [self deleteAnimation];

        [theCell.layer addAnimation:theAnimation forKey:@"transform.rotation.z"];
    }
    else {
        [theCell.layer removeAllAnimations];
    }
    return theCell;
}

#pragma mark UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)inCollectionView didSelectItemAtIndexPath:(NSIndexPath *)inIndexPath {
    if(self.deleteMode) {
        NSMutableArray *theItems = [self.items mutableCopy];

        [theItems removeObjectAtIndex:inIndexPath.row];
        self.items = theItems;
        [self setBookmarks:theItems];
        [self.collectionView deleteItemsAtIndexPaths:@[inIndexPath]];
    }
    else {
        NSTimeInterval theTime = [self.items[inIndexPath.row] doubleValue];

        [self.delegate bookmarksViewController:self didUpdatePlaybackTime:theTime];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
