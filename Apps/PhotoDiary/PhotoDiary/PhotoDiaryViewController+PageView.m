#import "PhotoDiaryViewController+PageView.h"
#import "ItemViewController.h"

@implementation PhotoDiaryViewController(PageView)

- (ItemViewController *)itemViewControllerWithIndexPath:(NSIndexPath *)inIndexPath {
    if(inIndexPath == nil) {
        return self.itemViewController;
    }
    else {
        DiaryEntry *theItem = [self entryForTableView:self.currentTableView atIndexPath:inIndexPath];
        ItemViewController *theController = [[ItemViewController alloc] init];
        
        theController.diaryEntry = theItem;
        theController.indexPath = inIndexPath;
        return [theController autorelease];
    }
}

- (void)pushItemAtIndexPath:(NSIndexPath *)inIndexPath {
    ItemViewController *theItemController = self.itemViewController;    
    DiaryEntry *theItem = [self entryForTableView:self.currentTableView atIndexPath:inIndexPath];
    
    theItemController.diaryEntry = theItem;
    theItemController.indexPath = inIndexPath;
    if(self.splitViewController == nil) {
        [self.navigationController pushViewController:theItemController animated:YES];
    }
}

#ifdef __IPHONE_5_0
- (UIPageViewController *)pageViewController {
    id theController = self.view.window.rootViewController;
    
    if([theController isKindOfClass:[UISplitViewController class]]) {
        return [[theController viewControllers] objectAtIndex:1];
    }
    else {
        return nil;
    }
}

- (UIPageViewController *)pageViewControllerWithViewController:(UIViewController *)inItemController {
    if(NSClassFromString(@"UIPageViewController") == nil) {
        return nil;
    }
    else {
        UIPageViewController *theController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStylePageCurl navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
        
        theController.delegate = self;
        theController.dataSource = self;
        [theController setViewControllers:[NSArray arrayWithObject:inItemController]
                                direction:UIPageViewControllerNavigationDirectionForward 
                                 animated:NO completion:nil];
        return [theController autorelease];
    }
}

- (void)setupPageViewControllerWithViewController:(UIViewController *)inViewController {
    UISplitViewController *theMainController = self.splitViewController;
    
    if(theMainController != nil) {
        UIPageViewController *thePageController = 
            [self pageViewControllerWithViewController:inViewController];
        
        if(thePageController != nil) {
            UIViewController *theMasterController = 
                [theMainController.viewControllers objectAtIndex:0];

            theMainController.viewControllers = 
                [NSArray arrayWithObjects:theMasterController, thePageController, nil];
        }
    }
}

- (void)displayItemAtIndexPath:(NSIndexPath *)inIndexPath {
    if(NSClassFromString(@"UIPageViewController") == nil) {
        [self pushItemAtIndexPath:inIndexPath];
    }
    else {
        UIPageViewController *thePageController = self.pageViewController;
        UIViewController *theController = [self itemViewControllerWithIndexPath:inIndexPath];
        
        if(thePageController == nil) {
            thePageController = [self pageViewControllerWithViewController:theController];
            [self.navigationController pushViewController:thePageController animated:YES];
        }
        else {
            NSArray *theControllers = [NSArray arrayWithObject:theController];
            [thePageController setViewControllers:theControllers 
                                        direction:UIPageViewControllerNavigationDirectionForward
                                         animated:NO 
                                       completion:NULL];
        }
    }
}

- (UIViewController *)pageViewController:(UIPageViewController *)inPageViewController 
      viewControllerBeforeViewController:(UIViewController *)inViewController {
    ItemViewController *theController = (ItemViewController *)inViewController;
    NSIndexPath *theIndexPath = theController.indexPath;

    if(theIndexPath.row > 0) {
        theIndexPath = [NSIndexPath indexPathForRow:theIndexPath.row - 1 inSection:theIndexPath.section];
        return [self itemViewControllerWithIndexPath:theIndexPath];
    }
    else {
        return nil;
    }
}

- (UIViewController *)pageViewController:(UIPageViewController *)inPageViewController 
       viewControllerAfterViewController:(UIViewController *)inViewController {
    ItemViewController *theController = (ItemViewController *)inViewController;
    NSIndexPath *theIndexPath = theController.indexPath;
    UITableView *theTableView = self.currentTableView;
    
    if(theIndexPath.row + 1 < [self tableView:theTableView numberOfRowsInSection:theIndexPath.section]) {
        theIndexPath = [NSIndexPath indexPathForRow:theIndexPath.row + 1 inSection:theIndexPath.section];
        return [self itemViewControllerWithIndexPath:theIndexPath];
    }
    else {
        return nil;
    }
}
#else
- (void)setupPageViewControllerWithViewController:(UIViewController *)inViewController {
}

- (void)displayItemAtIndexPath:(NSIndexPath *)inIndexPath {
    [self pushItemAtIndexPath:inIndexPath];
}
#endif

@end
