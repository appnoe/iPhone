//
//  DownloadViewController.m
//  Shop
//
//  Created by Clemens Wagner on 29.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DownloadViewController.h"
#import "UIViewController+SiteSchedule.h"
#import "NSDictionary+HTTPRequest.h"
#import "HTTPContentRange.h"
#import "NSURLCredentialStorage+Extensions.h"
#import "Reachability.h"

#define RESUMABLE_DOWNLOAD 1

#define kLocalDownloadURL @"http://nostromo.local/~clemens/SiteSchedule/schedule.xml"
#define kLocalDigestDownloadURL @"http://nostromo.local/~clemens/SiteSchedule/digest/schedule.xml"
#define kDefaultDownloadURL @"http://www.rodewig.de/iphone/without/schedule.xml"
#define kProtectedDownloadURL @"http://www.rodewig.de/iphone/withauth/schedule.xml"
static NSString * const kDownloadURL = kProtectedDownloadURL;

@interface DownloadViewController()<NSURLConnectionDataDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (weak, nonatomic) IBOutlet UITableViewCell *sitesCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *teamsCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *activitiesCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *reachabilityCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *updateCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *serverCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *updateRequiredCell;

@property (strong, nonatomic) IBOutletCollection(UIBarButtonItem) NSArray *buttons;

@property (strong, nonatomic) IBOutlet UIView *overlayView;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;

#if RESUMABLE_DOWNLOAD
@property (nonatomic) HTTPContentRange contentRange;
@property (strong, nonatomic) NSOutputStream *outputStream;
#else
@property (nonatomic) NSUInteger dataLength;
@property (strong, nonatomic) NSMutableData *data;
@property (strong, nonatomic) NSDate *lastModified;
#endif
@property (weak, nonatomic) NSURLConnection *connection;
@property (strong, nonatomic) NSURLAuthenticationChallenge *challenge;

- (IBAction)refreshServerCell;
- (void)refresh;
- (NSUInteger)countElementsForEntityNamed:(NSString *)inName;

@end

@implementation DownloadViewController

@synthesize managedObjectContext;
@synthesize sitesCell;
@synthesize teamsCell;
@synthesize activitiesCell;
@synthesize reachabilityCell;
@synthesize updateCell;
@synthesize serverCell;
@synthesize updateRequiredCell;
@synthesize overlayView;
@synthesize progressView;

@synthesize buttons;

#if RESUMABLE_DOWNLOAD
@synthesize contentRange;
@synthesize outputStream;
#else
@synthesize dataLength;
@synthesize data;
@synthesize lastModified;
#endif
@synthesize connection;
@synthesize challenge;

