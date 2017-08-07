//
//  TiledImageView.m
//  ScrollView
//
//  Created by Clemens Wagner on 09.09.12.
//
//

#import "TiledImageView.h"
#import <QuartzCore/QuartzCore.h>

#define USE_DELEGATION 0

@implementation TiledImageView

const static CGFloat kImageWidth = 320.0;
const static CGFloat kImageHeight = 170.0;

+ (Class)layerClass {
    return [CATiledLayer class];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    CATiledLayer *theLayer = (CATiledLayer *)self.layer;
    
    theLayer.tileSize = CGSizeMake(kImageWidth, kImageHeight);
}

- (void)drawRect:(CGRect)inRect {
    CGRect theTileFrame = CGRectMake(0.0, 0.0, kImageWidth, kImageHeight);
    NSBundle *theBundle = [NSBundle mainBundle];
    
    NSLog(@"drawRect:%@", NSStringFromCGRect(inRect));
    for(NSUInteger i = 0; i < 5; ++i) {
        for(NSUInteger j = 0; j < 4; ++j) {
            theTileFrame.origin.x = j * kImageWidth;
            theTileFrame.origin.y = i * kImageHeight;
            
            if(CGRectIntersectsRect(inRect, theTileFrame)) {
                NSString *theFile = [NSString stringWithFormat:@"flower_%ux%u", i, j];
                NSString *thePath = [theBundle pathForResource:theFile ofType:@"jpg"];
                UIImage *theImage = [UIImage imageWithContentsOfFile:thePath];
                
                [theImage drawAtPoint:theTileFrame.origin];
            }
        }
    }
}

#if USE_DELEGATION
- (void)drawLayer:(CALayer *)inLayer inContext:(CGContextRef)inContext {
    CGContextSaveGState(inContext);
    CGContextScaleCTM(inContext, 1.0, -1.0);
    CGContextTranslateCTM(inContext, 0.0, -CGRectGetHeight(self.bounds));
    
    CGRect theRect = CGContextGetClipBoundingBox(inContext);
    CGRect theTileFrame = CGRectMake(0.0, 0.0, kImageWidth, kImageHeight);
    NSBundle *theBundle = [NSBundle mainBundle];
    
    NSLog(@"drawLayer:inContext:%@", NSStringFromCGRect(theRect));
    for(NSUInteger i = 0; i < 5; ++i) {
        for(NSUInteger j = 0; j < 4; ++j) {
            theTileFrame.origin.x = j * kImageWidth;
            theTileFrame.origin.y = i * kImageHeight;
            
            if(CGRectIntersectsRect(theRect, theTileFrame)) {
                NSString *theFile = [NSString stringWithFormat:@"flower_%ux%u", 4 - i, j];
                NSString *thePath = [theBundle pathForResource:theFile ofType:@"jpg"];
                UIImage *theImage = [UIImage imageWithContentsOfFile:thePath];
                
                CGContextDrawImage(inContext, theTileFrame, theImage.CGImage);
            }
        }
    }
    CGContextRestoreGState(inContext);
}
#endif

@end
