#import "AlarmClockViewController.h"
#import "ClockControl.h"
#import "ClockView.h"

const NSTimeInterval kSecondsOfDay = 60.0 * 60.0 * 24.0;

@interface AlarmClockViewController()

@end

@implementation AlarmClockViewController

@synthesize clockView;
@synthesize clockControl;
@synthesize alarmSwitch;
@synthesize timeLabel;

- (void)dealloc {
    self.clockView = nil;
    self.clockControl = nil;
    self.alarmSwitch = nil;
    self.timeLabel = nil;    
    [super dealloc];
}

- (NSTimeInterval)startTimeOfCurrentDay {
    NSCalendar *theCalendar = [NSCalendar currentCalendar];
    NSDateComponents *theComponents = [theCalendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit 
                                                     fromDate:[NSDate date]];
    NSDate *theDate = [theCalendar dateFromComponents:theComponents];
    
    return [theDate timeIntervalSinceReferenceDate];
}

- (void)updateControl {
    UIApplication *theApplication = [UIApplication sharedApplication];
	UILocalNotification *theNotification = [[theApplication scheduledLocalNotifications] lastObject];
    
    if([theNotification.fireDate compare:[NSDate date]] > NSOrderedSame) {
        NSTimeInterval theTime = [theNotification.fireDate timeIntervalSinceReferenceDate] - self.startTimeOfCurrentDay;
        
        self.clockControl.time = remainder(theTime, kSecondsOfDay / 2.0);
        self.clockControl.hidden = NO;
    }
    else {
        self.alarmSwitch.on = NO;
        self.clockControl.hidden = YES;
    }
    [self updateTimeLabel];
}

- (void)updateAlarmHand:(UIGestureRecognizer *)inRecognizer {
    CGPoint thePoint = [inRecognizer locationInView:clockControl];
    CGFloat theAngle = [clockControl angleWithPoint:thePoint];
    
    self.clockControl.angle = theAngle;
    [self.clockControl setNeedsDisplay];
    self.alarmSwitch.on = YES;
    [self updateAlarm];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UILongPressGestureRecognizer *theRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(updateAlarmHand:)];

    [self.clockView addGestureRecognizer:theRecognizer];
    [theRecognizer release];
}

- (void)viewDidUnload {
    self.clockView = nil;
    self.clockControl = nil;
    self.alarmSwitch = nil;
    self.timeLabel = nil;    
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)inAnimated {
    [super viewWillAppear:inAnimated];
    [self updateControl];
}

- (void)viewDidAppear:(BOOL)inAnimated {
    [super viewDidAppear:inAnimated];
    [self.clockView startAnimation];
}

- (void)viewWillDisappear:(BOOL)inAnimated {
    [super viewWillDisappear:inAnimated];
    [self.clockView stopAnimation];
}

- (void)createAlarm {
    UIApplication *theApplication = [UIApplication sharedApplication];
    UILocalNotification *theNotification = [[UILocalNotification alloc] init];
    NSTimeInterval theTime = self.startTimeOfCurrentDay + self.clockControl.time;
    
    while(theTime < [NSDate timeIntervalSinceReferenceDate]) {
        theTime += kSecondsOfDay / 2.0;
    }
    [theApplication cancelAllLocalNotifications];
    theNotification.fireDate = [NSDate dateWithTimeIntervalSinceReferenceDate:theTime];
    theNotification.timeZone = [NSTimeZone defaultTimeZone];
    theNotification.alertBody = NSLocalizedString(@"Wake up", @"Alarm message");
    theNotification.soundName = @"ringtone.caf";
    theNotification.applicationIconBadgeNumber = 1;
    theApplication.applicationIconBadgeNumber = 0;
    [theApplication scheduleLocalNotification:theNotification];
    [theNotification release];
}

- (IBAction)updateAlarm {
    self.clockControl.hidden = !alarmSwitch.on;
    if(self.alarmSwitch.on) {
        [self createAlarm];
    }
    else {
        UIApplication *theApplication = [UIApplication sharedApplication];
        
        [theApplication cancelAllLocalNotifications];        
    }
    [self updateTimeLabel];
}

- (IBAction)updateTimeLabel {
    self.timeLabel.hidden = clockControl.hidden;
    if(!self.timeLabel.hidden) {
        NSInteger theTime = round(self.clockControl.time / 60.0);
        NSInteger theMinutes = theTime % 60;
        NSInteger theHours = theTime / 60;
        
        timeLabel.text = [NSString stringWithFormat:@"%d:%02d", theHours, theMinutes];
    }
}


@end
