//
//  SharingSetupViewController.m
//  Posterboard
//
//  Created by Apptellect5 on 9/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SharingSetupViewController.h"
#import "headerfiles.h"
#import "domainClasses.h"
#import "commonUsedMethods.h"
#import "SetupSharingCell.h"
#import "commonUsedMethods.h"
#import "SA_OAuthTwitterEngine.h"
#import "OAToken.h"
#import "EnvetFinderDelegate.h"

@implementation SharingSetupViewController
@synthesize tableView;
@synthesize _engine,fmgr;
@synthesize delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [tableView release];
    [super dealloc];
}

-(void) backButtonMethod
{
    
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    if(isFB)
    {
        [arr addObject:@"Facebook"];
    }
    if(isTWT)
    {
        [arr addObject:@"Twitter"];
    }
    
    if( delegate && [delegate respondsToSelector:@selector(SetupSharingResponse:)])
        [delegate performSelector:@selector(SetupSharingResponse:) withObject:arr];
    [self.navigationController popViewControllerAnimated:YES];
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
    
    
    isFB = [commonUsedMethods getFacebookConfigured];
    isTWT = [commonUsedMethods getTwitterConfigured];
    // Do any additional setup after loading the view from its nib.
    
    
    // New navigation and button code eith effects
    
//    UINavigationItem *item = [self.navigationController.navigationBar.items objectAtIndex:0];
    UINavigationItem *item = self.navigationItem;
    item.titleView =  [commonUsedMethods navigationlogoView];
    
    item.leftBarButtonItem = [commonUsedMethods navigationButtonWithText:@"Back":TRUE];
    UIButton* rightButton = (UIButton*)item.leftBarButtonItem.customView;
    [rightButton addTarget:self action:@selector(backButtonMethod) forControlEvents:UIControlEventTouchUpInside];
    
    // code end
    
    /*
    self.navigationItem.titleView =  [commonUsedMethods navigationlogoView];
    
    UIImage *image=[UIImage imageNamed:@"back.png"];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.bounds = CGRectMake(0, 0, 72, 30);//[Font_size getNavRightButtonFrame];     
    [button setBackgroundImage:image forState:UIControlStateNormal];
    UIImage *image1=[UIImage imageNamed:@"back_selected.png"];
    [button setBackgroundImage:image1 forState:UIControlStateSelected];
    //UIImage *image=[UIImage imageNamed:@"settings.png"];
    //UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    //button.bounds = [Font_size getNavRightButtonFrame];     
    [button setBackgroundImage:image forState:UIControlStateNormal];
    [button addTarget:self action:@selector(backButtonMethod) forControlEvents:UIControlEventTouchUpInside];    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = barButtonItem;
    [barButtonItem release];
     */
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

#pragma mark Table view methods

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    
//	return 2;
//}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
//    if(section == 0)
//        return 2;
//    else
        return 2;
	
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath  
{
    
     static NSString *ProfileCellIdentifier = @"ShareViewCell";
        SetupSharingCell *cell = (SetupSharingCell *) [self.tableView dequeueReusableCellWithIdentifier:ProfileCellIdentifier];
        if (cell == nil)
        {
            
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"SetupSharingCell" owner:self options:nil];
            
            for (id currentObject in topLevelObjects)
            {
                if ([currentObject isKindOfClass:[UITableViewCell class]])
                {
                    cell =  (SetupSharingCell *) currentObject;
                    break;
                }
            }
        }
    if(indexPath.row == 0)
    {
        cell.lblTitle.text = @"Facebook";
        if(isFB)
        {
            cell.imgView.image = [commonUsedMethods getCheckImage];
        }
        else
        {
            cell.imgView.image = [commonUsedMethods getUncheckImage];
        }
    }
    else if(indexPath.row == 1)
    {
        cell.lblTitle.text = @"Twitter";
        if(isTWT)
        {
            cell.imgView.image = [commonUsedMethods getCheckImage];
        }
        else
        {
            cell.imgView.image = [commonUsedMethods getUncheckImage];
        }
    }
    
    
                
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.row == 0)
    {
        if(isFB)
        {
            [self showFaceBookSheet];
        }
        else
        {
            socailObject = [[SingletonClass sharedInstance ] getSocialObject];
            socailObject.delegate= self;
            [socailObject facebookConnectMethod];
        }
        
        
    }
    
    else if(indexPath.row == 1)
    {
        
        if(isTWT)
        {
            [self showTwitterSheet];
        }
        else
        {
            socailObject = [[SingletonClass sharedInstance ] getSocialObject];
            if(![socailObject TwitterHasKey]){
                
                socailObject.delegate= self;
                [socailObject logoutTwitter];
                [socailObject loginTwitter];
            }
            
            else
            {
                isTWT = YES;
                [commonUsedMethods setTwitterConfigured:isTWT];
                [self.tableView reloadData];
            }
        }
        
        
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    
    return  45;
}

