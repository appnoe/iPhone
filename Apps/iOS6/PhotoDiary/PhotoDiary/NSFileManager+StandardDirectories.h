//
//  NSFileManager+StandardDirectories.h
//  PhotoDiary
//
//  Created by Clemens Wagner on 13.09.13.
//  Copyright (c) 2013 Cocoaneheads. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSFileManager (StandardDirectories)

- (NSString *)standardDirectory:(NSSearchPathDirectory)inDirectory inDomain:(NSSearchPathDomainMask)inMask withSubdirectory:(NSString *)inSubdirectory error:(NSError **)outError;
- (NSString *)applicationDocumentsDirectory;
- (NSString *)applicationSupportDirectory;

@end
