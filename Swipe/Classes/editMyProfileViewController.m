//
//  editMyProfileViewController.m
//  Petstagram
//
//  Created by Awais Ahmad Qureshi on 5/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "editMyProfileViewController.h"
#import "DataModel.h"
#import "userProfile.h"
#import "Font+size.h"
#import "SingletonClass.h"
#import "settingValues.h"

#import "headerfiles.h"
@implementation editMyProfileViewController
@synthesize picImageView;
@synthesize fullName;

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
    self.navigationItem.rightBarButtonItem =  [[UIBarButtonItem alloc]
                                               initWithTitle:@"Update" style:UIBarButtonItemStyleDone target:self action:@selector(updateButtonPressed:)];
	self.navigationItem.rightBarButtonItem.enabled=FALSE;
	NSMutableArray *profileArray = [DataModel getDataInDictionary:8];
	userProfile  *userprofile  = [profileArray objectAtIndex:0];
	fullName.text = userprofile.fullName;

	if (![imageCaches imageFromKey:userprofile.imgURL])
	{
		NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
		[request setURL:[NSURL URLWithString:userprofile.imgURL]];
		NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
		UIImage *image = [[UIImage alloc] initWithData:returnData];
		[picImageView setImage:image];
		//[imageCaches setCacheImage:image:userprofile.imgURL];
        [imageCaches storeImage:image imageData:UIImageJPEGRepresentation(image, 1.0) forKey:userprofile.imgURL toDisk:YES];
		[Font_size makeRoundImageView:picImageView];
	}
	else
	{
		[picImageView setImage:[imageCaches imageFromKey:userprofile.imgURL]];
		[Font_size makeRoundImageView:picImageView];
		
	}
 
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	
}
-(IBAction) updateButtonPressed:(id)sender
{
	// TO DO
}
-(IBAction) getLibraryPicture:(id)sender
{
	isfreshPicture = FALSE;
	[self openCameraView];
}

/////////////////////////////////////////////////////////////////
/////         -------   IMPORTANT NOTES -------  //////////
/////////////////////////////////////////////////////////////////
-(IBAction) getCameraPicture:(id)sender
{
	isfreshPicture = TRUE;
    
    ////   Un- Comment for real Deive
    
	[self openCameraView];
    
    // Comment below statement to work on a real device
    
    //[self pictureTaken];
}
/////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
-(void) openCameraView
{
	if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])  {
		////if(!overlay)
			//overlay = [[OverlayView alloc] initWithFrame:CGRectMake(0, 0, 320, 460)];
		UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
		if(isFrontOn)
			imagePicker.cameraDevice = UIImagePickerControllerCameraDeviceFront;
		else 
			imagePicker.cameraDevice = UIImagePickerControllerCameraDeviceRear;
		
		if(isFlushOn && [UIImagePickerController isFlashAvailableForCameraDevice:imagePicker.cameraDevice])
			imagePicker.cameraFlashMode = TRUE;
		else
			imagePicker.cameraFlashMode = FALSE;
		
		// Set source to the camera
		if(isfreshPicture)// && ([imagePicker isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear] || [imagePicker isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront]))
			imagePicker.sourceType =  UIImagePickerControllerSourceTypeCamera;
		else
			imagePicker.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;	
		
		// Delegate is self
		imagePicker.delegate = self;
		
		// Allow editing of image ?
		imagePicker.allowsEditing = NO;
        //imagePicker.cameraOverlayView = overlay;
		
		// Show image picker
		[self presentModalViewController:imagePicker animated:YES];	
	}
	else {
		
		UIAlertView *myAlert = [[UIAlertView alloc] initWithTitle:@"Sorry"
                                                          message:@"No Camera available yet"
                                                         delegate:self 
                                                cancelButtonTitle:@"Ok" 
                                                otherButtonTitles:nil, nil];
        //myAlert.tag=2;
        CGAffineTransform myTransform = CGAffineTransformMakeTranslation(0, 60);
        [myAlert setTransform:myTransform];
        [myAlert show];
        [myAlert release];
	}
	
}
- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	UIImage *image1 = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
	[self dismissModalViewControllerAnimated:YES];
	
	// Pass the image from camera to method that will email the same
	// A delay is needed so camera view can be dismissed
	[self performSelector:@selector(displayImage:) withObject:image1 afterDelay:0.5];
	// Release picker
	[picker release];
	self.navigationItem.rightBarButtonItem.enabled=TRUE;
}
-(void) displayImage:(UIImage *)_image
{  
	NSLog(@"Here at displaying image");
	[self.picImageView setImage:_image];
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    [AppDelegate clearAllCacheImage];
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
-(void) syncOnThreadAction
{
	overlay = [[SingletonClass sharedInstance] getOverlay];
	[overlay setDelegate:self];
	
}

#pragma mark ParserProtocolDelegate
-(void) loginResponse:(NSNumber *)_value
{
	
	[overlay dismiss];
	if([_value intValue] == 1)
	{
		
	}
	else {
		//[self loadAlertView:@"Sorry" :@"Some error is there"];
	}
}
#pragma mark clientProtocolDelegate

-(void) notfiyResponse:(NSNumber *)_value
{
	[overlay dismiss];
	[self loadAlertView:@"Sorry" :@"Internet Connection not available"];
	
}
-(void) loadAlertView:(NSString *)_title1:(NSString *)_msg
{
	UIAlertView *alert = [[UIAlertView alloc] 
						  initWithTitle:_title1 
						  message:_msg 
						  delegate:self 
						  cancelButtonTitle:@"OK" 
						  otherButtonTitles:nil];
	[alert show];
	[alert release];
	
}
- (void)dealloc {
	[picImageView release];
	[fullName release];
    [super dealloc];
}


@end
