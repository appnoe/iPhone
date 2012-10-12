//
//  keychainguckerAppDelegate.h
//  keychaingucker
//
//  Created by Klaus M. Rodewig on 05.07.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Security/Security.h>

@interface keychainguckerAppDelegate : UIResponder <UIApplicationDelegate>
{
    UITextView			*thisTextView;
    UIWindow			*thisWindow;
}

@property (strong, nonatomic) UIWindow *window;

@end
