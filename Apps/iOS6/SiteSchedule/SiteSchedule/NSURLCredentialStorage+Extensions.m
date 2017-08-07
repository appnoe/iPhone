//
//  NSURLCredentialStorage+Extensions.m
//  SiteSchedule
//
//  Created by Clemens Wagner on 08.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NSURLCredentialStorage+Extensions.h"

@implementation NSURLCredentialStorage (Extensions)

- (void)removeAllCredentials {
    for(NSURLProtectionSpace *theSpace in self.allCredentials) {
        NSDictionary *theCredentials = [self credentialsForProtectionSpace:theSpace];
        
        for(NSURLCredential *theCredential in theCredentials.allValues) {
            [self removeCredential:theCredential forProtectionSpace:theSpace];
        }
    }
}

@end
