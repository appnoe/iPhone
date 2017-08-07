//
//  LogUtility.h
//  Kapitel2
//
//  Created by Rodewig Klaus on 15.07.12.
//  Copyright (c) 2012 Klaus M. Rodewig. All rights reserved.
//


#import <Foundation/Foundation.h>

@protocol LogDelegate;

@interface Log : NSObject

@property (nonatomic, weak) id<LogDelegate> delegate;

-(void)logToConsole:(NSString *)theMessage;

@end

@protocol LogDelegate<NSObject>

-(void)logDidFinishLogging:(Log *)inLog;

@end
