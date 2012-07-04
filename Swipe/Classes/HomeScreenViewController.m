//
//  HomeScreenViewController.m
//  show
//
//  Created by svp on 01/11/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "HomeScreenViewController.h"
#import "headerfiles.h"
#import "profileViewCell.h"
#import "domainClasses.h"
#import "photoDetailViewController.h"
#import "ActivityController.h"
#import "FeedCustomCell.h"
#import "feedCommentView.h"
#import "EGORefreshTableFooterView.h"
#import "profileViewController.h"
#import "commitDetailViewController.h"
#import "addCommentViewController.h"

#import "NSAttributedString+Attributes.h"

int feedOffset = 0;

@interface HomeScreenViewController (Private)

- (void)dataSourceDidFinishLoadingNewData;
- (float)tableViewHeight;
- (void)repositionRefreshHeaderView;
- (float)endOfTableView:(UIScrollView *)scrollView;
-(void) removeAllButtonFromCell:(UITableViewCell *)cell;
-(void) showSupporterView:(UIView *)_sView:(NSMutableArray *)_supporterArray:(NSIndexPath *)indexPath;
-(void) setMasterTableDisplay:(profileViewCell *)cell:(NSIndexPath *)indexPath;
-(void) dataCellForFeedTab:(FeedCustomCell *)cell:(NSIndexPath *)indexPath;
@end

@implementation HomeScreenViewController
@synthesize feedData,serachFeed;
@synthesize dataTable;
@synthesize imageDownloadsInProgress;
@synthesize tableHeaderView;
@synthesize reqType;
@synthesize searchbar;
@synthesize tableHeightArray;
@synthesize dataArray;
@synthesize reloading=_reloading;
@synthesize emptyListView;

@synthesize currentLocation;
//@synthesize isLocation;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
 - (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
 if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
 // Custom initialization
 }
 return self;
 }
 */


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [Font_size cellBackgroundColor];
    self.title = @"Feed";
  //  self.navigationItem.titleView =  [commonUsedMethods navigationlogoView];
	self.searchbar.tintColor = [commonUsedMethods getNavTintColor];
    [Font_size customSearchBarBackground:self.searchbar];
	tableHeightArray = [[NSMutableArray alloc] init];
    imageDownloadsInProgress = [[NSMutableDictionary alloc] init];
	firtTimeView = TRUE;
	searching = FALSE;
    reqType = 1;
    
    UINavigationItem *item = [self.navigationController.navigationBar.items objectAtIndex:0];
    item.titleView =  [commonUsedMethods navigationlogoView];
    
    item.rightBarButtonItem = [commonUsedMethods navigationButtonWithText:@"Refresh":FALSE];
    UIButton* rightButton = (UIButton*)item.rightBarButtonItem.customView;
    [rightButton addTarget:self action:@selector(topicButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
}
-(IBAction) topicButtonPressed:(id)sender
{
    reqType = 6;
    [[GPS_Object sharedInstance] startUpdatingLocating:self];
    
}

#pragma mark Delete Photo Delegate

-(void) DeletePhotoResponse:(NSString *)_index
{
    NSLog(@"index %d, array : %d",[_index intValue], [dataArray count]);
    [DataModel deletePhotoData:[_index intValue] :3];
    //[self.dataArray removeObjectAtIndex:[[commonUsedMethods getPhotoIndexToDelete] intValue]];
    //NSLog(@"data array %d ",[dataArray count]);
    [self reloadTableData];
    //[self.dataTable reloadData];
}


#pragma mark -
#pragma mark Search Bar 
/*
 comment 5 sep
 - (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
 {
 // only show the status bar’s cancel button while in edit mode
 searchBar.showsCancelButton = YES;
 searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
 
 }
 - (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
 {
 searchBar.showsCancelButton = NO;
 }
 */

/*
 - (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
 {
 if([searchText isEqualToString:@""] || searchText==nil){
 return;
 }
 }
 */

/*
 comment 5 sep
 - (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
 {
 // if a valid search was entered but the user wanted to cancel, bring back the main list 
 searchBar.text = @"";
 // searchBar.showsCancelButton = NO;
 [searchBar resignFirstResponder];
 self.dataArray = feedData.photoArray;
 reqType = 1;
 searching = FALSE;
 [self.dataTable reloadData];
 }
 // called when Search (in our case “Done”) button pressed
 - (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
 {
 self.searchbar.text = [commonUsedMethods stripDoubleSpaceFrom:searchbar.text];
 [searchBar resignFirstResponder];
 if([self.searchbar.text length]>0)
 {
 reqType =2;
 searching = TRUE;
 [self syncOnThreadAction:FALSE];
 }
 }
 */


-(void)viewWillAppear:(BOOL)animated 
{
    [super viewWillAppear:animated];
    reqType =0;
    [commonUsedMethods setTabIndexToReturn:0];
    [commonUsedMethods setLastTabBarIndex:@"0"];
    [self reloadTableData];
}
- (void)viewWillDisappear:(BOOL)animated {
	
	NSLog(@"Now removing view and removing all dictionary contents");
	NSArray *viewControllers = self.navigationController.viewControllers;
	if (viewControllers.count > 1 && [viewControllers objectAtIndex:viewControllers.count-2] == self) 
	{
        // TO DO
	} 
	else if ([viewControllers indexOfObject:self] == NSNotFound) { }
    if([self.imageDownloadsInProgress count]> 0)
        [commonUsedMethods clearImageDownloader:self.imageDownloadsInProgress];
    [imageCaches clearMemory];
    [self removeAllButtonFromCell:[self.dataTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]]];
    
}


