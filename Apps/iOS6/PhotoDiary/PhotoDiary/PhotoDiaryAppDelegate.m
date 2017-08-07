//
//  PhotoDiaryAppDelegate.m
//  PhotoDiary
//
//  Created by Clemens Wagner on 10.09.13.
//  Copyright (c) 2013 Cocoaneheads. All rights reserved.
//

#import "PhotoDiaryAppDelegate.h"

#import "PhotoDiaryViewController.h"
#import "NSFileManager+StandardDirectories.h"

@interface PhotoDiaryAppDelegate()

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (strong, nonatomic) UIStoryboard *storyboard;

- (NSURL *)persistentStoreURL;

@end

@implementation PhotoDiaryAppDelegate

- (BOOL)application:(UIApplication *)inApplication didFinishLaunchingWithOptions:(NSDictionary *)inOptions {
    UINavigationController *theNavigationController = (UINavigationController *)self.window.rootViewController;
    PhotoDiaryViewController *theController = (PhotoDiaryViewController *)theNavigationController.topViewController;

    theController.managedObjectContext = self.managedObjectContext;
    self.storyboard = theNavigationController.storyboard;
    return YES;
}

- (UIViewController *)topViewController {
    UINavigationController *theController = (UINavigationController *)self.window.rootViewController;

    return theController.topViewController;
}

#pragma mark - Core Data stack

- (NSURL *)persistentStoreURL {
    NSString *theDirectory = [[NSFileManager defaultManager] applicationSupportDirectory];
    NSString *theFile = [theDirectory stringByAppendingPathComponent:@"Diary.sql"];

    return [NSURL fileURLWithPath:theFile];
}

- (NSManagedObjectModel *)managedObjectModel {
    if (_managedObjectModel == nil) {
        NSURL *theURL = [[NSBundle mainBundle] URLForResource:@"PhotoDiary" withExtension:@"momd"];

        _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:theURL];
    }
    return _managedObjectModel;
}

- (NSManagedObjectContext *)managedObjectContext {
    if (_managedObjectContext == nil) {
        NSPersistentStoreCoordinator *theCoordinator = self.persistentStoreCoordinator;

        if(theCoordinator != nil) {
            _managedObjectContext = [[NSManagedObjectContext alloc] init];
            _managedObjectContext.persistentStoreCoordinator = theCoordinator;
        }
    }
    return _managedObjectContext;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if(_persistentStoreCoordinator == nil) {
        NSURL *theURL = self.persistentStoreURL;
        NSError *theError = nil;
        NSPersistentStoreCoordinator *theCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];

        if([theCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:theURL options:nil error:&theError]) {
            self.persistentStoreCoordinator = theCoordinator;
        }
        else {
            NSLog(@"Error: %@", theError);
        }
    }
    return _persistentStoreCoordinator;
}
@end
