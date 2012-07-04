//
//  addFilterViewController.m
//  Petstagram
//
//  Created by Awais Ahmad Qureshi on 5/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "addFilterViewController.h"
#import "shareViewController.h"
#import "commonUsedMethods.h"
#import "Font+size.h"
#import <QuartzCore/QuartzCore.h>
#import "headerfiles.h"
//#include <math.h>
//static inline double radians (double degrees) {return degrees * M_PI/180;}

@implementation addFilterViewController
@synthesize imageView;
@synthesize Image;
@synthesize SVC;

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil wtihImage:(UIImage *)_image {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
        self.Image = _image;
        self.navigationController.navigationBar.hidden = FALSE;
        [commonUsedMethods showTabBar:self.tabBarController];
       
    }
    return self;
}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	self.title = @"Add filter";
	self.navigationItem.rightBarButtonItem =  [[UIBarButtonItem alloc]
                                               initWithTitle:@"Next" style:UIBarButtonItemStyleDone target:self action:@selector(settingButtonPressed:)];
	//self.navigationItem.rightBarButtonItem.enabled=FALSE;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = FALSE;
     self.navigationController.navigationBarHidden = FALSE;
    [commonUsedMethods showTabBar:self.tabBarController];
     
	 [self.imageView setImage:Image];
	
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/
-(void) setCameraImage:(UIImage *)_image
{
	self.Image = _image;
	[imageView setImage:_image];
	
}
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
-(IBAction) settingButtonPressed:(id)sender
{
	NSLog(@"%d",[self.navigationController.viewControllers count]);
   
	shareViewController	*SVC1 = [[shareViewController alloc] initWithNibName:@"shareViewController" bundle:nil withImage:self.Image withOption:0];
	          [self.navigationController pushViewController:SVC1 animated:NO];
    [SVC1 release];
}
-(IBAction) addBorderPressed:(id)sender
{
    self.Image = [self imageWithBorderFromImage:self.Image];
    [self.imageView setImage:self.Image];
    
}

/*
- (UIImage*)imageWithBorderFromImage:(UIImage*)source
{
    CGSize size = [source size];
    UIGraphicsBeginImageContext(size);
    CGRect rect = CGRectMake(0, 0, size.width+10, size.height+10);
    [source drawInRect:rect blendMode:kCGBlendModeNormal alpha:1.0];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    //CGContextSetRGBStrokeColor(context, 1.0, 0.5, 1.0, 1.0);
      CGContextSetRGBStrokeColor(context, 50.0, 50.0, 50.0, 50.0);
    CGContextStrokeRect(context, rect);
    UIImage *testImg =  UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return testImg;
}*/
/*
- (UIImage*)imageWithBorderFromImage:(UIImage*)source
{
    source.layer.borderColor = [UIColor grayColor].CGColor;
    source.layer.borderWidth = 5.0;
    source.layer.CornerRadius = 10;
    source.layer.masksToBounds = YES;
    return testImg;
}
 */
- (UIImage*)imageWithBorderFromImage:(UIImage*)image
{
    //image = [Font_size makeRoundImage:image];
    CGImageRef bgimage = [image CGImage];
	float width = CGImageGetWidth(bgimage);
	float height = CGImageGetHeight(bgimage);
    
    // Create a temporary texture data buffer
	void *data = malloc(width * height * 4);
    
	// Draw image to buffer
	CGContextRef ctx = CGBitmapContextCreate(data,
                                             width,
                                             height,
                                             8,
                                             width * 4,
                                             CGImageGetColorSpace(image.CGImage),
                                             kCGImageAlphaPremultipliedLast);
	CGContextDrawImage(ctx, CGRectMake(0, 0, (CGFloat)width, (CGFloat)height), bgimage);
    
	//Set the stroke (pen) color
	CGContextSetStrokeColorWithColor(ctx, [UIColor lightGrayColor].CGColor);
    
	//Set the width of the pen mark
	CGFloat borderWidth = (float)width*0.08;
	CGContextSetLineWidth(ctx, borderWidth);
    
	//Start at 0,0 and draw a square
	CGContextMoveToPoint(ctx, 0.0, 0.0);	
	CGContextAddLineToPoint(ctx, 0.0, height);
	CGContextAddLineToPoint(ctx, width, height);
	CGContextAddLineToPoint(ctx, width, 0.0);
	CGContextAddLineToPoint(ctx, 0.0, 0.0);
    
	//Draw it
	CGContextStrokePath(ctx);
    
    // write it to a new image
	CGImageRef cgimage = CGBitmapContextCreateImage(ctx);
	UIImage *newImage = [UIImage imageWithCGImage:cgimage];
	CFRelease(cgimage);
	CGContextRelease(ctx);
    
    // auto-released
	return newImage;
}


- (void)dealloc {
	[SVC release];
	[Image release];
	[imageView release];
    [super dealloc];
}


@end
