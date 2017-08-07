#import "HelpViewController.h"

@implementation HelpViewController
@synthesize webView;

- (void)dealloc {
    self.webView.delegate = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSBundle *theBundle = [NSBundle mainBundle];
    NSData *theData = [NSData dataWithContentsOfFile:[theBundle pathForResource:@"index" ofType:@"html"]];
    NSURL *theBaseURL = [theBundle resourceURL];
    
    [self.webView loadData:theData MIMEType:@"text/html" textEncodingName:@"UTF-8" baseURL:theBaseURL];
}

#pragma mark UIWebViewDelegate

- (BOOL)webView:(UIWebView *)inWebView shouldStartLoadWithRequest:(NSURLRequest *)inRequest navigationType:(UIWebViewNavigationType)inNavigationType {
    NSURL *theURL = inRequest.URL;
    
    if([theURL.scheme isEqualToString:@"games"]) {
        NSInteger theIndex = [theURL.host intValue];
        
        self.tabBarController.selectedIndex = theIndex;
        return NO;
    }
    else {
        return YES;
    }
}

@end
