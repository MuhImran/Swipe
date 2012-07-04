//
//  ReaderSampleViewController.m
//  ReaderSample
//
//  Created by spadix on 8/4/10.
//

#import "cameraViewController.h"
#import "OverlayView.h"
#import "addFilterViewController.h"
#import "adjustLibPhotViewContorller.h"
#import "shareViewController.h"
#import "commonUsedMethods.h"
#import "EnvetFinderDelegate.h"

@implementation cameraViewController
@synthesize picImageView,image;
@synthesize overlay;
@synthesize AFVC;
@synthesize ALIVC;
@synthesize flushButton,cameraButton;
@synthesize takePic;
@synthesize option,imgPicker;
@synthesize helpView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withOption:(int)_option
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        option = _option;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	//self.title = @"Camera";
	self.image = [UIImage imageNamed:@"testingImage.jpg"];
	[self.picImageView setImage:image];
	isFlushOn =FALSE;
	isFrontOn = FALSE;                    
    isRetakePicture= FALSE;
    enableCrossButton = FALSE;
    hasPhoto = FALSE;
    self.imgPicker = [[UIImagePickerController alloc] init];
	self.imgPicker.allowsEditing = YES;
	self.imgPicker.delegate = self;	
    
   // [self setCameraSetting];
   
 /*
    self.navigationItem.rightBarButtonItem =  [[UIBarButtonItem alloc]
                                               initWithTitle:@"Next" style:UIBarButtonSystemItemAdd target:self action:@selector(showShareView:)];
	//self.navigationItem.rightBarButtonItem.enabled=FALSE;
  */
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if(!hasPhoto)
    [self getCameraPicture:self];
	
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
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) 
    {
		if(!isfreshPicture)
            self.imgPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        else
        {
           /* if(!overlay)
                overlay = [[OverlayView alloc] initWithFrame:CGRectMake(0, 0, 320, 460)];
            self.imgPicker.cameraOverlayView = overlay;*/
            self.imgPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            
        }
        [self presentModalViewController:self.imgPicker animated:NO];	
     }
            else {
                [self loadAlertView:@"No Camera available yet"];
    
                  }
}

  
            
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)img editingInfo:(NSDictionary *)editInfo {
	self.image = img;
    [self.picImageView setImage:img];
    hasPhoto = TRUE;
	[[picker parentViewController] dismissModalViewControllerAnimated:YES];
   // [self loadAlertView:@"Delegate called"];
    [self displayImage:self.image];
   // [self performSelector:@selector(displayImage:) withObject:img afterDelay:0.1];
}

 /*      
- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	UIImage *image1 = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
     enableCrossButton = TRUE;
	[self dismissModalViewControllerAnimated:YES];
	
	// Pass the image from camera to method that will email the same
	// A delay is needed so camera view can be dismissed
	[self performSelector:@selector(displayImage:) withObject:image1 afterDelay:0.1];
	// Release picker
	[picker release];
	self.navigationItem.rightBarButtonItem.enabled=TRUE;
}
  */
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

-(void) displayImage:(UIImage *)_image
{  
	self.image = _image;
	NSLog(@"Here at displaying image");
    [self.picImageView setImage:_image];
    [self callNewViewBaseOnPhoto];
   
}
-(void) callNewViewBaseOnPhoto
{
 
    if(self.image)
    {
    self.image = [commonUsedMethods imageWithImage:self.image :self.picImageView.frame.size];
        shareViewController *AFVC1 = [[shareViewController alloc] initWithNibName:@"shareViewController" bundle:nil withImage:self.image withOption:option];
    [self.navigationController pushViewController:AFVC1 animated:NO]; 
    [AFVC1 release];
    hasPhoto = FALSE;
    }
    else
    {
        [self loadAlertView:@"Image has not been selected or taken yet"];
        
    }
    /*
    if(!isfreshPicture)
    {
        adjustLibPhotViewContorller *ALIVC1 = [[adjustLibPhotViewContorller alloc] initWithNibName:@"adjustLibPhotViewContorller" bundle:nil withImage:self.image withDelegate:self];
        [self.navigationController pushViewController:ALIVC1 animated:NO];
        [ALIVC1 release];
    }
    else
    {
        addFilterViewController     *AFVC1 = [[addFilterViewController alloc] initWithNibName:@"addFilterViewController" bundle:nil wtihImage:self.image];
        [self.navigationController pushViewController:AFVC1 animated:NO]; 
        [AFVC1 release];
    }*/
     enableCrossButton = FALSE;
    
}


-(IBAction) removeThisView:(id)sender
{   
    self.image = [UIImage imageNamed:@"testImage.png"];
	NSLog(@"Here at displaying image");
    [self.picImageView setImage:self.image];
    [self callNewViewBaseOnPhoto];
       
}
-(void) libraryPitureAdjusted:(UIImage *)_image
{
    [self.picImageView setImage:_image];
     [self dismissModalViewControllerAnimated:YES];
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


- (void)dealloc {
   
   [imgPicker release]; 
   [flushButton release ];
    [cameraButton release];
	[picImageView release];
    [AFVC release];
	[ALIVC release];
    [super dealloc];
}

@end
