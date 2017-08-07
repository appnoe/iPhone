//
//  LoginViewController.h
//  PhotoDiary
//
//  Created by Klaus Rodewig on 13.08.12.
//
//

#import <UIKit/UIKit.h>
#import "SecUtils.h"

@interface LoginViewController : UIViewController
- (IBAction)loginUser:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property BOOL passwordSet;
@end