- (void)updateReachabilty:(Reachability *)inReachability {
    ReachabilityStatus theStatus = inReachability.currentReachabilityStatus;
    NSString *theKey = [NSString stringWithFormat:@"Reachability%d", 
                        theStatus];
    
    self.reachabilityCell.detailTextLabel.text = NSLocalizedString(theKey, @"");
    for(UIBarButtonItem *theItem in self.buttons) {
        theItem.enabled = theStatus != kReachabilityNotReachable;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.managedObjectContext = [self newManagedObjectContext];
    [self refreshServerCell];
}

- (void)viewDidUnload {
    self.managedObjectContext = nil;
    self.overlayView = nil;
    self.progressView = nil;
#if RESUMABLE_DOWNLOAD
    [self.outputStream close];
    self.outputStream = nil;
#else
    self.data = nil;
    self.lastModified = nil;
#endif
    self.challenge = nil;
    [super viewDidUnload];
}

- (void)viewWillDisappear:(BOOL)inAnimated {
    NSNotificationCenter *theCenter = [NSNotificationCenter defaultCenter];
    
    [theCenter removeObserver:self];
    [super viewWillDisappear:inAnimated];
}


- (void)viewWillAppear:(BOOL)inAnimated {
    [super viewWillAppear:inAnimated];
    id theDelegate = [[UIApplication sharedApplication] delegate];
    NSNotificationCenter *theCenter = [NSNotificationCenter defaultCenter];

    [self updateReachabilty:[theDelegate reachability]];
    [self refresh];
    [theCenter addObserver:self 
                  selector:@selector(reachabilityChanged:) 
                      name:kReachabilityChangedNotification 
                    object:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)inInterfaceOrientation {
    return NO;
}

- (void)reachabilityChanged:(NSNotification *)inNotification {
    [self updateReachabilty:inNotification.object];
}

- (UIView *)overlayParentView {
    return self.view.window.rootViewController.view;
}

- (BOOL)overlayHidden {
    return self.overlayView.superview == nil;
}

- (void)setOverlayHidden:(BOOL)inHidden {
    if(inHidden) {
        [self.overlayView removeFromSuperview];
    }
    else {
        UIView *theView = self.overlayParentView;
        
        self.overlayView.frame = theView.bounds;
        [theView addSubview:self.overlayView];
    }
}

- (void)setOverlayHidden:(BOOL)inHidden animated:(BOOL)inAnimated {
    self.overlayView.frame = self.overlayParentView.bounds;
    [UIView transitionWithView:self.overlayParentView duration:0.75 
                       options:UIViewAnimationOptionTransitionCrossDissolve | UIViewAnimationOptionLayoutSubviews
                    animations:^{
                        self.overlayHidden = inHidden;
                    }
                    completion:NULL];
}

- (NSURL *)downloadURL {
    return [NSURL URLWithString:kDownloadURL];
}

- (NSString *)downloadFile {
    NSArray *thePaths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    
    return [thePaths[0] stringByAppendingPathComponent:@"SiteSchedule.dat"];
}

- (IBAction)refreshServerCell {
    id theDelegate = [[UIApplication sharedApplication] delegate];
    Reachability *theReachability = [theDelegate reachability];
    
    if(theReachability.currentReachabilityStatus == kReachabilityNotReachable) {
        self.serverCell.detailTextLabel.text = @"-";
        self.updateRequiredCell.detailTextLabel.text = @"-";        
    }
    else {
        NSURL *theURL = self.downloadURL;
        NSDictionary *theFields = [NSDictionary dictionaryWithHeaderFieldsForURL:theURL];
        NSUserDefaults *theDefaults = [NSUserDefaults standardUserDefaults];
        NSDate *theUpdateTime = [theDefaults objectForKey:@"updateTime"];
        NSDate *theModificationTime = [theFields lastModified];
        NSString *theText = [NSDateFormatter localizedStringFromDate:theModificationTime
                                                           dateStyle:NSDateFormatterShortStyle 
                                                           timeStyle:NSDateFormatterShortStyle];
        NSString *theUpdateText = theUpdateTime == nil ||
            [theUpdateTime compare:theModificationTime] < NSOrderedSame ?
            NSLocalizedString(@"Yes", @"") : NSLocalizedString(@"No", @"");

        self.serverCell.detailTextLabel.text = theText;
        self.updateRequiredCell.detailTextLabel.text = theUpdateText;
    }
}

- (void)refresh {
    NSString *theDateText = @"-";
    NSUInteger theCount;
    NSDate *theDate = [[NSUserDefaults standardUserDefaults] objectForKey:@"downloadTime"];
    
    [self.managedObjectContext reset];
    theCount = [self countElementsForEntityNamed:@"Site"];
    self.sitesCell.detailTextLabel.text = [NSString stringWithFormat:@"%u", theCount];
    theCount = [self countElementsForEntityNamed:@"Team"];
    self.teamsCell.detailTextLabel.text = [NSString stringWithFormat:@"%u", theCount];
    theCount = [self countElementsForEntityNamed:@"Activity"];
    self.activitiesCell.detailTextLabel.text = [NSString stringWithFormat:@"%u", theCount];
    if(theDate != nil) {
        theDateText = [NSDateFormatter localizedStringFromDate:theDate 
                                                     dateStyle:NSDateFormatterShortStyle 
                                                     timeStyle:NSDateFormatterShortStyle];
    }
    self.updateCell.detailTextLabel.text = theDateText;
    if(!self.overlayHidden) {
        [self setOverlayHidden:YES animated:YES];
    }
}

- (NSUInteger)countElementsForEntityNamed:(NSString *)inName {
    NSFetchRequest *theRequest = [NSFetchRequest fetchRequestWithEntityName:inName];
    
    return [self.managedObjectContext countForFetchRequest:theRequest error:NULL];
}

- (BOOL)downloadRequired {
    NSUserDefaults *theDefaults = [NSUserDefaults standardUserDefaults];
    NSDate *theUpdateTime = [theDefaults objectForKey:@"updateTime"];
    
    if(theUpdateTime == nil) {
        return YES;
    }
    else {
        NSURL *theURL = self.downloadURL;
        NSDictionary *theFields = [NSDictionary dictionaryWithHeaderFieldsForURL:theURL];
        NSDate *theModificationTime = theFields.lastModified;
        
        return [theUpdateTime compare:theModificationTime] < NSOrderedSame;
    }
}

- (void)deleteDownloadFile {
    NSFileManager *theManager = [NSFileManager defaultManager];
    NSError *theError = nil;
    
    [theManager removeItemAtPath:self.downloadFile error:&theError];
    if(theError) {
        NSLog(@"deleteDownloadFile: %@", theError);
    }
}

- (NSUInteger)downloadFileSize {
    NSFileManager *theManager = [NSFileManager defaultManager];
    NSDictionary *theAttributes = [theManager attributesOfItemAtPath:self.downloadFile error:NULL];
    
    return theAttributes.fileSize;
}

- (void)finishDownload:(NSInputStream *)inoutStream {
    NSError *theError = [self.applicationDelegate updateWithInputStream:inoutStream];
    NSUserDefaults *theDefaults = [NSUserDefaults standardUserDefaults];
    
    if(theError) {
        NSLog(@"updateScheduleWithStream: error = %@", theError);
    }
    [theDefaults setObject:[NSDate date] forKey:@"downloadTime"];
    [theDefaults synchronize];
    [self refresh];
    [self setOverlayHidden:YES animated:YES];
#if RESUMABLE_DOWNLOAD
    [self deleteDownloadFile];
#else
    self.data = nil;
#endif
}

- (void)startDownload {
    NSURL *theURL = self.downloadURL;
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:theURL 
                                                              cachePolicy:NSURLRequestReloadIgnoringLocalCacheData 
                                                          timeoutInterval:5.0];
    
    NSLog(@"credentials = %@", [[NSURLCredentialStorage sharedCredentialStorage] allCredentials]);
#if SIMPLE_DOWNLOAD
    [NSURLConnection sendAsynchronousRequest:theRequest 
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *inResponse, NSData *inData, NSError *inError) {
                               if(inError == nil) {
                                   NSInputStream *theStream = [NSInputStream inputStreamWithData:inData];
                                   [self finishDownload:theStream];
                               }
                               else {
                                   NSLog(@"error = %@", inError);
                               }
                           }];
#else
#if RESUMABLE_DOWNLOAD
    NSUInteger theSize = self.downloadFileSize;
    
    if(theSize > 0 && ![self downloadRequired]) {
        NSString *theValue = [NSString stringWithFormat:@"bytes=%u-", theSize];
        
        [theRequest setValue:theValue forHTTPHeaderField:@"Range"];
    }
#endif
    NSLog(@"Headers: %@", theRequest.allHTTPHeaderFields);
    self.connection = [NSURLConnection connectionWithRequest:theRequest delegate:self];
#endif
}