-(void)showTwitterSheet
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Unlink your twitter account"
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:@"Unlink"
                                                    otherButtonTitles: nil];
    actionSheet.tag = 1;
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [actionSheet showFromTabBar:self.tabBarController.tabBar];
}
-(void)showFaceBookSheet
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Unlink your facebook account"
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:@"Unlink"
                                                    otherButtonTitles: nil];
    actionSheet.tag = 0;
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [actionSheet showFromTabBar:self.tabBarController.tabBar];
}

#pragma mark Action sheet delegate

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(actionSheet.tag == 0)
    {
        NSLog(@"Facebook clicked");
        if(buttonIndex == 0)
        {
            if(isFB)
            {
                isFB = NO;
                [commonUsedMethods setFacebookConfigured:isFB];
//                socailObject = [[SingletonClass sharedInstance ] getSocialObject];
//                socailObject.delegate= self;
//                [socailObject singOutFacebook];
                [tableView reloadData];
            }
            
        }
        else if(buttonIndex == 1)
            NSLog(@"canceled clicked");
    }
    else if(actionSheet.tag == 1)
    {
        NSLog(@"Twitter clicked");
        if(buttonIndex == 0)
        {
            if(isTWT)
            {
                isTWT = NO;
                [commonUsedMethods setTwitterConfigured:isTWT];
//                socailObject = [[SingletonClass sharedInstance ] getSocialObject];
//                socailObject.delegate= self;
//                [socailObject logoutTwitter];
                [tableView reloadData];
            }
            
        }
        else if(buttonIndex == 1)
            NSLog(@"canceled clicked");
    }
        
}


#pragma mark socialResponseDelegate
-(void)showTwitterView:(SA_OAuthTwitterController *)_controller
{
    [self presentModalViewController: _controller animated:YES];
}
-(void) TwitterStatus:(NSNumber *)_status
{
    if([_status boolValue])
    {
        isTWT = TRUE;
        //[commonUsedMethods setTwitterConfigured:YES];
        [commonUsedMethods setTwitterConfigured:isTWT];
        [tableView reloadData];
    }
    else
    {
        isTWT = FALSE;
        [commonUsedMethods setTwitterConfigured:NO];
    }
}
-(void) facebookStatus:(NSNumber *)_status
{
    if([_status boolValue])
    {
        isFB = TRUE;
        //[commonUsedMethods setFacebookConfigured:YES];
        [commonUsedMethods setFacebookConfigured:isFB];
        [tableView reloadData];
    }
    else
    {
        isFB = FALSE;
        [commonUsedMethods setFacebookConfigured:NO];
    }
}


