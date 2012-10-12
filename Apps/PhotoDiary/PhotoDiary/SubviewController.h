#import <Foundation/Foundation.h>

@protocol SubviewControllerDelegate;

@interface SubviewController : NSObject

@property(nonatomic) BOOL visible;
@property(nonatomic, copy) NSString *nibName;
@property(nonatomic, retain) IBOutlet UIView *view;
@property(nonatomic, assign) IBOutlet id<SubviewControllerDelegate> delegate;

- (void)loadView;
- (void)addViewToViewController:(UIViewController *)inViewController;
- (void)removeView;
- (void)setVisible:(BOOL)inVisible animated:(BOOL)inAnimated;

- (IBAction)clear;

@end

@protocol SubviewControllerDelegate<NSObject>

@optional
- (void)subviewControllerWillAppear:(SubviewController *)inController;
- (void)subviewControllerWillDisappear:(SubviewController *)inController;

@end
