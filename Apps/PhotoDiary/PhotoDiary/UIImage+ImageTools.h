#import <Foundation/Foundation.h>

@interface UIImage(ImageTools)

- (CGSize)sizeToAspectFitInSize:(CGSize)inSize;
- (UIImage *)scaledImageWithSize:(CGSize)inSize;

@end
