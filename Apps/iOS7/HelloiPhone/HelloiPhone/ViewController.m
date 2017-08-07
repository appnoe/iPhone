//
//  ViewController.m
//  HelloiPhone
//
//  Created by Clemens Wagner on 12.07.13.
//  Copyright (c) 2013 Cocoaneheads. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)inAnimated {
    [super viewWillAppear:inAnimated];
    NSLog(@"[+] viewWillAppear:");
    [self.label setText:@"Moin!"];
}

- (IBAction)go:(id)sender {
    NSLog(@"[+] go:");
    NSError *theError = nil;
    NSURL *theURL = [NSURL URLWithString:@"http://www.rodewig.de/ip.php"];
    NSString *theIP = [NSString stringWithContentsOfURL:theURL encoding:NSASCIIStringEncoding error:&theError];

    if(theError == nil) {
        NSLog(@"[+] IP: %@", theIP);
    }
    else {
        NSLog(@"[+] Error: %@", [theError localizedDescription]);
    }
    [self.label setText:theIP];
}

@end
