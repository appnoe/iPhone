#import "UIView+MirrorImage.h"
#import <QuartzCore/QuartzCore.h>

@interface CALayer(MirrorImage)

- (void)setAllNeedsDisplay;

@end

@implementation UIView(MirrorImage)

- (UIImage *)mirroredImageWithScale:(CGFloat)inScale {
    CALayer *theLayer = self.layer;
    CALayer *thePresentationLayer = [theLayer presentationLayer];
    CGRect theFrame = self.frame;
    CGSize theSize = theFrame.size;
    CGContextRef theContext;
    UIImage *theImage;
    
    if(thePresentationLayer) {
        theLayer = thePresentationLayer;
    }
    UIGraphicsBeginImageContext(theSize);
    theContext = UIGraphicsGetCurrentContext();
    CGContextScaleCTM(theContext, 1.0, -inScale);
    CGContextTranslateCTM(theContext, 0.0, -theSize.height);
    [theLayer setAllNeedsDisplay];
    [theLayer renderInContext:theContext];
    theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

- (CGImageRef)createGradientImageWithSize:(CGSize)inSize gray:(float)inGray {
	CGImageRef theImage = NULL;
    CGColorSpaceRef theColorSpace = CGColorSpaceCreateDeviceGray();
	CGContextRef theContext = CGBitmapContextCreate(NULL, inSize.width, inSize.height,
                                                    8, 0, theColorSpace, kCGImageAlphaNone);
	CGFloat theColors[] = {inGray, 1.0, 0.0, 1.0};
	CGGradientRef theGradient = CGGradientCreateWithColorComponents(theColorSpace, theColors, NULL, 2);
	CGContextDrawLinearGradient(theContext, theGradient,
								CGPointZero, CGPointMake(0, inSize.height), 
                                kCGGradientDrawsAfterEndLocation);
    
	CGColorSpaceRelease(theColorSpace);	
	CGGradientRelease(theGradient);
	theImage = CGBitmapContextCreateImage(theContext);
	CGContextRelease(theContext);
    return theImage;
}

- (void)drawMirrorWithScale:(CGFloat)inScale {
    CGRect theFrame = self.frame;
    CGSize theSize = theFrame.size;
    CGPoint thePoint = CGPointMake(CGRectGetMinX(theFrame), CGRectGetMaxY(theFrame));
    CGFloat theHeight = theSize.height * inScale;
    CGImageRef theGradient = [self createGradientImageWithSize:CGSizeMake(1.0, theHeight) gray:0.8];
    CGContextRef theContext = UIGraphicsGetCurrentContext();
    UIImage *theImage = [self mirroredImageWithScale:inScale];
    CGRect theRect;
    
    theRect.origin = thePoint;
    theRect.size = theSize;
    CGContextSaveGState(theContext);
    CGContextClipToMask(theContext, theRect, theGradient);
    [theImage drawAtPoint:thePoint];
    CGImageRelease(theGradient);
    CGContextRestoreGState(theContext);
}

@end

@implementation CALayer(MirrorImage)

- (void)setAllNeedsDisplay {
    if(self.contents == nil) {
        [self setNeedsDisplay];
    }
    for(id theLayer in self.sublayers) {
        [theLayer setAllNeedsDisplay];
    }
}

@end