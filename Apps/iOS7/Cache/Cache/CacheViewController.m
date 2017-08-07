//
//  CacheViewController.m
//  Cache
//
//  Created by Clemens Wagner on 29.05.14.
//  Copyright (c) 2014 Clemens Wagner. All rights reserved.
//

#import "CacheViewController.h"

@interface CacheViewController ()<NSURLSessionDelegate>

@property (weak, nonatomic) IBOutlet UITextField *urlField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *policyControl;
@property (weak, nonatomic) IBOutlet UISlider *timeoutSlider;
@property (weak, nonatomic) IBOutlet UILabel *timeoutLabel;
@property (weak, nonatomic) IBOutlet UITextField *requestETagField;
@property (weak, nonatomic) IBOutlet UITextField *requestDateField;
@property (weak, nonatomic) IBOutlet UILabel *cacheLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusCodeLabel;
@property (weak, nonatomic) IBOutlet UILabel *lengthLabel;
@property (weak, nonatomic) IBOutlet UILabel *cacheControlLabel;
@property (weak, nonatomic) IBOutlet UIButton *etagButton;
@property (weak, nonatomic) IBOutlet UIButton *dateButton;

@property (nonatomic) NSInteger dataLength;

@end

@implementation CacheViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.urlField.text = @"https://cloud.foobar.guru/eap/eap/impress.html";
    [self updateTimeoutLabel];
}

- (NSURLRequestCachePolicy)cachePolicy {
    return (NSURLRequestCachePolicy)self.policyControl.selectedSegmentIndex;
}

- (NSTimeInterval)timeout {
    return self.timeoutSlider.value;
}

- (IBAction)send:(id)sender {
    NSURL *theURL = [NSURL URLWithString:self.urlField.text];
    
    if(theURL) {
        NSString *theETag = self.requestETagField.text;
        NSString *theDate = self.requestDateField.text;
        NSURLRequestCachePolicy thePolicy = self.cachePolicy;
        NSTimeInterval theTimeout = self.timeout;
        NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:theURL cachePolicy:thePolicy timeoutInterval:theTimeout];
        NSURLCache *theCache = [NSURLCache sharedURLCache];
        
        self.urlField.textColor = [UIColor blackColor];
        [self closeKeyboard];
        if(theETag.length > 0) {
            [theRequest setValue:theETag forHTTPHeaderField:@"If-None-Match"];
        }
        if(theDate.length > 0) {
            [theRequest setValue:theDate forHTTPHeaderField:@"If-Modified-Since"];
        }
        self.cacheLabel.text = [theCache cachedResponseForRequest:theRequest] == nil ? @"none" : @"exists";
        
        NSURLSession *theSession = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]
                                                                 delegate:self
                                                            delegateQueue:[NSOperationQueue mainQueue]];
//        [[theSession dataTaskWithRequest:theRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//            //
//            NSLog(@"Ready");
//        }] resume];
//        
        [[theSession dataTaskWithRequest:theRequest] resume];

        
    }
    else {
        self.urlField.textColor = [UIColor redColor];
    }
}

- (IBAction)copyETag {
    self.requestETagField.text = [self.etagButton titleForState:UIControlStateNormal];
}

- (IBAction)copyLastModified {
    self.requestDateField.text = [self.dateButton titleForState:UIControlStateNormal];
}

- (IBAction)updateTimeoutLabel {
    self.timeoutLabel.text = [NSString stringWithFormat:@"%.1fs", self.timeoutSlider.value];
}

- (IBAction)closeKeyboard {
    [self.view endEditing:YES];
}

- (IBAction)clearCache {
    NSURLCache *theCache = [NSURLCache sharedURLCache];

    self.cacheLabel.text = @"clear";
    [theCache removeAllCachedResponses];
}

