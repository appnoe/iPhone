#import "BarsViewController.h"

@implementation BarsViewController
@synthesize toolbar;

- (void)dealloc {
    self.toolbar = nil;
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.toolbarItems = self.toolbar.items;
}

- (void)viewDidUnload {
    self.toolbar = nil;
    [super viewDidUnload];
}

@end
