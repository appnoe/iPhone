#import "RetinaViewController.h"

@implementation RetinaViewController
@synthesize displayLabel;

- (void)dealloc {
    self.displayLabel = nil;
    [super dealloc];
}
- (void)viewDidUnload {
    self.displayLabel = nil;
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)inAnimated {
    [super viewWillAppear:inAnimated];
    float theScale = [[UIScreen mainScreen] scale];

    self.displayLabel.text = [NSString stringWithFormat:@"scale = %.2f (%@)", 
                              theScale, theScale > 1.0 ? @"Retina" : @"Normal"];
}

@end