//=========================================  TWITTER  ====================================================================================  
#pragma mark SA_OAuthTwitterEngineDelegate  
- (void) storeCachedTwitterOAuthData: (NSString *) data forUsername: (NSString *) username {  
    NSUserDefaults          *defaults = [NSUserDefaults standardUserDefaults];  
    [defaults setObject: data forKey: @"authData"];  
    [defaults synchronize]; 
	NSLog(@"data is %@ ",data);
    //NSString *responseBody = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    OAToken *accessToken      = [[OAToken alloc] initWithHTTPResponseBody:data];
    //[responseBody release];
    NSLog(@" data is %@\n  %@ \n %@\n  ",accessToken.key,accessToken.pin,accessToken.secret);
	[commonUsedMethods setTwitterTokenObject:accessToken.key];
	//[self.shareTableView reloadData];
}  

- (NSString *) cachedTwitterOAuthDataForUsername: (NSString *) username {  
    
    return [[NSUserDefaults standardUserDefaults] objectForKey: @"authData"];  
}  
- (void) twitterOAuthConnectionFailedWithData: (NSData *) data
{
	NSLog(@"Login failed ");
}

#pragma mark SA_OAuthTwitterController Delegate

- (void) OAuthTwitterController: (SA_OAuthTwitterController *) controller authenticatedWithUsername: (NSString *) username {
	
	NSLog(@"Authenticated with user %@", username);
	//[self.shareTableView reloadData];
	//[_engine sendUpdate:@"Post at same time when login"];
    isTWT = YES;
    [tableView reloadData];
	
}

- (void) OAuthTwitterControllerFailed: (SA_OAuthTwitterController *) controller {
	
	NSLog(@"Authentication Failure");
}

- (void) OAuthTwitterControllerCanceled: (SA_OAuthTwitterController *) controller {
	
	NSLog(@"Authentication Canceled");
}

#pragma mark TwitterEngineDelegate  
- (void) requestSucceeded: (NSString *) requestIdentifier {  
    NSLog(@"Request %@ succeeded", requestIdentifier); 
	//[self removeView];
	UIAlertView *myAlert = [[UIAlertView alloc] 
							initWithTitle:@"test"
							message:@"text" 
							delegate:self
							cancelButtonTitle:@"OK"
							otherButtonTitles:nil];
	CGAffineTransform myTransform = CGAffineTransformMakeTranslation(0, 60);
	[myAlert setTransform:myTransform];
	[myAlert show];
	[myAlert release];
	
	
}  

- (void) requestFailed: (NSString *) requestIdentifier withError: (NSError *) error {  
    NSLog(@"Request %@ failed with error: %@", requestIdentifier, error);
	//[self removeView];
	UIAlertView *myAlert = [[UIAlertView alloc] 
							initWithTitle:@"Error"
							message:@"text" 
							delegate:self
							cancelButtonTitle:@"OK"
							otherButtonTitles:nil];
	CGAffineTransform myTransform = CGAffineTransformMakeTranslation(0, 60);
	[myAlert setTransform:myTransform];
	[myAlert show];
	[myAlert release];
	
	
} 



#pragma mark FBSessionDelegate
///////////////////////////////////////////////////////////////////////////////////////////////////
// FBRequestDelegate

/**
 * Called when the Facebook API request has returned a response. This callback
 * gives you access to the raw response. It's called before
 * (void)request:(FBRequest *)request didLoad:(id)result,
 * which is passed the parsed response object.
 */

/**
 * Called when an error prevents the Facebook API request from completing successfully.
 */
- (void)request:(FBRequest *)request didFailWithError:(NSError *)error {
	NSLog(@"Error");
	EnvetFinderDelegate *appDelegate = (EnvetFinderDelegate *)[[UIApplication sharedApplication] delegate];
	[appDelegate cancelProgressView];
    
    UIAlertView *myAlert = [[UIAlertView alloc] 
							initWithTitle:@"Error"
							message:@"Failed to post to facebook. Please try again" 
							delegate:nil
							cancelButtonTitle:@"OK"
							otherButtonTitles:nil];
    [myAlert show];
	[myAlert release];
//	[self loadAlertView:@"Failed to post to facebook. Please try again"];
	
	//Reset the facebook expirationDate so that it will force a reauthentication later
	[[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"ExpirationDate"];
}


@end
