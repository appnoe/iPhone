#import "DigitView.h"
#import <QuartzCore/QuartzCore.h>

static NSString * const kDigitKey = @"digit";

@interface DigitLayer : CALayer

@property (nonatomic) CGFloat digit;

@end

@interface DigitView()

@property (nonatomic, strong) NSNumber *fromValue;

@end


@implementation DigitView

@synthesize font;
@synthesize fromValue;

+ (id)layerClass {
    return [DigitLayer class];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.clipsToBounds = YES;
    self.font = [UIFont fontWithName:@"Helvetica-Bold" size:32.0];
}

- (NSUInteger)digit {
    NSInteger theDigit = roundf([(DigitLayer *)self.layer digit]);

    theDigit %= 10;
    return theDigit < 0 ? theDigit + 10 : theDigit;
}

- (void)setDigit:(NSUInteger)inDigit {
    NSInteger theOldDigit = self.digit;
    NSInteger theNewDigit = inDigit % 10;

    if(theOldDigit == 9 && theNewDigit == 0) {
        theOldDigit = -1;
    }
    else if(theOldDigit == 0 && theNewDigit == 9) {
        theOldDigit = 10;
    }
    self.fromValue = [NSNumber numberWithInt:theOldDigit];
    [(DigitLayer *)self.layer setDigit:theNewDigit];
}

- (void)drawRect:(CGRect)inRect {
}

- (void)drawLayer:(CALayer *)inLayer inContext:(CGContextRef)inContext {
    CGRect theBounds = self.bounds;
    CGSize theSize = theBounds.size;
    CGFloat theDigit = [(DigitLayer *)inLayer digit];
    UIFont *theFont = self.font;
    CGSize theFontSize = [@"0" sizeWithFont:theFont];
    CGFloat theX = (theSize.width - theFontSize.width) / 2.0;
    CGFloat theY = (theFont.capHeight - theSize.height) / 2.0;
    
    theY -= theDigit * theSize.height;
    CGContextSaveGState(inContext);
    CGContextClipToRect(inContext, theBounds);
    CGContextSetFillColorWithColor(inContext, self.backgroundColor.CGColor);
    CGContextFillRect(inContext, theBounds);
    CGContextSetRGBFillColor(inContext, 0.0, 0.0, 0.0, 1.0);
    CGContextSetRGBStrokeColor(inContext, 0.0, 0.0, 0.0, 1.0);
    CGContextSelectFont(inContext, [theFont.fontName cStringUsingEncoding:NSMacOSRomanStringEncoding], 
                        theFont.pointSize, kCGEncodingMacRoman);
    CGContextSetTextMatrix(inContext, CGAffineTransformMakeScale(1.0, -1.0));
    for(int i = 9; i <= 20; ++i) {
        char theCharacter = '0' + (i % 10);
        
        CGContextShowTextAtPoint(inContext, theX, theY, &theCharacter, 1);
        theY += theSize.height;
    }
    CGContextRestoreGState(inContext);
    [self.superview setNeedsDisplay];
}

- (id<CAAction>)actionForLayer:(CALayer *)inLayer forKey:(NSString *)inKey {
    if([kDigitKey isEqualToString:inKey]) {
        CABasicAnimation *theAnimation = (id)[inLayer actionForKey:@"opacity"];
        
        theAnimation.keyPath = inKey;
        theAnimation.fromValue = self.fromValue;
        theAnimation.toValue = nil;
        theAnimation.byValue = nil;
        return theAnimation;
    }
    else {
        return [super actionForLayer:inLayer forKey:inKey];
    }    
}

@end

@implementation DigitLayer

@dynamic digit;

+ (id)defaultValueForKey:(NSString *)inKey {
    return [inKey isEqualToString:kDigitKey] ? [NSNumber numberWithFloat:0.0] : [super defaultValueForKey:inKey];
}

+ (BOOL)needsDisplayForKey:(NSString *)inKey {
    return [inKey isEqualToString:kDigitKey] || [super needsDisplayForKey:inKey];
}

@end

