//
//  SecUtils.m
//  PhotoDiary
//
//  Created by Klaus Rodewig on 14.08.12.
//
//

#import "SecUtils.h"

@interface SecUtils ()

@end

@implementation SecUtils

+(NSString *)generateSHA256:(NSString *)inputString{
    NSLog(@"[+] %@", NSStringFromSelector(_cmd));
    
    UIDevice *thisDevice = [UIDevice currentDevice];
    
    NSLog(@"udid: %@", [thisDevice identifierForVendor]);

    NSString *passwordWithSalt = [NSString stringWithFormat:@"%@%@", [[thisDevice identifierForVendor] UUIDString], inputString];
//    NSString *passwordWithSalt = [NSString stringWithFormat:@"%@%@", @"foobar", inputString];

//    NSLog(@"[+] passwordWithSalt: %@", passwordWithSalt);
    
    NSMutableString *passwordHash = [NSMutableString stringWithCapacity:CC_SHA256_DIGEST_LENGTH];
    unsigned char passwordChars[CC_SHA256_DIGEST_LENGTH];
    CC_SHA256([passwordWithSalt UTF8String], [passwordWithSalt lengthOfBytesUsingEncoding:NSUTF8StringEncoding], passwordChars);
    for(int i=0; i< CC_SHA256_DIGEST_LENGTH; i++){
        [passwordHash appendString:[NSString stringWithFormat:@"%02x", passwordChars[i]]];
    }
    return passwordHash;
}

+(BOOL)addKeychainEntry:(NSString *)entry{
    NSLog(@"[+] %@", NSStringFromSelector(_cmd));
    
    NSMutableDictionary *searchDict = [NSMutableDictionary dictionary];
    [searchDict setObject:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];
    [searchDict setObject:KEYCHAIN_SERVICE forKey:(__bridge id)kSecAttrService];
    [searchDict setObject:KEYCHAIN_LABEL forKey:(__bridge id)kSecAttrLabel];
    [searchDict setObject:KEYCHAIN_ACCOUNT forKey:(__bridge id)kSecAttrAccount];
    
    NSMutableDictionary *writeDict = [NSMutableDictionary dictionary];
    [writeDict setDictionary:searchDict];
    [writeDict setObject:(__bridge id)kSecAttrAccessibleWhenUnlocked forKey:(__bridge id)kSecAttrAccessible];
    [writeDict setObject:[entry dataUsingEncoding:NSUTF8StringEncoding] forKey:(__bridge id)kSecValueData];
    
    NSMutableDictionary *updateDict = [NSMutableDictionary dictionary];
    [updateDict setObject:[entry dataUsingEncoding:NSUTF8StringEncoding] forKey:(__bridge id)kSecValueData];
    
    if(SecItemAdd((__bridge CFDictionaryRef)writeDict, NULL) == errSecDuplicateItem){
        NSLog(@"[+] Old password found - updating");
        SecItemUpdate((__bridge CFDictionaryRef)searchDict, ((__bridge CFDictionaryRef)updateDict));
    }
    return YES;
}

+(NSString *)getUserPwFromKeychain{
    NSLog(@"[+] %@", NSStringFromSelector(_cmd));
   
    NSMutableDictionary *query = [NSMutableDictionary dictionary];
    [query setObject:(__bridge NSString *)kSecClassGenericPassword forKey:(__bridge NSString *)kSecClass];
    [query setObject:KEYCHAIN_ACCOUNT forKey:(__bridge id)kSecAttrAccount];
    [query setObject:KEYCHAIN_LABEL forKey:(__bridge id)kSecAttrService];
    [query setObject:KEYCHAIN_SERVICE forKey:(__bridge id)kSecAttrService];
    [query setObject:(id)kCFBooleanTrue forKey:(__bridge_transfer id)kSecReturnData];
        
    CFDataRef pw = nil;
    OSStatus status = SecItemCopyMatching((__bridge CFDictionaryRef)query, (CFTypeRef*)&pw);
    
    if(status != noErr){
        NSLog(@"[+] Error reading PW from Keychain");
    }
    
    NSData *result = (__bridge_transfer NSData*)pw;
    NSString *storedPassword = [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
    return  storedPassword;
}

+(BOOL)checkJailbreak{
    NSLog(@"[+] %@", NSStringFromSelector(_cmd));
    
    NSRange range = [[[UIDevice currentDevice] localizedModel] rangeOfString:@"Simulator" options:NSCaseInsensitiveSearch];
    if(range.location != NSNotFound)
    {
        NSLog(@"[+] Running on Simulator");
        return NO;
    }
    NSInteger forecast = 0;
    
    // root partition rw
    NSError *error = nil;
    NSString *fstab = [NSString stringWithContentsOfFile:@"/etc/fstab" encoding:NSISOLatin1StringEncoding error:&error];
    NSRange textRange;
    NSString *substring = @" / hfs rw";
    textRange =[[fstab lowercaseString] rangeOfString:[substring lowercaseString]];
    
    if(textRange.location != NSNotFound)
    {
        NSLog(@"[+] / writeable");
        forecast += 16;
    } else {
        NSLog(@"[+] / not writeable");
    }
    
    // locate Cydia
    NSString *docsDir = @"/Applications/";
    NSFileManager *localFileManager=[[NSFileManager alloc] init];
    error =nil;
    NSArray *dirEnum = [localFileManager contentsOfDirectoryAtPath:docsDir error:&error];
    
    for(id object in dirEnum){
        if([object isEqual:@"Cydia.app"]){
            forecast += 16;
            NSLog(@"[+] Cydia found");
        }
    }
    
    // write in /
    if([localFileManager createDirectoryAtPath:@"/tmp/..." withIntermediateDirectories:NO attributes:nil error:&error]){
        forecast += 16;
        NSLog(@"[+] could write to /tmp");
        [localFileManager removeItemAtPath:@"/tmp/..." error:&error];
    } else {
        NSLog(@"[+] error creating dir: %@", error);
    }
    
    
    // find sshd
    if([localFileManager fileExistsAtPath:@"/usr/sbin/sshd"]){
        forecast += 16;
        NSLog(@"[+] sshd found");
    }
    
    // find apt
    if([localFileManager fileExistsAtPath:@"/private/var/lib/apt"]){
        forecast += 16;
        NSLog(@"[+] apt found");
    }
    
    // find bash
    if([localFileManager fileExistsAtPath:@"/bin/bash"]){
        forecast += 16;
        NSLog(@"[+] bash found");
    }
    
    // find MobileSubstrate
    if([localFileManager fileExistsAtPath:@"/Library/MobileSubstrate/MobileSubstrate.dylib"]){
        forecast += 16;
        NSLog(@"[+] MobileSubstrate found");
    }
    
    // fork()
    int res = fork();
    if(res>0){
        forecast += 16;
        NSLog(@"[+] fork successfull");
    } else {
        NSLog(@"fork: %s\n", strerror(errno));
    }
    
    // symlink
    NSFileManager *file = [NSFileManager defaultManager];
    NSDictionary *fileDic = [file attributesOfItemAtPath:@"/Applications" error:&error];
    NSString *type = [fileDic objectForKey:NSFileType];
    if(type != NSFileTypeDirectory){
        forecast += 16;
        NSLog(@"type: %@", type);
    } else {
        NSLog(@"type: %@", type);
    }
    
    
    NSLog(@"[+] forecast: %d%%", forecast);
    
    if(forecast >= 32) // adjust for probability
        return YES;
    else
        return NO;
}

@end
