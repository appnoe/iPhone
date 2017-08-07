//
//  LoginViewController.m
//  PhotoDiary
//
//  Created by Klaus Rodewig on 13.08.12.
//
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController
@synthesize password = _password;
@synthesize passwordSet;

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

-(void)viewDidAppear:(BOOL)animated{
    passwordSet = [[NSUserDefaults standardUserDefaults] boolForKey:@"passwordSet"];
    if(!passwordSet){
        NSLog(@"Passwort nicht gesetzt");
        NSLog(@"Starte Registrierung");
        UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"Registration"];
        [vc setModalPresentationStyle:UIModalPresentationFullScreen];
        [self presentModalViewController:vc animated:YES];
    }
}

- (void)viewDidUnload
{
    [self setPassword:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)loginUser:(id)sender {
    NSLog(@"[+] %@", NSStringFromSelector(_cmd));

    NSString *storedPassword = [SecUtils getUserPwFromKeychain];
    
//    NSLog(@"[+] PW: %@", storedPassword);
    
    NSString *userPassword = [_password text];
    
    NSString *passwordHash = [SecUtils generateSHA256:userPassword];
    NSLog(@"[+] Password hash: %@", passwordHash);
    NSLog(@"[+] Password: %@", userPassword);

    if([passwordHash isEqualToString:storedPassword]){
        UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"MainNavigationController"];
        [vc setModalPresentationStyle:UIModalPresentationFullScreen];
        [self presentModalViewController:vc animated:YES];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Anmeldung fehlgeschlagen"
                                                        message:@"Bitte erneut versuchen!"
                                                       delegate:self
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
        [alert show];
    }
}


@end
