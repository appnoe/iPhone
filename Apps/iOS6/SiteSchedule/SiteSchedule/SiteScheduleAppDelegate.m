//
//  ShopAppDelegate.m
//  Shop
//
//  Created by Clemens Wagner on 29.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>

#import "SiteScheduleAppDelegate.h"
#import "SiteScheduleParser.h"
#import "Reachability.h"

@interface SiteScheduleAppDelegate()

@property (nonatomic, strong, readwrite) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, strong, readwrite) NSPersistentStoreCoordinator *storeCoordinator;
@property (nonatomic, strong, readwrite) Reachability *reachability;

@end

@implementation SiteScheduleAppDelegate

@synthesize window;
@synthesize viewController;
@synthesize managedObjectModel;
@synthesize storeCoordinator;
@synthesize reachability;

- (BOOL)application:(UIApplication *)inApplication didFinishLaunchingWithOptions:(NSDictionary *)inOptions {
    self.reachability = [Reachability reachabilityWithHostName:@"0.0.0.0"];
    [self.reachability startNotifier];
    return YES;
}

#pragma mark Core Data Initialisierung

- (NSURL *)applicationDocumentsURL {
    NSFileManager *theManager = [NSFileManager defaultManager];
    
    return [[theManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSURL *)applicationSupportURL {
    NSFileManager *theManager = [NSFileManager defaultManager];
    
    return [[theManager URLsForDirectory:NSApplicationSupportDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    if(managedObjectModel == nil) {
        NSURL *theURL = [[NSBundle mainBundle] URLForResource:@"SiteSchedule" withExtension:@"mom"];
        
        self.managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:theURL];    
    }
    return managedObjectModel;
}

- (NSPersistentStoreCoordinator *)storeCoordinator {
    if(storeCoordinator == nil) {
        NSURL *theURL = [[self applicationDocumentsURL] URLByAppendingPathComponent:@"SiteSchedule.sqlite"];
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

- (NSError *)updateWithInputStream:(NSInputStream *)inoutStream {
    NSManagedObjectContext *theContext = [[NSManagedObjectContext alloc] init];
    NSXMLParser *theParser = [[NSXMLParser alloc] initWithStream:inoutStream];
    SiteScheduleParser *theDelegate = [[SiteScheduleParser alloc] initWithManagedObjectContext:theContext];
    
    theContext.persistentStoreCoordinator = self.storeCoordinator;
    theParser.shouldProcessNamespaces = YES;
    theParser.shouldReportNamespacePrefixes = YES;
    theParser.delegate = theDelegate;
    [theParser parse];
    [inoutStream close];
    return theDelegate.error;
}

@end
