#import "TableViewAppDelegate.h"

@implementation TableViewAppDelegate

@synthesize window;
@synthesize viewController;

- (BOOL)application:(UIApplication *)inApplication didFinishLaunchingWithOptions:(NSDictionary *)inLaunchOptions {
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)dealloc {
    self.viewController = nil;
    self.window = nil;
    [super dealloc];
}

@end
