#import "LayerViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <CoreText/CoreText.h>

@interface LayerViewController()

@property (nonatomic, retain) CAScrollLayer *scrollLayer;

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

@synthesize scrollLayer;

- (void)dealloc {
    self.scrollLayer = nil;
    [super dealloc];
}

- (void)setUpLayer:(CALayer *)inLayer withFrame:(CGRect)inFrame {
    inLayer.frame = inFrame;
    inLayer.cornerRadius = 10;
    inLayer.masksToBounds = YES;
    inLayer.borderColor = [UIColor darkGrayColor].CGColor;
    inLayer.borderWidth = 1.0;
}

- (CAGradientLayer *)gradientLayerWithFrame:(CGRect)inFrame {
    CAGradientLayer *theLayer = [[CAGradientLayer alloc] init];
    NSArray *theColors = [NSArray arrayWithObjects:(id)[UIColor redColor].CGColor, 
                          [UIColor greenColor].CGColor, [UIColor blueColor].CGColor, nil];

    [self setUpLayer:theLayer withFrame:inFrame];
    theLayer.colors = theColors;
    theLayer.startPoint = CGPointMake(0.0, 0.0);
    theLayer.endPoint = CGPointMake(1.0, 1.0);
    return [theLayer autorelease];
}

- (CATextLayer *)textLayerWithFrame:(CGRect)inFrame {
    CATextLayer *theLayer = [[CATextLayer alloc] init];
    CGAffineTransform theIdentity = CGAffineTransformIdentity;
    CTFontRef theFont = CTFontCreateWithName((CFStringRef)@"Courier", 24.0, &theIdentity);
    
    [self setUpLayer:theLayer withFrame:inFrame];
    theLayer.font = theFont;
    theLayer.fontSize = 20.0;
    theLayer.backgroundColor = [UIColor whiteColor].CGColor;
    theLayer.foregroundColor = [UIColor blackColor].CGColor;
    theLayer.wrapped = YES;
    theLayer.string = @"Die heiße Zypernsonne quälte Max und Victoria ja böse auf dem Weg bis zur Küste.";
    CFRelease(theFont);
    return [theLayer autorelease];
}

- (CAScrollLayer *)scrollLayerWithFrame:(CGRect)inFrame {
    CAScrollLayer *theLayer = [[CAScrollLayer alloc] init];
    CATextLayer *theTextLayer = [self textLayerWithFrame:CGRectMake(0.0, 0.0, CGRectGetWidth(inFrame), 4 * CGRectGetHeight(inFrame))];
        
    [self setUpLayer:theLayer withFrame:inFrame];
    [theLayer addSublayer:theTextLayer];
    theTextLayer.fontSize *= 2;
    theLayer.scrollMode = kCAScrollVertically;
    return [theLayer autorelease];
}

- (CAShapeLayer *)shapeLayerWithFrame:(CGRect)inFrame {
    CAShapeLayer *theLayer = [[CAShapeLayer alloc] init];
    CGMutablePathRef thePath = CGPathCreateMutable();
    CGAffineTransform theIdentity = CGAffineTransformIdentity;
    CGFloat theOffset = CGRectGetHeight(inFrame) / 2.0;
    CGFloat theWidth = CGRectGetWidth(inFrame);

    [self setUpLayer:theLayer withFrame:inFrame];
    theLayer.backgroundColor = [UIColor whiteColor].CGColor;
    theLayer.strokeColor = [UIColor blackColor].CGColor;
    theLayer.fillColor = [UIColor clearColor].CGColor;
    theLayer.lineWidth = 1.0;
    CGPathMoveToPoint(thePath, &theIdentity, 0.0, f(0.0) + theOffset);
    for(float x = 1.0; x < theWidth; x += 1.0) {
        CGPathAddLineToPoint(thePath, &theIdentity, x, f(x * M_PI / theWidth) + theOffset);
    }
    theLayer.path = thePath;
    CGPathRelease(thePath);
    return [theLayer autorelease];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    CALayer *theLayer = self.view.layer;
    
    self.scrollLayer = [self scrollLayerWithFrame:CGRectMake(10, 190, 300, 80)];
    [theLayer addSublayer:[self gradientLayerWithFrame:CGRectMake(10, 10, 300, 80)]];
    [theLayer addSublayer:[self textLayerWithFrame:CGRectMake(10, 100, 300, 80)]];
    [theLayer addSublayer:self.scrollLayer];
    [theLayer addSublayer:[self shapeLayerWithFrame:CGRectMake(10, 310, 300, 80)]];
}

- (void)viewDidUnload {
    self.scrollLayer = nil;
    [super viewDidUnload];
}

- (IBAction)updateSliderValue:(id)inSender {
    CGFloat theOffset = [(UISlider *)inSender value];
    
    [self.scrollLayer scrollPoint:CGPointMake(0.0, theOffset)];
}

@end
