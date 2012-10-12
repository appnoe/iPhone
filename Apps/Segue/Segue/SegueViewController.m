#import "SegueViewController.h"

@interface SegueViewController()

@property (nonatomic, strong) UIPopoverController *popoverController;

@end

@implementation SegueViewController

@synthesize popoverController;

- (void)prepareForSegue:(UIStoryboardSegue *)inSegue sender:(id)inSender {
    if([inSegue respondsToSelector:@selector(popoverController)]) {
        self.popoverController = [(id)inSegue popoverController];
    }
}

- (IBAction)performSegue:(id)inSender {
    [self performSegueWithIdentifier:@"dialog" sender:inSender];
}

@end
