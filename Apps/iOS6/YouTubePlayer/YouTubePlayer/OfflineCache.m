//
//  OfflineCache.m
//  YouTubePlayer
//
//  Created by Clemens Wagner on 11.05.13.
//  Copyright (c) 2013 Clemens Wagner. All rights reserved.
//

#import "OfflineCache.h"
#import "FMDatabase.h"
#import "FMDatabaseQueue.h"
#import "FMDatabaseAdditions.h"
#import "NSString+Extensions.h"
#import "NSHTTPURLResponse+TimestampHeaders.h"

#define USE_DATABASE_QUEUE 0

@interface OfflineCache()

#if USE_DATABASE_QUEUE == 0
@property (nonatomic, strong) FMDatabase *database;
#else
@property (nonatomic, strong) FMDatabaseQueue *databaseQueue;
#endif
@property (nonatomic, copy) NSString *baseDirectory;
@property (nonatomic) BOOL searchKeysAreUnique;

- (NSString *)databaseFile;
- (NSOperationQueue *)operationQueue;
- (BOOL)open;
- (void)close;
- (NSInteger)logicalSize;
- (NSInteger)physicalSize;
- (void)scheduleShrinkIfNeeded;
- (void)shrinkIfNeeded;

- (BOOL)shouldReturnCachedResponseForRequest:(NSURLRequest *)inRequest;
- (NSString *)searchKeyForRequest:(NSURLRequest *)inRequest;
- (BOOL)cachedRequest:(NSURLRequest *)inCachedRequest isEqualToRequest:(NSURLRequest *)inRequest;

@end

@interface FMResultSet(OfflineCache)

- (id)decodedObjectForColumnIndex:(int)inIndex;

@end

@implementation OfflineCache

@synthesize delegate;
@synthesize capacity;

static OfflineCache *sharedOfflineCache;

+ (OfflineCache *)sharedOfflineCache {
    return sharedOfflineCache;
}

+ (void)setSharedOfflineCache:(OfflineCache *)inCache {
    sharedOfflineCache = inCache;
}

- (id)initWithCapacity:(NSUInteger)inCapacity path:(NSString *)inPath {
    self = [super init];
    if(self) {
        self.capacity = inCapacity;
        self.baseDirectory = inPath;
        if(![self open]) {
            self = nil;
        }
    }
    return self;
}

- (BOOL)cachedRequest:(NSURLRequest *)inCachedRequest isEqualToRequest:(NSURLRequest *)inRequest {
    if([inCachedRequest.HTTPMethod isEqualToString:inRequest.HTTPMethod]) {
        NSURL *theCachedURL = [inCachedRequest.URL standardizedURL];
        NSURL *theURL = [inRequest.URL standardizedURL];

        return [theCachedURL isEqual:theURL];
    }
    else {
        return NO;
    }
}

- (BOOL)shouldReturnCachedResponseForRequest:(NSURLRequest *)inRequest {
    if([self.delegate respondsToSelector:@selector(offlineCache:shouldReturnCachedResponseForRequest:)]) {
        return [self.delegate offlineCache:self shouldReturnCachedResponseForRequest:inRequest];
    }
    else {
        return YES;
    }
}


- (NSString *)searchKeyForRequest:(NSURLRequest *)inRequest {
    NSURL *theURL = [inRequest.URL standardizedURL];

    return [NSString stringWithFormat:@"%@:%@", inRequest.HTTPMethod, theURL];
}

- (NSDate *)expirationDateForResponse:(NSURLResponse *)inResponse {
    if([inResponse respondsToSelector:@selector(dateOfExpiry)]) {
        return [(id)inResponse dateOfExpiry];
    }
    else {
        return [NSDate date];
    }
}

- (NSString *)databaseFile {
    return [self.baseDirectory stringByAppendingPathComponent:@"cache.db"];
}

- (void)setCapacity:(NSUInteger)inCapacity {
    NSUInteger theCapacity = self.capacity;

    capacity = inCapacity;
    if(theCapacity > inCapacity) {
        [self scheduleShrinkIfNeeded];
    }
}

- (NSOperationQueue *)operationQueue {
    return [NSOperationQueue mainQueue];
}

