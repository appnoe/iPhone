//
//  ViewController.m
//  AlarmClock
//
//  Created by Clemens Wagner on 17.07.13.
//  Copyright (c) 2013 Cocoaneheads. All rights reserved.
//

#import "ViewController.h"
#import "ClockView.h"
#import "ClockControl.h"
#import "UIView+AlarmClock.h"

const NSTimeInterval kSecondsOfDay = 60.0 * 60.0 * 24.0;

@interface ViewController ()

@property (weak, nonatomic) IBOutlet ClockView *clockView;
@property (weak, nonatomic) IBOutlet ClockControl *clockControl;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (nonatomic) BOOL alarmHidden;

- (IBAction)updateTimeLabel;
- (IBAction)switchAlarm:(UILongPressGestureRecognizer *)inRecognizer;
- (IBAction)updateAlarm;

@end

@implementation ViewController

-(BOOL) prefersStatusBarHidden {
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)inAnimated {
    [super viewWillAppear:inAnimated];
    [self updateViews];
}

- (void)viewDidAppear:(BOOL)inAnimated {
    [super viewDidAppear:inAnimated];
    [self.clockView startAnimation];
}

- (void)viewWillDisappear:(BOOL)inAnimated {
    [self.clockView stopAnimation];
    [super viewWillDisappear:inAnimated];
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

    self.timeLabel.text = [NSString stringWithFormat:@"%d:%02d",
                           (int)theHours, (int)theMinutes];
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
    theNotification.soundName = UILocalNotificationDefaultSoundName;
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

@end
