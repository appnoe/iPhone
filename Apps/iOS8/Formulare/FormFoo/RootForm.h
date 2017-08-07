//
//  RootForm.h
//  FormFoo
//
//  Created by Klaus Rodewig on 07.11.14.
//  Copyright (c) 2014 Cocoaneheads. All rights reserved.
//

#import "FXForms.h"

typedef NS_ENUM(NSInteger, Gender)
{
    MALE = 0,
    FEMALE = 1,
    OTHER = 2
};

@interface RootForm : NSObject <FXForm>
@property (copy) NSString *name;
@property (copy) NSString *surName;
@property (copy) NSNumber *phoneNumber;
@property (copy) NSString *email;
@property (copy) NSString *street;
@property (copy) NSString *streetNumber;
@property (copy) NSNumber *zip;
@property (copy) NSString *city;
@property (copy) NSString *country;
@property BOOL newsletter;
@property Gender gender;
@end
