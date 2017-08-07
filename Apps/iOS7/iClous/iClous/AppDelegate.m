//
//  AppDelegate.m
//  iClous
//
//  Created by Klaus Rodewig on 11.10.13.
//  Copyright (c) 2013 KMR. All rights reserved.
//

#import "AppDelegate.h"
#import "CryptoUtils.h"

NSString *const CLOUDKEY = @"iClous";

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    self.theCloud = NO;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        self.iCloudPath = [[NSFileManager defaultManager] URLForUbiquityContainerIdentifier:nil];
        if (self.iCloudPath) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"iCloud-Verzeichnis: %@", self.iCloudPath);
                self.theCloud = YES;
                
                NSString *theLocalText = @"Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua.";
                
                // Key Value Store
                NSUbiquitousKeyValueStore *cloudStore = [NSUbiquitousKeyValueStore defaultStore];
                if([[cloudStore stringForKey:CLOUDKEY] length] == 0){
                    NSLog(@"Kein Text in der Cloud gefunden");
                    [cloudStore setString:theLocalText forKey:CLOUDKEY];
                    [cloudStore synchronize];
                } else {
                    NSLog(@"Die Cloud sagt: %@", [cloudStore stringForKey:CLOUDKEY]);
                }
                
                // Verschlüsselte Datenablage über Key Value Store
                CryptoUtils *theCrypt = [[CryptoUtils alloc] initWithPassword:@"4711"];
                NSData *ciphertext = [theCrypt encryptData:[theLocalText dataUsingEncoding:NSUTF8StringEncoding]];
                NSLog(@"Ciphertext: %@", ciphertext);
                // verschlüsselte Daten in der Cloud ablegen
                [cloudStore setData:theCrypt.salt forKey:@"Salt"];
                [cloudStore setData:theCrypt.iv forKey:@"IV"];
                [cloudStore setData:ciphertext forKey:@"Secret"];
                
                // Dateiablage
                NSError *theError;
                
                NSString *cloudFile = [NSString stringWithFormat:@"%@/%@", [self.iCloudPath path], @"foobar.txt"];
                NSString *theCloudString = [NSString stringWithFormat:@"%@: %@", [NSDate date], theLocalText];
                
                NSLog(@"cloudFile: %@", cloudFile);
                [theCloudString writeToFile:cloudFile
                                 atomically:YES
                                   encoding:NSUTF8StringEncoding
                                      error:&theError];
                if(theError){
                    NSLog(@"Fehler beim Speichern: %@", [theError localizedDescription]);
                }
            });
        }
        else {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"No iCloud");
                [self setTheCloud:NO];
            });
        }
    });
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
