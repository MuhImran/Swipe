//
//  photosViewCell.m
//  Petstagram
//
//  Created by Imran on 7/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "contactViewCell.h"


@implementation contactViewCell

@synthesize nameLabel,email;

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
		[nameLabel release];
        [email release];
   
	  [super dealloc];
}


@end
