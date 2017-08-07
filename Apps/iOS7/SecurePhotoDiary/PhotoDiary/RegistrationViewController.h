//
//  RegistrationViewController.h
//  PhotoDiary
//
//  Created by Klaus Rodewig on 14.08.12.
//
//

#import <UIKit/UIKit.h>
#import "SecUtils.h"

@interface RegistrationViewController : UIViewController
- (IBAction)registerUser:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *firstPassword;
@property (weak, nonatomic) IBOutlet UITextField *secondPassword;
@end
