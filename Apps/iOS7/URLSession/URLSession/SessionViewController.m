//
//  SessionViewController.m
//  URLSession
//
//  Created by Clemens Wagner on 09.06.14.
//  Copyright (c) 2014 Clemens Wagner. All rights reserved.
//

#import "SessionViewController.h"
#import "SessionAppDelegate.h"

static NSString * const kDownloadURL = @"https://codeload.github.com/Cocoaneheads/iPhone/zip/Auflage_2";

@interface SessionViewController ()<NSURLSessionDownloadDelegate>

@property (strong, nonatomic) NSURLSession *session;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (weak, nonatomic) NSURLSessionTask *task;

@end

@implementation SessionViewController

- (NSURLSession *)backgroundSession {
	static dispatch_once_t onceToken;
    static NSURLSession *theSession;
    
	dispatch_once(&onceToken, ^{
		NSURLSessionConfiguration *theConfiguration = [NSURLSessionConfiguration backgroundSessionConfiguration:@"BackgroundSession"];
        
		theSession = [NSURLSession sessionWithConfiguration:theConfiguration delegate:self delegateQueue:nil];
	});
	return theSession;
}

- (IBAction)downloadContent {
    NSURLSession *theSession = [NSURLSession sharedSession];
    NSURL *theURL = [NSURL URLWithString:kDownloadURL];
    NSURLSessionDownloadTask *theTask = [theSession downloadTaskWithURL:theURL completionHandler:^(NSURL *inURL, NSURLResponse *inResponse, NSError *inError) {
        if(inURL == nil) {
            NSLog(@"downloadContent: error = %@", inError);
        }
        else {
            NSLog(@"downloadContent: success = %@", inURL);
        }
        [self.task removeObserver:self forKeyPath:@"countOfBytesReceived"];
    }];
    
    self.progressView.progress = 0.0;
    [theTask addObserver:self forKeyPath:@"countOfBytesReceived" options:0 context:NULL];
    [theTask resume];
    self.task = theTask;
}

- (IBAction)downloadContentInBackground {
    NSURLSession *theSession = self.backgroundSession;
    NSURL *theURL = [NSURL URLWithString:kDownloadURL];
    NSURLSessionDownloadTask *theTask = [theSession downloadTaskWithURL:theURL];
    
    self.progressView.progress = 0.0;
    [theTask resume];
    self.task = theTask;
    NSLog(@"Download started");
}

- (void)URLSession:(NSURLSession *)inSession downloadTask:(NSURLSessionDownloadTask *)inDownloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)inTotalBytesWritten totalBytesExpectedToWrite:(int64_t)inTotalBytesExpectedToWrite {
    CGFloat theProgress = (float)inTotalBytesWritten / (float) inTotalBytesExpectedToWrite;
    
    NSLog(@"Progress: %.1f%%", 100.0 * theProgress);
    dispatch_async(dispatch_get_main_queue(), ^{
        self.progressView.progress = theProgress;
    });
}

- (void)URLSession:(NSURLSession *)inSession downloadTask:(NSURLSessionDownloadTask *)inTask didFinishDownloadingToURL:(NSURL *)inLocation {
    NSFileManager *theManager = [NSFileManager defaultManager];
    NSURL *theDestinationURL = [[theManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] firstObject];
    NSError *theError;
    
    theDestinationURL = [theDestinationURL URLByAppendingPathComponent:@"code.zip"];
    [theManager removeItemAtURL:theDestinationURL error:NULL];
    if([theManager moveItemAtURL:inLocation toURL:theDestinationURL error:&theError]) {
        NSLog(@"Source code saved");
    }
    else {
        NSLog(@"Error: %@", theError);
    }
}

- (void)URLSessionDidFinishEventsForBackgroundURLSession:(NSURLSession *)inSession {
    SessionAppDelegate *theDelegate = [[UIApplication sharedApplication] delegate];
    
    [theDelegate sessionEventsCompleted];
}

- (void)observeValueForKeyPath:(NSString *)inKeyPath ofObject:(id)inObject
                        change:(NSDictionary *)inChange context:(void *)inContext {
    if([inKeyPath isEqualToString:@"countOfBytesReceived"]) {
        int64_t theLength = [inObject countOfBytesReceived];
        int64_t theTotalLength = [inObject countOfBytesExpectedToReceive];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.progressView.progress = (float)theLength / (float) theTotalLength;
        });
    }
}

@end
