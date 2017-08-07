#import <UIKit/UIKit.h>

@interface ClockView : UIView {
	@private
}

@property (nonatomic, retain) NSDate *time;
@property (nonatomic, retain, readonly) NSCalendar *calendar;

- (void)startAnimation;
- (void)stopAnimation;

@end
