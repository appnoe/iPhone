//
//  main.m
//  First Steps
//
//  Created by Klaus M. Rodewig on 04.01.11.
//  Copyright 2011 Klaus M. Rodewig. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Fahrzeug.h"
#import "Automobil.h"
#import "ReverseString.h"

int main (int argc, const char * argv[]) {
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
       
    [@"Wortverdreher" reverse];
    NSLog(@" --- Fahrzeug *fahrzeug = [[Fahrzeug alloc] init]; ---");
    Fahrzeug *fahrzeug = [[Fahrzeug alloc] init];
    NSLog(@" --- Automobil *automobil = [[Automobil alloc] init]; ---");
    Automobil *automobil = [[Automobil alloc] init];
    NSLog(@" --- [fahrzeug getId]; ---");
    [fahrzeug getId];
    NSLog(@" --- [automobil getId]; ---");
    [automobil getId];
    NSLog(@" --- [fahrzeug release]; ---");
    [fahrzeug release];
    NSLog(@" --- [automobil release] ---");
    [automobil release];
    NSLog(@" --- [pool drain]; ---");
    [pool drain];
    return 0;
}

