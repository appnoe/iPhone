//
//  CacheControl.m
//  Cache
//
//  Created by Klaus Rodewig on 09.03.17.
//  Copyright © 2017 Clemens Wagner. All rights reserved.
//

#import "CacheControl.h"

@interface CacheControlStorage : NSObject

@end

@interface CacheControl()

@end

@implementation CacheControl

#pragma mark Object creation

+ (instancetype)sharedInstance {
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [(id)[super alloc] init];
    });
    return sharedInstance;
}

#pragma mark Cache handling

- (void)fileToCache:(NSString *)localFileName remoteURL:(NSURL *)inURL serverResponse:(NSHTTPURLResponse *)inHTTPURLResponse completion:(void (^)(KMRCacheControlState cacheControlState))completionBlock{
    // lookup file
    // not in cache
//    completionBlock(KMRCacheControlStored);
    
}

@end
