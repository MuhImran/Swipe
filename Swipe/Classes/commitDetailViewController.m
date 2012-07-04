//
//  feedCommentView.m
//  Petstagram
//
//  Created by Awais Ahmad Qureshi on 4/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "commitDetailViewController.h"
#import "commentDetailCell.h"
#import "domainClasses.h"
#import  "Font+size.h"
#import "headerfiles.h"
#import "profileViewController.h"



@interface commitDetailViewController (Private)
-(void) setChildTableDisplay:(commentDetailCell *)cell:(NSIndexPath *)indexPath;
- (void)startIconDownload:(NSString *)_url:(NSIndexPath *)indexpath:(int)_key;
@end

@implementation commitDetailViewController
@synthesize commentTable;
@synthesize imageDownloadsInProgress;
@synthesize UPVC;


// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withPhoto:(PhotoData *)_photodata{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
		 photodata  = _photodata;
    }
    return self;
}



 // Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
 - (void)viewDidLoad {
   [super viewDidLoad];
	self.title = @"Comments"; 
	 imageDownloadsInProgress = [[NSMutableDictionary alloc] init];
 }
 
-(void)viewWillAppear:(BOOL)animated 
{
    [super viewWillAppear:animated];
	[self.navigationController setNavigationBarHidden:NO];
	[imageDownloadsInProgress removeAllObjects];
	
}
-(void) setDetailItem:(PhotoData *)_photodata;
{
	photodata  = _photodata;
	[self.commentTable reloadData];
}
#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
		return [photodata.commentArray count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath  {
	
	static NSString *CellIdentifier = @"commentDetailCell";
	commentDetailCell *cell = (commentDetailCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		
		NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"commentDetailCell" owner:self options:nil];
		
		for (id currentObject in topLevelObjects){
			if ([currentObject isKindOfClass:[UITableViewCell class]]){
				cell =  (commentDetailCell *) currentObject;
				break;
			}
		}
	} 
	[self setChildTableDisplay:cell:indexPath];
    [Font_size dropShahdowToButton:cell.userButton];
    cell.backgroundColor = [Font_size cellBackgroundColor];
	cell.selectionStyle=0;
	return cell;
	
}
-(void) setChildTableDisplay:(commentDetailCell *)cell:(NSIndexPath *)indexPath
{
    [commonUsedMethods removeActivityFromView:cell.userButton.subviews];
    [cell.userButton setImage:nil forState:UIControlStateNormal];
    CommentsData *obj = [photodata.commentArray objectAtIndex:indexPath.row];
	cell.timeInfo.text = [commonUsedMethods timeIntervalWithStartDate:obj.createdDate];
	cell.name.text = (obj.user.userName) ? obj.user.userName : obj.user.fullName; 
	cell.textString.text = obj.textData;
	[Font_size adjustLabelHeight:cell.textString:65];
    
    
    if(obj.user.imgURL && [obj.user.imgURL length] > 0)
    {
        if (![imageCaches imageFromKey:obj.user.imgURL])
        {
            UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(15, 20, 25, 25)];
            [activityIndicator startAnimating];
            activityIndicator.activityIndicatorViewStyle= UIActivityIndicatorViewStyleGray;
            [cell.userButton addSubview:activityIndicator];
            [activityIndicator release];
            [self startIconDownload:obj.user.imgURL:indexPath:1];
        }
        else
        {
            cell.userButton.enabled=TRUE;
            [cell.userButton setImage:[imageCaches imageFromKey:obj.user.imgURL] forState:UIControlStateNormal];
        }
    }
    else
    {    cell.userButton.enabled=TRUE;  
        [cell.userButton setImage:[Font_size getPersonShahowImage] forState:UIControlStateNormal];
    }
    [cell.userButton addTarget:self action:@selector(userProfileViewPressed:) forControlEvents:UIControlEventTouchUpInside];
    [cell.userButton setTag:[obj.user.iden intValue]];
    
   	
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	// TO DO	
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 85;
/*
	CGFloat		result = 0.0f;
	NSString*	text = nil;
	
	CommentsMetaData *obj = [photodata.commentdata.commentsInfo objectAtIndex:indexPath.row];
	text =[NSString stringWithFormat:@"%@%@",obj.user.userName,obj.textData];
	//NSLog(text);
	if(text)
	{
		CGSize		textSize = {290, 35};		// width and height of text area
		CGSize		size = [text sizeWithFont:[UIFont systemFontOfSize:12.0f] constrainedToSize:textSize lineBreakMode:UILineBreakModeWordWrap];
		result = size.height; 
	}
	result +=5;
	NSLog(@"The cell height is %f", result);
	
	return result;
 */
	
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection: (NSInteger)section 
{
	return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection: (NSInteger) section
{
		return COMMENT_CELL_HEIGHT;
	
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection: (NSInteger) section
{
	return COMMENT_CELL_HEIGHT;
	
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
	
	
	NSArray *visiblePaths = [self.commentTable indexPathsForVisibleRows];
	for (NSIndexPath *indexPath in visiblePaths)
	{
		CommentsMetaData *obj = [photodata.commentArray objectAtIndex:indexPath.row];
			if (![imageCaches imageFromKey:obj.user.imgURL])
			{
				[self startIconDownload:obj.user.imgURL:indexPath:1];
			}
	}
			    
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
	
	[self loadImagesForOnscreenRows];
}
-(IBAction) userProfileViewPressed:(id)sender
{
	iden = [(UIButton *)sender tag];
	[self syncOnThreadAction:FALSE];
}

// called by our ImageDownloader when an icon is ready to be displayed
#pragma mark delegate method of Image download
- (void)appImageDidLoad:(NSIndexPath *)indexPath:(NSString *)_key
{	
	/*
	IconDownloader *iconDownloader = [imageDownloadsInProgress objectForKey:indexPath];
    if (iconDownloader != nil)
    {
			commentDetailCell *cell = (commentDetailCell *) [self.commentTable cellForRowAtIndexPath:indexPath];
			UIImage *buttonImage =[imageCaches imageFromKey:iconDownloader.url];
			buttonImage =[ImageManipulator scaleImage:buttonImage:cell.userButton.frame.size];
			buttonImage =[ImageManipulator makeRoundCornerImage:buttonImage:5:5];
			[cell.userButton setImage:buttonImage forState:UIControlStateNormal];
            [commonUsedMethods removeActivityFromView:cell.userButton.subviews];
      			
    }  */
}
-(void) syncOnThreadAction:(int)_tag
{
	overlay = [[SingletonClass sharedInstance] getOverlay];
	[overlay setDelegate:self];
	
	[overlay getUserProfileData:[requestStringURLs getUserProfileRequest:[NSNumber numberWithInt:iden] :24 :0] :FALSE :FALSE];
}

#pragma mark ParserProtocolDelegate
-(void) ParserArraylist:(NSMutableArray *) _array
{
	[overlay dismiss];
    overlay.delegate=nil;
    profileViewController *UPVC1 = [[profileViewController alloc] initWithNibName:@"profileViewController"  bundle:nil withUser:[_array objectAtIndex:0]];
    [self.navigationController pushViewController:UPVC1 animated:NO];
    [UPVC1 release];
		
}
-(void) errorResponseData:(NSDictionary *)_dictionary
{
	[overlay dismiss];
    overlay.delegate=nil;
    [self loadAlertView:@"":[_dictionary valueForKey:@"message"]];
}
#pragma mark clientProtocolDelegate

-(void) notfiyResponse:(NSNumber *)_value
{
	 
    [overlay dismiss];
    overlay.delegate=nil;
	[self loadAlertView:@"Sorry" :@"Internet Connection not available"];
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


- (void)dealloc {
	[imageDownloadsInProgress release];
	[commentArray release];
	[commentTable release];
	[UPVC release];
    [super dealloc];
}


@end
