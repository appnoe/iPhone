//
//  main.m
//  iclous
//
//  Created by Klaus M. Rodewig on 02.07.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "iclousAppDelegate.h"

int main(int argc, char *argv[])
{
    int retVal = 0;
    @autoreleasepool {
        retVal = UIApplicationMain(argc, argv, nil, NSStringFromClass([iclousAppDelegate class]));
    }
    return retVal;
}