- (IBAction)cancelDownload {
    [self.connection cancel];
    [self setOverlayHidden:YES animated:YES];
#if RESUMABLE_DOWNLOAD
    [self.outputStream close];
    self.outputStream = nil;
#else
    self.data = nil;
#endif
}

- (IBAction)downloadData {
    [self setOverlayHidden:NO animated:YES];
    self.progressView.progress = 0.0;
    [self startDownload];
}

- (IBAction)removeAllCredentials {
    [[NSURLCredentialStorage sharedCredentialStorage] removeAllCredentials];    
}

#pragma mark NSURLConnectionDataDelegate

#if RESUMABLE_DOWNLOAD
- (void)connection:(NSURLConnection *)inConnection didReceiveResponse:(NSURLResponse *)inResponse {
    NSHTTPURLResponse *theResponse = (id)inResponse;
    NSDictionary *theFields = [theResponse allHeaderFields];
    
    if(theResponse.statusCode == 200) {
        HTTPContentRange theRange = theFields.contentRange;
        NSUserDefaults *theDefaults = [NSUserDefaults standardUserDefaults];
        
        self.contentRange = theRange;
        self.outputStream = [NSOutputStream outputStreamToFileAtPath:self.downloadFile
                             append:theRange.range.location > 0];
        [self.outputStream open];
        self.progressView.progress = 0.0;
        [theDefaults setValue:theFields.lastModified forKey:@"updateTime"];
    }
    else {
        NSLog(@"Invalid status code: %d", theResponse.statusCode);
    }
}

- (void)connection:(NSURLConnection *)inConnection didReceiveData:(NSData *)inData {
    [self.outputStream write:inData.bytes maxLength:inData.length];
    self.progressView.progress = (double) self.downloadFileSize / (double) self.contentRange.size;
    // NSLog(@"%u / %u / %.1f%%", inData.length, self.downloadFileSize, self.progressView.progress * 100.0);
}

