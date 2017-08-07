#import "ClockViewController.h"
#import "ClockView.h"

@implementation ClockViewController

@synthesize clockView;
@synthesize switchButton;

- (void)dealloc {
    self.clockView = nil;
    self.switchButton = nil;
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *theTitle = [switchButton titleForState:UIControlStateHighlighted];
    
    [self.switchButton setTitle:theTitle
                       forState:UIControlStateSelected |
                                UIControlStateHighlighted];
}

- (void)viewDidUnload {
    self.clockView = nil;
    self.switchButton = nil;
    [super viewDidUnload];
}

- (void)viewDidAppear:(BOOL)inAnimated {
    [super viewDidAppear:inAnimated];
}

- (void)viewWillDisappear:(BOOL)inAnimated {
    [super viewWillDisappear:inAnimated];
}

- (IBAction)switchAnimation:(UIButton *)inSender {
    inSender.selected = !inSender.selected;
    if(inSender.selected) {
        [self.clockView startAnimation];
    }
    else {
        [self.clockView stopAnimation];        
    }
}

@end
