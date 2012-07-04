//
//  VenueCustomCell.m
//  EventFinder
//
//  Created by Ahmad on 24/02/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "profileViewCell.h"


@implementation profileViewCell

@synthesize name,fullName,likeCount,commentsCount,time;
@synthesize smallImg,bigImg;
@synthesize commentsButton,likeButton,mapButton,btnPhotoOption;
@synthesize commentView,supportedView;

@synthesize profileButton,increaseButton,decreaseButton,commentCouneterLabel;
@synthesize titleString,descString,timestring,userName,counterLabel;
@synthesize addComments,richText,label1;
@synthesize progressView;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
 - (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
 if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
 // Custom initialization
 }
 return self;
 }
 */

/*
 // Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
 - (void)viewDidLoad {
 [super viewDidLoad];
	 footerView.backgroundColor = [UIColor clearColor];
	 
 }
 */

/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */



- (void)dealloc {
	//	[name release];[time release];[summery release];
	
	//	[smallImg release];[smallImg release];[view1 release];
	  [super dealloc];
}


@end
