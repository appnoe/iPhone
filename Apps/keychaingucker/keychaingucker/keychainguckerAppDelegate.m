//
//  keychainguckerAppDelegate.m
//  keychaingucker
//
//  Created by Klaus M. Rodewig on 05.07.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "keychainguckerAppDelegate.h"

@implementation keychainguckerAppDelegate

@synthesize window = window;

-(BOOL)checkJailbreak
{
    // check for jailbreak
    // result not guaranteed, rootkits may disable any check
    // feature, not a bug: simulator appears always to be jailbroken (as using OS X resources)
    // remove logging for convenience
    // (c) 2011 by <klaus@rodewig.de>
    
    NSLog(@"[+] %@", NSStringFromSelector(_cmd));
    
    NSInteger forecast = 0;

    // first check: root partition rw    
    NSError *error = nil;
    NSString *fstab = [NSString stringWithContentsOfFile:@"/etc/fstab" encoding:NSISOLatin1StringEncoding error:&error];
    NSRange textRange;
    NSString *substring = [NSString stringWithString:@" / hfs rw"];
    textRange =[[fstab lowercaseString] rangeOfString:[substring lowercaseString]];
    
    if(textRange.location != NSNotFound)
    {
        NSLog(@"[+] / writeable");
        forecast += 25;
    } else {
        NSLog(@"[+] / not writeable");
    }
        
    // second check: locate Cydia
    NSString *docsDir = @"/Applications/";
    NSFileManager *localFileManager=[[NSFileManager alloc] init];
    error =nil;
    NSArray *dirEnum = [localFileManager contentsOfDirectoryAtPath:docsDir error:&error];
  
    for(id object in dirEnum){
        if([object isEqual:@"Cydia.app"]){
           forecast += 25;
            NSLog(@"[+] Cydia found");
        }
    }

    // third check: write in /
    if([localFileManager createDirectoryAtPath:@"/tmp/..." withIntermediateDirectories:NO attributes:nil error:&error]){
        forecast += 25;
        NSLog(@"[+] could write to /tmp");
        [localFileManager removeItemAtPath:@"/tmp/..." error:&error];
    } else {
        NSLog(@"[+] error creating dir: %@", error);
    }

    
    // forth check: find sshd
    if([localFileManager fileExistsAtPath:@"/usr/sbin/sshd"]){
        forecast += 25;
        NSLog(@"[+] sshd found");
    }

    // fifth check: find apt
    if([localFileManager fileExistsAtPath:@"/private/var/lib/apt"]){
        forecast += 25;
        NSLog(@"[+] apt found");
    }

    // sixth check: find bash
    if([localFileManager fileExistsAtPath:@"/bin/bash"]){
        forecast += 25;
        NSLog(@"[+] bash found");
    }
    
    [localFileManager release];
    
    NSLog(@"[+] forecast: %d%%", forecast);

    if(forecast >= 100) // adjust for probability
        return YES;
    else
        return NO;
}

-(BOOL)getKeychainData
{
    NSLog(@"[+] %@", NSStringFromSelector(_cmd));
    
    NSArray *keys = [NSArray arrayWithObjects:(NSString *)kSecClass, kSecAttrAccount, kSecAttrService, kSecReturnData, nil];
	NSArray *objects = [NSArray arrayWithObjects:(NSString *)kSecClassGenericPassword, @"fooname", @"1337-Service", kCFBooleanTrue, nil];
	
	NSMutableDictionary *query = [NSMutableDictionary dictionaryWithObjects:objects forKeys:keys];
    
    NSData *pw = NULL;
	OSStatus status = SecItemCopyMatching((CFDictionaryRef)query, (CFTypeRef *)&pw);
    NSLog(@"[+] keychain read status: %ld", status);
    
	if (status != noErr)
    {
        return NO;
    }
    
    NSString *password = [[NSString alloc] initWithData:pw encoding:NSUTF8StringEncoding];
    
    NSLog(@"[+] password from keychain: %@", password);
    
    return  YES;
}

-(BOOL)writeKeychainData
{
    NSLog(@"[+] %@", NSStringFromSelector(_cmd));

    NSString *service = [[NSString alloc] initWithString:@"1337-Service"];
    NSString *label = [[NSString alloc] initWithString:@"foolabel"];
    NSString *account = [[NSString alloc] initWithString:@"fooname"];
    NSString *pass = [[NSString alloc] initWithString:@"foopass"];
    
    NSMutableDictionary *query = [NSMutableDictionary dictionary];
    [query setObject:(id)kSecClassGenericPassword forKey:(id)kSecClass]; 
    [query setObject:service forKey:(id)kSecAttrService];
    [query setObject:label forKey:(id)kSecAttrLabel];
    [query setObject:account forKey:(id)kSecAttrAccount];    
    [query setObject:(id)kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly forKey:(id)kSecAttrAccessible];    
    [query setObject:[pass dataUsingEncoding:NSUTF8StringEncoding] forKey:(id)kSecValueData];
    
	OSStatus status = SecItemDelete((CFDictionaryRef)query);
    NSLog(@"[+] status deleting keychain item: %ld", status);

    status = SecItemAdd((__bridge CFDictionaryRef)query, NULL);
    NSLog(@"[+] keychain write status: %ld", status);
    
    if (status != noErr)
    {		

        return NO;
	}
    
    return  YES;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSLog(@"[+] %@", NSStringFromSelector(_cmd));
    
    window = [[UIWindow alloc] initWithFrame:[[UIScreen  mainScreen] bounds]];
	CGRect	rectFrame = [UIScreen mainScreen].applicationFrame;
	thisTextView  = [[UITextView alloc] initWithFrame:rectFrame];
	thisTextView.editable = NO;
    [window addSubview:thisTextView];
    [window makeKeyAndVisible];
    [self writeKeychainData];
    [self getKeychainData];
    
    if([self checkJailbreak])
        NSLog(@"[+] Device jailbroken!");
    else
        NSLog(@"[+] No Jailbreak");
    
    
//    [self urlRequest];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

@end
