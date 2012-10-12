#import <UIKit/UIKit.h>

@interface HelpViewController : UIViewController<UIWebViewDelegate> {
    @private
}

@property (nonatomic, retain) IBOutlet UIWebView *webView;

@end
