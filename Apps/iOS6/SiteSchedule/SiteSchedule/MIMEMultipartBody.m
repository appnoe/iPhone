//
//  Multipart.m
//
//  Created by Clemens Wagner on 19.05.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MIMEMultipartBody.h"
#import "NSString+URLTools.h"

@interface MIMEMultipartBody()

@property (nonatomic, readwrite) NSStringEncoding encoding;
@property (nonatomic, copy, readwrite) NSString *charset;
@property (nonatomic, copy, readwrite) NSString *boundary;
@property (nonatomic, retain, readwrite) NSMutableData *data;

@end

@implementation MIMEMultipartBody

@synthesize encoding;
@synthesize charset;
@synthesize boundary;
@synthesize data;

- (id)init {
    return [self initWithEncoding:NSUTF8StringEncoding];
}

- (id)initWithEncoding:(NSStringEncoding)inEncoding {
    return [self initWithEncoding:inEncoding boundary:nil];
}


- (id)initWithEncoding:(NSStringEncoding)inEncoding boundary:(NSString *)inBoundary {
    self = [super init];
    if(self) {
        CFStringEncoding theEncoding = CFStringConvertNSStringEncodingToEncoding(self.encoding);
        
        self.encoding = inEncoding;
        self.charset = (id)CFStringConvertEncodingToIANACharSetName(theEncoding);
        self.data = [NSMutableData dataWithCapacity:8192];
        if(inBoundary.length > 0) {
            self.boundary = inBoundary;
        }
        else {
            NSUInteger theKey = (NSUInteger) [NSDate timeIntervalSinceReferenceDate] * 19 + (rand() % 123457);
            
            self.boundary = [NSString stringWithFormat:@"----MIMEMultipartBody%x", theKey];
        }
    }
    return self;
}

- (NSString *)contentType {
    return [NSString stringWithFormat:@"multipart/form-data; boundary=%@", self.boundary];
}

- (void)appendString:(NSString *)inValue {
    NSData *theData = [inValue dataUsingEncoding:self.encoding];
    
    [self.data appendData:theData];
}

- (void)appendNewline {
    [self appendString:@"\r\n"];
}

- (NSData *)body {
    NSMutableData *theBody = self.data;
    NSUInteger theLength = theBody.length;
    NSData *theData;

    [self appendString:[NSString stringWithFormat:@"--%@--", self.boundary]];
    [self appendNewline];
    theData = [theBody copy];
    theBody.length = theLength;
    return theData;
}

- (void)startNewPart {
    [self appendString:[NSString stringWithFormat:@"--%@", self.boundary]];
    [self appendNewline];
}

- (void)appendParameterValue:(NSString *)inValue withName:(NSString *)inName {
    NSString *theName = [inName encodedStringForURLWithEncoding:self.encoding];
    
    [self startNewPart];
    [self appendString:[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"", theName]];
    [self appendNewline];
    [self appendNewline];
    [self appendString:inValue];
    [self appendNewline];
}

- (void)appendData:(NSData *)inData
          withName:(NSString *)inName
       contentType:(NSString *)inContentType
          filename:(NSString *)inFileName {
    NSString *theName = [inName encodedStringForURLWithEncoding:self.encoding];
    NSString *theFileName = [inFileName encodedStringForURLWithEncoding:self.encoding];

    [self startNewPart];
    [self appendString:[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"", theName, theFileName]];
    [self appendNewline];
    [self appendString:[NSString stringWithFormat:@"Content-Type: %@", inContentType]];
    [self appendNewline];
    [self appendNewline];
    [self.data appendData:inData];
    [self appendNewline];
}

- (NSMutableURLRequest *)mutableRequestWithURL:(NSURL *)inURL timeout:(NSTimeInterval)inTimeout {
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:inURL
                                                              cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                          timeoutInterval:inTimeout];
    NSData *theBody = self.body;
    NSString *theLength = [NSString stringWithFormat:@"%d", theBody.length];
    
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setValue:self.contentType forHTTPHeaderField:@"Content-Type"];
    [theRequest setValue:theLength forHTTPHeaderField:@"Content-Length"];
    [theRequest setHTTPBody:theBody];
    return theRequest;
}

@end