- (void)scheduleShrinkIfNeeded {
    if(self.size > self.capacity) {
        NSOperation *theOperation = [NSBlockOperation blockOperationWithBlock:^{
            [self shrinkIfNeeded];
        }];

        theOperation.queuePriority = NSOperationQueuePriorityVeryLow;
        [self.operationQueue addOperation:theOperation];
    }
}

- (NSInteger)size {
    if([self.delegate respondsToSelector:@selector(sizeForOfflineCache:)]) {
        return [self.delegate sizeForOfflineCache:self];
    }
    else {
        return [self logicalSize];
    }
}

- (NSInteger)physicalSize {
    NSFileManager *theManager = [NSFileManager defaultManager];
    NSDictionary *theAttributes = [theManager attributesOfItemAtPath:self.databaseFile error:NULL];

    return theAttributes.fileSize;
}

#if USE_DATABASE_QUEUE == 0

- (NSCachedURLResponse *)cachedResponseForRequest:(NSURLRequest *)inRequest {
    NSCachedURLResponse *theResult = nil;

    if([self shouldReturnCachedResponseForRequest:inRequest]) {
        NSString *theKey = [self searchKeyForRequest:inRequest];

        @synchronized(self.database) {
            FMResultSet *theResultSet = [self.database executeQuery:@"SELECT response, data, user_info FROM cache_entry WHERE search_key = ?", theKey];

            if([theResultSet next]) {
                NSURLResponse *theResponse = [theResultSet decodedObjectForColumnIndex:0];
                NSData *theData = [theResultSet dataForColumnIndex:1];
                NSDictionary *theUserInfo = [theResultSet decodedObjectForColumnIndex:2];

                theResult = [[NSCachedURLResponse alloc] initWithResponse:theResponse
                                                                     data:theData
                                                                 userInfo:theUserInfo
                                                            storagePolicy:NSURLCacheStorageAllowed];
                [theResultSet close];
                [self.database executeUpdate:@"UPDATE cache_entry SET last_access_time = CURRENT_TIMESTAMP WHERE search_key = ?", theKey];
            }
        }
    }
    return theResult;
}

- (void)storeCachedResponse:(NSCachedURLResponse *)inResponse forRequest:(NSURLRequest *)inRequest {
    NSURLResponse *theResponse = inResponse.response;
    NSDate *theExpirationDate = [self expirationDateForResponse:theResponse];
    NSData *theRequestData = [NSKeyedArchiver archivedDataWithRootObject:inRequest];
    NSData *theResponseData = [NSKeyedArchiver archivedDataWithRootObject:theResponse];
    NSData *theUserInfo = [NSKeyedArchiver archivedDataWithRootObject:inResponse.userInfo];
    NSString *theSearchKey = [self searchKeyForRequest:inRequest];

    NSLog(@"storeCachedResponse:%u forRequest:%@", inResponse.data.length, inRequest.URL);
    NSLog(@"Expires: %@", theExpirationDate);
    @synchronized(self.database) {
        [self.database executeUpdate:@"DELETE FROM cache_entry WHERE search_key = ?", theSearchKey];
        if(![self.database executeUpdate:@"INSERT INTO cache_entry (expiration_date, search_key, request, response, data, user_info) VALUES (?, ?, ?, ?, ?, ?)",
             theExpirationDate, theSearchKey, theRequestData, theResponseData, inResponse.data, theUserInfo]) {
            NSLog(@"error: %@", [self.database lastError]);
        }
        [self scheduleShrinkIfNeeded];
    }
}

- (NSDate *)expirationDateOfResponseForRequest:(NSURLRequest *)inRequest {
    @synchronized(self.database) {
        NSString *theSearchKey = [self searchKeyForRequest:inRequest];

        return [self.database dateForQuery:@"SELECT expiration_date FROM cache_entry WHERE search_key = ?", theSearchKey];

    }
}

- (void)removeAllCachedResponses {
    @synchronized(self.database) {
        [self.database executeUpdate:@"DELETE FROM cache_entry"];
    }
}