#pragma mark NSURLSessionDelegate

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask willCacheResponse:(NSCachedURLResponse *)proposedResponse completionHandler:(void (^)(NSCachedURLResponse *cachedResponse))completionHandler{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    NSLog(@"Caching data …");
    self.cacheLabel.text = @"write";
//    NSHTTPURLResponse *theResponse = dataTask.response;
//    NSDictionary *theHeaders = [theResponse allHeaderFields];
//    NSString *theETag = theHeaders[@"ETag"];
//    NSString *theDate = theHeaders[@"Last-Modified"];
//    
//    self.dataLength = 0;
//    self.statusCodeLabel.text = [NSString stringWithFormat:@"%d", theResponse.statusCode];
//    self.lengthLabel.text = [NSString stringWithFormat:@"%lld", theResponse.expectedContentLength];
//    self.cacheControlLabel.text = theHeaders[@"Cache-Control"];
//    [self.etagButton setTitle:theETag forState:UIControlStateNormal];
//    [self.dateButton setTitle:theDate forState:UIControlStateNormal];

    completionHandler(proposedResponse);
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    NSHTTPURLResponse *theResponse = (NSHTTPURLResponse *)response;
    NSDictionary *theHeaders = [theResponse allHeaderFields];
    NSString *theETag = theHeaders[@"ETag"];
    NSString *theDate = theHeaders[@"Last-Modified"];
    self.dataLength = 0;
    self.statusCodeLabel.text = [NSString stringWithFormat:@"%ld", (long)theResponse.statusCode];
    self.lengthLabel.text = [NSString stringWithFormat:@"%lld", theResponse.expectedContentLength];
    self.cacheControlLabel.text = theHeaders[@"Cache-Control"];
    [self.etagButton setTitle:theETag forState:UIControlStateNormal];
    [self.dateButton setTitle:theDate forState:UIControlStateNormal];
    completionHandler(NSURLSessionResponseAllow);
}

//- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data{
//    NSHTTPURLResponse *theResponse = (NSHTTPURLResponse *)dataTask.response;
//    NSDictionary *theHeaders = [theResponse allHeaderFields];
//    NSString *theETag = theHeaders[@"ETag"];
//    NSString *theDate = theHeaders[@"Last-Modified"];
//    
//    self.dataLength = 0;
//    self.statusCodeLabel.text = [NSString stringWithFormat:@"%ld", (long)theResponse.statusCode];
//    self.lengthLabel.text = [NSString stringWithFormat:@"%lld", theResponse.expectedContentLength];
//    self.cacheControlLabel.text = theHeaders[@"Cache-Control"];
//    [self.etagButton setTitle:theETag forState:UIControlStateNormal];
//    [self.dateButton setTitle:theDate forState:UIControlStateNormal];
//
//}

//#pragma mark NSURLConnectionDataDelegate
//
//- (void)connection:(NSURLConnection *)inConnection didReceiveResponse:(NSURLResponse *)inResponse {
//    if([inResponse isKindOfClass:[NSHTTPURLResponse class]]) {
//        NSHTTPURLResponse *theResponse = (NSHTTPURLResponse *)inResponse;
//        NSDictionary *theHeaders = [theResponse allHeaderFields];
//        NSString *theETag = theHeaders[@"ETag"];
//        NSString *theDate = theHeaders[@"Last-Modified"];
//
//        self.dataLength = 0;
//        self.statusCodeLabel.text = [NSString stringWithFormat:@"%d", theResponse.statusCode];
//        self.lengthLabel.text = [NSString stringWithFormat:@"%lld", theResponse.expectedContentLength];
//        self.cacheControlLabel.text = theHeaders[@"Cache-Control"];
//        [self.etagButton setTitle:theETag forState:UIControlStateNormal];
//        [self.dateButton setTitle:theDate forState:UIControlStateNormal];
//    }
//}
//
//- (NSURLRequest *)connection:(NSURLConnection *)inConnection willSendRequest:(NSURLRequest *)inRequest redirectResponse:(NSURLResponse *)inResponse {
//    return inRequest;
//}
//
//- (NSCachedURLResponse *)connection:(NSURLConnection *)inConnection willCacheResponse:(NSCachedURLResponse *)inCachedResponse {
//    self.cacheLabel.text = @"write";
//    return inCachedResponse;
//}
//
//- (void)connection:(NSURLConnection *)inConnection didReceiveData:(NSData *)inData {
//    self.dataLength += inData.length;
//}
//
//- (void)connectionDidFinishLoading:(NSURLConnection *)inConnection {
//    self.lengthLabel.text = [NSString stringWithFormat:@"%@ / %d", self.lengthLabel.text, self.dataLength];
//}

@end
