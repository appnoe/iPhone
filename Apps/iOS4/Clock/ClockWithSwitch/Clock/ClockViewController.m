#import "ClockViewController.h"
#import "ClockView.h"

@implementation ClockViewController

@synthesize clockView;
@synthesize clockSwitch;

- (void)dealloc {
    self.clockView = nil;
    self.clockSwitch = nil;
    [super dealloc];
}

- (void)viewDidUnload {
    self.clockView = nil;
    self.clockSwitch = nil;
    [super viewDidUnload];
}

- (void)viewDidAppear:(BOOL)inAnimated {
    [super viewDidAppear:inAnimated];
    if(self.clockSwitch.on) {
        [self.clockView startAnimation];
    }
}

- (void)viewWillDisappear:(BOOL)inAnimated {
    [super viewWillDisappear:inAnimated];
    [self.clockView stopAnimation];        
}

- (IBAction)switchAnimation:(UISwitch *)inSender {
    if(inSender.on) {
        [self.clockView startAnimation];
    }
    else {
        [self.clockView stopAnimation];        
    }
}

@end