- (void)removeCachedResponseForRequest:(NSURLRequest *)inRequest {
    NSString *theSearchKey = [self searchKeyForRequest:inRequest];

    @synchronized(self.database) {
        [self.database executeUpdate:@"DELETE FROM cache_entry WHERE search_key = ?", theSearchKey];
    }
}

- (FMDatabase *)createDatabaseWithError:(NSError **)outError {
    NSFileManager *theManager = [NSFileManager defaultManager];
    FMDatabase *theDatabase = nil;

    if([theManager createDirectoryAtPath:self.baseDirectory withIntermediateDirectories:YES attributes:nil error:outError]) {
        if([theManager fileExistsAtPath:self.databaseFile]) {
            theDatabase = [FMDatabase databaseWithPath:self.databaseFile];
        }
        else {
            NSString *thePath = [[NSBundle mainBundle] pathForResource:@"cache" ofType:@"db"];

            if([theManager copyItemAtPath:thePath toPath:self.databaseFile error:outError]) {
                theDatabase = [FMDatabase databaseWithPath:self.databaseFile];
            }
        }
    }
    return theDatabase;
}

- (BOOL)open {
    NSError *theError = nil;
    FMDatabase *theDatabase = [self createDatabaseWithError:&theError];

    if([theDatabase open]) {
        self.database = theDatabase;
        [self scheduleShrinkIfNeeded];
        return YES;
    }
    else {
        NSLog(@"open: %@", theError);
        return NO;
    }
}

- (void)close {
    [self.database close];
}

- (NSInteger)logicalSize {
    @synchronized(self.database) {
        return [self.database intForQuery:@"SELECT SUM(LENGTH(data)) FROM cache_entry"];
    }
}

- (void)shrinkIfNeeded {
    @synchronized(self.database) {
        if(self.size > self.capacity) {
            [self.database executeUpdate:@"DELETE FROM cache_entry WHERE id = (SELECT id FROM cache_entry ORDER BY last_access_time LIMIT 1)"];
            [self scheduleShrinkIfNeeded];
        }
    }
}

#else

- (NSCachedURLResponse *)cachedResponseForRequest:(NSURLRequest *)inRequest {
    __block NSCachedURLResponse *theResult = nil;

    if([self shouldReturnCachedResponseForRequest:inRequest]) {
        NSString *theKey = [self searchKeyForRequest:inRequest];

        [self.databaseQueue inDatabase:^(FMDatabase *inDatabase) {
            FMResultSet *theResultSet = [inDatabase executeQuery:@"SELECT response, data, user_info FROM cache_entry WHERE search_key = ?", theKey];

            if([theResultSet next]) {
                NSURLResponse *theResponse = [theResultSet decodedObjectForColumnIndex:0];
                NSData *theData = [theResultSet dataForColumnIndex:1];
                NSDictionary *theUserInfo = [theResultSet decodedObjectForColumnIndex:2];

                theResult = [[NSCachedURLResponse alloc] initWithResponse:theResponse
                                                                     data:theData
                                                                 userInfo:theUserInfo
                                                            storagePolicy:NSURLCacheStorageAllowed];
                [theResultSet close];
                [inDatabase executeUpdate:@"UPDATE cache_entry SET last_access_time = CURRENT_TIMESTAMP WHERE search_key = ?", theKey];
            }
        }];
    }
    return theResult;
}

- (void)storeCachedResponse:(NSCachedURLResponse *)inResponse forRequest:(NSURLRequest *)inRequest {
    NSURLResponse *theResponse = inResponse.response;
    NSDate *theExpirationDate = [self expirationDateForResponse:theResponse];
    NSData *theRequestData = [NSKeyedArchiver archivedDataWithRootObject:inRequest];
    NSData *theResponseData = [NSKeyedArchiver archivedDataWithRootObject:theResponse];
    NSData *theUserInfo = [NSKeyedArchiver archivedDataWithRootObject:inResponse.userInfo];
    NSString *theSearchKey = [self searchKeyForRequest:inRequest];

    NSLog(@"storeCachedResponse:%u forRequest:%@", inResponse.data.length, inRequest.URL);
    NSLog(@"Expires: %@", theExpirationDate);
    [self.databaseQueue inDatabase:^(FMDatabase *inDatabase) {
        [inDatabase executeUpdate:@"DELETE FROM cache_entry WHERE search_key = ?", theSearchKey];
        NSLog(@"ERROR:%@", inDatabase.lastErrorMessage);
        if(![inDatabase executeUpdate:@"INSERT INTO cache_entry (expiration_date, search_key, request, response, data, user_info) VALUES (?, ?, ?, ?, ?, ?)",
             theExpirationDate, theSearchKey, theRequestData, theResponseData, inResponse.data, theUserInfo]) {
            NSLog(@"error: %@", [inDatabase lastError]);
        }
    }];
    [self scheduleShrinkIfNeeded];
}

