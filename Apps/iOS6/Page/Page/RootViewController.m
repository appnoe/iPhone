//
//  RootViewController.m
//  Page
//
//  Created by Clemens Wagner on 30.07.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RootViewController.h"
#import "LabelViewController.h"

@interface RootViewController()

@property (nonatomic, strong) UIPageViewController *pageViewController;
@property (weak, nonatomic) IBOutlet UISegmentedControl *orientationControl;
@property (weak, nonatomic) IBOutlet UISegmentedControl *spineLocationControl;
@property (weak, nonatomic) IBOutlet UISegmentedControl *doubleSidedControl;
@property (weak, nonatomic) IBOutlet UISegmentedControl *directionControl;
@property (weak, nonatomic) IBOutlet UISegmentedControl *animationControl;
@property (weak, nonatomic) IBOutlet UISwitch *updateLocationSwitch;

@end

@implementation RootViewController

- (UIPageViewControllerSpineLocation)selectedSpineLocation {
    return self.spineLocationControl.selectedSegmentIndex + 1;
}

- (UIPageViewControllerNavigationOrientation)selectedNavigationOrientation {
    return self.orientationControl.selectedSegmentIndex;
}

- (UIPageViewControllerNavigationDirection)selectedDirection {
    return self.directionControl.selectedSegmentIndex;
}

- (id)labelViewControllerWithPageNumber:(NSInteger)inPage {
    LabelViewController *theController = [self.storyboard instantiateViewControllerWithIdentifier:@"label"];
    
    theController.pageNumber = inPage;
    return theController;
}

- (NSArray *)viewControllersForSpineLocation:(UIPageViewControllerSpineLocation)inLocation {
    if(inLocation == UIPageViewControllerSpineLocationMid) {
        return @[[self labelViewControllerWithPageNumber:0],
                 [self labelViewControllerWithPageNumber:1]];
    }
    else {
        return @[[self labelViewControllerWithPageNumber:0]];
    }
}

- (IBAction)create {
    UIPageViewControllerNavigationOrientation theOrientation = self.selectedNavigationOrientation;
    UIPageViewControllerSpineLocation theLocation = self.selectedSpineLocation;
    BOOL isDoubleSided = self.doubleSidedControl.selectedSegmentIndex;
    NSDictionary *theOptions = @{UIPageViewControllerOptionSpineLocationKey: @(theLocation)};
    UIPageViewController *theController = [[UIPageViewController alloc] initWithTransitionStyle:self.animationControl.selectedSegmentIndex
                                                                          navigationOrientation:theOrientation 
                                                                                        options:theOptions];
    NSArray *theControllers = [self viewControllersForSpineLocation:theLocation];
    
    [theController setViewControllers:theControllers 
                            direction:self.selectedDirection 
                             animated:YES 
                           completion:NULL];
    theController.doubleSided = isDoubleSided || theLocation == UIPageViewControllerSpineLocationMid;
    theController.dataSource = self;
    theController.delegate = self;
    theController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:theController animated:YES completion:NULL];
    self.pageViewController = theController;
}

- (IBAction)reset {
    UIPageViewController *theController = self.pageViewController;
    NSArray *theControllers = [self viewControllersForSpineLocation:theController.spineLocation];
    
    [theController setViewControllers:theControllers 
                            direction:self.selectedDirection 
                             animated:NO
                           completion:NULL];
}

#pragma mark UITableViewControllerDelegate

- (void)tableView:(UITableView *)inTableView didSelectRowAtIndexPath:(NSIndexPath *)inIndexPath {
    if(inIndexPath.section == 1 && inIndexPath.row == 0) {
        [self create];
    }
}

#pragma mark UIPageViewControllerDataSource

- (UIViewController *)pageViewController:(UIPageViewController *)inPageViewController viewControllerBeforeViewController:(UIViewController *)inViewController {
    LabelViewController *theController = (LabelViewController *)inViewController;
    
    return [self labelViewControllerWithPageNumber:theController.pageNumber - 1];
}

- (UIViewController *)pageViewController:(UIPageViewController *)inPageViewController viewControllerAfterViewController:(UIViewController *)inViewController {
    LabelViewController *theController = (LabelViewController *)inViewController;
    
    return [self labelViewControllerWithPageNumber:theController.pageNumber + 1];
}

#pragma mark UIPageViewControllerDelegate

- (UIPageViewControllerSpineLocation)pageViewController:(UIPageViewController *)inPageViewController
                   spineLocationForInterfaceOrientation:(UIInterfaceOrientation)inOrientation {
    UIPageViewControllerSpineLocation theLocation = self.selectedSpineLocation;

    if(self.updateLocationSwitch.on) {
        BOOL isHorizontal = self.selectedNavigationOrientation == UIPageViewControllerNavigationOrientationHorizontal;
        NSArray *theControllers;

        if(theLocation == UIPageViewControllerSpineLocationMid &&
           UIInterfaceOrientationIsLandscape(inOrientation) != isHorizontal) {
            theLocation = UIPageViewControllerSpineLocationMin;
        }
        theControllers = [self viewControllersForSpineLocation:theLocation];
        [inPageViewController setViewControllers:theControllers
                                       direction:self.selectedDirection
                                        animated:YES
                                      completion:NULL];
    }
    return theLocation;
}

@end
