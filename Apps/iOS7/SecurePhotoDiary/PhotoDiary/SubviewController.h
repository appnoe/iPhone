#import <Foundation/Foundation.h>

@protocol SubviewControllerDelegate;

@interface SubviewController : UIViewController

@property(nonatomic, weak) IBOutlet id<SubviewControllerDelegate> delegate;

- (void)dismissSubviewAnimated:(BOOL)inAnimated;

@end

@protocol SubviewControllerDelegate<NSObject>

@optional
- (void)subviewControllerWillAppear:(SubviewController *)inController;
- (void)subviewControllerWillDisappear:(SubviewController *)inController;

@end
