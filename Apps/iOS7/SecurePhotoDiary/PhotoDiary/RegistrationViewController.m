//
//  RegistrationViewController.m
//  PhotoDiary
//
//  Created by Klaus Rodewig on 14.08.12.
//
//

#import "RegistrationViewController.h"
#import <CommonCrypto/CommonDigest.h>

@interface RegistrationViewController ()

@end

@implementation RegistrationViewController
@synthesize firstPassword;
@synthesize secondPassword;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [self setFirstPassword:nil];
    [self setSecondPassword:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)registerUser:(id)sender {
    NSLog(@"[+] %@", NSStringFromSelector(_cmd));
    NSString *password = [firstPassword text];
    if([password isEqualToString:[secondPassword text]]){
        NSLog(@"[+] Password accepted. Creating hash for secure storage");
      
        NSString *passwordHash = [SecUtils generateSHA256:password];
        
        NSLog(@"[+] Password hash: %@", passwordHash);
        
        NSLog(@"[+] Password accepted. Writing to Keychain");
                
        if([SecUtils addKeychainEntry:passwordHash]){
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"passwordSet"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"Login"];
            [vc setModalPresentationStyle:UIModalPresentationFullScreen];
            [self presentModalViewController:vc animated:YES];
        }
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Passwörter stimmen nicht überein!"
                                                        message:@"Bitte erneut versuchen!"
                                                       delegate:self
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
        [alert show];
//        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
        UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"Registration"];
        [vc setModalPresentationStyle:UIModalPresentationFullScreen];
        [self presentModalViewController:vc animated:YES];

    }
}


@end
