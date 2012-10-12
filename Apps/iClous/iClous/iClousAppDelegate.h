//
//  iclousAppDelegate.h
//  iclous
//
//  Created by Klaus M. Rodewig on 02.07.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "DeviceInfo.h"

@interface iclousAppDelegate : UIResponder <UIApplicationDelegate>
{
    CLLocationManager	*cllMgr;
    UITextView			*thisTextView;
    UIWindow			*thisWindow;
    int                 cnt; // for Clemens
    DeviceInfo          *thisDevice;
}

@property (strong, nonatomic) UIWindow *window;

@end
