#import "RotationViewController.h"

@implementation RotationViewController

@synthesize rotationControl;

- (void)dealloc {
    self.rotationControl = nil;
    [super dealloc];
}

-(void)viewDidUnload {
    self.rotationControl = nil;
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)inInterfaceOrientation {
    return self.rotationControl.selectedSegmentIndex || inInterfaceOrientation == UIInterfaceOrientationPortrait;
}

@end
