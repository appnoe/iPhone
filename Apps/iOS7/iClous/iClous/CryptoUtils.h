//
//  CryptoUtils.h
//  iClous
//
//  Created by Klaus Rodewig on 11.10.13.
//  Copyright (c) 2013 KMR. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CryptoUtils : NSObject
-(NSData *)encryptData:(NSData *)clearText;
-(id)initWithPassword:(NSString *)thePassword;
@property (retain) NSData *salt;
@property (retain) NSData *iv;
@property (retain) NSString *password;
@property (retain) NSData *cryptKey;
@end
