//
//  ShopAppDelegate.h
//  Shop
//
//  Created by Clemens Wagner on 29.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@class Reachability;

@interface SiteScheduleAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UITabBarController *viewController;

@property (nonatomic, strong, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, strong, readonly) NSPersistentStoreCoordinator *storeCoordinator;
@property (nonatomic, strong, readonly) Reachability *reachability;

- (NSError *)updateWithInputStream:(NSInputStream *)inStream;

@end
