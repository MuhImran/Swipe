//
//  ReaderSampleViewController.m
//  ReaderSample
//
//  Created by spadix on 8/4/10.
//

#import "profilePicViewController.h"
#import "headerfiles.h"
#import "CameraOverlayViewController.h"
#import "UIImage+Resize.h"
@implementation profilePicViewController
@synthesize picImageView,image;
@synthesize delegate;
@synthesize profileActivity;
@synthesize flushButton,cameraButton;
//@synthesize imgPicker;
@synthesize arCameraOverlay;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withDelegate:(id)_delegate withPic:(UIImage *)_image
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        delegate = _delegate;
        self.image = _image;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	isFlushOn =FALSE;
	isFrontOn = FALSE;                    
    isRetakePicture= FALSE;
    hasPhoto = FALSE;
//    CameraOverlayViewController *covc = [[CameraOverlayViewController alloc] initWithNibName:@"CameraOverlayViewController" bundle:nil];
//    [covc.view setUserInteractionEnabled:NO];
//    self.imgPicker = [[UIImagePickerController alloc] init];
//	self.imgPicker.allowsEditing = YES;
//	self.imgPicker.delegate = self;
//    self.imgPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    //self.imgPicker.cameraOverlayView = covc.view;

    //[covc release];
	[self openCameraView];
   
}

/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if(!hasPhoto)
        [self getCameraPicture:self];
   
}*/
-(IBAction) getLibraryPicture:(id)sender
{
	isfreshPicture = FALSE;
	[self openCameraView];
}

-(IBAction) getCameraPicture:(id)sender
{
	isfreshPicture = TRUE;
	[self openCameraView];
   
}

/////////////////////////////////////////////////////////////////
-(void) openCameraView
{
//    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) 
//    {
//		//if(!isfreshPicture)
//        //    self.imgPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//       // else
//       // {
//            /* if(!overlay)
//             overlay = [[OverlayView alloc] initWithFrame:CGRectMake(0, 0, 320, 460)];
//             self.imgPicker.cameraOverlayView = overlay;*/
//        
//        
//            self.imgPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
//        [AppDelegate addCameraOverlayToWindow];
//      //  }
//        [self presentModalViewController:self.imgPicker animated:YES];	
//    }
//    else {
//        [self loadAlertView:@"No Camera available yet"];
//        
//    }
    if(!self.arCameraOverlay)
    {
        self.arCameraOverlay = [[AROverlayViewController alloc] initWithNibName:@"AROverlayViewController" bundle:nil];
    }
    arCameraOverlay.delegate = self;
    [self presentModalViewController:arCameraOverlay animated:YES];
    
}

#pragma mark AROverlayProtocolDelegate

-(void)didCancelAROverlayViewController
{
    [arCameraOverlay release];
    arCameraOverlay = nil;
    hasPhoto = NO;
    //EnvetFinderDelegate *appDelegate = (EnvetFinderDelegate *)[[UIApplication sharedApplication] delegate];
    
//    self.tabBarController.selectedViewController = [self.tabBarController.viewControllers objectAtIndex:[commonUsedMethods getTabIndexToReturn]];
    [self dismissModalViewControllerAnimated:YES];
    [self.navigationController popViewControllerAnimated:NO];
}

-(void)didFinishPickingImageAROverlayViewController:(UIImage *)_img
{
    if(_img)
    {
        
        [arCameraOverlay release];
        arCameraOverlay = nil;
        hasPhoto = TRUE; 
        NSLog(@"Before size is %f  %f",_img.size.width,_img.size.height);
        self.image = [_img imageByScalingAndCroppingForSize:CGSizeMake(612, 612)];
        //self.image = shrinkImage(_img, CGSizeMake(306.0f, 306.0f));
        NSLog(@"After size is %f  %f",self.image.size.width,self.image.size.height);
        //[[GPS_Object sharedInstance] startUpdatingLocating:self];
        if( delegate && [delegate respondsToSelector:@selector(pictureHasTaken:)])
            [delegate performSelector:@selector(pictureHasTaken:) withObject:self.image];
    }
    [self dismissModalViewControllerAnimated:YES];
    [self.navigationController popViewControllerAnimated:NO];
}

-(void)didFinishPickingLibraryImageAROverlayViewController:(UIImage *)_img
{
    if(_img)
    {
        
        [arCameraOverlay release];
        arCameraOverlay = nil;
        hasPhoto = TRUE; 
        self.image = _img;
        //[[GPS_Object sharedInstance] startUpdatingLocating:self];
        if( delegate && [delegate respondsToSelector:@selector(pictureHasTaken:)])
            [delegate performSelector:@selector(pictureHasTaken:) withObject:self.image];
    }
    [self dismissModalViewControllerAnimated:YES];
    [self.navigationController popViewControllerAnimated:NO];
}


/*
 // Set source to the camera
 if(isfreshPicture)// && ([imagePicker isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear] || [imagePicker isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront]))
 imagePicker.sourceType =  UIImagePickerControllerSourceTypeCamera;
 else  imagePicker.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;
 
 
 // Delegate is self
 imagePicker.delegate = self;
 //	imagePicker.showsCameraControls = NO;
 imagePicker.allowsEditing = NO;
 imagePicker.cameraOverlayView = overlay;*/



