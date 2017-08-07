//
//  HTTPProtocol.m
//  YouTubePlayer
//
//  Created by Clemens Wagner on 11.05.13.
//  Copyright (c) 2013 Clemens Wagner. All rights reserved.
//

#import "OfflineHTTPProtocol.h"
#import "OfflineCache.h"

static NSString * const kUseHTTPProtocol = @"kUseHTTPProtocol";

@interface OfflineHTTPProtocol()<NSURLConnectionDelegate, NSURLConnectionDataDelegate>

@property (nonatomic, weak) NSURLConnection *connection;
@property (nonatomic, strong) NSURLResponse *response;
@property (nonatomic, strong) NSMutableData *data;

@end

@implementation OfflineHTTPProtocol

- (id)initWithRequest:(NSURLRequest *)inRequest
       cachedResponse:(NSCachedURLResponse *)inResponse
               client:(id<NSURLProtocolClient>)inClient {
    NSMutableURLRequest *theRequest = [inRequest mutableCopy];

    [NSURLProtocol setProperty:@YES forKey:kUseHTTPProtocol inRequest:theRequest];
    [theRequest setCachePolicy:NSURLRequestReloadIgnoringCacheData];
    return [super initWithRequest:theRequest cachedResponse:inResponse client:inClient];
}

+ (BOOL)canInitWithRequest:(NSURLRequest *)inRequest {
    return [inRequest.URL.scheme hasPrefix:@"http"] && [NSURLProtocol propertyForKey:kUseHTTPProtocol inRequest:inRequest] == nil;
}

+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)inRequest {
    return inRequest;
}

- (void)startLoading {
    OfflineCache *theCache = [OfflineCache sharedOfflineCache];
    NSCachedURLResponse *theResponse = [theCache cachedResponseForRequest:self.request];

    if(theResponse == nil) {
        self.connection = [NSURLConnection connectionWithRequest:self.request delegate:self];
    }
    else {
        [self.client URLProtocol:self didReceiveResponse:theResponse.response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
        [self.client URLProtocol:self didLoadData:theResponse.data];
        [self.client URLProtocolDidFinishLoading:self];
    }
}

- (void)stopLoading {
    [self.connection cancel];
}

#pragma mark NSURLConnectionDelegate

- (void)connection:(NSURLConnection *)inConnection didReceiveResponse:(NSURLResponse *)inResponse {
    long long theCapacity = inResponse.expectedContentLength;
    
    self.response = inResponse;
    if(theCapacity < 8192) {
        theCapacity = 8192;
    }
    self.data = [NSMutableData dataWithCapacity:theCapacity];
    [self.client URLProtocol:self didReceiveResponse:inResponse cacheStoragePolicy:NSURLCacheStorageNotAllowed];
}

- (void)connection:(NSURLConnection *)inConnection didFailWithError:(NSError *)inError {
    self.response = nil;
    self.data = nil;
    [self.client URLProtocol:self didFailWithError:inError];
}

- (void)connection:(NSURLConnection *)inConnection didReceiveData:(NSData *)inData {
    [self.data appendData:inData];
    [self.client URLProtocol:self didLoadData:inData];
}

- (void)connection:(NSURLConnection *)inConnection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)inChallenge {
    [self.client URLProtocol:self didReceiveAuthenticationChallenge:inChallenge];
}

- (void)connection:(NSURLConnection *)inConnection didCancelAuthenticationChallenge:(NSURLAuthenticationChallenge *)inChallenge {
    [self.client URLProtocol:self didCancelAuthenticationChallenge:inChallenge];
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)inConnection willCacheResponse:(NSCachedURLResponse *)inCachedResponse {
    return nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)inConnection {
    OfflineCache *theCache = [OfflineCache sharedOfflineCache];
    NSCachedURLResponse *theResponse = [[NSCachedURLResponse alloc] initWithResponse:self.response data:self.data];

    [theCache storeCachedResponse:theResponse forRequest:self.request];
    [self.client URLProtocolDidFinishLoading:self];
}

@end
