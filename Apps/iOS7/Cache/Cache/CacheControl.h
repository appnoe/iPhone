//
//  CacheControl.h
//  Cache
//
//  Created by Klaus Rodewig on 09.03.17.
//  Copyright © 2017 Clemens Wagner. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, KMRCacheControlState) {
    KMRCacheControlNone         = 0,    // I dunno, pal!
    KMRCacheControlStoreFile    = 1,    // File not in cache … please store
    KMRCacheControlInCache      = 2     // File already in cache. Go home, you're drunk!
};

#pragma mark - CacheObject

@interface CacheObject : NSObject
+ (instancetype)cacheObjectWithFile:(NSString *)inFileName remoteURL:(NSURL *)inURL serverResponse:(NSHTTPURLResponse *)inHTTPURLResponse;

@end

#pragma mark - CacheControl
@interface CacheControl : NSObject
#pragma mark Object creation
+ (instancetype)sharedInstance;
+ (instancetype)alloc __attribute__((unavailable("alloc not available, call sharedInstance instead")));
- (instancetype)init __attribute__((unavailable("init not available, call sharedInstance instead")));
+ (instancetype) new __attribute__((unavailable("new not available, call sharedInstance instead")));
#pragma mark Cache handling
- (KMRCacheControlState)fileToCache:(NSString *)localFileName remoteURL:(NSURL *)inURL serverResponse:(NSHTTPURLResponse *)inHTTPURLResponse;
@end
