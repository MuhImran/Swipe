#import "AROverlayViewController.h"
#import "UIImage+Resize.h"
#import "EnvetFinderDelegate.h"

@interface AROverlayViewController ()
static UIImage *shrinkImage(UIImage *original, CGSize size); 
@end



@implementation AROverlayViewController

@synthesize captureManager;
@synthesize torchBtn;
@synthesize imageView;
@synthesize slider;
@synthesize indicator;
@synthesize takePhotoBar, retakePhotoBar;
@synthesize btnFlipCamera1;
@synthesize isFrontCamera;
@synthesize delegate;
@synthesize flashButtonView,flipCameraView;
@synthesize btnflash1,btnflash2,btnflash3,btnFlipCamera2;
@synthesize isFlashOn,isFlashOff,isFlashAuto;
@synthesize libraryButtonBar;
@synthesize croppedAndResizedImage;

- (void)viewDidLoad {
    isFrontCamera = YES;
    isFlashOn = NO;
    isFlashOff = NO;
    isFlashAuto = YES;
    self.slider.transform = CGAffineTransformMakeRotation(270 * M_PI / 180);
    self.croppedAndResizedImage = [[UIImage alloc] init];
	[self setCaptureManager:[[CaptureSessionManager alloc] init]];
  
	[[self captureManager] addVideoInput];
  
    [[self captureManager] addStillImageOutput];

	[[self captureManager] addVideoPreviewLayer];
	CGRect layerRect = CGRectMake(0.0, 0.0, 320.0, 480.0);
	[[[self captureManager] previewLayer] setBounds:layerRect];
	[[[self captureManager] previewLayer] setPosition:CGPointMake(CGRectGetMidX(layerRect),
                                                                CGRectGetMidY(layerRect))];
	[[[self view] layer] addSublayer:[[self captureManager] previewLayer]];
  
    [self bringSubViewsToFront];
    [self switchFlashModeAuto:isFlashAuto On:isFlashOn Off:isFlashOff];
   
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(displayImage) name:kImageCapturedSuccessfully object:nil];
  
	[[captureManager captureSession] startRunning];
    //[AppDelegate addCameraOverlayToWindow];
}
/*
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if ([self.torchBtn.title isEqualToString:@"Torch ON"]) {
        [self turnON];
    }
    else {
        [self turnOFF];        
    }
}
*/
-(void)bringSubViewsToFront {
    for (UIView *v in [self.view subviews]) {
        if (v.tag == 10) {
            [self.view bringSubviewToFront:v];
        }
    }
}

-(IBAction)sliderValueChanged:(id)sender {
    [[self captureManager] setZoomScaleFactor:self.slider.value+1.0];
}

- (void)displayImage 
{
    self.croppedAndResizedImage = [[self captureManager] stillImage];
    self.imageView.image = self.croppedAndResizedImage;
    self.imageView.hidden = NO;
    
    [self.indicator stopAnimating];
    self.retakePhotoBar.hidden = NO;
    self.takePhotoBar.hidden = YES;
    self.libraryButtonBar.hidden = YES;
    [self.takePhotoBar setUserInteractionEnabled:YES];
    [self.captureManager.captureSession stopRunning];
}

-(IBAction)takePhoto:(id)sender {
    [self.indicator startAnimating];
    [self.takePhotoBar setUserInteractionEnabled:NO];
    [[self captureManager] captureStillImage];
}

-(IBAction)retakePhoto:(id)sender {
    self.takePhotoBar.hidden = NO;
    self.libraryButtonBar.hidden = NO;
    self.retakePhotoBar.hidden = YES;
    self.imageView.hidden = YES;
    [[self captureManager].captureSession startRunning];
   // [self cameraTorch:self.torchBtn];
}

//-(IBAction)addMorePhoto:(id)sender {
//    self.takePhotoBar.hidden = NO;
//    self.retakePhotoBar.hidden = YES;
//    self.imageView.hidden = YES;
//    [[self captureManager].captureSession startRunning];
//    if ([self.torchBtn.title isEqualToString:@"Torch ON"]) {
//        [self turnON];
//    }
//    else {
//        [self turnOFF];        
//    }
//
//}

