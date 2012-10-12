//
//  main.m
//  keychaingucker
//
//  Created by Klaus M. Rodewig on 05.07.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "keychainguckerAppDelegate.h"

int main(int argc, char *argv[])
{
    int retVal = 0;
    @autoreleasepool {
        retVal = UIApplicationMain(argc, argv, nil, NSStringFromClass([keychainguckerAppDelegate class]));
    }
    return retVal;
}
