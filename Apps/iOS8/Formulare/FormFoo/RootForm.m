//
//  RootForm.m
//  FormFoo
//
//  Created by Klaus Rodewig on 07.11.14.
//  Copyright (c) 2014 Cocoaneheads. All rights reserved.
//

#import "RootForm.h"

@implementation RootForm

- (NSArray *)fields
{
    return @[
             @{FXFormFieldKey: @"name", FXFormFieldTitle: @"Vorame", FXFormFieldHeader: @"Ihr Name"},
             @{FXFormFieldKey: @"surName", FXFormFieldTitle: @"Name", @"textField.placeholder" : @"foobar"},
             @{FXFormFieldKey: @"phoneNumber", FXFormFieldTitle: @"Telefon", FXFormFieldHeader: @"Ihre Kontaktdaten"},
             @{FXFormFieldKey: @"email", FXFormFieldTitle: @"Email"},
             @{FXFormFieldKey: @"street", FXFormFieldTitle: @"Strasse", FXFormFieldHeader: @"Ihre Anschrift"},
             @{FXFormFieldKey: @"streetNumber", FXFormFieldTitle: @"Hausnummer"},
             @{FXFormFieldKey: @"zip", FXFormFieldTitle: @"PLZ"},
             @{FXFormFieldKey: @"city", FXFormFieldTitle: @"Stadt"},
             @{FXFormFieldKey: @"country", FXFormFieldTitle: @"Land"},
             @{FXFormFieldKey: @"gender", FXFormFieldTitle: @"Geschlecht", FXFormFieldOptions: @[@"männlich", @"weiblich", @"Borg"], FXFormFieldHeader: @"Diverses"}
             ];
}

@end
