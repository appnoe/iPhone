//
//  SessionAppDelegate.m
//  URLSession
//
//  Created by Clemens Wagner on 09.06.14.
//  Copyright (c) 2014 Clemens Wagner. All rights reserved.
//

#import "SessionAppDelegate.h"

static NSString * const kNewstickerURL = @"https://developer.apple.com/news/rss/news.rss";

@interface SessionAppDelegate()

@property (nonatomic, strong, readwrite) void (^eventsCompletionHandler)();

@end

@implementation SessionAppDelegate

- (BOOL)application:(UIApplication *)inApplication didFinishLaunchingWithOptions:(NSDictionary *)inLaunchOptions {
    [inApplication setMinimumBackgroundFetchInterval:UIApplicationBackgroundFetchIntervalMinimum];
    return YES;
}

- (void)application:(UIApplication *)inApplication performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))inCompletionHandler {
    NSURL *theURL = [NSURL URLWithString:kNewstickerURL];
    NSURLSession *theSession = [NSURLSession sharedSession];
    NSURLSessionTask *theTask = [theSession dataTaskWithURL:theURL completionHandler:^(NSData *inData, NSURLResponse *inResponse, NSError *inError) {
        NSError *theError = inError;
        UIBackgroundFetchResult theResult = UIBackgroundFetchResultFailed;
        
        if(inData != nil && theError == nil) {
            NSFileManager *theManager = [NSFileManager defaultManager];
            NSURL *theDestinationURL = [[theManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] firstObject];

            theDestinationURL = [theDestinationURL URLByAppendingPathComponent:@"data.rss"];
            [theManager removeItemAtURL:theDestinationURL error:NULL];
            if([inData writeToURL:theDestinationURL options:NSDataWritingAtomic error:&theError]) {
                NSLog(@"Newsfeed saved");
                theResult = UIBackgroundFetchResultNewData;
            }
        }
        if(theError != nil) {
            NSLog(@"Error: %@", inError);
        }
        inCompletionHandler(theResult);
    }];
    [theTask resume];
}

- (void)application:(UIApplication *)inApplication handleEventsForBackgroundURLSession:(NSString *)inIdentifier completionHandler:(void (^)())inCompletionHandler {
    self.eventsCompletionHandler = inCompletionHandler;
}

- (void)sessionEventsCompleted {
    void (^theHandler)() = self.eventsCompletionHandler;
    
    self.eventsCompletionHandler = nil;
    if(theHandler) {
        theHandler();
        NSLog(@"sessionEventsDidComplete");
    }
}

@end
