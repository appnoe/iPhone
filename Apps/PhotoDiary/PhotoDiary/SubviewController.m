#import "SubviewController.h"

@implementation SubviewController

@synthesize nibName;
@synthesize delegate;
@synthesize view;

- (void)dealloc {
    self.delegate = nil;
    self.nibName = nil;
    self.view = nil;
    [super dealloc];
}

- (NSString *)nibName {
    if(nibName == nil) {
        self.nibName = NSStringFromClass([self class]);
    }
    return nibName;
}

- (UIView *)view {
    if(view == nil) {
        [self loadView];
    }
    return view;
}

- (void)loadView {
    NSBundle *theBundle = [NSBundle mainBundle];
    
    [theBundle loadNibNamed:self.nibName owner:self options:nil];
}

- (void)addViewToViewController:(UIViewController *)inViewController {
    if(self.view.superview == nil) {
        UIView *theView = inViewController.view;
        
        self.view.frame = theView.bounds;
        [theView addSubview:self.view];
        [self setVisible:NO];
    }
}

- (void)removeView {
    [self.view removeFromSuperview];
}

- (BOOL)visible {
    return self.view.alpha > 0.01;
}

- (void)setVisible:(BOOL)inVisible {
    UIView *theView = self.view;
    SEL theSelector;
    
    theView.frame = theView.superview.bounds;
    if(inVisible) {
        theView.alpha = 1.0;
        theSelector = @selector(subviewControllerWillAppear:);
        [theView.superview bringSubviewToFront:theView];
    }
    else {
        theView.alpha = 0.0;
        theSelector = @selector(subviewControllerWillDisappear:);
    }
    [self clear];
    if([self.delegate respondsToSelector:theSelector]) {
        [self.delegate performSelector:theSelector withObject:self];
    }
}

- (void)setVisible:(BOOL)inVisible animated:(BOOL)inAnimated {
    if(inAnimated) {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:1.0];
        self.visible = inVisible;
        [UIView commitAnimations];
    }
    else {
        self.visible = inVisible;
    }
}

- (IBAction)clear {
}

@end
