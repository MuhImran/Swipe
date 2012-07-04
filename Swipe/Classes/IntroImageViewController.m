//
//  IntroImageViewController.m
//  Posterboard
//
//  Created by Apptellect5 on 9/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "IntroImageViewController.h"
#import "headerfiles.h"

static NSArray *__pageControlColorList = nil;

@implementation IntroImageViewController

@synthesize imageView;


// Creates the color list the first time this method is invoked. Returns one color object from the list.
+ (UIImage *)pageControlImageWithIndex:(NSUInteger)index {
    if (__pageControlColorList == nil) {
        __pageControlColorList = [[NSArray alloc] initWithObjects:[UIImage imageNamed:@"posterboard_introduction1.png"], [UIImage imageNamed:@"posterboard_introduction2.png"], [UIImage imageNamed:@"posterboard_introduction3.png"],
                                  [UIImage imageNamed:@"posterboard_introduction4.png"], [UIImage imageNamed:@"posterboard_introduction5.png"], nil];
    }
	
    // Mod the index by the list length to ensure access remains in bounds.
    return [__pageControlColorList objectAtIndex:index ];//] % [__pageControlColorList count]];
}



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withPageNumber:(int)_page
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        pageNumber = _page;
    }
    return self;
}

- (void)dealloc
{
    [imageView release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    [AppDelegate clearAllCacheImage];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.imageView.image = [IntroImageViewController pageControlImageWithIndex:pageNumber];
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
