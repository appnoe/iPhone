//
//  GameAppDelegate.m
//  Games
//
//  Created by Clemens Wagner on 19.08.13.
//  Copyright (c) 2013 Cocoaneheads. All rights reserved.
//

#import "GamesAppDelegate.h"
#import <CoreData/CoreData.h>

@interface GamesAppDelegate()

@property (nonatomic, strong, readwrite) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, strong, readwrite) NSPersistentStoreCoordinator *storeCoordinator;
@property (nonatomic, strong, readwrite) CMMotionManager *motionManager;

@end

@implementation GamesAppDelegate

- (BOOL)application:(UIApplication *)inApplication didFinishLaunchingWithOptions:(NSDictionary *)inLaunchOptions {
    UITabBarController *theTabBarController = (UITabBarController *)self.window.rootViewController;

    self.managedObjectContext = [NSManagedObjectContext new];
    self.managedObjectContext.persistentStoreCoordinator = self.storeCoordinator;
    theTabBarController.customizableViewControllers = theTabBarController.viewControllers;
    self.motionManager = [CMMotionManager new];
    [self.motionManager setAccelerometerUpdateInterval:0.1];
    return YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)inApplication {
    srand48(time(NULL));
}

- (NSURL *)applicationDocumentsURL {
    NSFileManager *theManager = [NSFileManager defaultManager];

    return [[theManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}


- (NSManagedObjectModel *)managedObjectModel {
    if(_managedObjectModel == nil) {
        NSURL *theURL = [[NSBundle mainBundle] URLForResource:@"Games" withExtension:@"mom"];

        self.managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:theURL];
    }
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)storeCoordinator {
    if(_storeCoordinator == nil) {
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
    return _storeCoordinator;
}

@end
