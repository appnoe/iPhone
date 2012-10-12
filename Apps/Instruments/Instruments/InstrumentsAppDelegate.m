#import "InstrumentsAppDelegate.h"
#import "InstrumentsViewController.h"

@implementation InstrumentsAppDelegate

@synthesize window;
@synthesize viewController;

- (void)dealloc {
    self.window = nil;
    self.viewController = nil;
    [super dealloc];
}

- (BOOL)application:(UIApplication *)inApplication didFinishLaunchingWithOptions:(NSDictionary *)inLaunchOptions {
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    return YES;
}

@end
