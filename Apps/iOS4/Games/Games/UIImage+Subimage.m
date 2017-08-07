//
//  UIImage_Subimage.m
//  Games
//
//  Created by Clemens Wagner on 13.04.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "UIImage+Subimage.h"

@implementation UIImage(Subimage)

- (UIImage *)subimageWithRect:(CGRect)inRect {
    CGImageRef theImage = CGImageCreateWithImageInRect(self.CGImage, inRect);
    UIImage *theResult = [UIImage imageWithCGImage:theImage];
                    
    CGImageRelease(theImage);
    return theResult;
}

- (NSArray *)splitIntoSubimagesWithRows:(NSUInteger)inRows columns:(NSUInteger)inColumns {
    CGSize theSize = self.size;
    CGRect theRect = CGRectMake(0.0, 0.0, 
                                self.scale * theSize.width / inColumns, 
                                self.scale * theSize.height / inRows);
    NSMutableArray *theResult = [NSMutableArray arrayWithCapacity:inRows * inColumns];
    
    theSize = theRect.size;
    for(NSUInteger theRow = 0; theRow < inRows; ++theRow) {
        for(NSUInteger theColumn = 0; theColumn < inColumns; ++theColumn) {
            theRect.origin.x = theSize.width * theColumn;
            theRect.origin.y = theSize.height * theRow;
            [theResult addObject:[self subimageWithRect:theRect]];
        }
    }
    return [theResult copy];
}

@end
