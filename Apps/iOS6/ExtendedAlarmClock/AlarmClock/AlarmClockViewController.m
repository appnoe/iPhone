//
//  AlarmClockViewController.m
//  AlarmClock
//
//  Created by Clemens Wagner on 17.07.13.
//  Copyright (c) 2013 Cocoaneheads. All rights reserved.
//

#import "AlarmClockViewController.h"
#import "ClockView.h"
#import "ClockControl.h"
#import "UIView+AlarmClock.h"
#import "UIView+LayoutConstraints.h"

const NSTimeInterval kSecondsOfDay = 60.0 * 60.0 * 24.0;

@interface AlarmClockViewController()

@property (assign, nonatomic) IBOutlet ClockView *clockView;
@property (assign, nonatomic) IBOutlet ClockControl *clockControl;
@property (assign, nonatomic) IBOutlet UILabel *timeLabel;

@property (nonatomic) BOOL alarmHidden;

- (IBAction)updateTimeLabel;
- (IBAction)switchAlarm:(UILongPressGestureRecognizer *)inRecognizer;
- (IBAction)updateAlarm;

@end

@implementation AlarmClockViewController

@synthesize clockView;
@synthesize clockControl;
@synthesize timeLabel;
@synthesize alarmHidden;

- (void)dealloc {
    self.clockView = nil;
    self.clockControl = nil;
    self.timeLabel = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    ClockView *theView = self.clockView;
    NSLayoutConstraint *theConstraint = [NSLayoutConstraint constraintWithItem:theView
                                                                     attribute:NSLayoutAttributeHeight
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:theView
                                                                     attribute:NSLayoutAttributeWidth
                                                                    multiplier:1.0 constant:0.0];

    theConstraint.priority = UILayoutPriorityRequired;
    theView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view removeConstraintsForView:theView];
    [self.view addConstraint:theConstraint];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[clock(>=100)]-(>=0@750)-|"
                                                                    options:0
                                                                    metrics:nil
                                                                      views:@{ @"clock" : theView }]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[clock(>=100)]-(>=0@750)-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:@{ @"clock" : theView }]];
}

- (void)viewDidUnload {
    self.clockView = nil;
    self.clockControl = nil;
    self.timeLabel = nil;
    [super viewDidUnload];
}

- (void)updateClockView {
    NSUserDefaults *theDefaults = [NSUserDefaults standardUserDefaults];

    self.clockView.showDigits = [theDefaults boolForKey:@"showDigits"];
    self.clockView.partitionOfDial = [theDefaults integerForKey:@"partitionOfDial"];
    [self.clockView setNeedsDisplay];
}

- (void)viewWillAppear:(BOOL)inAnimated {
    [super viewWillAppear:inAnimated];
    [self updateClockView];
    [self updateViews];
}

- (void)viewDidAppear:(BOOL)inAnimated {
    [super viewDidAppear:inAnimated];
    NSUserDefaults *theDefaults = [NSUserDefaults standardUserDefaults];

    [theDefaults addObserver:self forKeyPath:@"showDigits" options:0 context:nil];
    [theDefaults addObserver:self forKeyPath:@"partitionOfDial" options:0 context:nil];
    [self.clockView startAnimation];
}

- (void)viewWillDisappear:(BOOL)inAnimated {
    NSUserDefaults *theDefaults = [NSUserDefaults standardUserDefaults];

    [theDefaults removeObserver:self forKeyPath:@"showDigits"];
    [theDefaults removeObserver:self forKeyPath:@"partitionOfDial"];
    [self.clockView stopAnimation];
    [super viewWillDisappear:inAnimated];
}

- (void)observeValueForKeyPath:(NSString *)inKeyPath
                      ofObject:(id)inObject change:(NSDictionary *)inChange
                       context:(void *)inContext {
    [self updateClockView];
}

- (void)updateViews {
    UIApplication *theApplication = [UIApplication sharedApplication];
    UILocalNotification *theNotification = [[theApplication scheduledLocalNotifications] lastObject];

    if(theNotification == nil) {
        self.alarmHidden = YES;
    }
    else {
        NSTimeInterval theTime = [theNotification.fireDate timeIntervalSinceReferenceDate] - self.startTimeOfCurrentDay;

        theTime = remainder(theTime, kSecondsOfDay / 2.0);
        self.clockControl.time = theTime < 0 ? theTime + kSecondsOfDay / 2.0 : theTime;
        self.alarmHidden = NO;
    }
    [self updateTimeLabel];
}

