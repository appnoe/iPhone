//
//  StackLayout.m
//  UniversalYouTube
//
//  Created by Clemens Wagner on 21.07.12.
//  Copyright (c) 2012 Clemens Wagner. All rights reserved.
//

#import "StackLayout.h"

@interface StackLayout()

@property(nonatomic, copy) NSArray *attributes;
@property(nonatomic) CGSize contentSize;

@end

static const CGFloat kHeaderHeight = 44.0;
static const CGFloat kFooterHeight = 44.0;

@implementation StackLayout

@synthesize attributes;
@synthesize contentSize;

- (CGSize)collectionViewContentSize {
    return self.collectionView.bounds.size;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)inBounds {
    return YES;
}

- (void)prepareLayout {    
    NSInteger theSectionCount = [self.collectionView numberOfSections];
    NSMutableArray *theArray = [NSMutableArray array];
    UICollectionViewLayoutAttributes *theAttributes;
    CGRect theFrame = CGRectZero;
    
    for(NSInteger i = 0; i < theSectionCount; ++i) {
        NSInteger theCount = [self.collectionView numberOfItemsInSection:i];
        
        theAttributes = [self layoutAttributesForDecorationViewOfKind:@"Logo" atIndexPath:[NSIndexPath indexPathForRow:0 inSection:i]];
        [theArray addObject:theAttributes];
        theFrame = CGRectUnion(theAttributes.frame, theFrame);
        theAttributes = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:[NSIndexPath indexPathForRow:0 inSection:i]];
        [theArray addObject:theAttributes];
        theFrame = CGRectUnion(theAttributes.frame, theFrame);
        for(NSInteger j = 0; j < theCount; ++j) {
            NSIndexPath *theIndexPath = [NSIndexPath indexPathForRow:j inSection:i];
            
            theAttributes = [self layoutAttributesForItemAtIndexPath:theIndexPath];
            [theArray addObject:theAttributes];
            theFrame = CGRectUnion(theAttributes.frame, theFrame);
        }
        theAttributes = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter atIndexPath:[NSIndexPath indexPathForRow:1 inSection:i]];
        [theArray addObject:theAttributes];
        theFrame = CGRectUnion(theAttributes.frame, theFrame);
    }
    self.attributes = theArray;
    self.contentSize = theFrame.size;
}

- (CGSize)sizeForItemAtIndexPath:(NSIndexPath *)inIndexPath {
    UICollectionView *theView = self.collectionView;
    id theDelegate = theView.delegate;

    return [theDelegate collectionView:theView layout:self sizeForItemAtIndexPath:inIndexPath];
}

- (CGRect)cellFrameForSection:(NSInteger)inSection {
    UICollectionView *theView = self.collectionView;
    NSInteger theCount = [theView numberOfItemsInSection:inSection];
    CGSize theSize = self.collectionView.bounds.size;
    CGSize theFirstSize = [self sizeForItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:inSection]];
    CGSize theLastSize = [self sizeForItemAtIndexPath:[NSIndexPath indexPathForRow:theCount - 1 inSection:inSection]];
    CGRect theFrame = CGRectZero;
    
    theFrame.origin = CGPointMake(theLastSize.width / 2.0, kHeaderHeight + theLastSize.height / 2.0);
    theFrame.size = CGSizeMake(theSize.width - theFirstSize.width / 2.0 - theLastSize.width / 2.0,
                               theSize.height - theFirstSize.height / 2.0 - theLastSize.height / 2.0 - kHeaderHeight - kFooterHeight);
    return theFrame;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)inIndexPath {
    UICollectionViewLayoutAttributes *theAttributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:inIndexPath];
    UICollectionView *theView = self.collectionView;
    NSInteger theCount = [theView numberOfItemsInSection:inIndexPath.section];
    CGRect theFrame = [self cellFrameForSection:inIndexPath.section];
    CGSize theSize = theFrame.size;
    CGPoint thePoint;
    
    if(theCount <= 1) {
        thePoint.x = CGRectGetMidX(theFrame);
        thePoint.y = CGRectGetMidY(theFrame);
    }
    else {
        NSInteger theLastIndex = theCount - 1;
        NSInteger theIndex = inIndexPath.row;

        thePoint.x = CGRectGetMaxX(theFrame) - theIndex * theSize.width / theLastIndex;
        thePoint.y = CGRectGetMaxY(theFrame) - theIndex * theSize.height / theLastIndex;
    }
    theAttributes.center = thePoint;
    theAttributes.size = [self sizeForItemAtIndexPath:inIndexPath];
    theAttributes.zIndex = [theView.indexPathsForSelectedItems containsObject:inIndexPath] ? 0 : -inIndexPath.row;
    return theAttributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)inKind
                                                                     atIndexPath:(NSIndexPath *)inIndexPath {
    UICollectionViewLayoutAttributes *theAttributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:inKind withIndexPath:inIndexPath];
    CGSize theSize = [self collectionViewContentSize];
    
    if([UICollectionElementKindSectionHeader isEqualToString:inKind]) {
        theAttributes.frame = CGRectMake(0.0, 0.0, theSize.width, kHeaderHeight);
    }
    else if([UICollectionElementKindSectionFooter isEqualToString:inKind]) {
        theAttributes.frame = CGRectMake(0.0, theSize.height - kFooterHeight, theSize.width, kFooterHeight);
    }
    return theAttributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForDecorationViewOfKind:(NSString *)inKind atIndexPath:(NSIndexPath *)inIndexPath {
    CGFloat theWidth = CGRectGetWidth(self.collectionView.bounds);
    UICollectionViewLayoutAttributes *theAttributes = [UICollectionViewLayoutAttributes layoutAttributesForDecorationViewOfKind:inKind withIndexPath:inIndexPath];
    
    theAttributes.size = CGSizeMake(230.0, 113.0);
    theAttributes.center = CGPointMake(theWidth - 130.0, 114.0);
    return theAttributes;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)inRect {
    NSPredicate *thePredicate = [NSPredicate predicateWithBlock:^BOOL(id inObject, NSDictionary *inBindings) {
        return CGRectIntersectsRect(inRect, [inObject frame]);
    }];
    
    return [self.attributes filteredArrayUsingPredicate:thePredicate];
}

@end
