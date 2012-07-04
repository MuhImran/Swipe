//
//  feedCommentView.m
//  Petstagram
//
//  Created by Awais Ahmad Qureshi on 4/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "feedCommentView.h"
#import "feedCommentCell.h"
#import "domainClasses.h"
#import  "Font+size.h"
#import "headerfiles.h"

@implementation feedCommentView
@synthesize commentTable;
@synthesize delegate;

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
		//commentArray = [[NSMutableArray alloc] init];
    }
    return self;
}


/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/
-(void) setCommentData:(PhotoData *)_photoData:(userProfile *)_userprofile
{
	photodata  = _photoData;
    userprofile= _userprofile;
	[self.commentTable reloadData];
}
#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
	NSLog(@"Total Row for comments %d",[photodata.commentArray count]+1);	
	if([photodata.commentArray count] < 5)
	return [photodata.commentArray count]+1;
	else
	 return 6;
	return 0;
	
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath  {
    
    static NSString *CellIdentifier = @"feedCommentCell";
    feedCommentCell *cell = (feedCommentCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"feedCommentCell" owner:self options:nil];
        
        for (id currentObject in topLevelObjects){
            if ([currentObject isKindOfClass:[UITableViewCell class]]){
                cell =  (feedCommentCell *) currentObject;
                break;
            }
        }
    } 
    if(indexPath.row == 0)
    {
		// cell.textString.text = @"This is a multiline test and willl consist of more than two line and by using the method we will wrap the extra length of the characters and then will write exta charactes dot dot dot";//obj.user.userName;
        NSString *str = (userprofile.userName) ? userprofile.userName : userprofile.fullName; 
		/*if(userprofile.fullName && [userprofile.fullName length]>0)
		 [cell.userButton setTitle:userprofile.fullName forState:UIControlStateNormal];
         else if(userprofile.userName && [userprofile.userName length]>0)*/
        [cell.userButton setTitle:str forState:UIControlStateNormal];
        [cell.userButton addTarget:self action:@selector(ViewUserPressed:) forControlEvents:UIControlEventTouchUpInside];
        cell.userButton.tag = [userprofile.iden intValue];
        cell.textString.text =photodata.title;
       // [Font_size adjustLabelHeight:cell.textString:30];
    }
	else
	{
		CommentsData *obj = [photodata.commentArray objectAtIndex:indexPath.row-1];
        NSString *str = (obj.user.userName) ? obj.user.userName : obj.user.fullName; 
        [cell.userButton setTitle:str forState:UIControlStateNormal];
        [cell.userButton addTarget:self action:@selector(ViewUserPressed:) forControlEvents:UIControlEventTouchUpInside];
        cell.userButton.tag = [obj.user.iden intValue];
        cell.textString.text =obj.textData;
        [Font_size adjustLabelHeight:cell.textString:30];
	}
    cell.selectionStyle=0;
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	// TO DO	
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //return COMMENT_CELL_HEIGHT;
	if([indexPath row] == 0)
		return 20;
	else if ([photodata.commentArray count] > 5 && [indexPath row] == 6)
		return COMMENT_CELL_HEIGHT+5;
	else
	{
        CGFloat		result = 0.0f;
        NSString*	text = nil;
        
        CommentsData *obj = [photodata.commentArray objectAtIndex:indexPath.row-1];
        text =[NSString stringWithFormat:@"%@",obj.textData];
        if(text)
        {
            CGSize		textSize = {190, 30};		// width and height of text area
            CGSize		size = [text sizeWithFont:[UIFont systemFontOfSize:12.0f] constrainedToSize:textSize lineBreakMode:UILineBreakModeWordWrap];
            // CGSize		size = [text sizeWithFont:[UIFont fontWithName:@"Helvetica-Neue" size:12.0f] constrainedToSize:textSize lineBreakMode:UILineBreakModeWordWrap];
            result = size.height; 
        }
        result +=2;
        //NSLog(@"The cell height is %f", result);
        return result;
	}
	return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection: (NSInteger)section 
{
	if([photodata.commentArray count] > 5){
	CGRect footerFrame = CGRectMake(0.0, 0.0, 320, COMMENT_CELL_HEIGHT+5);
    UIView *_footerView = [[UIView alloc] initWithFrame: footerFrame];
    _footerView.backgroundColor = [UIColor clearColor];
   // _footerView.contentMode = UIViewContentModeCenter;
	
	UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *upImage,*downImage;
        upImage = [UIImage imageNamed:@"viewAllCommentsUp.png"];
         downImage = [UIImage imageNamed:@"viewAllCommentsDown.png"];
       // UIImage *newImage = [buttonBkground stretchableImageWithLeftCapWidth:12.0 topCapHeight:0.0];
        [button setBackgroundImage:upImage forState:UIControlStateNormal]; 
         [button setBackgroundImage:downImage forState:UIControlStateSelected]; 
	//[button setTitle:@"Viw all Comments" forState:UIControlStateNormal];
	[button addTarget:self action:@selector(ViewAllCommentPressed:) forControlEvents:UIControlEventTouchUpInside];	
	button.tag = [photodata.iden intValue];
	[button setTitleColor:[UIColor darkGrayColor]  forState:UIControlStateNormal];
	button.frame = CGRectMake(5.0, 5.0, 140.0, COMMENT_CELL_HEIGHT);
	[_footerView addSubview:button];
	return _footerView;
	}
	return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection: (NSInteger) section
{
	if([photodata.commentArray count] > 5)
      return COMMENT_CELL_HEIGHT;
	return 0;
}
-(IBAction)ViewAllCommentPressed:(id)sender
{
	UIButton *button = (UIButton *)sender;
	NSLog(@"Comment View All Button tag is %d",button.tag);
	if(delegate && [delegate respondsToSelector:@selector(viewAllComment:)])
		[delegate performSelector:@selector(viewAllComment:) withObject:[NSNumber numberWithInt:button.tag]];

}
-(IBAction)ViewUserPressed:(id)sender
{
	UIButton *button = (UIButton *)sender;
	if(delegate && [delegate respondsToSelector:@selector(viewUserProfile:)])
		[delegate performSelector:@selector(viewUserProfile:) withObject:[NSNumber numberWithInt:button.tag]];

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
	delegate = nil;
	[commentArray release];
	[commentTable release];
    [super dealloc];
}


@end