- (NSDate *)expirationDateOfResponseForRequest:(NSURLRequest *)inRequest {
    NSString *theSearchKey = [self searchKeyForRequest:inRequest];
    __block NSDate *theDate = nil;

    [self.databaseQueue inDatabase:^(FMDatabase *inDatabase) {
        theDate = [inDatabase dateForQuery:@"SELECT expiration_date FROM cache_entry WHERE search_key = ?", theSearchKey];
    }];
    return theDate;
}

- (void)removeAllCachedResponses {
    [self.databaseQueue inDatabase:^(FMDatabase *inDatabase) {
        [inDatabase executeUpdate:@"DELETE FROM cache_entry"];
    }];
}

- (void)removeCachedResponseForRequest:(NSURLRequest *)inRequest {
    NSString *theSearchKey = [self searchKeyForRequest:inRequest];

    [self.databaseQueue inDatabase:^(FMDatabase *inDatabase) {
        [inDatabase executeUpdate:@"DELETE FROM cache_entry WHERE search_key = ?", theSearchKey];
    }];
}

- (FMDatabaseQueue *)createDatabaseQueueWithError:(NSError **)outError {
    NSFileManager *theManager = [NSFileManager defaultManager];
    FMDatabaseQueue *theDatabaseQueue = nil;

    if([theManager createDirectoryAtPath:self.baseDirectory withIntermediateDirectories:YES attributes:nil error:outError]) {
        if([theManager fileExistsAtPath:self.databaseFile]) {
            theDatabaseQueue = [FMDatabaseQueue databaseQueueWithPath:self.databaseFile];
        }
        else {
            NSString *thePath = [[NSBundle mainBundle] pathForResource:@"cache" ofType:@"db"];

            if([theManager copyItemAtPath:thePath toPath:self.databaseFile error:outError]) {
                theDatabaseQueue = [FMDatabaseQueue databaseQueueWithPath:self.databaseFile];
            }
        }
    }
    return theDatabaseQueue;
}

- (BOOL)open {
    NSError *theError = nil;
    FMDatabaseQueue *theDatabaseQueue = [self createDatabaseQueueWithError:&theError];

    if(theDatabaseQueue == nil) {
        NSLog(@"open: %@", theError);
        return NO;
    }
    else {
        self.databaseQueue = theDatabaseQueue;
        [self scheduleShrinkIfNeeded];
        return YES;
    }
}

- (void)close {
    [self.databaseQueue close];
}

- (NSInteger)logicalSize {
    __block NSInteger theResult = 0;
    
    [self.databaseQueue inDatabase:^(FMDatabase *inDatabase) {
        theResult = [inDatabase intForQuery:@"SELECT SUM(LENGTH(data)) FROM cache_entry"];
    }];
    return theResult;
}

- (void)shrinkIfNeeded {
    if(self.size > self.capacity) {
        [self.databaseQueue inDatabase:^(FMDatabase *inDatabase) {
            [inDatabase executeUpdate:@"DELETE FROM cache_entry WHERE id = (SELECT id FROM cache_entry ORDER BY last_access_time LIMIT 1)"];
        }];
        [self scheduleShrinkIfNeeded];
    }
}

#endif

@end

@implementation FMResultSet(OfflineCache)

- (id)decodedObjectForColumnIndex:(int)inIndex {
    NSData *theData = [self dataForColumnIndex:inIndex];

    return theData == nil ? nil : [NSKeyedUnarchiver unarchiveObjectWithData:theData];
}

@end