#import "PhotoDiaryViewController.h"

@interface PhotoDiaryViewController(PageView)
#ifdef __IPHONE_5_0
<UIPageViewControllerDataSource, UIPageViewControllerDelegate>
#endif

- (void)setupPageViewControllerWithViewController:(UIViewController *)inViewController;
- (ItemViewController *)itemViewControllerWithIndexPath:(NSIndexPath *)inIndexPath;
- (void)displayItemAtIndexPath:(NSIndexPath *)inIndexPath;

@end
