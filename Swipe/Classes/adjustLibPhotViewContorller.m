//
//  adjustLibraryImageViewContorller.m
//  Petstagram
//
//  Created by Awais Ahmad Qureshi on 5/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "adjustLibPhotViewContorller.h"
#import "addFilterViewController.h"
#import "commonUsedMethods.h"
#import "headerfiles.h"

@interface adjustLibPhotViewContorller (UtilityMethods)
- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center;
@end

@implementation adjustLibPhotViewContorller
@synthesize picImageView;
@synthesize image;
@synthesize scrollView;
@synthesize overlayImageView;
@synthesize delegate;
// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withImage:(UIImage *)_image withDelegate:(id)_delegate {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.image = _image;
       
       // set = self.overlayImageView.frame.size;
        delegate =_delegate;
    }
    return self;
}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	//scrollView.bouncesZoom = YES;
	scrollView.delegate = self;
	scrollView.clipsToBounds = YES;
    // NSLog(@"%f %f %f %f ",picImageView.center.x,picImageView.center.y,scrollView.center.x,scrollView.center.y);
    picImageView.center = scrollView.center;
	picImageView.userInteractionEnabled = YES;
	picImageView.autoresizingMask =UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	//picImageView.autoresizingMask = ( UIViewAutoresizingFlexibleWidth );
	//scrollView.contentSize = [picImageView frame].size;
	
	UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
	UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
	UITapGestureRecognizer *twoFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTwoFingerTap:)];
	
	[doubleTap setNumberOfTapsRequired:2];
	[twoFingerTap setNumberOfTouchesRequired:2];
	
	[picImageView addGestureRecognizer:singleTap];
	[picImageView addGestureRecognizer:doubleTap];
	[picImageView addGestureRecognizer:twoFingerTap];
	
	[singleTap release];
	[doubleTap release];
	[twoFingerTap release];
    scrollView.frame = picImageView.frame;
	float minimumScale = [scrollView frame].size.width  / [picImageView frame].size.width;
	//scrollView.maximumZoomScale = 1.0;
	scrollView.minimumZoomScale = minimumScale;
	scrollView.maximumZoomScale = 5;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [commonUsedMethods hideTabBar:self.tabBarController];
    self.navigationController.navigationBar.hidden = TRUE;
    self.image = [commonUsedMethods imageWithImage:self.image :self.picImageView.frame.size];
	[picImageView setImage:self.image];
	
}
-(void) setCameraImage:(UIImage *)_image:(id)_delegate
{
	self.image = _image;
    self.delegate  = _delegate;
    [self.picImageView setImage:_image];	
}

-(IBAction) buttonPressed:(id)sender
{  
	UIButton * button = (UIButton *)sender;
    if (button.tag == 2)
       {
           self.navigationController.navigationBarHidden = NO;
           UIImage *newImage = [self makeCropImage];
             addFilterViewController     *AFVC = [[addFilterViewController alloc] initWithNibName:@"addFilterViewController" bundle:nil wtihImage:newImage];
               [self.navigationController pushViewController:AFVC animated:NO]; 
                [AFVC release];
       }
    if (button.tag == 1)
    {
        [self.navigationController popViewControllerAnimated:NO];
    }
   
}
-(UIImage *) makeCropImage
{
    UIImage *oldImage = picImageView.image;
    CGSize size  = [oldImage size];
     NSLog(@"Image Size is width:%f and length:%f",size.width,size.height);
    float scale = 1.0f/scrollView.zoomScale;
    
    CGRect visibleRect;
    visibleRect.origin.x = scrollView.contentOffset.x * scale;
    visibleRect.origin.y = scrollView.contentOffset.y * scale;
    visibleRect.size.width = scrollView.bounds.size.width * scale;
    visibleRect.size.height = scrollView.bounds.size.height * scale;

     
    NSLog(@"Size is x:%f  y:%f   width:%f and length:%f",visibleRect.origin.x,visibleRect.origin.y, visibleRect.size.width,visibleRect.size.height);
    // Create rectangle that represents a cropped image  
    // from the middle of the existing image
//    CGRect rect = overlayImageView.frame;
    // Create bitmap image from original image data,
    // using rectangle to specify desired crop area
    CGImageRef imageRef = CGImageCreateWithImageInRect([oldImage CGImage], visibleRect);
    UIImage *img = [UIImage imageWithCGImage:imageRef]; 
    CGImageRelease(imageRef);
    
    return img;
    /*
    // Create and show the new image from bitmap data
    imageView = [[UIImageView alloc] initWithImage:img];
    [imageView setFrame:CGRectMake(0, 200, (size.width / 2), (size.height / 2))];
    [[self view] addSubview:imageView];
    [imageView release];*/
    
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

#pragma mark UIScrollViewDelegate methods

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
	return picImageView;
}

#pragma mark TapDetectingImageViewDelegate methods

- (void)handleSingleTap:(UIGestureRecognizer *)gestureRecognizer {
	// single tap does nothing for now
	NSLog(@"Single Tap at here");
    
	//CGRect zoomRect = [self zoomRectForScale:[scrollView zoomScale] withCenter:[gestureRecognizer locationInView:gestureRecognizer.view]];
    //	CGPoint locationPoint = [gestureRecognizer locationInView:gestureRecognizer.view];
	//[self adjustMovementOfImage:locationPoint];
}

