//
//  DeviceInfo.m
//  iClous
//
//  Created by Rodewig Klaus on 26.06.11.
//  Copyright 2011 Klaus M. Rodewig. All rights reserved.
//

#import "DeviceInfo.h"

#define UBIQUITY_CONTAINER_URL @"6RT4NMNXMS.de.ifoo.iclous"

@implementation DeviceInfo

@synthesize udid, name, systemName, systemVersion, model, thisDevicesExternalIpEvenBehindARouter, location;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

-(id)initWithDeviceData
{
    self = [super init];
    if (self) {
        UIDevice *thisDevice =[[UIDevice alloc] init];
        self.udid = [thisDevice uniqueIdentifier];
        self.name = [thisDevice name];
        self.systemName = [thisDevice systemName];
        self.systemVersion = [thisDevice systemVersion];
        self.model = [thisDevice model];
    }
    
    return self;
}

- (void)dumpDeviceInfo
{
    NSLog(@"[+] %@", NSStringFromSelector(_cmd));
    NSMutableString *str = [[NSMutableString alloc] initWithString:self.udid];
    [str appendString:@"\n"];
    [str appendString:self.location];
    [str appendString:@"\n"];
    [str appendString:self.thisDevicesExternalIpEvenBehindARouter];
    [str appendString:@"\n"];
    [str appendString:self.name];
    [str appendString:@"\n"];
    [str appendString:self.systemName];
    [str appendString:@"\n"];
    [str appendString:self.systemVersion];
        
    NSData* data=[str dataUsingEncoding:NSUTF8StringEncoding];
    
    NSArray *domainDirs = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSMutableString *file = [[NSMutableString alloc] initWithString:[domainDirs objectAtIndex:0]];
    [file appendString:@"/"];
    [file appendString:self.udid];
    [file appendString:@".txt"];
    NSLog(@"[+] file: %@", file);
    [data writeToFile:file atomically:YES];
    
    // hier beginnt der iCloud-Teil
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    NSURL *ubiquityContainerURL = [[fileMgr URLForUbiquityContainerIdentifier:UBIQUITY_CONTAINER_URL] URLByAppendingPathComponent:@"Documents"];
    if ([fileMgr fileExistsAtPath:[ubiquityContainerURL path]] == NO)
        // Documents directory does not exist yet.
        [fileMgr createDirectoryAtURL:ubiquityContainerURL withIntermediateDirectories:YES attributes:nil error:nil];
    if ([fileMgr isUbiquitousItemAtURL:[NSURL fileURLWithPath:file]] == NO)
        // Item is not stored in the cloud.
        [fileMgr setUbiquitous:YES itemAtURL:[NSURL fileURLWithPath:file] destinationURL:[ubiquityContainerURL URLByAppendingPathComponent:[file lastPathComponent]] error:nil];

}

- (void)getExternalIp
{
    NSLog(@"[+] %@", NSStringFromSelector(_cmd));
    NSString *externalIp = @"0.0.0.0";
    
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://checkip.dyndns.org/"]
                                                cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                            timeoutInterval:10];
    NSError *error;
    NSURLResponse *response;
    NSData *urlData = [NSURLConnection sendSynchronousRequest:urlRequest
                                            returningResponse:&response
                                                        error:&error];    
    
    if(!urlData)
        NSLog(@"[+] no ip. no future: %@", error);
    
    
    NSString *ipString = [NSString stringWithUTF8String:[urlData bytes]];
    
    NSArray *listItems1 = [ipString componentsSeparatedByString:@": "];
    NSArray *listItems2 = [[listItems1 objectAtIndex:1] componentsSeparatedByString:@"<"];
    externalIp = [listItems2 objectAtIndex:0];
    NSLog(@"[+] IP: %@", externalIp);
    
    thisDevicesExternalIpEvenBehindARouter = externalIp;
}

@end
