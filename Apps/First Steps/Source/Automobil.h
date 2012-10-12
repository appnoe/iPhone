//
//  Automobil.h
//  First Steps
//
//  Created by Klaus M. Rodewig on 17.01.11.
//  Copyright 2011 Klaus M. Rodewig. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Fahrzeug.h"

@interface Automobil : Fahrzeug {
    @private
    NSDate  *hauptUntersuchung;
    unsigned int anzahlTueren;
    double leistung;
}

-(NSString*)details;

#pragma mark Getter
-(NSDate *)hauptUntersuchung;
-(unsigned int)anzahlTueren;
-(double)leistung;

#pragma mark Setter
-(void)setHauptUntersuchung:(NSDate*)inDate;
-(void)setAnzahlTueren:(unsigned int)inTueren;
-(void)setLeistung:(double)inLeistung;

@end
