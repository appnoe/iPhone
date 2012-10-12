#import "RotationAppDelegate.h"
#import "RotationViewController.h"

@implementation RotationAppDelegate

@synthesize window;
@synthesize viewController;

- (void)dealloc {
    self.viewController = nil;
    self.window = nil;
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    return YES;
}

@end
