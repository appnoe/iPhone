//
//  NSFileManager+StandardDirectories.m
//  PhotoDiary
//
//  Created by Clemens Wagner on 13.09.13.
//  Copyright (c) 2013 Cocoaneheads. All rights reserved.
//

#import "NSFileManager+StandardDirectories.h"

@implementation NSFileManager (StandardDirectories)

- (NSString *)standardDirectory:(NSSearchPathDirectory)inDirectory inDomain:(NSSearchPathDomainMask)inMask withSubdirectory:(NSString *)inSubdirectory error:(NSError **)outError {
	NSArray *theDirectories = NSSearchPathForDirectoriesInDomains(inDirectory, inMask, YES);

    if(theDirectories.count > 0) {
        NSString *theDirectory = [theDirectories[0] stringByAppendingPathComponent:inSubdirectory];

        if([self createDirectoryAtPath:theDirectory withIntermediateDirectories:YES attributes:nil error:outError]) {
            return theDirectory;
        }
    }
    return nil;
}

- (NSString *)applicationDocumentsDirectory {
    NSArray *thePaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);

    return thePaths.count == 0 ? nil : thePaths[0];
}

- (NSString *)applicationSupportDirectory {
	NSString *theBundleId = [[NSBundle mainBundle] bundleIdentifier];
    NSError *theError = nil;
    NSString *theDirectory = [self standardDirectory:NSApplicationSupportDirectory inDomain:NSUserDomainMask withSubdirectory:theBundleId error:&theError];

    if(theDirectory == nil) {
        NSLog(@"Can't create application support folder: %@", theError);
    }
    return theDirectory;
}

@end
