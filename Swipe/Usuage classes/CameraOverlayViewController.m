//
//  CameraOverlayViewController.m
//  Posterboard
//
//  Created by Apptellect5 on 12/28/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "CameraOverlayViewController.h"



@implementation CameraOverlayViewController

@synthesize imageView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.opaque = NO;
    self.view.backgroundColor = [UIColor clearColor];
    // Load the image to show in the overlay:
    UIImage *overlayGraphic = nil;
    overlayGraphic = [UIImage imageNamed:@"imageframe.png"];
    imageView = [[UIImageView alloc] initWithImage:overlayGraphic];
    imageView.frame = CGRectMake(0, 55, 320, 320);
    [self.view addSubview:imageView];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
