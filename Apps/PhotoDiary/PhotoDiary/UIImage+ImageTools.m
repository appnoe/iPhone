#import "UIImage+ImageTools.h"

@implementation UIImage(ImageTools)

- (CGSize)sizeToAspectFitInSize:(CGSize)inSize {
    CGSize theSize = self.size;
    CGFloat theWidthFactor = inSize.width / theSize.width;
    CGFloat theHeightFactor = inSize.height / theSize.height;
    CGFloat theFactor = fmin(theWidthFactor, theHeightFactor);
    
    return CGSizeMake(theSize.width * theFactor, theSize.height * theFactor);
}

- (UIImage *)scaledImageWithSize:(CGSize)inSize {
    CGRect theFrame = CGRectMake(0.0, 0.0, inSize.width, inSize.height);
    UIImage *theImage;
    
    UIGraphicsBeginImageContext(inSize);
    [self drawInRect:theFrame];
    theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

@end
