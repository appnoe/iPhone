//
//  DeviceInfo.h
//  iClous
//
//  Created by Rodewig Klaus on 26.06.11.
//  Copyright 2011 Klaus M. Rodewig. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeviceInfo : NSObject

-(void)getExternalIp;
-(void)dumpDeviceInfo;
-(id)initWithDeviceData;

@property(retain) NSString *udid;
@property(retain) NSString *name;
@property(retain) NSString *systemName;
@property(retain) NSString *systemVersion;
@property(retain) NSString *model;
@property(retain) NSString *thisDevicesExternalIpEvenBehindARouter;    // for Clemens
@property(retain) NSString *location;


@end
