#import "SecurePhotoDiaryAppDelegate.h"
#import "PhotoDiaryViewController.h"
#import "SecUtils.h"

@interface SecurePhotoDiaryAppDelegate()

@property (nonatomic, readwrite) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, readwrite) NSPersistentStoreCoordinator *storeCoordinator;

@end

@implementation SecurePhotoDiaryAppDelegate

@synthesize window;
@synthesize overviewButton;
@synthesize viewController;
@synthesize managedObjectContext;

@synthesize managedObjectModel;
@synthesize storeCoordinator;

- (BOOL)application:(UIApplication *)inApplication didFinishLaunchingWithOptions:(NSDictionary *)inLaunchOptions {
    [SecUtils checkJailbreak];
    self.managedObjectContext = [[NSManagedObjectContext alloc] init];
    self.managedObjectContext.persistentStoreCoordinator = self.storeCoordinator;
    self.viewController = self.window.rootViewController;
    if([self.viewController isKindOfClass:[UISplitViewController class]]) {
        UISplitViewController *theController = (UISplitViewController *)self.viewController;
        UINavigationController *theDetailController = theController.viewControllers.lastObject;
        
        theController.delegate = [theDetailController.viewControllers objectAtIndex:0];
    }
    return YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)inApplication {
    srand((unsigned) [NSDate timeIntervalSinceReferenceDate]);
}


- (void)applicationDidEnterBackground:(UIApplication *)inApplication{
    NSLog(@"[+] %@", NSStringFromSelector(_cmd));
    UIViewController *vc = [[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil] instantiateViewControllerWithIdentifier:@"Login"];
    [vc setModalPresentationStyle:UIModalPresentationFullScreen];
    [self.viewController presentModalViewController:vc animated:YES];
}

- (NSURL *)applicationDocumentsURL {
    NSFileManager *theManager = [NSFileManager defaultManager];
    
    return [[theManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}


- (NSManagedObjectModel *)managedObjectModel {
    if(managedObjectModel == nil) {
        NSURL *theURL = [[NSBundle mainBundle] URLForResource:@"Model" withExtension:@"momd"];
        
        self.managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:theURL];    
    }
    return managedObjectModel;
}

- (NSPersistentStoreCoordinator *)storeCoordinator {
    if(storeCoordinator == nil) {
        NSURL *theURL = [[self applicationDocumentsURL] URLByAppendingPathComponent:@"Diary.sqlite"];
        NSError *theError = nil;
        NSPersistentStoreCoordinator *theCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];
        NSDictionary *fileAttributes = [NSDictionary dictionaryWithObject:NSFileProtectionComplete forKey:NSFileProtectionKey];
        [[NSFileManager defaultManager] setAttributes:fileAttributes ofItemAtPath:[theURL absoluteString] error:&theError];
        
        if ([theCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil 
                                                   URL:theURL options:nil error:&theError]) {
            self.storeCoordinator = theCoordinator;
            [[NSFileManager defaultManager] fileExistsAtPath:[theURL path]];
            BOOL result = [theURL setResourceValue:[NSNumber numberWithBool: YES]
                                            forKey:NSURLIsExcludedFromBackupKey error: &theError];
            if(!result){
                NSLog(@"Fehler beim Schützen der Datenbank: %@ / %@", [theURL lastPathComponent], theError);
            }
        }
        else {
            NSLog(@"storeCoordinator: %@", theError);
        }
    }
    return storeCoordinator;
}

- (void)showPhotoDiaryViewController:(id)inSender {
    
}

@end