-(void) addPullViewAtBottom
{
    
    if([dataArray count] >= 24)
    {
        if (refreshFooterView == nil) {
            refreshFooterView = [[EGORefreshTableFooterView alloc] initWithFrame:CGRectMake(0.0f, [self tableViewHeight], 320.0f, 600.0f)];
            refreshFooterView.backgroundColor = [UIColor colorWithRed:226.0/255.0 green:231.0/255.0 blue:237.0/255.0 alpha:1.0];
            [self.dataTable addSubview:refreshFooterView];
            self.dataTable.showsVerticalScrollIndicator = YES;
        }
        else
        {
            [refreshFooterView removeFromSuperview];
            [refreshFooterView setFrame:CGRectMake(0.0f, [self tableViewHeight], 320.0f, 600.0f)];
            [self.dataTable addSubview:refreshFooterView];
        }
    }
	
}
-(void) getFeedDataArray
{
	if(reqType == 2 || searching)
	{
        self.serachFeed= [[DataModel getDataInDictionary:2] objectAtIndex:0];
        dataArray =serachFeed.photoArray;
	}
	else 
    {
        //self.feedData= [[DataModel getDataInDictionary:1] objectAtIndex:0]; //commented on 22/09/2011
        self.feedData= [[DataModel getDataInDictionary:3] objectAtIndex:0];
        dataArray =feedData.photoArray;
        //         NSMutableArray *arr = [[NSMutableArray alloc] init];
        //         for(int i = 0;i<5;i++)
        //             [arr addObjectsFromArray:dataArray];
        //         NSLog(@"%d",[arr count]);
        //         dataArray = [arr copy];
        //  if(reqType == 0)
        //   [self syncOnThreadAction:YES];
    }
}

/*
 -(void) sendRequestForImage:(NSString *)_url:(NSSttring *)_key
 {
 IconDownloader *imageDownloader = [[IconDownloader alloc] init];
 imageDownloader.delegate = self;
 imageDownloader.key = _key;
 [imageDownloader startDownload2:_url];
 [imageDownloader release];
 
 }
 */


///     Replace Image at here to change the image
/*
 -(void) customTabBarImage
 
 {
 for(UIView *view in self.tabBarController.tabBar.subviews) 
 {  
 if([view isKindOfClass:[UIImageView class]]) 
 {  
 [view removeFromSuperview];  
 }  
 }  
 
 [self.tabBarController.tabBar insertSubview:[[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tabbar1.png"]] autorelease] atIndex:0];  
 
 }
 */


