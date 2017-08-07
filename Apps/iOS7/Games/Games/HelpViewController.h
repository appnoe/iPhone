#import <UIKit/UIKit.h>

@interface HelpViewController : UIViewController<UIWebViewDelegate>

@property (nonatomic, weak) IBOutlet UIWebView *webView;

@end