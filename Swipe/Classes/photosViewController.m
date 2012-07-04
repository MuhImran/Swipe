//
//  HomeScreenViewController.m
//  show
//
//  Created by svp on 01/11/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "photosViewController.h"
#import "headerfiles.h"

#import "domainClasses.h"

@interface photosViewController (Private)


@end


@implementation photosViewController
@synthesize dataTable;
@synthesize imageDownloadsInProgress;
@synthesize dataArray;
@synthesize Iden;

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withPhotoArray:(NSMutableArray *)_photoArray  {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
        self.dataArray   = _photoArray;
    }
    return self;
}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	self.title =  @"Detail";
	imageDownloadsInProgress = [[NSMutableDictionary alloc] init];
	
}
-(void)viewWillAppear:(BOOL)animated 
{
    [super viewWillAppear:animated];
	//[self.navigationController setNavigationBarHidden:NO];
	//[self.dataTable scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
	//[imageDownloadsInProgress removeAllObjects];
    
}
#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [dataArray count];	
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath  {
    
   	return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	// TO DO	
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
	return 360.0f;
   
   // return  height+cellHeight;
}
#pragma mark -
#pragma mark Table cell image support

- (void)startIconDownload:(NSString *)_url:(NSIndexPath *)indexpath:(int)_key
{
	if([_url length] == 0)
        return;
	
}
// this method is used in case the user scrolled into a set of cells that don't have their app icons yet
- (void)loadImagesForOnscreenRows
{
	
	    
}
/*
 - (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
 {
 if (!decelerate)
 {
 [self loadImagesForOnscreenRows];
 }
 }
 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
	
	[self loadImagesForOnscreenRows];
}

// called by our ImageDownloader when an icon is ready to be displayed

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    [AppDelegate clearAllCacheImage];
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
-(void) loadAlertView:(NSString *)_title1:(NSString *)_msg
{
	UIAlertView *alert = [[UIAlertView alloc] 
						  initWithTitle:_title1 
						  message:_msg 
						  delegate:self 
						  cancelButtonTitle:@"OK" 
						  otherButtonTitles:nil];
	[alert show];
	[alert release];
	
}



- (void)dealloc {
    [dataTable release];
    [imageDownloadsInProgress release];
    [dataArray release];
    [super dealloc];
}


@end
