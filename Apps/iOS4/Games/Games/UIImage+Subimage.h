//
//  UIImage_Subimage.h
//  Games
//
//  Created by Clemens Wagner on 13.04.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Subimage)

- (UIImage *)subimageWithRect:(CGRect)inRect;
- (NSArray *)splitIntoSubimagesWithRows:(NSUInteger)inRows columns:(NSUInteger)inColumns;

@end
