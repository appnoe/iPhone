#import "GamesAppDelegate.h"
#import <CoreData/CoreData.h>

@interface GamesAppDelegate()

@property (nonatomic, strong, readwrite) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, strong, readwrite) NSPersistentStoreCoordinator *storeCoordinator;

@end

@implementation GamesAppDelegate

@synthesize window;
@synthesize viewController;
@synthesize managedObjectContext;

@synthesize managedObjectModel;
@synthesize storeCoordinator;


- (BOOL)application:(UIApplication *)inApplication didFinishLaunchingWithOptions:(NSDictionary *)inLaunchOptions {
    self.managedObjectContext.persistentStoreCoordinator = self.storeCoordinator;
    self.viewController.customizableViewControllers = self.viewController.viewControllers;
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)inApplication {
    srand((unsigned) [NSDate timeIntervalSinceReferenceDate]);
}

- (NSURL *)applicationDocumentsURL {
    NSFileManager *theManager = [NSFileManager defaultManager];
    
    return [[theManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}


- (NSManagedObjectModel *)managedObjectModel {
    if(managedObjectModel == nil) {
        NSURL *theURL = [[NSBundle mainBundle] URLForResource:@"Games" withExtension:@"momd"];
        
        self.managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:theURL];    
    }
    return managedObjectModel;
}

- (NSPersistentStoreCoordinator *)storeCoordinator {
    if(storeCoordinator == nil) {
        NSURL *theURL = [[self applicationDocumentsURL] URLByAppendingPathComponent:@"Games.sqlite"];
        NSError *theError = nil;
        NSPersistentStoreCoordinator *theCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];
        
        if ([theCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil 
                                                   URL:theURL options:nil error:&theError]) {
            self.storeCoordinator = theCoordinator;
        }
        else {
            NSLog(@"storeCoordinator: %@", theError);
        }
    }
    return storeCoordinator;
}

@end
