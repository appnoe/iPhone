//
//  ViewController.m
//  TLS
//
//  Created by Klaus Rodewig on 13.10.13.
//  Copyright (c) 2013 Cocoaneheads. All rights reserved.
//

#import "ViewController.h"
#import <CommonCrypto/CommonDigest.h>
#import <Security/Security.h>

#define SERVER_CERT_HASH @"68f3dc2e68b6f5bfedb467ed055e949c369f1089"

@interface ViewController ()

@end

@implementation ViewController

- (NSString*)sha1HexDigest:(NSData*)input
{ // see http://www.makebetterthings.com/blogs/uncategorized/how-to-get-md5-and-sha1-in-objective-c-ios-sdk/
    unsigned char result[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1([input bytes], (int) [input length], result);
	
    return [NSString stringWithFormat:
			@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
			result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7],
			result[8], result[9], result[10], result[11], result[12], result[13], result[14], result[15],
			result[16], result[17], result[18], result[19]
			];
}

- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace
{
	return ([[protectionSpace authenticationMethod] isEqual:NSURLAuthenticationMethodServerTrust]);
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    NSURLProtectionSpace *protectionSpace = [challenge protectionSpace];
    if ([[protectionSpace authenticationMethod] isEqual:NSURLAuthenticationMethodServerTrust]) {
        SecTrustRef theTrust = [protectionSpace serverTrust];
        BOOL trustedCert = NO;
        
        if(theTrust != NULL) {
            CFIndex theCertCount = SecTrustGetCertificateCount(theTrust);
            
            for(CFIndex theCertIndex = 0; theCertIndex < theCertCount; theCertIndex++) {
                SecCertificateRef theCert = SecTrustGetCertificateAtIndex(theTrust, theCertIndex);
                NSData *theData = (__bridge NSData *)SecCertificateCopyData(theCert);
                trustedCert |= [SERVER_CERT_HASH isEqual:[self sha1HexDigest:theData]];
            }
        }
        if(trustedCert) {
            NSURLCredential * credential = [NSURLCredential credentialForTrust:theTrust];
            
            [[challenge sender] useCredential:credential forAuthenticationChallenge:challenge];
            NSLog(@"Certificate trusted");
        }
        else {
            NSLog(@"Invalid certificate!");
        }
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    NSString *theURLString = @"https://www.postbank.de/";
    NSURL *theURL = [NSURL URLWithString:theURLString];
    NSURLRequest *theRequest = [NSURLRequest requestWithURL:theURL];
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    [connection start];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