- (void)handleDoubleTap:(UIGestureRecognizer *)gestureRecognizer {
	// zoom in
	
    float newScale = [scrollView zoomScale] * ZOOM_STEP;
	CGRect zoomRect = [self zoomRectForScale:newScale withCenter:[gestureRecognizer locationInView:gestureRecognizer.view]];
	[scrollView zoomToRect:zoomRect animated:YES];
    //	scrollView.contentSize = zoomRect.size;
	[picImageView setFrame:zoomRect];
	NSLog(@"handleDoubleTap image Rect is %0.2f, %.02f",zoomRect.size.width,zoomRect.size.height);
    
}

- (void)handleTwoFingerTap:(UIGestureRecognizer *)gestureRecognizer {
	// two-finger tap zooms out
	
    float newScale = [scrollView zoomScale] / ZOOM_STEP;
	CGRect zoomRect = [self zoomRectForScale:newScale withCenter:[gestureRecognizer locationInView:gestureRecognizer.view]];
	[scrollView zoomToRect:zoomRect animated:YES];
	//scrollView.contentSize = zoomRect.size;
	[picImageView setFrame:zoomRect];
	NSLog(@"handleTwoFingerTap image Rect is %0.2f, %.02f",zoomRect.size.width,zoomRect.size.height);
    
}

#pragma mark Utility methods

- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center {
	
	CGRect zoomRect;
	
	// the zoom rect is in the content view's coordinates. 
	//    At a zoom scale of 1.0, it would be the size of the scrollView's bounds.
	//    As the zoom scale decreases, so more content is visible, the size of the rect grows.
	zoomRect.size.height = [scrollView frame].size.height / scale;
	zoomRect.size.width  = [scrollView frame].size.width  / scale;
	
	// choose an origin so as to get the right center.
	zoomRect.origin.x    = center.x - (zoomRect.size.width  / 2.0);
	zoomRect.origin.y    = center.y - (zoomRect.size.height / 2.0);
	
	return zoomRect;
}
- (void)layoutSubviews {
    [super.view layoutSubviews];
    
    // center the image as it becomes smaller than the size of the screen
    CGSize boundsSize = self.view.bounds.size;
    CGRect frameToCenter = picImageView.frame;
    
    // center horizontally
    if (frameToCenter.size.width < boundsSize.width)
        frameToCenter.origin.x = (boundsSize.width - frameToCenter.size.width) / 2;
    else
        frameToCenter.origin.x = 0;
    
    // center vertically
    if (frameToCenter.size.height < boundsSize.height)
        frameToCenter.origin.y = (boundsSize.height - frameToCenter.size.height) / 2;
    else
        frameToCenter.origin.y = 0;
    
    picImageView.frame = frameToCenter;
}

- (void)dealloc {
    //[delegate release];
    //delegate =nil;
    [scrollView release];
    [image release];
	[picImageView release];
    [overlayImageView release];
    [super dealloc];
}
/*
-(UIImage*)resizedImage2:(UIImage*)inImage  inRect:(CGRect)thumbRect { 
	
	CGImageRef			imageRef = [inImage CGImage];
	CGImageAlphaInfo	alphaInfo = CGImageGetAlphaInfo(imageRef);
	
	// There's a wierdness with kCGImageAlphaNone and CGBitmapContextCreate
	// see Supported Pixel Formats in the Quartz 2D Programming Guide
	// Creating a Bitmap Graphics Context section
	// only RGB 8 bit images with alpha of kCGImageAlphaNoneSkipFirst, kCGImageAlphaNoneSkipLast, kCGImageAlphaPremultipliedFirst,
	// and kCGImageAlphaPremultipliedLast, with a few other oddball image kinds are supported
	// The images on input here are likely to be png or jpeg files
	if (alphaInfo == kCGImageAlphaNone)
		alphaInfo = kCGImageAlphaNoneSkipLast;
	
	// Build a bitmap context that's the size of the thumbRect
	CGFloat bytesPerRow;
	
	if( thumbRect.size.width > thumbRect.size.height ) {
		bytesPerRow = 4 * thumbRect.size.width;
	} else {
		bytesPerRow = 4 * thumbRect.size.height;
	}
	
	CGContextRef bitmap = CGBitmapContextCreate(	
                                                NULL,
                                                thumbRect.size.width,		// width
                                                thumbRect.size.height,		// height
                                                8, //CGImageGetBitsPerComponent(imageRef),	// really needs to always be 8
                                                bytesPerRow, //4 * thumbRect.size.width,	// rowbytes
                                                CGImageGetColorSpace(imageRef),
                                                alphaInfo
                                                );
	
	// Draw into the context, this scales the image
	CGContextDrawImage(bitmap, thumbRect, imageRef);
	
	// Get an image from the context and a UIImage
	CGImageRef	ref = CGBitmapContextCreateImage(bitmap);
	UIImage*	result = [UIImage imageWithCGImage:ref];
	
	CGContextRelease(bitmap);	// ok if NULL
	CGImageRelease(ref);
	
	return result;
}
 -(UIImage*)imageWithImage:(UIImage*)image 
 scaledToSize:(CGSize)newSize;
 {
 UIGraphicsBeginImageContext( newSize );
 [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
 UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
 UIGraphicsEndImageContext();
 
 return newImage;
 }

*/
@end
