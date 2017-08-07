//
//  Reachability.h
//
//  Created by Clemens Wagner on 04.07.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import <netinet/in.h>

typedef enum {
    kReachabilityNotReachable = 0,
    kReachabilityWiFi,
    kReachabilityWWAN
} ReachabilityStatus;

extern NSString * const kReachabilityChangedNotification;

@interface Reachability : NSObject

+ (id)reachabilityWithHostName:(NSString *)inHostName;
+ (id)reachabilityWithAddress:(const struct sockaddr_in *)inAddress;
+ (id)reachabilityForInternetConnection;
+ (id)reachabilityForLocalWiFi;

- (id)initWithHostName:(NSString *)inHostName;
- (id)initWithAddress:(const struct sockaddr_in *)inAddress;

- (BOOL)startNotifier;
- (void)stopNotifier;
- (ReachabilityStatus)currentReachabilityStatus;
- (BOOL)connectionRequired;

@end