- (void)connection:(NSURLConnection *)inConnection didFailWithError:(NSError *)inError {
    [self setOverlayHidden:YES animated:YES];
    [self.outputStream close];
    self.outputStream = nil;
    NSLog(@"error = %@", inError);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)inConnection {
    if(self.outputStream != nil) {
        NSInputStream *theStream;
    
        [self.outputStream close];
        self.outputStream = nil;
        theStream = [NSInputStream inputStreamWithFileAtPath:self.downloadFile];
        self.updateRequiredCell.detailTextLabel.text = NSLocalizedString(@"No", @"");
        [self performSelector:@selector(finishDownload:) withObject:theStream afterDelay:0.0];
    }
}
#else
- (void)connection:(NSURLConnection *)inConnection didReceiveResponse:(NSURLResponse *)inResponse {    
    NSHTTPURLResponse *theResponse = (id)inResponse;
    
    if(theResponse.statusCode == 200) {
        NSDictionary *theFields = [theResponse allHeaderFields];

        self.dataLength = (NSUInteger) inResponse.expectedContentLength;
        self.data = [NSMutableData dataWithCapacity:self.dataLength];
        self.progressView.progress = 0.0;
        if([inResponse respondsToSelector:@selector(allHeaderFields)]) {
            self.lastModified = [(id)inResponse allHeaderFields].lastModified;
        }
    }
    else {
        NSLog(@"Invalid status code: %d", theResponse.statusCode);
    }
}

- (void)connection:(NSURLConnection *)inConnection didReceiveData:(NSData *)inData {
    [self.data appendData:inData];
    self.progressView.progress = (double) self.data.length / (double) self.dataLength;
    // NSLog(@"%u / %u / %.1f%%", inData.length, self.data.length, self.progressView.progress * 100.0);
}

- (void)connection:(NSURLConnection *)inConnection didFailWithError:(NSError *)inError {
    [self setOverlayHidden:YES animated:YES];
    self.data = nil;
    NSLog(@"error = %@", inError);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)inConnection {
    NSUserDefaults *theDefaults = [NSUserDefaults standardUserDefaults];
    
    [theDefaults setObject:self.lastModified forKey:@"updateTime"];
    [theDefaults synchronize];
    self.lastModified = nil;
    self.updateRequiredCell.detailTextLabel.text = NSLocalizedString(@"No", @"");
    [self performSelector:@selector(finishDownload:)
               withObject:[NSInputStream inputStreamWithData:self.data]
               afterDelay:0.0];
}
#endif

- (void)sendAuthenticationChallenge:(NSURLAuthenticationChallenge *)inChallenge
                      forConnection:(NSURLConnection *)inConnection {
    if([inChallenge previousFailureCount] < 3) {
        NSString *theMethod = [inChallenge.protectionSpace authenticationMethod];
        UIAlertView *theAlert = [[UIAlertView alloc] initWithTitle:theMethod
                                                           message:NSLocalizedString(@"Please enter your credentials.", @"")
                                                          delegate:self
                                                 cancelButtonTitle:NSLocalizedString(@"Cancel", @"")
                                                 otherButtonTitles:NSLocalizedString(@"Login", @""), nil];
        
        self.challenge = inChallenge;
        theAlert.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
        [theAlert show];
    }
    else {
        [inChallenge.sender cancelAuthenticationChallenge:inChallenge];
    }
}

- (void)connection:(NSURLConnection *)inConnection willSendRequestForAuthenticationChallenge:(NSURLAuthenticationChallenge *)inChallenge {
    [self sendAuthenticationChallenge:inChallenge forConnection:inConnection];
}

- (void)connection:(NSURLConnection *)inConnection 
didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)inChallenge {
    [self sendAuthenticationChallenge:inChallenge forConnection:inConnection];
}

#pragma mark UIAlertViewDelegate

- (void)alertView:(UIAlertView *)inAlertView willDismissWithButtonIndex:(NSInteger)inButtonIndex {
    if(inButtonIndex == 1) {
        NSString *theLogin = [inAlertView textFieldAtIndex:0].text;
        NSString *thePassword = [inAlertView textFieldAtIndex:1].text;
        NSURLCredential *theCredential = [NSURLCredential credentialWithUser:theLogin
                                                                    password:thePassword
                                                                 persistence:NSURLCredentialPersistenceForSession];
        
        [self.challenge.sender useCredential:theCredential
                  forAuthenticationChallenge:self.challenge];
    }
    else {
        [self cancelDownload];        
    }
    self.challenge = nil;
}

@end
