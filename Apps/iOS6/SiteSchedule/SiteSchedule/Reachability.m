//
//  Reachability.m
//
//  Created by Clemens Wagner on 04.07.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Reachability.h"
#import <CoreFoundation/CoreFoundation.h>
#import <sys/socket.h>
#import <netinet6/in6.h>
#import <arpa/inet.h>
#import <ifaddrs.h>
#import <netdb.h>

NSString * const kReachabilityChangedNotification = @"kNetworkReachabilityChangedNotification";

@interface Reachability()

@property (nonatomic) SCNetworkReachabilityRef networkReachability;
@property (nonatomic) BOOL localWiFiReference;

@end

@implementation Reachability

@synthesize networkReachability;
@synthesize localWiFiReference;

static void ReachabilityCallback(SCNetworkReachabilityRef inTarget, SCNetworkReachabilityFlags inFlags, void *inInfo) {
#pragma unused (inTarget, inFlags)
    id theInfo = (__bridge id)inInfo;
    
    @autoreleasepool {
        Reachability *theReachability = theInfo;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kReachabilityChangedNotification 
                                                            object:theReachability];
    }
}

+ (id)reachabilityWithHostName:(NSString *)inHostName {
    return [[self alloc] initWithHostName:inHostName];
}

+ (id)reachabilityWithAddress:(const struct sockaddr_in *)inAddress {
    return [[self alloc] initWithAddress:inAddress];
}

+ (id)reachabilityForInternetConnection {
    return [self reachabilityWithHostName:@"0.0.0.0"];
}

+ (id)reachabilityForLocalWiFi {
    struct sockaddr_in theAddress;
    id theResult;
    
    bzero(&theAddress, sizeof(theAddress));
    theAddress.sin_len = sizeof(theAddress);
    theAddress.sin_family = AF_INET;
    theAddress.sin_addr.s_addr = htonl(IN_LINKLOCALNETNUM);
    theResult = [self reachabilityWithAddress:&theAddress];
    [theResult setLocalWiFiReference:YES];
    return theResult;
}

- (id)initWithHostName:(NSString *)inHostName {
    SCNetworkReachabilityRef theReachability = SCNetworkReachabilityCreateWithName(NULL, [inHostName UTF8String]);
    
    if(theReachability == NULL) {
        self = nil;
    }
    else {
        self = [super init];
        if(self) {
            networkReachability = theReachability;
            self.localWiFiReference = NO;
        }
        else {
            CFRelease(theReachability);
        }
    }
    return self;
}

- (id)initWithAddress:(const struct sockaddr_in *)inAddress {
    SCNetworkReachabilityRef theReachability = SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, 
                                                                                      (const struct sockaddr *)inAddress);
    if(theReachability == NULL) {
        self = nil;
    }
    else {
        self = [super init];
        if(self) {
            networkReachability = theReachability;
            self.localWiFiReference = NO;
        }
        else {
            CFRelease(theReachability);
        }
    }
    return self;
}

- (void)dealloc {
    [self stopNotifier];
    if(networkReachability) {
        CFRelease(networkReachability);
    }
}

- (BOOL)startNotifier {
    SCNetworkReachabilityContext theContext = {0, (__bridge void *)self, NULL, NULL, NULL};
    
    return SCNetworkReachabilitySetCallback(networkReachability, ReachabilityCallback, &theContext) &&
    SCNetworkReachabilityScheduleWithRunLoop(networkReachability, CFRunLoopGetCurrent(), kCFRunLoopDefaultMode);
}

- (void)stopNotifier {
    if(networkReachability) {
        SCNetworkReachabilityUnscheduleFromRunLoop(networkReachability, CFRunLoopGetCurrent(), kCFRunLoopDefaultMode);
    }
}

#pragma mark Network Flag Handling

CF_INLINE ReachabilityStatus localWiFiStatusForFlags(SCNetworkReachabilityFlags inFlags) {    
    return (inFlags & kSCNetworkReachabilityFlagsReachable) && (inFlags & kSCNetworkReachabilityFlagsIsDirect) ?
    kReachabilityWiFi : kReachabilityNotReachable;
}

CF_INLINE ReachabilityStatus networkStatusForFlags(SCNetworkReachabilityFlags inFlags) {
    ReachabilityStatus theStatus = kReachabilityNotReachable;
    
    if((inFlags & kSCNetworkReachabilityFlagsReachable) != 0) {
        if((inFlags & kSCNetworkReachabilityFlagsIsWWAN) != 0) {
            theStatus = kReachabilityWWAN;
        }
        else if((inFlags & kSCNetworkReachabilityFlagsConnectionRequired) == 0 ||
           (((inFlags & kSCNetworkReachabilityFlagsConnectionOnDemand) != 0 ||
             ((inFlags & kSCNetworkReachabilityFlagsConnectionOnTraffic) != 0)) && 
            (inFlags & kSCNetworkReachabilityFlagsInterventionRequired) == 0)) {
            theStatus = kReachabilityWiFi;
        }
    }
    return theStatus;
}

- (BOOL)connectionRequired {
    SCNetworkReachabilityFlags theFlags;
    
    return SCNetworkReachabilityGetFlags(self.networkReachability, &theFlags) &&
        (theFlags & kSCNetworkReachabilityFlagsConnectionRequired) != 0;
}

- (ReachabilityStatus)currentReachabilityStatus {
    SCNetworkReachabilityFlags theFlags;
    
    if(SCNetworkReachabilityGetFlags(self.networkReachability, &theFlags)) {
        return self.localWiFiReference ? localWiFiStatusForFlags(theFlags) : networkStatusForFlags(theFlags);
    }
    else {
        return kReachabilityNotReachable;
    }
}

@end
