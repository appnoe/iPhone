//
//  ViewController.m
//  Kapitel2
//
//  Created by Clemens Wagner on 22.09.13.
//  Copyright (c) 2013 Cocoaneheads. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (strong, nonatomic) IBOutlet UILabel *countLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.textView setText:@""];
    [self writeLog:@"viewDidLoad"];
    self.model = [[Model alloc] initWithName:@"LoremIpsum"];
    [self writeLog:[NSString stringWithFormat:@"Model.name: %@", [self.model name]]];

}

- (void)viewDidAppear:(BOOL)inAnimated {
    [super viewDidAppear:inAnimated];
    [self.model addObserver:self
                 forKeyPath:@"status"
                    options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                    context:NULL];
    [self.model addObserver:self forKeyPath:@"countOfObjects" options:NSKeyValueObservingOptionNew context:NULL];
}

- (void)viewWillDisappear:(BOOL)inAnimated {
    [self.model removeObserver:self forKeyPath:@"status"];
    [self.model removeObserver:self forKeyPath:@"countOfObjects"];
    [super viewWillDisappear:inAnimated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)writeLog:(NSString *)inLogString{
    NSLog(@"[+] %@.%@", self, NSStringFromSelector(_cmd));
    NSDateFormatter *theFormatter = [[NSDateFormatter alloc] init];

    [theFormatter setDateFormat:@"HH:mm:ss.SSS"];
    [self.textView setText:[NSString stringWithFormat:@"%@\n%@ [+] %@",
                            [self.textView text],
                            [theFormatter stringFromDate:[NSDate date]],
                            inLogString]];
}

- (IBAction)updateCountOfDroids:(UIStepper *)inSender {
    int theValue = [inSender value];

    [self.model updateDroids:theValue];
    [self writeLog:[NSString stringWithFormat:@"countOfObjects = %d", [self.model countOfObjects]]];
}

- (IBAction)listModel:(id)sender {
    [self.model listDroids];
}

- (void)observeValueForKeyPath:(NSString *)inKeyPath ofObject:(id)inObject change:(NSDictionary *)inChange context:(void *)inContext {
    if([inKeyPath isEqualToString:@"status"]) {
        NSLog(@"[+] Old status:%@", [inChange valueForKey:NSKeyValueChangeOldKey]);
        NSLog(@"[+] New status:%@", [inChange valueForKey:NSKeyValueChangeNewKey]);
    }
    else if([inKeyPath isEqualToString:@"countOfObjects"]) {
        [self.countLabel setText:[NSString stringWithFormat:@"%d",
                                  [inObject countOfObjects]]];
    }
}


@end