#import <Foundation/Foundation.h>

@protocol SubviewControllerDelegate;

@interface SubviewController : UIViewController

@property(nonatomic, weak) IBOutlet id<SubviewControllerDelegate> delegate;

- (void)dismissAnimated:(BOOL)inAnimated;
- (void)presentFromViewController:(UIViewController *)inViewController animated:(BOOL)inAnimated;

@end

@protocol SubviewControllerDelegate<NSObject>

@optional
- (void)subviewControllerWillAppear:(SubviewController *)inController;
- (void)subviewControllerWillDisappear:(SubviewController *)inController;

@end

@interface SubviewSegue : UIStoryboardSegue

@end