-(void)cameraCanSwap
{
    if(isFrontCamera)
    {
        isFrontCamera = NO;
        btnflash1.enabled = NO;
    }
    else
    {
        isFrontCamera = YES;
        btnflash1.enabled = YES;
    }
    [[self captureManager] swapFrontAndBackCameras];
    flipCameraView.hidden = YES;
}

//-(IBAction)cameraTorch:(id)sender {
//
//    UIBarButtonItem *button = (UIBarButtonItem*)sender;
//    if ([button.title isEqualToString:@"Torch OFF"]) {
//        [self turnON];
//        button.title = @"Torch ON";
//    }
//    else if ([button.title isEqualToString:@"Torch ON"]) {
//        [self turnOFF];
//        button.title = @"Torch OFF";
//    }
//}

-(IBAction)FlipCameraView:(id)sender
{
    if(flipCameraView.isHidden)
        flipCameraView.hidden = NO;
    else
        flipCameraView.hidden = YES;
}

-(IBAction)FlipCameraView2:(id)sender
{
    [self cameraCanSwap];
    
    if(isFrontCamera)
    {
        [btnFlipCamera2 setImage:[UIImage imageNamed:@"selectfrontcamera.png"] forState:UIControlStateNormal];
        [btnFlipCamera2 setImage:[UIImage imageNamed:@"selectfrontcamera_selected.png"] forState:UIControlStateHighlighted];
        [btnFlipCamera2 setImage:[UIImage imageNamed:@"selectfrontcamera_selected.png"] forState:UIControlStateSelected];
        
        [btnFlipCamera1 setImage:[UIImage imageNamed:@"selectrearcamera.png"] forState:UIControlStateNormal];
        [btnFlipCamera1 setImage:[UIImage imageNamed:@"selectrearcamera_selected.png"] forState:UIControlStateHighlighted];
        [btnFlipCamera1 setImage:[UIImage imageNamed:@"selectrearcamera_selected.png"] forState:UIControlStateSelected];
        
    }
    else
    {
        [btnFlipCamera1 setImage:[UIImage imageNamed:@"selectfrontcamera.png"] forState:UIControlStateNormal];
        [btnFlipCamera1 setImage:[UIImage imageNamed:@"selectfrontcamera_selected.png"] forState:UIControlStateHighlighted];
        [btnFlipCamera1 setImage:[UIImage imageNamed:@"selectfrontcamera_selected.png"] forState:UIControlStateSelected];
        
        [btnFlipCamera2 setImage:[UIImage imageNamed:@"selectrearcamera.png"] forState:UIControlStateNormal];
        [btnFlipCamera2 setImage:[UIImage imageNamed:@"selectrearcamera_selected.png"] forState:UIControlStateHighlighted];
        [btnFlipCamera2 setImage:[UIImage imageNamed:@"selectrearcamera_selected.png"] forState:UIControlStateSelected];
    }
}

-(IBAction)libraryMethod:(id)sender
{
    //[AppDelegate removeCameraOverlayFromWindows];
    UIImagePickerController *imagepicker = [[UIImagePickerController alloc] init];
    imagepicker.allowsEditing = YES;
	imagepicker.delegate = self;
    EnvetFinderDelegate *appDelegate = (EnvetFinderDelegate *)[[UIApplication sharedApplication] delegate];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) 
    {
        imagepicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        //[AppDelegate addCameraOverlayToWindow];
        [self presentModalViewController:imagepicker animated:NO];	
    }
    else {
        [appDelegate showAlertView:@"No Library available."];
        
        
        self.tabBarController.selectedViewController = [self.tabBarController.viewControllers objectAtIndex:appDelegate.preTabIndex];
    }
	
}

#pragma mark Camera Picker Delegate


