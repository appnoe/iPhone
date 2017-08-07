//
//  SecUtils.h
//  PhotoDiary
//
//  Created by Klaus Rodewig on 14.08.12.
//
//

#import <UIKit/UIKit.h>
#import <CommonCrypto/CommonDigest.h>

#define SALT @"loremipsumdolorsitametconsectetueradipiscingelit"
#define KEYCHAIN_LABEL @"PhotoDiary"
#define KEYCHAIN_SERVICE @"Foo Services Ltd."
#define KEYCHAIN_ACCOUNT @"PhotoDiaryUser"

@interface SecUtils : NSObject
+(NSString *)generateSHA256:(NSString *)inputString;
+(BOOL)addKeychainEntry:(NSString *)entry;
+(NSString *)getUserPwFromKeychain;
+(BOOL)checkJailbreak;
@end
