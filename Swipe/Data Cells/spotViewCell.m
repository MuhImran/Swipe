//
//  spotViewCell.m
//  Petstagram
//
//  Created by Awais Ahmad Qureshi on 5/31/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "spotViewCell.h"

@implementation spotViewCell
@synthesize textLabel;
@synthesize textTitle;
@synthesize imageView;



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