- (void)imagePickerController:(UIImagePickerController *)picker3 didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    
   // [AppDelegate removeCameraOverlayFromWindows];
    UIImage *img = [info objectForKey:UIImagePickerControllerEditedImage]; 
    
    if(img)
    {
        //hasPhoto = TRUE; 
        NSLog(@"Before size is %f  %f",img.size.width,img.size.height);
        img = shrinkImage(img, CGSizeMake(306.0f, 306.0f));
        NSLog(@"After size is %f  %f",img.size.width,img.size.height);
        //[[GPS_Object sharedInstance] startUpdatingLocating:self];
    }
    
    
    //[picker3 dismissModalViewControllerAnimated:YES];
    
    if(delegate && [delegate respondsToSelector:@selector(didFinishPickingLibraryImageAROverlayViewController:)])
        [delegate performSelector:@selector(didFinishPickingLibraryImageAROverlayViewController:) withObject:img];
    [[self captureManager].captureSession stopRunning];
    [[self captureManager] release];
    
    [self dismissModalViewControllerAnimated:YES];
}


-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    //[AppDelegate removeCameraOverlayFromWindows];
    
//    EnvetFinderDelegate *appDelegate = (EnvetFinderDelegate *)[[UIApplication sharedApplication] delegate];
//    
//    self.tabBarController.selectedViewController = [self.tabBarController.viewControllers objectAtIndex:appDelegate.preTabIndex];
    //[[picker parentViewController] dismissModalViewControllerAnimated:YES];
    [self dismissModalViewControllerAnimated:YES];
}

-(IBAction)flash1Method:(id)sender
{
    if(flashButtonView.isHidden)
    {
        flashButtonView.hidden = NO;
        [btnflash1 setImage:[UIImage imageNamed:@"flashautosquare.png"] forState:UIControlStateNormal];
        [btnflash1 setImage:[UIImage imageNamed:@"flashautosquare_selected.png"] forState:UIControlStateHighlighted];
        [btnflash1 setImage:[UIImage imageNamed:@"flashautosquare_selected.png"] forState:UIControlStateSelected];
        
        [btnflash2 setImage:[UIImage imageNamed:@"flashoffsquare.png"] forState:UIControlStateNormal];
        [btnflash2 setImage:[UIImage imageNamed:@"flashoffsquare_selected.png"] forState:UIControlStateHighlighted];
        [btnflash2 setImage:[UIImage imageNamed:@"flashoffsquare_selected.png"] forState:UIControlStateSelected];
        
        [btnflash3 setImage:[UIImage imageNamed:@"flashonsquare.png"] forState:UIControlStateNormal];
        [btnflash3 setImage:[UIImage imageNamed:@"flashonsquare_selected.png"] forState:UIControlStateHighlighted];
        [btnflash3 setImage:[UIImage imageNamed:@"flashonsquare_selected.png"] forState:UIControlStateSelected];
    }
    else
    {
        flashButtonView.hidden = YES;
        isFlashAuto = YES;
        isFlashOff = NO;
        isFlashOn = NO;
        [self switchFlashModeAuto:isFlashAuto On:isFlashOn Off:isFlashOff];
    }
}
-(IBAction)flash2Method:(id)sender
{
    flashButtonView.hidden = YES;
    [btnflash1 setImage:[UIImage imageNamed:@"flashoffsquare.png"] forState:UIControlStateNormal];
    [btnflash1 setImage:[UIImage imageNamed:@"flashoffsquare_selected.png"] forState:UIControlStateHighlighted];
    [btnflash1 setImage:[UIImage imageNamed:@"flashoffsquare_selected.png"] forState:UIControlStateSelected];
    isFlashAuto = NO;
    isFlashOff = YES;
    isFlashOn = NO;
    [self switchFlashModeAuto:isFlashAuto On:isFlashOn Off:isFlashOff];
}
-(IBAction)flash3Method:(id)sender
{
    flashButtonView.hidden = YES;
    [btnflash1 setImage:[UIImage imageNamed:@"flashonsquare.png"] forState:UIControlStateNormal];
    [btnflash1 setImage:[UIImage imageNamed:@"flashonsquare_selected.png"] forState:UIControlStateHighlighted];
    [btnflash1 setImage:[UIImage imageNamed:@"flashonsquare_selected.png"] forState:UIControlStateSelected];
    isFlashAuto = NO;
    isFlashOff = NO;
    isFlashOn = YES;
    [self switchFlashModeAuto:isFlashAuto On:isFlashOn Off:isFlashOff];
}

