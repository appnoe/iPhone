#import "AnimationAppDelegate.h"
#import "AnimationViewController.h"

@implementation AnimationAppDelegate

@synthesize window;
@synthesize viewController;

- (void)dealloc {
    self.viewController = nil;
    self.window = nil;
    [super dealloc];
}
- (BOOL)application:(UIApplication *)inApplication didFinishLaunchingWithOptions:(NSDictionary *)inLaunchOptions {
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    return YES;
}

@end