/*
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)img editingInfo:(NSDictionary *)editInfo 
{
    [AppDelegate removeCameraOverlayFromWindows];
    if(picker.cameraDevice == UIImagePickerControllerCameraDeviceFront)
    {
        
            
        self.image = [UIImage imageWithCGImage:img.CGImage scale:img.scale orientation:UIImageOrientationUpMirrored];
    }
    else
        self.image = img;
     hasPhoto = TRUE;
    if( delegate && [delegate respondsToSelector:@selector(pictureHasTaken:)])
        [delegate performSelector:@selector(pictureHasTaken:) withObject:self.image];
	//[[picker parentViewController] dismissModalViewControllerAnimated:YES];
    [self dismissModalViewControllerAnimated:YES];
    [self.navigationController popViewControllerAnimated:NO];
   // [self removeThisView:self];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [AppDelegate removeCameraOverlayFromWindows];
    //[[picker parentViewController] dismissModalViewControllerAnimated:YES];
    [self dismissModalViewControllerAnimated:YES];
    [self.navigationController popViewControllerAnimated:NO];
}
*/


/*
- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	UIImage *image1 = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
	[self dismissModalViewControllerAnimated:YES];
	[profileActivity startAnimating];
	// Pass the image from camera to method that will email the same
	// A delay is needed so camera view can be dismissed
	[self performSelector:@selector(displayImage:) withObject:image1 afterDelay:0.1];
	// Release picker
	[picker release];
	self.navigationItem.rightBarButtonItem.enabled=TRUE;
}
 */
-(void) displayImage:(UIImage *)_image
{  
	self.image = _image;
	NSLog(@"Here at displaying image");
    [profileActivity stopAnimating];
    [self.picImageView setImage:_image];
    if( delegate && [delegate respondsToSelector:@selector(pictureHasTaken:)])
        [delegate performSelector:@selector(pictureHasTaken:) withObject:self.image];
    [self dismissModalViewControllerAnimated:YES];
}
-(IBAction) removeThisView:(id)sender
{   
     
    //if( delegate && [delegate respondsToSelector:@selector(pictureHasTaken:)])
      //  [delegate performSelector:@selector(pictureHasTaken:) withObject:self.image];
        [self dismissModalViewControllerAnimated:YES];
    
}
- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    [AppDelegate clearAllCacheImage];
    // Release any cached data, images, etc that aren't in use.
}

-(void) setCameraSetting
{
    // [self flushOptionchange:self];
    
    // [self cameraOptionchange:self];
}

-(IBAction) flushOptionchange:(id)sender
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
		if(!isFlushOn) 
        {
            if(isFrontOn && [UIImagePickerController isFlashAvailableForCameraDevice:UIImagePickerControllerCameraDeviceFront])
            {
                isFlushOn = FALSE;
                [ flushButton setBackgroundImage:[ UIImage imageNamed: @"flash.png" ] forState: UIControlStateNormal ];
                [ flushButton setBackgroundImage: [ UIImage imageNamed: @"flash.png" ] forState: UIControlStateHighlighted ];
            }
            
            else if(!isFrontOn && [UIImagePickerController isFlashAvailableForCameraDevice:UIImagePickerControllerCameraDeviceRear])
            {
                isFlushOn = FALSE;
                [ flushButton setBackgroundImage:[ UIImage imageNamed: @"flash.png" ] forState: UIControlStateNormal ];
                [ flushButton setBackgroundImage: [ UIImage imageNamed: @"flash.png" ] forState: UIControlStateHighlighted ];
            }
            else
                [self loadAlertView:@"Flash not avail for camera"];
            
        }
        else
        {
            isFlushOn = TRUE;
            [ flushButton setBackgroundImage: [ UIImage imageNamed: @"flashOff.png" ] forState: UIControlStateNormal ];
            [ flushButton setBackgroundImage: [ UIImage imageNamed: @"flashOff.png" ] forState: UIControlStateHighlighted ];
        }
    }
    
    else
        [self loadAlertView:@"camera not available"];
	
}
-(IBAction) cameraOptionchange:(id)sender
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        if(isFrontOn) 
        {
            if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear])
            {
                isFrontOn = FALSE;
                [ cameraButton setBackgroundImage: [ UIImage imageNamed: @"camera2.png" ] forState: UIControlStateNormal ];
                [ cameraButton setBackgroundImage: [ UIImage imageNamed: @"camera2.png" ] forState: UIControlStateHighlighted ];
            }
            else
                [self loadAlertView:@"Rear camera not available"];
            
        }
        else
        {
            if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront])
            {
                isFrontOn = TRUE;
                [ cameraButton setBackgroundImage: [ UIImage imageNamed: @"cameraBack.png" ] forState: UIControlStateNormal ];
                [ cameraButton setBackgroundImage: [ UIImage imageNamed: @"cameraBack.png" ] forState: UIControlStateHighlighted ];
            }
            else
                [self loadAlertView:@"Rear camera not available"];
        }	
    }
    else
        [self loadAlertView:@"camera not available"];
}

-(void) loadAlertView:(NSString *)_msg
{
	UIAlertView *alert = [[UIAlertView alloc] 
						  initWithTitle:@"" 
						  message:_msg 
						  delegate:self 
						  cancelButtonTitle:@"OK" 
						  otherButtonTitles:nil];
	[alert show];
	[alert release];
	
}

- (void)dealloc {
    
    //[imgPicker release]; 
    delegate=nil;
    [profileActivity release];
	[image release];
	[picImageView release];
    [flushButton release];
    [cameraButton release];
    [super dealloc];
}

@end