- (BOOL)alarmHidden {
    return self.clockControl.hidden;
}

- (void)setAlarmHidden:(BOOL)inAlarmHidden {
    self.clockControl.hidden = inAlarmHidden;
    self.timeLabel.hidden = inAlarmHidden;
}

- (IBAction)updateTimeLabel {
    NSInteger theTime = round(self.clockControl.time / 60.0);
    NSInteger theMinutes = theTime % 60;
    NSInteger theHours = theTime / 60;

    self.timeLabel.text = [NSString stringWithFormat:@"%d:%02d", theHours, theMinutes];
}

- (IBAction)switchAlarm:(UILongPressGestureRecognizer *)inRecognizer {
    if(inRecognizer.state == UIGestureRecognizerStateEnded) {
        if(self.alarmHidden) {
            CGPoint thePoint = [inRecognizer locationInView:self.clockView];
            CGFloat theAngle = [self.clockView angleWithPoint:thePoint];
            NSTimeInterval theTime = 21600.0 * theAngle / M_PI;

            self.alarmHidden = NO;
            self.clockControl.time = theTime;
            [self updateTimeLabel];
            [self.clockControl exerciseAmbiguityInLayout];
        }
        else {
            self.alarmHidden = YES;
        }
        [self updateAlarm];
    }
}

- (IBAction)updateAlarm {
    if(self.alarmHidden) {
        UIApplication *theApplication = [UIApplication sharedApplication];

        [theApplication cancelAllLocalNotifications];
    }
    else {
        [self createAlarm];
    }
}


- (NSDate *)alarmDate {
    NSTimeInterval theTime = self.startTimeOfCurrentDay + self.clockControl.time;
    
    while(theTime < [NSDate timeIntervalSinceReferenceDate]) {
        theTime += kSecondsOfDay / 2.0;
    }
    return [NSDate dateWithTimeIntervalSinceReferenceDate:theTime];
}

- (void)createAlarm {
    UIApplication *theApplication = [UIApplication sharedApplication];
    UILocalNotification *theNotification = [UILocalNotification new];

    [theApplication cancelAllLocalNotifications];
    theNotification.fireDate = [self alarmDate];
    theNotification.timeZone = [NSTimeZone defaultTimeZone];
    theNotification.alertBody = NSLocalizedString(@"Wake up", @"Alarm message");
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"playSound"]) {
        theNotification.soundName = UILocalNotificationDefaultSoundName;
    }
    [theApplication scheduleLocalNotification:theNotification];
}

- (NSTimeInterval)startTimeOfCurrentDay {
    NSCalendar *theCalendar = [NSCalendar currentCalendar];
    NSDateComponents *theComponents = [theCalendar components:NSCalendarUnitYear | NSCalendarUnitMonth |NSCalendarUnitDay fromDate:[NSDate date]];
    NSDate *theDate = [theCalendar dateFromComponents:theComponents];

    return [theDate timeIntervalSinceReferenceDate];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"alarm: %@ (%@)", self.timeLabel.text, self.alarmHidden ? @"off" : @"on"];
}

- (NSString *)debugDescription {
    return [NSString stringWithFormat:@"debug alarm: %@ (%.3fs, %@)",
            self.timeLabel.text, self.clockControl.time,
            self.alarmHidden ? @"off" : @"on"];
}

#pragma mark UISplitViewControllerDelegate

- (void)splitViewController:(UISplitViewController *)inSplitViewController
     willHideViewController:(UIViewController *)inController
          withBarButtonItem:(UIBarButtonItem *)inItem
       forPopoverController:(UIPopoverController *)inPopover {
    inItem.title = NSLocalizedString(@"Preferences", @"");
    self.navigationItem.leftBarButtonItem = inItem;
}

- (void)splitViewController:(UISplitViewController *)inSplitViewController
     willShowViewController:(UIViewController *)inController
  invalidatingBarButtonItem:(UIBarButtonItem *)inItem {
    self.navigationItem.leftBarButtonItem = nil;
}

@end
