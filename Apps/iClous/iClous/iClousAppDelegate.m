//
//  iclousAppDelegate.m
//  iclous
//
//  Created by Klaus M. Rodewig on 02.07.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "iclousAppDelegate.h"

@implementation iclousAppDelegate

@synthesize window = window;

-(void)showDeviceData
{
    NSLog(@"[+] %@", NSStringFromSelector(_cmd));
    NSMutableString *thisText = [[NSMutableString alloc] init];
    [thisText appendString:@"UDID: "];
    [thisText appendString:thisDevice.udid];
    [thisText appendString:@"\n"];
    [thisText appendString:@"IP: "];
    [thisText appendString:thisDevice.thisDevicesExternalIpEvenBehindARouter];
    [thisText appendString:@"\n"];
    [thisText appendString:@"Location: "];
    [thisText appendString:thisDevice.location];
    [thisText appendString:@"\n"];
    [thisText appendString:@"Name: "];
    [thisText appendString:thisDevice.name];
    [thisText appendString:@"\n"];
    [thisText appendString:@"SystemName: "];
    [thisText appendString:thisDevice.systemName];
    [thisText appendString:@"\n"];
    [thisText appendString:@"SystemVersion: "];
    [thisText appendString:thisDevice.systemVersion];
    [thisText appendString:@"\n"];
    [thisText appendString:@"Model: "];
    [thisText appendString:thisDevice.model];
    [thisText appendString:@"\n"];
    thisTextView.text = thisText;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSLog(@"[+] %@", NSStringFromSelector(_cmd));
    
    window = [[UIWindow alloc] initWithFrame:[[UIScreen  mainScreen] bounds]];
	CGRect	rectFrame = [UIScreen mainScreen].applicationFrame;
	thisTextView  = [[UITextView alloc] initWithFrame:rectFrame];
	thisTextView.editable = NO;
    [window addSubview:thisTextView];
    [window makeKeyAndVisible];
    
    thisDevice = [[DeviceInfo alloc] initWithDeviceData];
    [thisDevice getExternalIp];
    // Location Manager initiieren
    cllMgr = [[CLLocationManager alloc] init];
	cllMgr.delegate = self;
	[cllMgr startUpdatingLocation];
    cnt = 0;
    
    return YES;
}


- (void)locationManager:(CLLocationManager *)manager 
	didUpdateToLocation:(CLLocation *)newLocation 
		   fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"[+] %@", NSStringFromSelector(_cmd));
    NSString *userLoc = [NSString stringWithFormat:@"%f:%f", newLocation.coordinate.latitude, newLocation.coordinate.longitude];
    NSLog(@"[+] userLoc: %@", userLoc);
    cnt++;
    // #### ggf. sinnvolle Abbruchbedingung definieren
    if(cnt<=1){
        thisDevice.location=userLoc;
    }
    else
    {
        [cllMgr stopUpdatingLocation];
        [self showDeviceData];
        [thisDevice dumpDeviceInfo];
    }
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

@end
