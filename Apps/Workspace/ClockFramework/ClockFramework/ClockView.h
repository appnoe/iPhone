#import <UIKit/UIKit.h>

#if DEBUG
#define DEBUG_LOG(MESSAGE, ...) NSLog(MESSAGE, __VA_ARGS__)
#else
#define DEBUG_LOG(MESSAGE, ...) /**/
#endif

@interface ClockView : UIView

@property (nonatomic, retain) NSDate *time;
@property (nonatomic, retain, readonly) NSCalendar *calendar;

- (void)startAnimation;
- (void)stopAnimation;

@end
