//
//  YouTubeAppDelegate.m
//  YouTubePlayer
//
//  Created by Clemens Wagner on 04.05.13.
//  Copyright (c) 2013 Clemens Wagner. All rights reserved.
//

#import "YouTubeAppDelegate.h"
#import "OfflineHTTPProtocol.h"
#import "OfflineCache.h"

#define USE_OFFLINE_CACHE 0

@interface YouTubeAppDelegate()<OfflineCacheDelegate>

@property (nonatomic, strong, readwrite) Reachability *reachability;

@end

@implementation YouTubeAppDelegate

- (BOOL)application:(UIApplication *)inApplication didFinishLaunchingWithOptions:(NSDictionary *)inOptions {
#if USE_OFFLINE_CACHE
    NSArray *thePaths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *thePath = [thePaths[0] stringByAppendingPathComponent:@"OfflineCache"];
    OfflineCache *theCache = [[OfflineCache alloc] initWithCapacity:10485760 path:thePath];

    theCache.delegate = self;
    [OfflineCache setSharedOfflineCache:theCache];
    [NSURLProtocol registerClass:[OfflineHTTPProtocol class]];
    self.reachability = [Reachability reachabilityForInternetConnection];
#endif
    return YES;
}

#pragma mark OfflineCacheDelegate

- (BOOL)offlineCache:(OfflineCache *)inOfflineCache shouldReturnCachedResponseForRequest:(NSURLRequest *)inRequest {
    NSDate *theExpirationDate = [inOfflineCache expirationDateOfResponseForRequest:inRequest];

    return [theExpirationDate compare:[NSDate date]] == NSOrderedDescending ||
    self.reachability.currentReachabilityStatus != kReachabilityWiFi;
}

@end