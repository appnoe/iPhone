//
//  AbstractClockView.m
//  
//
//  Created by Clemens Wagner on 01.09.13.
//
//

#import "AbstractClockView.h"

@interface AbstractClockView()

@property(nonatomic, strong) NSTimer *timer;

@end

@implementation AbstractClockView

- (id)initWithFrame:(CGRect)inFrame {
    self = [super initWithFrame:inFrame];
    if(self) {
        self.calendar = [NSCalendar currentCalendar];
        self.time = [NSDate date];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.calendar = [NSCalendar currentCalendar];
    self.time = [NSDate date];
}

- (void)updateTime:(NSTimer *)inTimer {
    self.time = [NSDate date];
    [self setNeedsDisplay];
}

- (void)startAnimation {
    if(self.timer == nil) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:0.5
                                                      target:self
                                                    selector:@selector(updateTime:)
                                                    userInfo:nil
                                                     repeats:YES];
    }
}

- (void)stopAnimation {
    [self.timer invalidate];
    self.timer = nil;
}

@end