#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    [imageDownloadsInProgress removeAllObjects];
	[tableHeightArray removeAllObjects];
	return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	/*
     int totalRows;
     for (int i =0; i < [dataArray count]; i++) {
     PhotoData *photodata = [dataArray objectAtIndex:i];
     if([commonUsedMethods getTopicOption:photodata.tag])
     totalRows++;
     }
     return totalRows; */
	return 1;//[dataArray count];
   
    /*int r = 1;
    
    if([dataArray count]%24 == 0)
        r = [dataArray count]/24;
    else
        r = [dataArray count]/24 + 1;
    
    return r;*/
	
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath  {
	if(firtTimeView)
	{
		firtTimeView = FALSE;
		[self addPullViewAtBottom];
	}
    
    static NSString *hlCellID = @"hlCellID";
    UITableViewCell *hlcell = [tableView dequeueReusableCellWithIdentifier:hlCellID];
    if(hlcell == nil) {
        hlcell =  [[[UITableViewCell alloc] 
                    initWithStyle:UITableViewCellStyleDefault reuseIdentifier:hlCellID] autorelease];
        hlcell.accessoryType = UITableViewCellAccessoryNone;
        hlcell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    [self removeAllButtonFromCell:hlcell]; 
    [self dataForOtherTab:hlcell:indexPath];
	return hlcell;
}
-(void) dataCellForFeedTab:(FeedCustomCell *)cell:(NSIndexPath *)indexPath
{
    PhotoData *photodata = [dataArray objectAtIndex:[indexPath row]];
    [cell.photoButton setImage:nil forState:UIControlStateNormal];
    [commonUsedMethods removeActivityFromButton:cell.photoButton];
    cell.titleString.text=@"";
    cell.timeString.text=@"";
    cell.userName.text=@"";
    cell.counterLabel.text=@"";
    cell.titleString.text = photodata.title;
       
    NSString *str = @""; 
    if(photodata.user.userName)
        str = [str stringByAppendingFormat:@"%@",photodata.user.userName];
    if(photodata.title)
        str = [str stringByAppendingFormat:@" reported %@",photodata.title];
    if(photodata.createdDate)
        str = [str stringByAppendingFormat:@"\n%@",[commonUsedMethods timeIntervalWithStartDate:photodata.createdDate]];
    
   	NSMutableAttributedString* attrStr = [NSMutableAttributedString attributedStringWithString:str];
    
	[attrStr setFont:[UIFont systemFontOfSize:12]];
	[attrStr setTextColor:[UIColor lightGrayColor]];
    NSLog(@"%@",str);
    if(photodata.title)
    {
        [attrStr setTextColor:[commonUsedMethods getNavTintColor]  range:[str rangeOfString:photodata.title options:0 range:NSMakeRange(0,[str length])]];
        [attrStr setFont:[UIFont boldSystemFontOfSize:15]  range:[str rangeOfString:photodata.title options:0 range:NSMakeRange(0,[str length])]];
    }
    if(photodata.user.userName)
    {
        [attrStr setFont:[UIFont boldSystemFontOfSize:15]  range:[str rangeOfString:photodata.user.userName options:0 range:NSMakeRange(0,[str length])]];
        [attrStr setTextColor:[commonUsedMethods getNavTintColor]  range:[str rangeOfString:photodata.user.userName options:0 range:NSMakeRange(0,[str length])]];
    }
    if(photodata.createdDate)
    {
        [attrStr setTextColor:[UIColor grayColor]  range:[str rangeOfString:[commonUsedMethods timeIntervalWithStartDate:photodata.createdDate] options:0 range:NSMakeRange(0,[str length])]];
        [attrStr setFont:[UIFont systemFontOfSize:12]  range:[str rangeOfString:[commonUsedMethods timeIntervalWithStartDate:photodata.createdDate] options:0 range:NSMakeRange(0,[str length])]];
    }
    cell.label1.attributedText = attrStr;
    cell.counterLabel.text=[NSString stringWithFormat:@"%d",[photodata.supporters intValue]];
    if([indexPath row]%2==0)
        cell.counterLabel.textColor = [commonUsedMethods getNavTintColor];
    else
        cell.counterLabel.textColor = [commonUsedMethods getNavTintColor1];
    
    [cell.photoButton setImage:nil forState:UIControlStateNormal];
    [cell.photoButton setContentMode:UIViewContentModeScaleAspectFit];
    [cell.photoButton addTarget:self action:@selector(viewDetailButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    cell.photoButton.tag =  indexPath.row; 
    [cell.userProfileButton setTitle:photodata.user.userName forState:UIControlStateNormal];
    [cell.userProfileButton addTarget:self action:@selector(profileButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    cell.userProfileButton.tag = [photodata.user.iden intValue];
    [cell.plusButton addTarget:self action:@selector(plusButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    cell.plusButton.tag = [photodata.iden intValue];
    [cell.negativeButton addTarget:self action:@selector(negativeButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    cell.negativeButton.tag = [photodata.iden intValue];
    
    if(photodata.thumbnail.url && [photodata.thumbnail.url length] > 0)
    {
        if (![imageCaches imageFromKey:photodata.thumbnail.url])
        {
            UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(25, 30, 20, 20)];
            [activityIndicator startAnimating];
            activityIndicator.activityIndicatorViewStyle= UIActivityIndicatorViewStyleGray;
            [cell.photoButton addSubview:activityIndicator];
            [activityIndicator release];
            [self startIconDownload:photodata.thumbnail.url:indexPath:[photodata.iden intValue]];
        }
        else
        {
            [cell.photoButton setImage:[imageCaches imageFromKey:photodata.thumbnail.url] forState:UIControlStateNormal];
        }
    }
    [Font_size dropShahdowToButton:cell.photoButton];
    cell.backgroundColor = [Font_size cellBackgroundColor];
    cell.selectionStyle=0;
}



#pragma mark code for image grid
-(void) dataForOtherTab:(UITableViewCell *)hlcell:(NSIndexPath *)indexPath
{
    int n = [dataArray count];
	int i=0,i1=0; 
	NSLog(@"redraw cell");
	while(i<n)
    {
		int yy = 4 +i1*75+(4*(i1+1));
		int j=0;
		for(j=0; j<4;j++)
        {
			
			if (i>=n) break;
			PhotoData *item = [dataArray objectAtIndex:i];
			ResolutionInfo *obj = item.thumbnail;
			CGRect rect = CGRectMake((4*(j+1))+75*j, yy, 75, 75);
			UIButton *button=[[UIButton alloc] initWithFrame:rect];
			[button setFrame:rect];
			NSString *tagValue = [NSString stringWithFormat:@"%d%d", indexPath.row, i];
            //NSString *tagValue = [NSString stringWithFormat:@"%d", i];
			button.tag = [tagValue intValue];
			UIImage *buttonImageNormal;
			if (![imageCaches imageFromKey:obj.url])
		    {
                //       
                buttonImageNormal = [UIImage imageNamed:@"frame.png"];//[Font_size getPlaceholderImage];
				[self startIconDownload:obj.url:indexPath:[tagValue intValue]];
			}
			else
			{
				buttonImageNormal =[imageCaches imageFromKey:obj.url];//[ImageManipulator makeRoundCornerImage:[imageCaches getCacheImage:obj.url] :8 : 8];
				[button setBackgroundImage:buttonImageNormal forState:UIControlStateNormal];
                
			}
			[button setImage:buttonImageNormal forState:UIControlStateNormal];
			[button setContentMode:UIViewContentModeScaleAspectFit];
			[button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
			[hlcell.contentView addSubview:button];
			[button release];
            
			
			i++;
		}
		i1 = i1+1;
	}
    hlcell.selectionStyle=0;
}


-(void) removeAllButtonFromCell:(UITableViewCell *)cell
{
	for (UIView *view in cell.contentView.subviews){
		if([view isKindOfClass:[UIButton class]])
		{
			[view removeFromSuperview];
		}
	}

	
}

-(IBAction)buttonPressed:(id)sender {
	
    UIButton *button =  (UIButton *)sender;
    int tagId = button.tag;//[sender tag];
    
    NSLog(@"del index : %d",tagId);
    [commonUsedMethods setPhotoIndexToDelete:[NSString stringWithFormat:@"%d",tagId]];
    photoDetailViewController *PDVC1 = [[photoDetailViewController alloc] initWithNibName:@"photoDetailViewController" bundle:nil withPhoto:[dataArray objectAtIndex:tagId]];
    PDVC1.delegate = self;
    [self.navigationController pushViewController:PDVC1 animated:YES];
    [PDVC1 release];
}


/*
 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath  {
 if(firtTimeView)
 {
 firtTimeView = FALSE;
 [self addPullViewAtBottom];
 }
 static NSString *ProfileCellIdentifier = @"profileViewCell";
 profileViewCell *cell = (profileViewCell *) [tableView dequeueReusableCellWithIdentifier:ProfileCellIdentifier];
 if (cell == nil) {
 
 NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"profileViewCell" owner:self options:nil];
 
 for (id currentObject in topLevelObjects){
 if ([currentObject isKindOfClass:[UITableViewCell class]]){
 cell =  (profileViewCell *) currentObject;
 break;
 }
 }
 } 
 [self setMasterTableDisplay:cell:indexPath];
 return cell;
 }
 
 -(void) setMasterTableDisplay:(profileViewCell *)cell:(NSIndexPath *)indexPath
 {
 cell.smallImg.image=nil;
 cell.bigImg.image = nil;
 cell.name.text=  (userprofile.userName) ? userprofile.userName:userprofile.fullName;
 [cell.imageActivity startAnimating];
 [cell.profileButton setImage:nil forState:UIControlStateNormal];
 [cell.profileButton setContentMode:UIViewContentModeScaleAspectFit];
 [cell.profileButton addTarget:self action:@selector(profileViewPressed:) forControlEvents:UIControlEventTouchUpInside];
 cell.profileButton.tag = [userprofile.iden intValue];
 cell.profileButton.enabled=FALSE;
 if(userprofile.imgURL && [userprofile.imgURL length] > 0)
 {
 if (![imageCaches imageForKey:userprofile.imgURL])
 {
 UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(8, 8, 20, 20)];
 [activityIndicator startAnimating];
 activityIndicator.activityIndicatorViewStyle= UIActivityIndicatorViewStyleGray;
 [cell.profileButton addSubview:activityIndicator];
 [activityIndicator release];
 [self startIconDownload:userprofile.imgURL:indexPath:1];
 }
 else
 {
 cell.profileButton.enabled=TRUE;
 [cell.profileButton setImage:[imageCaches getCacheImage:userprofile.imgURL] forState:UIControlStateNormal];
 }
 }
 else
 {    cell.profileButton.enabled=TRUE;  
 [cell.profileButton setImage:[Font_size getPersonShahowImage] forState:UIControlStateNormal];
 }
 
 PhotoData *photodata = [dataArray objectAtIndex:[indexPath row]];
 NSLog(@"Photo Id is :%d",[photodata.iden intValue]);
 cell.time.text = [commonUsedMethods timeIntervalWithStartDate:photodata.createdDate];
 cell.commentsCount.text = [NSString stringWithFormat:@"%d",[photodata.commentArray count]];
 cell.likeCount.text = [NSString stringWithFormat:@"%d",[photodata.supporterArray count]];
 cell.likeButton.alpha = 1.0;
 [cell.commentsButton addTarget:self action:@selector(commentButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
 cell.commentsButton.tag = [photodata.iden intValue];
 if(!photodata.hasLike)
 {
 [cell.likeButton addTarget:self action:@selector(likeButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
 [cell.likeButton setImage:[Font_size getLikeImageBeforeLike] forState:UIControlEventTouchUpInside];
 cell.likeButton.tag = [photodata.iden intValue];
 }
 else if(photodata.hasLike)
 {
 [cell.likeButton removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
 [cell.likeButton setImage:[Font_size getLikeImageAfterLike] forState:UIControlEventTouchUpInside];
 
 }
 cell.bigImg.tag = 2;
 if (![imageCaches imageForKey:photodata.lowResolution.url])
 {
 [self startIconDownload:photodata.lowResolution.url:indexPath:cell.bigImg.tag];
 }
 else
 {
 [cell.imageActivity stopAnimating];
 [cell.bigImg setImage:[imageCaches getCacheImage:photodata.lowResolution.url]];
 }
 if(photodata.supporterArray && [photodata.supporterArray count] > 0)
 [self showSupporterView:cell.supportedView:photodata.supporterArray:indexPath];
 cell.selectionStyle=0;
 }
 -(void) showSupporterView:(UIView *)_sView:(NSMutableArray *)_supporterArray:(NSIndexPath *)indexPath
 {
 CGRect frame = _sView.frame;	
 for(int j=0; j<[_supporterArray count];j++){
 if (j >=GRID_TOTAL-1) break;
 CommentsData *obj = [_supporterArray objectAtIndex:j];
 CGRect rect = CGRectMake((frame.size.width/GRID_TOTAL)*j,0, frame.size.width/GRID_TOTAL, frame.size.height);
 rect.origin.x = rect.origin.x+(4*j);
 UIButton *button=[[UIButton alloc] initWithFrame:rect];
 [button setFrame:rect];
 NSString *tagValue = [NSString stringWithFormat:@"%d%d", indexPath.row, j];
 button.tag = [tagValue intValue];
 if(obj.user.imgURL && [obj.user.imgURL length] > 0)
 {
 if (![imageCaches imageForKey:obj.user.imgURL])
 {
 UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(15, 20, 20, 20)];
 [activityIndicator startAnimating];
 activityIndicator.activityIndicatorViewStyle= UIActivityIndicatorViewStyleGray;
 [button addSubview:activityIndicator];
 [activityIndicator release];
 [self startIconDownload:obj.user.imgURL:indexPath:1];
 }
 else
 {
 button.enabled=TRUE;
 [button setImage:[ImageManipulator makeRoundCornerImage:[imageCaches getCacheImage:obj.user.imgURL]:8:8] forState:UIControlStateNormal];
 }
 }
 else
 {    button.enabled=TRUE;  
 [button setImage:[Font_size getPersonShahowImage] forState:UIControlStateNormal];
 }
 [button addTarget:self action:@selector(userProfileViewPressed:) forControlEvents:UIControlEventTouchUpInside];
 [button setTag:[obj.user.iden intValue]];
 
 [_sView addSubview:button];
 [button release];
 }
 }
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // TO DO	
    //    photoDetailViewController *PDVC1 = [[photoDetailViewController alloc] initWithNibName:@"photoDetailViewController" bundle:nil withPhoto:[dataArray objectAtIndex:indexPath.row]];
    //    [self.navigationController pushViewController:PDVC1 animated:YES];
    //    [PDVC1 release];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    
    
    CGFloat height = 400.0f;
   
    
    if([dataArray count] > 4)
    {
        int m = 0;
        if([dataArray count]%4 != 0)
            m = 1;
        NSLog(@"%d",([dataArray count]/4 * 75)+ ([dataArray count]/4 * 4) + m * 83);
        height = ([dataArray count]/4 * 75)+ ([dataArray count]/4 * 4)+ 12 + m * 83;
        
    }
	else 
    {
        
        height = 95;
    }
     
    
   // height = (24/4 * 75)+ (24/4 * 4)+ 12;
	//	int cellHeight = [Font_size feedCommentCellHeight:[dataArray objectAtIndex:[indexPath row]]];
	
	[tableHeightArray  addObject:[NSString stringWithFormat:@"%f",height]];
    return  height;
}

- (void)reloadTableViewDataSource{
	//  should be calling your tableviews model to reload
	//  put here just for demo
	//self.dataTable.userInteractionEnabled=FALSE;
    if([dataArray count]< 4)
        return;
    if(!searching)
    {
        reqType = 0;
        feedOffset++;
        //isLocation = NO;
        //[[GPS_Object sharedInstance] startUpdatingLocating:self];
        self.currentLocation = [[SingletonClass sharedInstance] getMyCurrentLocation];
    }
    else 
        reqType = 2;
	[self syncOnThreadAction:TRUE];
	//[self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:5.0];
}


- (void)doneLoadingTableViewData{
	//  model should call this when its done loading
	//self.dataTable.userInteractionEnabled=TRUE;
	[self dataSourceDidFinishLoadingNewData];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{	
	
    
	if (scrollView.isDragging) {
		float endOfTable = [self endOfTableView:scrollView];
        if (refreshFooterView.state == EGOOPullRefreshPulling && endOfTable < 0.0f && endOfTable > -65.0f && !_reloading) {
			[refreshFooterView setState:EGOOPullRefreshNormal];
		} else if (refreshFooterView.state == EGOOPullRefreshNormal && endOfTable < -65.0f && !_reloading) {
			[refreshFooterView setState:EGOOPullRefreshPulling];
		}
        
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	
	if (!decelerate)
	{
        [self loadImagesForOnscreenRows];
    }
	/*
     if (scrollView.contentOffset.y <= - 65.0f && !_reloading) {
     _reloading = YES;
     [self reloadTableViewDataSource];
     [UIView beginAnimations:nil context:NULL];
     [UIView setAnimationDuration:0.2];
     self.dataTable.contentInset = UIEdgeInsetsMake(60.0f, 0.0f, 0.0f, 0.0f);
     [UIView commitAnimations];
     }*/
    
    if ([self endOfTableView:scrollView] <= -65.0f && !_reloading && [dataArray count] > 0) {
        _reloading = YES;
        [self reloadTableViewDataSource];
        [refreshFooterView setState:EGOOPullRefreshLoading];
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.2];
        self.dataTable.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, 60.0f, 0.0f);
        [UIView commitAnimations];
	}
}

- (void)dataSourceDidFinishLoadingNewData{
	
	_reloading = NO;
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:.3];
	[self.dataTable setContentInset:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
	[UIView commitAnimations];
	
    if ([refreshFooterView state] != EGOOPullRefreshNormal) {
        [refreshFooterView setState:EGOOPullRefreshNormal];
        [refreshFooterView setCurrentDate];  //  should check if data reload was successful 
    }
}

- (float)tableViewHeight {
    // calculate height of table view (modify for multiple sections)
	float result  = 0.0f;
	for(int i = 0; i < [tableHeightArray count] ; i++)
	{
		NSString *value = [tableHeightArray objectAtIndex:i];
		result += [value intValue];
	}
    // NSLog(@"Result is %f",result);
	return result;
    
}
- (void)repositionRefreshHeaderView {
    refreshFooterView.center = CGPointMake(160.0f, [self tableViewHeight] + 300.0f);
}

- (float)endOfTableView:(UIScrollView *)scrollView {
	//NSLog(@"%0.2f,%0.2f,%0.2f",[self tableViewHeight],scrollView.bounds.size.height,scrollView.bounds.origin.y);
    return [self tableViewHeight] - scrollView.bounds.size.height - scrollView.bounds.origin.y;
}

#pragma mark GPXPointDelegate
-(void) newGPXPoints:(NSNumber*)_boolValue:(CLLocation *)_newlocation
{
    if([_boolValue boolValue])
    {
        self.currentLocation = _newlocation;
        [commonUsedMethods setIsRefreshData:YES];
        reqType = 6;
        [self syncOnThreadAction:NO];
        [[SingletonClass sharedInstance] setMyCurrentLocation:self.currentLocation];
    }
    else
    {
        
        [overlay dismiss];
        overlay.delegate=nil;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" 
                                                        message:@"Either location service is disable or issue in recognizing your location"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK" 
                                              otherButtonTitles: nil];
        
        [alert show];
        [alert release];
    }
    
}

#pragma mark -
#pragma mark Table cell image support

- (void)startIconDownload:(NSString *)_url:(NSIndexPath *)indexpath:(int)_key
{
	if([_url length] == 0)
        return ;
    NSMutableDictionary *Info = [[NSMutableDictionary alloc] init];
    [Info setObject:indexpath forKey:@"IndexPath"];
    [Info setObject:[NSString stringWithFormat:@"%d",_key] forKey:@"key"];
    [Info setObject:_url forKey:@"url"];
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    // Start an async download
    [manager downloadWithURL:[NSURL URLWithString:_url] delegate:self:Info];
    [Info release];
    
}
// this method is used in case the user scrolled into a set of cells that don't have their app icons yet
- (void)loadImagesForOnscreenRows
{
    [imageCaches clearMemory];
    NSLog(@"on screen cell image reloading");
	NSArray *visiblePaths = [self.dataTable indexPathsForVisibleRows];
	for (NSIndexPath *indexPath in visiblePaths)
	{
//        int start = indexPath.row*24;
//        int count = (indexPath.row+1)*24;
        for(int i = 0;i < [dataArray count];i++)
        {
            PhotoData *photodata = [dataArray objectAtIndex:i];
            if(![imageCaches imageFromKey:photodata.thumbnail.url])
            {
                [self startIconDownload:photodata.thumbnail.url:indexPath:[photodata.iden intValue]];
            }
        }
        
	}
    
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
	CLLocation *location = [[SingletonClass sharedInstance] getMyCurrentLocation];
    NSLog(@"%@",location);
    if(location.coordinate.latitude != 0 && location.coordinate.longitude != 0)
        [self loadImagesForOnscreenRows];
    
}

// called by our ImageDownloader when an icon is ready to be displayed
#pragma mark delegate method of Image download
- (void)webImageManager:(UIImage *)image didFinishWithImage2:(NSMutableDictionary *)userInfo
{	
    int _key = -1;
    NSLog(@"%@",userInfo);
    if([userInfo valueForKey:@"key"])
        _key= [[userInfo valueForKey:@"key"] intValue];
    if([userInfo valueForKey:@"url"])
    {
       image = [image resizedImageWithContentMode:UIViewContentModeScaleAspectFill bounds:CGSizeMake(75.0f, 75.0f) interpolationQuality:kCGInterpolationDefault];
         [[SDImageCache sharedImageCache] storeImage:image imageData:UIImagePNGRepresentation(image) forKey:[userInfo valueForKey:@"url"] toDisk:YES];
    }
    
    if([userInfo valueForKey:@"IndexPath"])
    {	
        NSIndexPath *indexPath = [userInfo valueForKey:@"IndexPath"];
        //  if(_key == 0) 
        // {
        UITableViewCell *cell = (UITableViewCell *) [self.dataTable cellForRowAtIndexPath:indexPath];
        for (UIView *view in cell.contentView.subviews){
			if([view isKindOfClass:[UIButton class]])
			{
				UIButton *button = (UIButton *)view;
				if( _key == button.tag)
                {
                    [button setContentMode:UIViewContentModeScaleAspectFit];
                    UIImage *buttonImage =[imageCaches imageFromKey:[userInfo valueForKey:@"url"]];
                    buttonImage =[ImageManipulator scaleImage:buttonImage:button.frame.size];
                    //   buttonImage =[ImageManipulator makeRoundCornerImage:buttonImage:8:8];
                    [button setImage:buttonImage forState:UIControlStateNormal];
                }
            }
		}
    }
}
-(IBAction) profileButtonPressed:(id)sender
{
    UIButton *button = (UIButton *)sender;
    Iden = button.tag;
    reqType = 3;
    [self syncOnThreadAction:FALSE];
    
}
-(IBAction) plusButtonPressed:(id)sender
{
    UIButton *button = (UIButton *)sender;
    Iden = button.tag;
    reqType = 4;
    [self syncOnThreadAction:FALSE];
    
}
-(IBAction) negativeButtonPressed:(id)sender
{
    UIButton *button = (UIButton *)sender;
    Iden = button.tag;
    reqType = 5;
    [self syncOnThreadAction:FALSE];
    
}
-(IBAction) viewDetailButtonPressed:(id)sender
{
    UIButton *button = (UIButton *)sender;
    
    photoDetailViewController *PDVC = [[photoDetailViewController alloc] initWithNibName:@"photoDetailViewController" bundle:nil withPhoto:[dataArray objectAtIndex:button.tag]];
    [self.navigationController pushViewController:PDVC animated:YES];
    [PDVC release];
    
}

-(void) reloadTableData
{
	[tableHeightArray removeAllObjects];
	[self getFeedDataArray];
    [refreshFooterView setState:EGOOPullRefreshNormal];
    if(dataArray && [dataArray count] > 0)
    {
        // self.dataTable.tableHeaderView = nil;    
        [self.dataTable reloadData];
        [self addPullViewAtBottom];
    }
    else
    {
        [self.dataTable reloadData];
        //  self.dataTable.tableHeaderView = self.emptyListView; 
        [self addPullViewAtBottom];
    }
    
}
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
/*
 - (void)enableCancelButton:(UISearchBar *)aSearchBar {
 for (id subview in [aSearchBar subviews]) {
 if ([subview isKindOfClass:[UIButton class]]) {
 [subview setEnabled:TRUE];
 }
 }  
 }
 
 - (void)searchBarTextDidEndEditing:(UISearchBar *)aSearchBar {
 [aSearchBar resignFirstResponder];
 [self performSelector:@selector(enableCancelButton:) withObject:aSearchBar afterDelay:0.0];
 }
 */
// called when text starts editing
/*
 - (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
 {
 searching = FALSE;
 NSLog(@"Search bar cancel button pressed ");
 [self.toolBar setFrame:self.searchbar.frame];
 searchBar.text=@"";
 [self.searchbar removeFromSuperview];
 [self.view addSubview:self.toolBar];
 reqType = segmentControl.selectedSegmentIndex;
 [self getFeedDataArray:reqType+1];
 [self reloadTableData];
 }
 
 - (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
 {
 NSLog(@"%@",searchBar.text);
 if([[commonUsedMethods trimString:searchBar.text] length] > 0)
 {
 searching = TRUE;
 reqType = 4;
 [self syncOnThreadAction:FALSE];
 }
 [searchBar resignFirstResponder];
 }
 */
#pragma mark commentDelegate
-(void) viewUserProfile:(NSNumber*)_userIden
{
	//NSLog(@"viewUserProfile delegate; %d ",[_userIden intValue]);
	reqType = 5;
	Iden = [_userIden intValue];
	[self syncOnThreadAction:FALSE];
}
#pragma mark addCommentD
-(void) commentHasAdded:(NSString *)_string:(NSNumber *)_iden
{
    
}
-(void) viewAllComment:(NSNumber*)photoIden
{
}

-(void) syncOnThreadAction:(BOOL)_isPull
{
    [commonUsedMethods setIsRefreshData:NO];
	overlay = [[SingletonClass sharedInstance] getOverlay];
	[overlay setDelegate:self];
    if(reqType == 0 || reqType == 6)
    {
        //[overlay getFeedData:[requestStringURLs getUserFeedRequest:_isPull]:_isPull];
        // if(isLocation)
        if(reqType == 6)
            [commonUsedMethods setIsRefreshData:YES];
        [overlay getNearByData:[requestStringURLs getUserNearByRequest:self.currentLocation :_isPull :feedOffset] :_isPull];
        //        else
        //            [self performSelector:@selector(LoadViewAgain:) withObject:[NSNumber numberWithBool:_isPull] afterDelay:6.0];
    }
    else if(reqType == 2)
        [overlay getUserSearchData:[requestStringURLs getUserSearchRequest:searchbar.text:_isPull]:_isPull];
    else if(reqType == 3)
        [overlay getUserProfileData:[requestStringURLs getUserProfileRequest:[NSNumber numberWithInt:Iden]:24 :0]:_isPull :NO];
    else if(reqType == 4)
    {
        [overlay setUserLikeRequest:[requestStringURLs getUserSupportRequest:[NSNumber numberWithInt:Iden]:TRUE]];
    }
    else if(reqType == 5)
    {
        [overlay setUserLikeRequest:[requestStringURLs getUserSupportRequest:[NSNumber numberWithInt:Iden]:FALSE]];
    }
    
}

//-(void)LoadViewAgain:(NSNumber *)_isPull
//{
//    [overlay getNearByData:[requestStringURLs getUserNearByRequest:self.currentLocation :[_isPull boolValue]] :[_isPull boolValue]];
//}

#pragma mark ParserProtocolDelegate
-(void) loginResponse:(NSNumber *)_value
{
	[overlay dismiss];
	if([_value intValue] == 1)
	{
		if(reqType == 2)
        {
            
            //[self reloadTableData];
        }
		else if (reqType == 7)
			[self callNewView];
        
	}
	
	else {
		// TO DO
	}
}
-(void) hasPullNewData:(NSMutableArray *)_array
{
    [overlay dismiss];
    if(reqType == 1)
    {
        [self getFeedDataArray];
    }
    else if(reqType == 2)
    {
        [self getFeedDataArray];
    }
    
    [self reloadTableData];
    [self doneLoadingTableViewData];
    
}
-(void) errorResponseData:(NSDictionary *)_dictionary
{
	[overlay dismissError];
    [AppDelegate showAlertView:[_dictionary valueForKey:@"message"]];
}

-(void) userFeedData:(NSDictionary *)_dictionary
{
	[overlay dismiss];
    if([_dictionary valueForKey:@"status"] && [[_dictionary valueForKey:@"status"] isEqualToString:@"OK"])
    {
        if(reqType == 4)
        {
            if(!searching)
            {
                [commonUsedMethods updateLikeProperty:feedData.photoArray:Iden:TRUE];
                [self reloadTableData];
            }
            else if(searching)
            {
                [commonUsedMethods updateLikeProperty:serachFeed.photoArray:Iden:TRUE];
                [self reloadTableData];
            }
        }
        else if(reqType == 5)
        {
            if(!searching)
            {
                [commonUsedMethods updateLikeProperty:feedData.photoArray:Iden:FALSE];
                [self reloadTableData];
            }
            else if(searching)
            {
                [commonUsedMethods updateLikeProperty:serachFeed.photoArray:Iden:FALSE];
                [self reloadTableData];
            }
            
        }
        
    } 
	else  if([_dictionary valueForKey:@"status"] && [[_dictionary valueForKey:@"status"] isEqualToString:@"ERROR"])
    {
        NSMutableDictionary *errorDic = [[_dictionary valueForKey:@"errors"] objectAtIndex:0];
        [AppDelegate showAlertView:[errorDic valueForKey:@"message"]];
        
        
    }
}
-(void) ParserArraylist:(NSMutableArray *) _array
{
    [overlay dismiss]; 
    if (reqType == 2)
    {
        //self.serachFeed = [_array objectAtIndex:0];
        self.serachFeed= [[DataModel getDataInDictionary:2] objectAtIndex:0];
        dataArray = self.serachFeed.photoArray;
        
        [self reloadTableData];
        
        
    }
    else if (reqType == 3)
    {
        profileViewController *PVC = [[profileViewController alloc] initWithNibName:@"profileViewController" bundle:nil withUser:[_array objectAtIndex:0]];
        [self.navigationController pushViewController:PVC animated:YES];
        [PVC release];
    }
    else if(reqType == 0 || reqType == 6)
    {
        //[self getFeedDataArray];
        [commonUsedMethods setIsRefreshData:NO];
        [self reloadTableData];
        [self doneLoadingTableViewData];
    }
}
#pragma mark clientProtocolDelegate

-(void) notfiyResponse:(NSNumber *)_value
{
	
	[overlay dismissError];
	[AppDelegate showAlertView:@"Internet Connection not available"];
	[self dataSourceDidFinishLoadingNewData];
	
	
}

-(void) callNewView
{
	
    
}

- (void)dealloc {
    [dataTable release];
    [imageDownloadsInProgress release];
    [tableHeaderView release];
	[searchbar release];
	[dataArray release];
    [emptyListView release];
    [feedData release];
    [serachFeed release];
    [super dealloc];
}



@end
