#import "LayerViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <CoreText/CoreText.h>

@interface LayerViewController()

@property (nonatomic, weak) CAScrollLayer *scrollLayer;

- (IBAction)updateSliderValue:(id)inSender;
- (IBAction)updateMask:(UISwitch *)inSwitch;

@end

static float f(float x) {
    float y = 0;
    float a = 1.0;
    
    for(int i = 0; i < 20; ++i) {
        y += sin(a * x);
        a *= 2.0;
    }
    return 4.0 * y;
}

@implementation LayerViewController

- (void)setUpLayer:(CALayer *)inLayer {
    inLayer.cornerRadius = 10;
    inLayer.masksToBounds = YES;
    inLayer.borderColor = [UIColor darkGrayColor].CGColor;
    inLayer.borderWidth = 1.0;
}

- (CAGradientLayer *)gradientLayerWithFrame:(CGRect)inFrame {
    CAGradientLayer *theLayer = [CAGradientLayer layer];
    NSArray *theColors = @[(id)[UIColor redColor].CGColor,
                           (id)[UIColor greenColor].CGColor,
                           (id)[UIColor blueColor].CGColor];

    [self setUpLayer:theLayer];
    theLayer.frame = inFrame;
    theLayer.colors = theColors;
    theLayer.startPoint = CGPointMake(0.0, 0.0);
    theLayer.endPoint = CGPointMake(1.0, 1.0);
    return theLayer;
}

- (CATextLayer *)textLayerWithFrame:(CGRect)inFrame {
    CATextLayer *theLayer = [CATextLayer layer];
    CGAffineTransform theIdentity = CGAffineTransformIdentity;
    CTFontRef theFont = CTFontCreateWithName((CFStringRef)@"Courier", 24.0, &theIdentity);
    
    [self setUpLayer:theLayer];
    theLayer.frame = inFrame;
    theLayer.font = theFont;
    theLayer.fontSize = 20.0;
    theLayer.backgroundColor = [UIColor whiteColor].CGColor;
    theLayer.foregroundColor = [UIColor blackColor].CGColor;
    theLayer.wrapped = YES;
    theLayer.string = @"Die heiße Zypernsonne quälte Max und Victoria ja böse auf dem Weg bis zur Küste.";
    CFRelease(theFont);
    return theLayer;
}

- (CAScrollLayer *)scrollLayerWithFrame:(CGRect)inFrame {
    CAScrollLayer *theLayer = [CAScrollLayer layer];
    CATextLayer *theTextLayer = [self textLayerWithFrame:CGRectMake(0.0, 0.0, CGRectGetWidth(inFrame), 4 * CGRectGetHeight(inFrame))];
        
    [self setUpLayer:theLayer];
    theLayer.frame = inFrame;
    [theLayer addSublayer:theTextLayer];
    theTextLayer.fontSize *= 2;
    theLayer.scrollMode = kCAScrollVertically;
    return theLayer;
}

- (CAShapeLayer *)shapeLayerWithFrame:(CGRect)inFrame {
    CAShapeLayer *theLayer = [CAShapeLayer layer];
    CGMutablePathRef thePath = CGPathCreateMutable();
    CGFloat theOffset = CGRectGetHeight(inFrame) / 2.0;
    CGFloat theWidth = CGRectGetWidth(inFrame);

    [self setUpLayer:theLayer];
    theLayer.frame = inFrame;
    theLayer.backgroundColor = [UIColor whiteColor].CGColor;
    theLayer.strokeColor = [UIColor blackColor].CGColor;
    theLayer.fillColor = [UIColor clearColor].CGColor;
    theLayer.lineWidth = 1.0;
    CGPathMoveToPoint(thePath, NULL, 0.0, f(0.0) + theOffset);
    for(CGFloat x = 1.0; x < theWidth; x += 1.0) {
        CGPathAddLineToPoint(thePath, NULL, x, f(x * M_PI / theWidth) + theOffset);
    }
    theLayer.path = thePath;
    CGPathRelease(thePath);
    return theLayer;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    CALayer *theLayer = self.view.layer;
    
    self.scrollLayer = [self scrollLayerWithFrame:CGRectMake(10, 190, 300, 80)];
    [theLayer addSublayer:[self gradientLayerWithFrame:CGRectMake(10, 10, 300, 80)]];
    [theLayer addSublayer:[self textLayerWithFrame:CGRectMake(10, 100, 300, 80)]];
    [theLayer addSublayer:self.scrollLayer];
    [theLayer addSublayer:[self shapeLayerWithFrame:CGRectMake(10, 320, 300, 80)]];
}

- (CALayer *)maskWithRect:(CGRect)inRect {
    CGMutablePathRef thePath = CGPathCreateMutable();
    CAShapeLayer *theMask = [CAShapeLayer layer];

    theMask.frame = inRect;
    theMask.fillColor = [UIColor blackColor].CGColor;
    CGPathAddEllipseInRect(thePath, NULL, inRect);
    theMask.path = thePath;
    CGPathRelease(thePath);
    return theMask;
}

- (IBAction)updateSliderValue:(id)inSender {
    CGFloat theOffset = [(UISlider *)inSender value];
    
    [self.scrollLayer scrollPoint:CGPointMake(0.0, theOffset)];
}

- (IBAction)updateMask:(UISwitch *)inSwitch {
    for(CALayer *theLayer in self.view.layer.sublayers) {
        theLayer.mask = inSwitch.on ? [self maskWithRect:theLayer.bounds] : nil;
    }
}

@end
