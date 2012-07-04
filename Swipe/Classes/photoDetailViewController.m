//
//  HomeScreenViewController.m
//  show
//
//  Created by svp on 01/11/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "photoDetailViewController.h"
#import "headerfiles.h"
#import "profileViewCell.h"
#import "domainClasses.h"
#import "feedCommentCell.h"
#import "feedCommentView.h"
#import "addCommentViewController.h"
#import "commitDetailViewController.h"
#import "profileViewController.h"
#import "commentDetailCell.h"
#import "mapViewController.h"
#import "NSAttributedString+Attributes.h"

#import "ShareOnSocialViewController.h"
#import "NSData+Base64.h"
#import "ASIHTTPRequest.h"
#import "ASINetworkQueue.h"
#import "UIImage+Resize.h"

@interface photoDetailViewController (Private)
-(void) setMasterTableDisplay:(profileViewCell *)cell:(NSIndexPath *)indexPath;
-(void) showSupporterView:(UIView *)_sView:(NSMutableArray *)_supporterArray:(NSIndexPath *)indexPath;
@end


@implementation photoDetailViewController
@synthesize dataTable;
@synthesize tableHeaderView;
@synthesize userProfileImage,petImage;
@synthesize Iden;
@synthesize photodata;
@synthesize userName;
@synthesize tokeninfo;
@synthesize imgToSend;
@synthesize strFlagForReview;
@synthesize myTextField;
@synthesize imgData;
@synthesize delegate;
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withPhoto:(PhotoData *)_photodata  {
 if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
 // Custom initialization
            self.photodata   = _photodata;
 }
 return self;
 }
 


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	//self.title =  @"Detail";
    downloadQueue = [[ASINetworkQueue alloc] init];
    tokeninfo = [[SingletonClass sharedInstance] getTokenInformation];
    isCommentAdded = NO;
    self.imgData = [[NSData alloc] init];
    
//    UINavigationItem *item = [self.navigationController.navigationBar.items objectAtIndex:0];
    UINavigationItem *item = self.navigationItem;
    item.titleView =  [commonUsedMethods navigationlogoView];
    
    item.leftBarButtonItem = [commonUsedMethods navigationButtonWithText:@"Back":TRUE];
    UIButton* rightButton = (UIButton*)item.leftBarButtonItem.customView;
    [rightButton addTarget:self action:@selector(backButtonMethod) forControlEvents:UIControlEventTouchUpInside];
    
       
}

-(void) backButtonMethod
{
    //overlay.delegate = nil;
    [self removeAllCacheImagesFromMemory];
    [self.navigationController popViewControllerAnimated:YES];
}    
    
-(void) removeAllCacheImagesFromMemory
{
    [imageCaches removeImageFromMemoryWithKey:self.photodata.user.imgURL];
    [imageCaches removeImageFromMemoryWithKey:self.photodata.lowResolution.url];
    for(int i=0;i<[photodata.commentArray count];i++)
    {
        CommentsData *obj = [photodata.commentArray objectAtIndex:i];
        [imageCaches removeImageFromMemoryWithKey:obj.user.imgURL];
    }
}
    
-(void) SetDetailItem:(PhotoData *)_photodata
{
		self.photodata		= _photodata;
        [self.dataTable reloadData];
}

