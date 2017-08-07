//
//  PhotoUploadViewController.m
//  SiteSchedule
//
//  Created by Clemens Wagner on 23.09.12.
//
//

#import "PhotoUploadViewController.h"
#import "MIMEMultipartBody.h"

#define USE_NETCAT 0

#if USE_NETCAT
#define kUploadURL @"http://nostromo.local:1234/~clemens/upload.php"
#else
#define kUploadURL @"http://nostromo.local/~clemens/upload.php"
#endif

@interface PhotoUploadViewController()<UIImagePickerControllerDelegate, UINavigationControllerDelegate, NSURLConnectionDataDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *photoView;
@property (weak, nonatomic) IBOutlet UILabel *result;
@property (weak, nonatomic) IBOutlet UIButton *uploadButton;
@property (weak, nonatomic) IBOutlet UIProgressView *progressBar;
@property (strong, nonatomic) UIImage *photo;
@property (strong, nonatomic) NSMutableData *responseData;

@end

@implementation PhotoUploadViewController

@synthesize photoView;
@synthesize result;
@synthesize uploadButton;
@synthesize activity;
@dynamic photo;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.photoView.image = nil;
}

- (void)viewWillAppear:(BOOL)inAnimated {
    [super viewWillAppear:inAnimated];
    self.result.text = @"";
    self.uploadButton.enabled = self.photoView.image != nil;
    self.progressBar.progress = 0.0;
    self.progressBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)inAnimated {
    self.photoView.image = nil;
    [super viewWillDisappear:inAnimated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)inInterfaceOrientation {
    return NO;
}

- (NSURL *)uploadURL {
    return [NSURL URLWithString:kUploadURL];
}

- (UIImage *)photo {
    return self.photoView.image;
}

- (void)setPhoto:(UIImage *)inImage {
    self.photoView.image = inImage;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)done {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)showCamera {
    UIImagePickerController *theController = [[UIImagePickerController alloc] init];
    
    theController.sourceType = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] ?
    UIImagePickerControllerSourceTypeCamera : UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    theController.delegate = self;
    [self presentViewController:theController animated:YES completion:NULL];
}

- (IBAction)upload {
    MIMEMultipartBody *theBody = [[MIMEMultipartBody alloc] init];
#if USE_NETCAT
    NSData *thePhoto = [@"Hello, world!" dataUsingEncoding:NSUTF8StringEncoding];
#else
    NSData *thePhoto = UIImageJPEGRepresentation(self.photo, 0.8);
#endif
    Site *theSite = self.activity.site;
    NSString *theFile = [NSString stringWithFormat:@"%@.jpg", theSite.code];
    NSMutableURLRequest *theRequest;
    
    [theBody appendParameterValue:theSite.code withName:@"code"];
    [theBody appendData:thePhoto withName:@"photo" contentType:@"image/jpeg" filename:theFile];
    theRequest = [theBody mutableRequestWithURL:[self uploadURL] timeout:10.0];
    self.progressBar.hidden = NO;
    [NSURLConnection connectionWithRequest:theRequest delegate:self];
}

#pragma mark NSURLConnectionDataDelegate

- (void)connection:(NSURLConnection *)inConnection didSendBodyData:(NSInteger)inBytesWritten
 totalBytesWritten:(NSInteger)inTotalBytesWritten totalBytesExpectedToWrite:(NSInteger)inTotalCount {
    self.progressBar.progress = (float) inTotalBytesWritten / (float) inTotalCount;
}

- (void)connection:(NSURLConnection *)inConnection didReceiveResponse:(NSURLResponse *)inResponse {
    self.responseData = [NSMutableData dataWithCapacity:8192];
}

- (void)connection:(NSURLConnection *)inConnection didReceiveData:(NSData *)inData {
    [self.responseData appendData:inData];
}

- (void)connection:(NSURLConnection *)inConnection didFailWithError:(NSError *)inError {
    self.result.text = inError.localizedDescription;
    self.progressBar.hidden = YES;
    self.responseData = nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)inConnection {
    NSString *theText = [[NSString alloc] initWithData:self.responseData encoding:NSUTF8StringEncoding];
    NSRange theRange = [theText rangeOfString:@"<p class='result'>"];
    
    if(theRange.location != NSNotFound) {
        theText = [theText substringFromIndex:theRange.location + theRange.length];
        theRange = [theText rangeOfString:@"</p>"];
        if(theRange.location != NSNotFound) {
            self.result.text = [theText substringToIndex:theRange.location];
        }
    }
    self.progressBar.hidden = YES;
    self.responseData = nil;
}

#pragma mark UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)inPicker didFinishPickingMediaWithInfo:(NSDictionary *)inInfo {
    self.photo = inInfo[UIImagePickerControllerOriginalImage];
    [inPicker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)inPicker {
    [inPicker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)viewDidUnload {
    [self setProgressBar:nil];
    [super viewDidUnload];
}
@end