-(IBAction)finishCamera:(id)sender 
{
    //[AppDelegate removeCameraOverlayFromWindows];
    if(delegate && [delegate respondsToSelector:@selector(didFinishPickingImageAROverlayViewController:)])
        [delegate performSelector:@selector(didFinishPickingImageAROverlayViewController:) withObject:self.croppedAndResizedImage];
    [[self captureManager].captureSession stopRunning];
    [[self captureManager] release];
    //[self dismissModalViewControllerAnimated:YES];

}

-(IBAction)cancelCamera:(id)sender {
    //[AppDelegate removeCameraOverlayFromWindows];
    [[self captureManager].captureSession stopRunning];
    [[self captureManager] release];
    //[self dismissModalViewControllerAnimated:YES];
    if(delegate && [delegate respondsToSelector:@selector(didCancelAROverlayViewController)])
        [delegate performSelector:@selector(didCancelAROverlayViewController) withObject:nil];
}

-(void)switchFlashModeAuto:(BOOL)_isAuto On:(BOOL)_isOn Off:(BOOL)_isOff
{
    
    AVCaptureDeviceInput *input = (AVCaptureDeviceInput*)[[self captureManager].captureSession.inputs objectAtIndex:0];
    if ([input.device isFlashModeSupported:AVCaptureFlashModeAuto] && _isAuto)
    {
        if([input.device lockForConfiguration:nil])
        {
            input.device.flashMode = AVCaptureFlashModeAuto;
        }
    }
    if ([input.device isFlashModeSupported:AVCaptureFlashModeOn] && _isOn)
    {
        if([input.device lockForConfiguration:nil])
        {
            input.device.flashMode = AVCaptureFlashModeOn;
        }
    }
    if ([input.device isFlashModeSupported:AVCaptureFlashModeOff] && _isOff)
    {
        if([input.device lockForConfiguration:nil])
        {
            input.device.flashMode = AVCaptureFlashModeOff;
        }
    }
}

//-(void)turnON {
//    AVCaptureDeviceInput *input = (AVCaptureDeviceInput*)[[self captureManager].captureSession.inputs objectAtIndex:0];
//    if ([input.device isTorchModeSupported:AVCaptureTorchModeOn]) {
//        if([input.device lockForConfiguration:nil])
//        {
//            input.device.torchMode = AVCaptureTorchModeOn;
//        }
//    }
//}
//
//-(void)turnOFF {
//    AVCaptureDeviceInput *input = (AVCaptureDeviceInput*)[[self captureManager].captureSession.inputs objectAtIndex:0];
//    if ([input.device isTorchModeSupported:AVCaptureTorchModeOff]) {
//        if([input.device lockForConfiguration:nil])
//        {
//            input.device.torchMode = AVCaptureTorchModeOff;
//        }
//    }
//}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

- (void)dealloc {
  [captureManager release], captureManager = nil;
  [super dealloc];
}

#pragma mark - 

static UIImage *shrinkImage(UIImage *original, CGSize size) {
    CGFloat scale = [UIScreen mainScreen].scale;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL, size.width * scale, size.height * scale, 8, 0, colorSpace, kCGImageAlphaPremultipliedFirst);
    CGContextDrawImage(context,
                       CGRectMake(0, 0, size.width * scale, size.height * scale),
                       original.CGImage);
    CGImageRef shrunken = CGBitmapContextCreateImage(context); UIImage *final = [UIImage imageWithCGImage:shrunken];
    CGContextRelease(context);
    CGImageRelease(shrunken);
    
    return final;
}


@end