-(void)viewWillAppear:(BOOL)animated 
{
    [super viewWillAppear:animated];
	[self.navigationController setNavigationBarHidden:NO];
	[self.dataTable scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
    [self.dataTable reloadData];
		
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    downloadQueue.requestDidFinishSelector =nil;
    downloadQueue.requestDidFailSelector = nil;
    [downloadQueue cancelAllOperations];
	downloadQueue.delegate = nil;
    
}
#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
     	 
    return 1+[photodata.commentArray count];	
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath  {
    
    if(indexPath.row == 0)
    {
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
    else
    {
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
        cell.selectionStyle=0;
        return cell;
        
    }
return 0;
}

-(void) setMasterTableDisplay:(profileViewCell *)cell:(NSIndexPath *)indexPath
{
    cell.smallImg.image=nil;
    cell.bigImg.image = nil;
    [cell.profileButton setImage:nil forState:UIControlStateNormal];
    [cell.profileButton setContentMode:UIViewContentModeScaleAspectFit];
    [cell.profileButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
     cell.profileButton.tag = 1;
    [cell.mapButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
     cell.mapButton.tag = 2;
    [cell.increaseButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
     cell.increaseButton.tag = 3;
    [cell.increaseButton setBackgroundImage:[UIImage imageNamed:@"plus_pressed.png"] forState:UIControlStateSelected];
     [cell.decreaseButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
     cell.decreaseButton.tag = 4;
    [cell.decreaseButton setBackgroundImage:[UIImage imageNamed:@"minus_pressed.png"] forState:UIControlStateSelected];
     [cell.addComments addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
      cell.addComments.tag = 5;
    
    [cell.btnPhotoOption addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    cell.btnPhotoOption.tag = 6;
    
    [cell.counterLabel setText:[NSString stringWithFormat:@"%d",[photodata.supporters intValue]]];
    if(photodata.user.imgURL && [photodata.user.imgURL length] > 0)
    {
        if (![imageCaches imageFromKey:photodata.user.imgURL])
        {
            
            UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(8, 8, 20, 20)];
            [activityIndicator startAnimating];
            activityIndicator.activityIndicatorViewStyle= UIActivityIndicatorViewStyleGray;
            [cell.profileButton addSubview:activityIndicator];
            [activityIndicator release];
            [self startIconDownload:photodata.user.imgURL:indexPath:1];
            
            

            
        }
        else
        {
            cell.profileButton.enabled=TRUE;
            [cell.profileButton setBackgroundImage:[imageCaches imageFromKey:photodata.user.imgURL] forState:UIControlStateNormal];
        }
    }
    else
    {    cell.profileButton.enabled=TRUE;  
        [cell.profileButton setImage:[Font_size getPersonShahowImage] forState:UIControlStateNormal];
    }
    cell.commentCouneterLabel.text = [NSString stringWithFormat:@"Comments: %d",[photodata.commentArray count]];
    NSString *str = @""; 
    NSLog(@"location : %@ : %@",photodata.location.locName,photodata.location.locationName);
    if(photodata.title)
        str = [str stringByAppendingFormat:@"%@",photodata.title];
    if([photodata.location.locName length] > 0)
        str = [str stringByAppendingFormat:@" trending in %@",photodata.location.locName];
    if(photodata.desc)
        str = [str stringByAppendingFormat:@"\n%@",photodata.desc];
    if(photodata.createdDate)
        str = [str stringByAppendingFormat:@"\nposted %@",[commonUsedMethods timeIntervalWithStartDate:photodata.createdDate]];
    if(photodata.user.userName)
        str = [str stringByAppendingFormat:@" by %@",photodata.user.userName];
    
   	NSMutableAttributedString* attrStr = [NSMutableAttributedString attributedStringWithString:str];

	[attrStr setFont:[UIFont systemFontOfSize:12]];
	[attrStr setTextColor:[UIColor lightGrayColor]];
    NSLog(@"%@",str);
    if(photodata.title)
    {
    [attrStr setTextColor:[commonUsedMethods getNavTintColor]  range:[str rangeOfString:photodata.title options:0 range:NSMakeRange(0,[str length])]];
    [attrStr setFont:[UIFont boldSystemFontOfSize:15]  range:[str rangeOfString:photodata.title options:0 range:NSMakeRange(0,[str length])]];
    }
    if([photodata.location.locName length] > 0)
    {
        [attrStr setTextColor:[commonUsedMethods getNavTintColor]  range:[str rangeOfString:photodata.location.locName options:0 range:NSMakeRange(0,[str length])]];
        [attrStr setFont:[UIFont boldSystemFontOfSize:15]  range:[str rangeOfString:photodata.location.locName options:0 range:NSMakeRange(0,[str length])]];
    }
    if(photodata.desc)
    {
    [attrStr setTextColor:[UIColor darkGrayColor]  range:[str rangeOfString:photodata.desc options:0 range:NSMakeRange(0,[str length])]];
    [attrStr setFont:[UIFont systemFontOfSize:13]  range:[str rangeOfString:photodata.desc options:0 range:NSMakeRange(0,[str length])]];
    }
    if(photodata.user.userName)
    {
	[attrStr setTextColor:[commonUsedMethods getNavTintColor1]  range:[str rangeOfString:photodata.user.userName options:0 range:NSMakeRange(0,[str length])]];
     [attrStr setFont:[UIFont boldSystemFontOfSize:12]  range:[str rangeOfString:photodata.user.userName options:0 range:NSMakeRange(0,[str length])]];
    }
    cell.label1.attributedText = attrStr;
    cell.bigImg.tag = 2;
	if (![imageCaches imageFromKey:photodata.lowResolution.url])
	{
        /*
        UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake((cell.bigImg.frame.size.width/2)-10, (cell.bigImg.frame.size.height/2)-10, 20, 20)];
        [activityIndicator startAnimating];
        activityIndicator.activityIndicatorViewStyle= UIActivityIndicatorViewStyleGray;
        [cell.bigImg addSubview:activityIndicator];
        [activityIndicator release];
        [self startIconDownload:photodata.lowResolution.url:indexPath:cell.bigImg.tag];
         */
        
        cell.progressView.hidden = NO;
        if ([cell.progressView respondsToSelector:@selector(setProgressTintColor:)])
        {
            [cell.progressView setProgressTintColor:[commonUsedMethods getNavTintColor]] ;//= [commonUsedMethods getNavTintColor];
        }
        
        //cell.progressView.progressTintColor = [commonUsedMethods getNavTintColor];
        //[cell.bigImg addSubview:progressView];
        cell.progressView.progress = 0.0;
        NSURL *url = [NSURL URLWithString:photodata.lowResolution.url];
        
        // Somehow, updating the progress view cannot be properly done
        // without a queue (thread issues?), so here we use a local
        // queue which updates the UIProgressView instance.
        ASIHTTPRequest *request = [[[ASIHTTPRequest alloc] initWithURL:url] autorelease];
        [downloadQueue setDelegate:self];
        [downloadQueue setRequestDidFinishSelector:@selector(requestDone:)];
        [downloadQueue setRequestDidFailSelector:@selector(requestWentWrong:)];
        [downloadQueue setShowAccurateProgress:YES];
        [downloadQueue setDownloadProgressDelegate:cell.progressView];
        [downloadQueue addOperation:request];
        [downloadQueue go];
	}
	else
	{
        cell.progressView.hidden = YES;
        [cell.bigImg setImage:[imageCaches imageFromKey:photodata.lowResolution.url]];
        self.imgData = UIImagePNGRepresentation([imageCaches imageFromKey:photodata.lowResolution.url]);
	}
    [Font_size dropShahdowToButton:cell.profileButton];
    [Font_size dropShahdowToImageView:cell.bigImg];
     cell.backgroundColor = [Font_size cellBackgroundColor];
    
    cell.selectionStyle=0;
}
-(void) setChildTableDisplay:(commentDetailCell *)cell:(NSIndexPath *)indexPath
{
    [commonUsedMethods removeActivityFromView:cell.userButton.subviews];
    [cell.userButton setImage:nil forState:UIControlStateNormal];
    CommentsData *obj = [photodata.commentArray objectAtIndex:indexPath.row-1];
    NSString *str = @""; 
    if(obj.textData)
        str = [str stringByAppendingFormat:@"%@",obj.textData];
    if(obj.createdDate)
        str = [str stringByAppendingFormat:@"\n\nposted %@",[commonUsedMethods timeIntervalWithStartDate:obj.createdDate]];
    if(photodata.user.userName)
        str = [str stringByAppendingFormat:@" by %@",obj.user.userName];
   	NSMutableAttributedString* attrStr = [NSMutableAttributedString attributedStringWithString:str];
	[attrStr setFont:[UIFont systemFontOfSize:12]];
	[attrStr setTextColor:[UIColor lightGrayColor]];
   
    if(obj.textData)
    {
	[attrStr setTextColor:[UIColor darkGrayColor]  range:[str rangeOfString:obj.textData options:0 range:NSMakeRange(0,[str length])]];
    [attrStr setFont:[UIFont systemFontOfSize:13]  range:[str rangeOfString:obj.textData options:0 range:NSMakeRange(0,[str length])]];
    }
    if(obj.user.userName )
    {
    [attrStr setTextColor:[commonUsedMethods getNavTintColor1]  range:[str rangeOfString:obj.user.userName options:0 range:NSMakeRange(0,[str length])]];
     [attrStr setFont:[UIFont boldSystemFontOfSize:12]  range:[str rangeOfString:obj.user.userName options:0 range:NSMakeRange(0,[str length])]];
    }
  
	cell.label1.attributedText = attrStr;
    
    
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
    [cell.userButton setContentMode:UIViewContentModeScaleToFill];
    [Font_size dropShahdowToButton:cell.userButton];
   	
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
            if (![imageCaches imageFromKey:obj.user.imgURL])
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
                [button setImage:[imageCaches imageFromKey:obj.user.imgURL] forState:UIControlStateNormal];
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
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	// TO DO	
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
	if(indexPath.row == 0)
    {
    int height = 365;
    //int cellHeight = [Font_size feedCommentCellHeight:photodata];
    return  height;
    }
    else
    {
         return 100;
    }
    return 0;
}
#pragma mark -
#pragma mark Table cell image support

- (void)startIconDownload:(NSString *)_url:(NSIndexPath *)indexpath:(int)_key
{
	if([_url length] == 0)
        return;
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
	
	
	NSArray *visiblePaths = [self.dataTable indexPathsForVisibleRows];
	for (NSIndexPath *indexPath in visiblePaths)
	{
		
			if (![imageCaches imageFromKey:photodata.user.imgURL])
			{
				[self startIconDownload:photodata.user.imgURL:indexPath:1];
			}
			if (![imageCaches imageFromKey:photodata.lowResolution.url])
			{
				[self startIconDownload:photodata.lowResolution.url:indexPath:2];
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
	
	[self loadImagesForOnscreenRows];
}

// called by our ImageDownloader when an icon is ready to be displayed
#pragma mark delegate method of Image download
- (void)webImageManager:(UIImage *)image didFinishWithImage2:(NSMutableDictionary *)userInfo
{	
   // int _key = -1;
    NSLog(@"%@",userInfo);
   // if([userInfo valueForKey:@"key"])
   //     _key= [[userInfo valueForKey:@"key"] intValue];
   // if([userInfo valueForKey:@"url"])
   //     [[SDImageCache sharedImageCache] storeImage:image imageData:UIImageJPEGRepresentation(image, 1.0) forKey:[userInfo valueForKey:@"url"] toDisk:YES];
    
    if([userInfo valueForKey:@"IndexPath"])
    {
        NSIndexPath * indexPath = [userInfo valueForKey:@"IndexPath"];
       if(indexPath.row == 0)
       {
        profileViewCell *cell = (profileViewCell *) [self.dataTable cellForRowAtIndexPath:indexPath];
        if([[userInfo valueForKey:@"key"] isEqualToString: @"1"])
        {
            for (UIView *view2 in cell.profileButton.subviews)
            {
                if([view2 isKindOfClass:[UIActivityIndicatorView class]])
                    [view2 removeFromSuperview];
            }
            image = [image resizedImageWithContentMode:UIViewContentModeScaleAspectFill bounds:CGSizeMake(75.0f, 75.0f) interpolationQuality:kCGInterpolationDefault];
            [[SDImageCache sharedImageCache] storeImage:image imageData:UIImagePNGRepresentation(image) forKey:[userInfo valueForKey:@"url"] toDisk:YES];
            cell.profileButton.enabled=TRUE;
            [cell.profileButton setImage:image forState:UIControlStateNormal];
            
            
        }
			else if([[userInfo valueForKey:@"key"] isEqualToString: @"2"])
			{
                for (UIView *view2 in cell.bigImg.subviews)
                {
                    if([view2 isKindOfClass:[UIActivityIndicatorView class]])
                        [view2 removeFromSuperview];
                }
                image = [image resizedImageWithContentMode:UIViewContentModeScaleAspectFill bounds:CGSizeMake(250.0f, 210.0f) interpolationQuality:kCGInterpolationDefault];
                [[SDImageCache sharedImageCache] storeImage:image imageData:UIImagePNGRepresentation(image) forKey:[userInfo valueForKey:@"url"] toDisk:YES];
                [cell.bigImg setImage:image];
                self.imgData = UIImagePNGRepresentation(image);
                self.imgToSend = image;
			}
       }
       else
       {
           commentDetailCell *cell = (commentDetailCell *) [self.dataTable cellForRowAtIndexPath:indexPath];
           UIImage *buttonImage =image;
           buttonImage =[ImageManipulator scaleImage:buttonImage:cell.userButton.frame.size];
           buttonImage =[ImageManipulator makeRoundCornerImage:buttonImage:5:5];
           [cell.userButton setImage:buttonImage forState:UIControlStateNormal];
           [commonUsedMethods removeActivityFromView:cell.userButton.subviews];
           
       }
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
-(IBAction) buttonPressed:(id)sender
{
	UIButton *button = (UIButton *)sender;
    if(button.tag == 1)
    {
        reqType = 1;
        Iden = photodata.user.iden;//[NSNumber numberWithInt:photodata.user.iden];
         [self syncOnThreadAction];
    }
    else  if(button.tag == 2)
    {
        mapViewController *MVC = [[mapViewController alloc] initWithNibName:@"mapViewController"  bundle:nil withPost:self.photodata];
        [self.navigationController pushViewController:MVC animated:NO];
        [MVC release];
    }
    else  if(button.tag == 3)
    {
        reqType = 3;
        [self syncOnThreadAction];
    }
    else  if(button.tag == 4)
    {
        reqType = 4;
        [self syncOnThreadAction];
    }
    else  if(button.tag == 5)
    {
        isCommentAdded = NO;
        addCommentViewController *ACVC1 = [[addCommentViewController alloc] initWithNibName:@"addCommentViewController"  bundle:nil withDelegate:self photo:[photodata.iden intValue]];
        [self.navigationController pushViewController:ACVC1 animated:NO];
        [ACVC1 release];
    }
    else if(button.tag == 6)
    {
        
        
       
        if([tokeninfo.iden intValue] == [photodata.user.iden intValue])
        {
            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Photo Options" 
                                                                     delegate:self 
                                                            cancelButtonTitle:@"Cancel" 
                                                       destructiveButtonTitle:@"Delete" 
                                                            otherButtonTitles:@"Share",@"Email Photo", nil];
            
            actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
            [actionSheet showFromTabBar:self.tabBarController.tabBar];
        }
        else
        {
            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Photo Options" 
                                                                     delegate:self 
                                                            cancelButtonTitle:@"Cancel" 
                                                       destructiveButtonTitle:@"Flag for Review" 
                                                            otherButtonTitles:nil];
            
            actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
            [actionSheet showFromTabBar:self.tabBarController.tabBar];
        }
        
        
    }
    
   
}

-(IBAction) userProfileViewPressed:(id)sender
{
	UIButton *button = (UIButton *)sender;
    reqType = 1;
    Iden = [NSNumber numberWithInt:button.tag];
    [self syncOnThreadAction];
    
}

-(IBAction) likeButtonPressed:(id)sender
{
	reqType = 2;
	[self syncOnThreadAction];
	
}
-(IBAction) commentButtonPressed:(id)sender
{
   
	
}

-(void) syncOnThreadAction
{
	
     overlay = [[SingletonClass sharedInstance] getOverlay];
	 [overlay setDelegate:self];
    if(reqType == 1)
        [overlay getUserProfileData:[requestStringURLs getUserProfileRequest:Iden:24 :0]:FALSE :NO];
    else if(reqType == 3)
        [overlay setUserLikeRequest:[requestStringURLs getUserSupportRequest:photodata.iden:TRUE]];
    else if(reqType == 4)
        [overlay setUserLikeRequest:[requestStringURLs getUserSupportRequest:photodata.iden:FALSE]];
   else if(reqType == 5)
       [overlay getUserPostDeleteRequest:[self DeletePhotoRequest]];
    else if(reqType == 6)
        [overlay getUserPostFlagRequest:[self FlagPhotoRequest]];

}


-(NSString *)DeletePhotoRequest
{
    //tokeInfo *tokeninfo = [[SingletonClass sharedInstance] getTokenInformation];
    NSMutableString *url = [[[NSMutableString alloc] init] autorelease];
    [url setString:kServerIp];
    
	[url appendString:@"/posts/delete?"];
    [url appendString:[NSString stringWithFormat:@"access_token=%@",tokeninfo.accessToken]];
    [url appendString:[NSString stringWithFormat:@"&postid=%d",[photodata.iden intValue]]]; 
    //[url appendString:[NSString stringWithFormat:@"&reason=%@",self.strFlagForReview]]; 
    url = [[url stringByReplacingOccurrencesOfString:@" " withString:@"%20"] mutableCopy];
    NSLog(@"%@",url);
    return url;
    
}

-(NSString *)FlagPhotoRequest
{
    
    //tokeInfo *tokeninfo = [[SingletonClass sharedInstance] getTokenInformation];
    NSMutableString *url = [[[NSMutableString alloc] init] autorelease];
    [url setString:kServerIp];
    
	[url appendString:@"/posts/flag?"];
    [url appendString:[NSString stringWithFormat:@"access_token=%@",tokeninfo.accessToken]];
    [url appendString:[NSString stringWithFormat:@"&postid=%d",[photodata.iden intValue]]]; 
    [url appendString:[NSString stringWithFormat:@"&reason=%@",self.strFlagForReview]]; 
    url = [[url stringByReplacingOccurrencesOfString:@" " withString:@"%20"] mutableCopy];
    NSLog(@"%@",url);
    return url;
    
    
}

#pragma mark UIActionSheet Delegate

-(void)actionSheet:(UIActionSheet *)actionSheet1 clickedButtonAtIndex:(NSInteger)buttonIndex 
{
   
    
    if([tokeninfo.iden intValue] == [photodata.user.iden intValue])
    {
        if (buttonIndex == 0) 
        {
            NSLog(@"Destructive Button Clicked") ;
            // need to add delete functionality 
            UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Confirm Deletion" message:@"Delete this photo?" delegate:self cancelButtonTitle:@"Don't delete" otherButtonTitles:@"Delete", nil];
            myAlertView.tag = 0;
            [myAlertView show];
            [myAlertView release];

        }
        else if (buttonIndex == 1) 
        {
            NSLog(@"Share Button Clicked");
            ShareOnSocialViewController *svc = [[ShareOnSocialViewController alloc] initWithNibName:@"ShareOnSocialViewController" bundle:nil withPhotoData:photodata];
            [self.navigationController pushViewController:svc animated:YES];
        }
        else if (buttonIndex == 2) 
        {
            NSLog(@"Email photo Button Clicked");
           Class mailClass = (NSClassFromString(@"MFMailComposeViewController")); 
           if(mailClass)
           {
               MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
               picker.mailComposeDelegate = self;
               [picker addAttachmentData:self.imgData mimeType:@"image/png" fileName:@""];
               // Fill out the email body text
               NSString *emailBody = @"";
               [picker setMessageBody:emailBody isHTML:NO];
               [self presentModalViewController:picker animated:YES];
               [picker release];
           }
            else
            {
                [self launchMailAppOnDevice];
            }
            
        }
        else if (buttonIndex == 3) 
        {
            NSLog(@"Cancel Button Clicked");
        }

    }
    else
    {
        if (buttonIndex == 0) 
        {
            NSLog(@"Destructive Button Clicked") ;
            UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Why?" message:@"this gets covered" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
            myTextField = [[UITextField alloc] initWithFrame:CGRectMake(12.0, 45.0, 260.0, 25.0)];
            [myTextField setBackgroundColor:[UIColor whiteColor]];
            myTextField.borderStyle = UITextBorderStyleRoundedRect;
            [myAlertView addSubview:myTextField];
            myAlertView.tag = 1;
            [myAlertView show];
            [myAlertView release];
        }
        else if (buttonIndex == 1) 
        {
            NSLog(@"Cancel Button Clicked");
            
        }
    }
}
-(void)launchMailAppOnDevice
{
    NSString *dataStr = [self.imgData base64EncodingWithLineLength:0];
    
    NSString *body = [@"" stringByAppendingFormat:@"<!DOCTYPE html PUBLIC '-//W3C//DTD HTML 4.01 Transitional//EN' 'http://www.w3.org/TR/html4/loose.dtd'><html><head></head><body><b><img src='data:image/png;base64,%@' alt=' image'/></b></body></html>", dataStr];
    
    NSString *encoded = [body stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *title = [[@"" stringByAppendingFormat:@"title: %@", @"Image "] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString * urlString = [@"" stringByAppendingFormat:@"mailto:?subject=%@&body=%@",title, encoded];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
    
    
    
    
    
//    NSString *email = [NSString stringWithFormat:@"mailto:%@%@", @"info@lobbyFriend.com", @""];
//     email = [email stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:email]];
}

#pragma mark Alert view delegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)
    {
       
        NSLog(@"Cancel pressed");
    }
    else
    {
         NSLog(@"ok pressed");
        if(alertView.tag == 0)
        {
            reqType = 5;
            [self syncOnThreadAction];
        }
        else if(alertView.tag == 1)
        {
            self.strFlagForReview = [[NSString alloc] init];
            self.strFlagForReview = self.myTextField.text;
            reqType = 6;
            [self syncOnThreadAction];
        }
    }
}


#pragma mark MailComposer delegate
// Dismisses the email composition interface when users tap Cancel or Send. Proceeds to update the message field with the result of the operation.
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error 
{	
	
	// Notifies users about errors associated with the interface
	switch (result)
	{
		case MFMailComposeResultCancelled:
			NSLog(@"Result: canceled");
			break;
		case MFMailComposeResultSaved:
            NSLog(@"Result: saved");

			break;
		case MFMailComposeResultSent:
            NSLog(@"Result: sent");

			break;
		case MFMailComposeResultFailed:
            NSLog(@"Result: failed");
			
			break;
		default:
            NSLog(@"Result: not sent");
			
			break;
	}
	[self dismissModalViewControllerAnimated:YES];
}



#pragma mark ParserProtocolDelegate
-(void) loginResponse:(NSNumber *)_value
{
	
	[overlay dismiss];
    if([_value intValue] == 555)
        [AppDelegate showAlertView:@"Post has been sent for review."];
    if([_value intValue] == 333)
    {
        [AppDelegate showAlertView:@"Post has been deleted."];
        if( delegate && [delegate respondsToSelector:@selector(DeletePhotoResponse:)])
        {
            
            [delegate performSelector:@selector(DeletePhotoResponse:) withObject:[NSString stringWithFormat:@"%d",[photodata.iden intValue]]];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}
-(void) ParserArraylist:(NSMutableArray *) _array
{
   [overlay dismiss];
    if (reqType == 1)
    {
           profileViewController  *UPVC1 = [[profileViewController alloc] initWithNibName:@"profileViewController"  bundle:nil withUser:[_array objectAtIndex:0]];
        [self.navigationController pushViewController:UPVC1 animated:NO];
        [UPVC1 release];
    }
    
}

-(void) errorResponseData:(NSDictionary *)_dictionary
{
	[overlay dismissError];
    [AppDelegate showAlertView:[_dictionary valueForKey:@"message"]];
}
#pragma mark clientProtocolDelegate

-(void) notfiyResponse:(NSNumber *)_value
{
	
	[overlay dismissError];
    [AppDelegate showAlertView:@"Unable To Connect To Internet Check Your Internet Connection"];
}
-(void) callNewView
{
	// TO DO
}
#pragma mark commentDelegate
-(void) viewAllComment:(NSNumber*)photoIden
{

		commitDetailViewController *CDVC1 = [[commitDetailViewController alloc] initWithNibName:@"commitDetailViewController"  bundle:nil withPhoto:photodata];
		[self.navigationController pushViewController:CDVC1 animated:NO];
        [CDVC1 release];
}
-(void) viewUserProfile:(NSNumber*)_userIden
{
	NSLog(@"viewUserProfile delegate; %d ",[_userIden intValue]);
	reqType = 1;
    Iden = _userIden;
	[self syncOnThreadAction];
}
-(void) reloadTableData
{
	[self.dataTable reloadData];
}
#pragma mark addCommentD
-(void) commentHasAdded:(NSString *)_string:(NSNumber *)_iden
{
    isCommentAdded = YES;
    [commonUsedMethods updatePhotoCommentProperty:photodata:_string];
    [self.dataTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[self.photodata.commentArray count]-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    [self reloadTableData];
}

-(void) userFeedData:(NSDictionary *)_dictionary
{
	
    [overlay dismiss];
	//reqType = 
    if([_dictionary valueForKey:@"status"] && [[_dictionary valueForKey:@"status"] isEqualToString:@"OK"])
    {
        if(reqType == 3)
            photodata.supporters =  [NSNumber numberWithInt:[photodata.supporters intValue] +1];
        else if(reqType == 4)
             photodata.supporters =  [NSNumber numberWithInt:[photodata.supporters intValue] -1];
        [self reloadTableData];
    } 
	else  if([_dictionary valueForKey:@"status"] && [[_dictionary valueForKey:@"status"] isEqualToString:@"ERROR"])
    {
        NSMutableDictionary *errorDic = [[_dictionary valueForKey:@"errors"] objectAtIndex:0];
        [AppDelegate showAlertView:[errorDic valueForKey:@"message"]];
    }
}

#pragma mark -
#pragma mark ASINetworkQueue delegate methods

- (void)requestDone:(ASIHTTPRequest *)request
{
    NSData *data = [request responseData];
    UIImage *remoteImage = [[UIImage alloc] initWithData:data];
    //[imageCaches storeImage:remoteImage forKey:photodata.lowResolution.url];
    [imageCaches storeImage:remoteImage imageData:UIImageJPEGRepresentation(remoteImage, 1.0) forKey:photodata.lowResolution.url toDisk:YES];
    //progressView.hidden = YES;
    
    profileViewCell *cell = (profileViewCell *) [self.dataTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    cell.progressView.hidden = YES;
    [cell.bigImg setImage:remoteImage];
    self.imgData = UIImagePNGRepresentation(remoteImage);
    self.imgToSend = remoteImage;
    [remoteImage release];
}
- (void)requestWentWrong:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    NSLog(@"%@",error);
}


- (void)dealloc {
    [dataTable release];
    [tableHeaderView release];
    [userProfileImage release];
    [petImage release];
    [userName release];
   // [Iden release];
    [photodata release];
    [downloadQueue release];
    [super dealloc];
}



@end
