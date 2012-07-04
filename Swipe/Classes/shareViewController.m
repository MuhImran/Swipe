//
//  browseViewController.m
//  Petstagram
//
//  Created by Haris Jawaid on 4/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "shareViewController.h"
#import "EnvetFinderDelegate.h"
#import "shareDataCell.h"
#import "SingletonClass.h"
#import "settingValues.h"
#import "SA_OAuthTwitterEngine.h"
#import "commonUsedMethods.h"
#import "requestStringURLs.h"
#import "OAToken.h"
#import "headerfiles.h"
#import "EnvetFinderDelegate.h"





@implementation shareViewController
@synthesize locationField,titlField,descText;
@synthesize profileImageView,photoImageView;
@synthesize facebookSwith;
@synthesize shareTableView;
@synthesize dataArray;
@synthesize _engine;
@synthesize AMVC;
@synthesize reverseGeocoder;
@synthesize image;
@synthesize currentLocation,option;
@synthesize scrollView;
@synthesize placemark;
@synthesize faceBookSharing,twitterSharing;
@synthesize twitterSwitch,emailSwitch;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withImage:(UIImage *)_image withOption:(int)_option
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.image = _image;
        self.option = _option;
        //NSLog(@"%d",[self.navigationController.viewControllers count]);
    }
    return self;
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
	self.title = @"Share";
    //UIBarButtonItem *submitButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(doneButtonPressed:)]; //cellButtonPressed         
	//self.navigationItem.rightBarButtonItem = submitButton;
	//[submitButton release];
	
    dataArray = [NSArray arrayWithObjects:@"Facebook",@"Twitter",@"Email",nil];// arrayByAddingObject
	[dataArray retain];
	shareTableView.backgroundColor = [UIColor clearColor];
    self.scrollView.contentSize = CGSizeMake(320, 485);
   
    [self.photoImageView setImage:self.image];
    [Font_size dropShahdowToImageView:self.photoImageView];
    [[GPS_Object sharedInstance] startUpdatingLocating:self];
    //[self profilePhoto];
    
    UIImage *image1=[UIImage imageNamed:@"back.png"];
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    button1.bounds = [Font_size getNavRightButtonFrame];     
    [button1 setBackgroundImage:image1 forState:UIControlStateNormal];
    
    //UIImage *image=[UIImage imageNamed:@"settings.png"];
    //UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    //button.bounds = [Font_size getNavRightButtonFrame];     
    [button1 setBackgroundImage:image1 forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(backButtonMethod) forControlEvents:UIControlEventTouchUpInside];    
    UIBarButtonItem *barButtonItem1 = [[UIBarButtonItem alloc] initWithCustomView:button1];
    self.navigationItem.leftBarButtonItem = barButtonItem1;
    [barButtonItem1 release];
    
}

-(void) backButtonMethod
{
    [self.navigationController popViewControllerAnimated:YES];
} 
-(void) profilePhoto
{
    /*
    tokeInfo *userprofile = [[SingletonClass sharedInstance] getTokenInformation];
    if(userprofile.imgURL && [userprofile.imgURL length] > 0)
    {
        if (![imageCaches checkCacheImage:userprofile.imgURL])
        {
            UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(8, 8, 20, 20)];
            [activityIndicator startAnimating];
            activityIndicator.activityIndicatorViewStyle= UIActivityIndicatorViewStyleGray;
            [profileImageView addSubview:activityIndicator];
            [activityIndicator release];
            IconDownloader  *iconDownloader = [[IconDownloader alloc] init];
            iconDownloader.url = userprofile.imgURL;
            iconDownloader.delegate = self;
            [iconDownloader startDownload2];
            [iconDownloader release]; 
        }
        else
        {
            [profileImageView setImage:[imageCaches getCacheImage:userprofile.imgURL]];
        }
    }
    else
    { 
        [profileImageView setImage:[Font_size getPersonShahowImage]];
    }
    */
}
#pragma mark delegate method of Image download
- (void)appImageDidLoad:(NSIndexPath *)indexPath:(NSString *)_key
{	
	NSLog(@"Download Image Index:%d and option:%@",indexPath.row,_key);
      [self.profileImageView setImage:[imageCaches imageFromKey:_key]];
}


-(void)viewWillAppear:(BOOL)animated 

{
    [super viewWillAppear:YES];
    //self.navigationController.navigationBar.hidden = FALSE;
    self.navigationController.navigationBarHidden = FALSE;
    [commonUsedMethods showTabBar:self.tabBarController];
	[self.shareTableView reloadData];
}
-(void) setImageItem:(UIImage *)_image
{
    self.image = _image;
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
-(IBAction) doneButtonPressed:(id)sender
{
    if([self validateExtraField])
        [self syncOnThreadAction];
}
-(BOOL) validateExtraField
{
    if([titlField.text length]== 0)
    {
        [self loadAlertView:@"Can't submit without title"];
        return FALSE;
    }
    
    else  if([locationField.text length]== 0)
    {
        [self loadAlertView:@"post must be tagged with your location"];
        return FALSE;
    }
    return TRUE;
}


-(IBAction) switchValueChanged:(id)sender
{
	// TO DO
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
	[textField resignFirstResponder];
	return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{    
     textField.text = [commonUsedMethods trimString:textField.text];
	 [textField resignFirstResponder];
	  return YES;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
		return 1;
}
// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
	static NSString *CellIdentifier = @"shareDataCell";
	shareDataCell *cell = (shareDataCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		
		NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"shareDataCell" owner:self options:nil];
		
		for (id currentObject in topLevelObjects){
			if ([currentObject isKindOfClass:[UITableViewCell class]]){
				cell =  (shareDataCell *) currentObject;
				break;
			}
		}
	} 
	cell.textString.text = [dataArray objectAtIndex:[indexPath row]];
	if(indexPath.row == 0) 
	{
		if([commonUsedMethods hasFaceBookTokenObject])
		{
		    cell.switchButton.hidden = FALSE;
		    cell.userButton.hidden  =  TRUE;
	        [cell.switchButton addTarget:self action:@selector(switchButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
		    [cell.switchButton setTag:indexPath.row];	
			cell.accessoryType=0;
		}
		else {
			cell.switchButton.hidden = TRUE;
			cell.userButton.hidden  =  FALSE;
			[cell.userButton addTarget:self action:@selector(cellButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
		    [cell.userButton setTag:indexPath.row];
		}
	}
	return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection: (NSInteger)section 
{
		CGRect footerFrame = CGRectMake(0.0, 0.0, self.shareTableView.frame.size.width, 40);
		UIView *_headerView = [[UIView alloc] initWithFrame: footerFrame];
		_headerView.backgroundColor = [UIColor clearColor];
		// _footerView.contentMode = UIViewContentModeCenter;
		UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 10.0, self.shareTableView.frame.size.width, 30)];
	    label.backgroundColor = [UIColor clearColor];
		label.text = @"Sharing";
		[_headerView addSubview:label];
		return _headerView;
	
}
-(IBAction) cellButtonPressed:(id)sender
{
	UIButton *button = (UIButton *)sender;
	if(button.tag == 0)
		[self facebookPressed];
	else if(button.tag == 1)
		[self TwitterButtonPressed];
	if(button.tag == 2)
    {
        NSLog(@"configured email");
    	 //[self configureEmailPressed];
    }
	
}
-(IBAction) switchButtonPressed:(id)sender
{
	UIButton *button = (UIButton *)sender;
	if(button.tag == 0)
		[self facebookPressed];
	else if(button.tag == 1)
		[self TwitterButtonPressed];

}
-(void) syncOnThreadAction
{
	overlay = [[SingletonClass sharedInstance] getOverlay];
	[overlay setDelegate:self];
     [overlay sendPhotoForUpload:[self getSharingOption]:[commonUsedMethods imageWithImage:self.image :CGSizeMake(612, 612)]];
  
    //[overlay sendPhotoForUpload:[self getSharingOption]:[commonUsedMethods imageWithImage:self.image :CGSizeMake(612, 612)]];
    
    
	//[overlay sendPhotoForUpload:[self getSharingOption]:image];
   // [overlay sendPhotoForUpload:[requestStringURLs getPhotoUploadURL:@"testing"]:image];
    //[overlay sendPhotoForUpload:[self getSharingOption]:[commonUsedMethods imageWithImage:self.image :CGSizeMake(612, 612)]];
}
-(NSString *) getSharingOption
{
  
    tokeInfo *tokeninfo = [[SingletonClass sharedInstance] getTokenInformation];
    NSMutableString *url = [[[NSMutableString alloc] init] autorelease];
    [url setString:kServerIp];
   
	[url appendString:@"/postPost?"];
    
    [url appendString:[NSString stringWithFormat:@"tags=%@",[commonUsedMethods getOptionStringValue:option]]];
    [url appendString:[NSString stringWithFormat:@"&access_token=%@",tokeninfo.accessToken]];
    if([descText.text length]> 0)
        [url appendString:[NSString stringWithFormat:@"&description=%@",descText.text]];
    if([locationField.text length]> 0)
        [url appendString:[NSString stringWithFormat:@"&location_name=%@",locationField.text]];
    [url appendString:[NSString stringWithFormat:@"&title=%@&long=%f",titlField.text,self.currentLocation.coordinate.longitude]]; 
    if(self.currentLocation)
    {
    [url appendString:[NSString stringWithFormat:@"&lat=%f",self.currentLocation.coordinate.latitude]];
    [url appendString:[NSString stringWithFormat:@"&long=%f",self.currentLocation.coordinate.longitude]]; 
    }
    if([[commonUsedMethods getFaceBookTokenObject] length] > 0)
        [url appendString:[NSString stringWithFormat:@"&fb_token=%@",[commonUsedMethods getFaceBookTokenObject]]];
    
    [url appendString:@"&name=photo"];
    url = [[url stringByReplacingOccurrencesOfString:@" " withString:@"%20"] mutableCopy];
    NSLog(@"%@",url);
    return url;
}


/*
-(NSString *) getSharingOption
{*/
    /*
  [NSString stringWithFormat:@"http://www.devexpertsteam.com/petstagram/web/api.php/postPhoto?lat=112.34&tags=pet&access_token=%@&caption=abc&lng=-34.434&%@&name=photo",tokeninfo.accessToken,@"&fb_token=166942940015970tc0ooRAAQrWcDm_84h307NN729DM&tw_token=JvyS7DO2qd6NNTsXJ4E7zA&email_address=airfl@devexperts.com"];
    
    
  //  NSLog(@"%@",self.currentLocation);
    tokeInfo *tokeninfo = [[SingletonClass sharedInstance] getTokenInformation];
    NSMutableString *url = [[[NSMutableString alloc] init] autorelease];
    [url setString:kServerIp];
    //[url appendString:@"/users/"];
    //[url appendString:[NSString stringWithFormat:@"%d",[tokeninfo.iden intValue]]];
	[url appendString:@"/postPost?"];
   // [url appendString:@"lat=112.34&tags=pets"];
    [url appendString:[NSString stringWithFormat:@"lat=%f&tags=%@",self.currentLocation.coordinate.latitude,@"happening"]];
    [url appendString:[NSString stringWithFormat:@"&access_token=%@",tokeninfo.accessToken]];
    if([descText.text length]> 0)
    [url appendString:[NSString stringWithFormat:@"&description=%@",descText.text]];
    if([locationField.text length]> 0)
        [url appendString:[NSString stringWithFormat:@"&location_name=%@",locationField.text]];
    //[url appendString:tokeninfo.accessToken];
    [url appendString:[NSString stringWithFormat:@"&title=%@&long=%f",titlField.text,self.currentLocation.coordinate.longitude]]; 
    
    if([[commonUsedMethods getFaceBookTokenObject] length] > 0)
    [url appendString:[NSString stringWithFormat:@"&fb_token=%@",[commonUsedMethods getFaceBookTokenObject]]];
    
   // if([[commonUsedMethods getTwitterTokenObject] length] > 0)
     //   [url appendString:[NSString stringWithFormat:@"&tw_token=%@",[commonUsedMethods getTwitterTokenObject]]];
    //[url appendString:@"&fb_token=166942940015970tc0ooRAAQrWcDm_84h307NN729DM&tw_token=JvyS7DO2qd6NNTsXJ4E7zA&email_address=airfl@devexperts.com"];
    [url appendString:@"&name=photo"];
     url = [[url stringByReplacingOccurrencesOfString:@" " withString:@"%20"] mutableCopy];
	 NSLog(@"%@",url);
      return url;
  }*/

#pragma mark ParserProtocolDelegate
-(void) loginResponse:(NSNumber *)_value
{
	
	[overlay dismiss];
    [overlay setDelegate:nil];
	if([_value boolValue])
	{
        
	}
    else
    {
        [self loadAlertView:@"Data not updated"];
    }
}
-(void) ParserArraylist:(NSMutableArray *) _array
{
    [overlay dismiss];
   
    
    EnvetFinderDelegate *appDelegate = (EnvetFinderDelegate*) [[UIApplication sharedApplication] delegate];
    [appDelegate switchTabIndex:self.tabBarController.selectedIndex];
    
    if((_array && [_array count]>0) && (FBShare || TWShare))
    {
        socailObject = [[SingletonClass sharedInstance] getSocialObject];
        [socailObject postSocialData:[_array objectAtIndex:0]:TWShare:FBShare];
    }
}
#pragma mark clientProtocolDelegate

-(void) notfiyResponse:(NSNumber *)_value
{
	[overlay dismiss];
	[overlay setDelegate:nil];
	
	
}
-(void) loadAlertView:(NSString *)_msg
{
	UIAlertView *alert = [[UIAlertView alloc] 
						  initWithTitle:@"" 
						  message:_msg 
						  delegate:self 
						  cancelButtonTitle:@"OK" 
						  otherButtonTitles:nil];
	[alert show];
	[alert release];
	
} 
#pragma mark GPXPointDelegate
-(void) newGPXPoints:(NSNumber*)_boolValue:(CLLocation *)_newlocation
{
    if([_boolValue boolValue])
    {
        // if(!currentLocation)
        //   currentLocation = [[CLLocation alloc] init];
        self.currentLocation = _newlocation;
        NSLog(@"Here GPX are now %@",currentLocation);
        [self getLocationAddress];
        
    }
    else
    {
        [overlay dismiss];
        overlay.delegate=nil;
        [self loadAlertView:@"Either location service is disable or issue in recognizing your location"];
        //self.segmentControl.selectedSegmentIndex = 0;
    }
    
}
-(void) getLocationAddress
{
    self.reverseGeocoder =
    [[[MKReverseGeocoder alloc] initWithCoordinate:self.currentLocation.coordinate] autorelease];
    reverseGeocoder.delegate = self;
    [reverseGeocoder start];
}

- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFailWithError:(NSError *)error
{
    NSString *errorMessage = [error localizedDescription];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Cannot obtain address."
														message:errorMessage
													   delegate:nil
											  cancelButtonTitle:@"OK"
											  otherButtonTitles:nil];
    [alertView show];
    [alertView release];
}

- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFindPlacemark:(MKPlacemark *)_placemark
{
    NSLog(@"%@",_placemark);
    self.placemark = _placemark;
     NSString *address = @"";
   //   [address setString:@""];
    
     if(placemark.thoroughfare && [placemark.thoroughfare length]> 0)
        address = [address stringByAppendingString:placemark.thoroughfare];

      if(placemark.subAdministrativeArea && [placemark.subAdministrativeArea length]> 0)
      {
          if([address length] > 0)
            address= [address stringByAppendingString:[NSString stringWithFormat:@",%@",placemark.subAdministrativeArea]];
          else
              address= [address stringByAppendingString:[NSString stringWithFormat:@"%@",placemark.subAdministrativeArea]];
      }
    if(placemark.subAdministrativeArea && [placemark.country length]> 0)
    {
         if([address length] > 0)
           address=  [address stringByAppendingString:[NSString stringWithFormat:@",%@",placemark.country]];
        else
            address=  [address stringByAppendingString:[NSString stringWithFormat:@"%@",placemark.country]];
    }
    if(placemark.subAdministrativeArea && [placemark.postalCode length]> 0)
      address=  [address stringByAppendingString:[NSString stringWithFormat:@",%@",placemark.postalCode]];
    NSLog(@"%@",address);
    self.locationField.text = address;
     
}

/*
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        self.descText.text = [commonUsedMethods stripDoubleSpaceFrom:self.descText.text];
		CGRect frame = self.view.frame;
		self.view.frame = CGRectMake(0.0f,0.0f,frame.size.width,frame.size.height);
        [scrollView setFrame:frame];
		[UIView commitAnimations];
        return FALSE;
    }
	//[[textView text] length] - range.length + text.length > 140
    //	NSLog(@"Total character are  %d",[[textView text] length]);
	
	if([[textView text] length] > 100)
	{
		//if([text isEqualToString:@"\b"])
		if(range.length ==1)
			return TRUE;
		return FALSE;
	}
    
    
    return TRUE;
}
 */
/*
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
	
	CGRect frame = self.scrollView.frame;
	//self.view.frame = CGRectMake(0.0f,0.0f, 320.0f, 460);
	CGPoint point = [self.view convertPoint:CGPointZero fromView:descText];
	if(point.y > 200)
	{
		if(frame.size.height-point.y < 120)
			frame.size.height =frame.size.height+120;
		self.scrollView.frame = CGRectMake(0.0f,
                                                   216 - point.y- 130,
                                                   frame.size.width,
                                                   frame.size.height);
		frame = self.scrollView.frame;
		NSLog(@"%f and %f and %f and %f",frame.origin.x,frame.origin.y,frame.size.width,frame.size.height);
		[UIView commitAnimations];
	}
	return YES;
}
*/ 
 
 
- (void)dealloc
{
	[shareTableView release];
	[titlField release];
    [profileImageView release];
    [photoImageView release];;
	[descText release];
	[facebookSwith release];
	[_engine release];
	[AMVC release];
	[image release];
    [currentLocation release];
    [scrollView release];
    [reverseGeocoder release];
    [placemark release];
    [faceBookSharing release];
    [twitterSharing release];
    [super dealloc];
}


-(void) facebookPressed
{
	
    EnvetFinderDelegate *appDelegate = (EnvetFinderDelegate *)[[UIApplication sharedApplication] delegate];
    
	// [appDelegate loadProgressViewWithCaption:@"Connecting to Facebook..."];
	
	[appDelegate checkNetworkConnection];
	if (appDelegate.connectionStatus == NotReachable) {
        [appDelegate cancelProgressView];
        UIAlertView * errorAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"An internet connection is required to share"
                                                             delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [errorAlert show];
        [errorAlert release];
        return;		
	}
	FacebookManager *fmgr = appDelegate.facebookManager;
    
	if ([fmgr isInitialized]) {
		;//[self postMessage:fmgr];
	}else {
		[fmgr initializeFacebook:self];
	}
}
/*
 -(void) postMessage:(FacebookManager*)fmgr {
 Baby *b = [BabyWarsAppDelegate appDelegate].baby;
 
 [fmgr postMessage:[NSString stringWithFormat:@"Hurray! Baby %@ %@",b.name, achievement.title]
 link:@"http://baby.currycloud.com" name:@"BabyBattle" caption:@"Capture and share your baby's priceless moments. Is your baby the brightest and the baddest?"
 description:@"by CurryCloud" picture:@"http://baby.currycloud.com/images/babyBattle.png"
 delegate:self];
 
 }*/

-(void) dismiss {
	[self.view removeFromSuperview];
}


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
	//[self showAlert:@"Failed to post to facebook. Please try again"];
	
	//Reset the facebook expirationDate so that it will force a reauthentication later
	[[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"ExpirationDate"];
}


#pragma mark FBSessionDelegate

//////  FOR TWITTER USE
-(void) TwitterButtonPressed
{
	//TweatViewController *temp = [[TweatViewController alloc] initWithNibName:@"TweatViewController" bundle:[NSBundle mainBundle]];;
	//[self.navigationController pushViewController:temp animated:NO];
	//EnvetFinderDelegate *appDelegate =(EnvetFinderDelegate *)[[UIApplication sharedApplication]delegate];
	//SA_OAuthTwitterEngine *_engine = appDelegate._engine;
	
	
	if (_engine == nil){
		
		_engine = [[SA_OAuthTwitterEngine alloc] initOAuthWithDelegate:self]; 
		
		_engine.consumerKey    = kOAuthConsumerKey;  
		_engine.consumerSecret = kOAuthConsumerSecret; 
	}   
	
	 if(![_engine isAuthorized]){  
	 UIViewController *controller = [SA_OAuthTwitterController controllerToEnterCredentialsWithTwitterEngine:_engine delegate:self];  
	 
	 if (controller){  
	 [self presentModalViewController: controller animated: YES];
	 //[delegate loginTwitter:controller];
	 }  
	 }  
	 else
	 [_engine sendUpdate:@"test message"];
	 
	
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

#pragma mark SA_OAuthTwitterController Delegate

- (void) OAuthTwitterController: (SA_OAuthTwitterController *) controller authenticatedWithUsername: (NSString *) username {
	
	NSLog(@"Authenticated with user %@", username);
	//[self.shareTableView reloadData];
	//[_engine sendUpdate:@"Post at same time when login"];
	
}

- (void) OAuthTwitterControllerFailed: (SA_OAuthTwitterController *) controller {
	
	NSLog(@"Authentication Failure");
}

- (void) OAuthTwitterControllerCanceled: (SA_OAuthTwitterController *) controller {
	
	NSLog(@"Authentication Canceled");
}
-(void) uploadData
{
	/*
	NSString            *stringBoundary, *contentType, *baseURLString, *urlString;
    NSData              *imageData;
    NSURL               *url;
    NSMutableURLRequest *urlRequest;
    NSMutableData       *postBody;
	
    // Create POST request from message, imageData, username and password
    baseURLString   = @"http://localhost:8888/Test.php";
    urlString       = [NSString stringWithFormat:@"%@", baseURLString];  
    url             = [NSURL URLWithString:urlString];
    urlRequest      = [[[NSMutableURLRequest alloc] initWithURL:url] autorelease];
    [urlRequest setHTTPMethod:@"POST"]; 
	
    // Set the params
    NSString *path = [[NSBundle mainBundle] pathForResource:@"LibraryIcon" ofType:@"png"];
    imageData = [[NSData alloc] initWithContentsOfFile:path];
	
    // Setup POST body
    stringBoundary = [NSString stringWithString:@"0xKhTmLbOuNdArY"];
    contentType    = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", stringBoundary];
    [urlRequest addValue:contentType forHTTPHeaderField:@"Content-Type"]; 
	
    // Setting up the POST request's multipart/form-data body
    postBody = [NSMutableData data];
	
    [postBody appendData:[[NSString stringWithFormat:@"\r\n\r\n--%@\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"source\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithString:@"lighttable"] dataUsingEncoding:NSUTF8StringEncoding]];  // So Light Table show up as source in Twitter post
	
    [postBody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"title\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithString:book.title] dataUsingEncoding:NSUTF8StringEncoding]];  // title
	
    [postBody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"isbn\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithString:book.isbn] dataUsingEncoding:NSUTF8StringEncoding]];  // isbn
	
    [postBody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"price\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithString:txtPrice.text] dataUsingEncoding:NSUTF8StringEncoding]];  // Price
	
    [postBody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"condition\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithString:txtCondition.text] dataUsingEncoding:NSUTF8StringEncoding]];  // Price
	
	
    NSString *imageFileName = [NSString stringWithFormat:@"photo.jpeg"];
    [postBody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"upload\"; filename=\"%@\"\r\n",imageFileName] dataUsingEncoding:NSUTF8StringEncoding]];
    //[postBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"upload\"\r\n\n\n"]dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
	
    [postBody appendData:imageData];
    [postBody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
	
	
	//  [postBody appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
	
    NSLog(@"postBody=%@", [[NSString alloc] initWithData:postBody encoding:NSASCIIStringEncoding]);
    [urlRequest setHTTPBody:postBody];
    NSLog(@"Image data=%@",[[NSString alloc] initWithData:imageData encoding:NSASCIIStringEncoding]);
	
    // Spawn a new thread so the UI isn't blocked while we're uploading the image
    [NSThread detachNewThreadSelector:@selector(uploadingDataWithURLRequest:) toTarget:self withObject:urlRequest]; 
	 */
}



/*************************** UIViewOrientationsIBActions ***************************/

static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 165;
static const CGFloat LANDSCAPE_KEYBOARD_HEIGHT = 140;

- (void)textFieldDidBeginEditing:(UITextField *)textField 
{
	
	textField.placeholder = @"";
    CGRect textFieldRect = [self.view.window convertRect:textField.bounds fromView:textField];
	CGRect viewRect = [self.view.window convertRect:self.view.bounds fromView:self.view];
	CGFloat midline = textFieldRect.origin.y + 0.5 * textFieldRect.size.height;
	CGFloat numerator = midline - viewRect.origin.y - MINIMUM_SCROLL_FRACTION * viewRect.size.height;
	CGFloat denominator = (MAXIMUM_SCROLL_FRACTION - MINIMUM_SCROLL_FRACTION) * viewRect.size.height;
	CGFloat heightFraction = numerator / denominator;
	if (heightFraction < 0.0)
	{
		heightFraction = 0.0;
	}
	else if (heightFraction > 1.0)
	{
		heightFraction = 1.0;
	}
	UIInterfaceOrientation orientation =
	[[UIApplication sharedApplication] statusBarOrientation];
	if (orientation == UIInterfaceOrientationPortrait ||
		orientation == UIInterfaceOrientationPortraitUpsideDown)
	{
		animatedDistance = floor(PORTRAIT_KEYBOARD_HEIGHT * heightFraction);
	}
	else
	{
		animatedDistance = floor(LANDSCAPE_KEYBOARD_HEIGHT * heightFraction);
	}
	CGRect viewFrame = self.view.frame;
	viewFrame.origin.y -= animatedDistance;
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
	[UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
	[self.view setFrame:viewFrame];
	[UIView commitAnimations];
	
		
}
- (void)fetchPointFromAddress
{
    NSError* error;
    NSString *urlStr = [NSString stringWithFormat:@"http://maps.google.com/maps/geo?q=%@&output=csv", 
                        [self.locationField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSLog(@"%@",urlStr);
    NSString* locationStr = [NSString stringWithContentsOfURL:[NSURL URLWithString:urlStr] encoding:NSASCIIStringEncoding error:&error]; 
    NSLog(@"%@ ===> %@",urlStr,locationStr);
    NSArray *items = [locationStr componentsSeparatedByString:@","];
    
    
    // double lat1 = 0.0;
    // double long1 = 0.0;
    
    if([items count] >= 4 && [[items objectAtIndex:0] isEqualToString:@"200"]) {
         
        CLLocation *loc  = [[CLLocation alloc] initWithLatitude:[[items objectAtIndex:2] doubleValue] longitude:[[items objectAtIndex:3] doubleValue]];
        self.currentLocation = loc;
        [loc release];
    }
      //  self.currentLocation.coordinate.latitude = [[items objectAtIndex:2] doubleValue];
}



- (void)textFieldDidEndEditing:(UITextField *)textField 
{
    if([titlField.text length]==0)
        titlField.placeholder = @"Title";
    if([locationField.text length]==0)
        locationField.placeholder = @"Location";
   
    
    CGRect viewFrame = self.view.frame;
	viewFrame.origin.y += animatedDistance;
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
	[UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
	[self.view setFrame:viewFrame];
 	[UIView commitAnimations];
    if(textField.tag ==2 && [textField.text length]>0)
        [self fetchPointFromAddress];
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    descText.text = @"";
    descText.textColor = [UIColor blackColor];
    CGRect textViewRect = [self.view.window convertRect:textView.bounds fromView:textView];
	CGRect viewRect = [self.view.window convertRect:self.view.bounds fromView:self.view];
	CGFloat midline = textViewRect.origin.y + 3.5 * textViewRect.size.height;
	CGFloat numerator = midline - viewRect.origin.y - MINIMUM_SCROLL_FRACTION * viewRect.size.height;
	CGFloat denominator = (MAXIMUM_SCROLL_FRACTION - MINIMUM_SCROLL_FRACTION) * viewRect.size.height;
	CGFloat heightFraction = numerator / denominator;
	if (heightFraction < 0.0)
	{
		heightFraction = 0.0;
	}
	else if (heightFraction > 1.0)
	{
		heightFraction = 1.0;
	}
	UIInterfaceOrientation orientation =
	[[UIApplication sharedApplication] statusBarOrientation];
	if (orientation == UIInterfaceOrientationPortrait ||
		orientation == UIInterfaceOrientationPortraitUpsideDown)
	{
		animatedDistance = floor(PORTRAIT_KEYBOARD_HEIGHT * heightFraction);
	}
	else
	{
		animatedDistance = floor(LANDSCAPE_KEYBOARD_HEIGHT * heightFraction);
	}
	CGRect viewFrame = self.view.frame;
	viewFrame.origin.y -= animatedDistance;
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
	[UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
	[self.view setFrame:viewFrame];
	[UIView commitAnimations];
	
	
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    if([descText.text length]==0||[descText.text isEqualToString:@"\n"])
    {
        descText.textColor = [UIColor lightGrayColor];
        descText.text = @"Description";
    }
    CGRect viewFrame = self.view.frame;
	viewFrame.origin.y += animatedDistance;
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
	[UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
	[self.view setFrame:viewFrame];
 	[UIView commitAnimations];

}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        self.descText.text = [commonUsedMethods stripDoubleSpaceFrom:self.descText.text];
        [self.descText resignFirstResponder];
    }
	//[[textView text] length] - range.length + text.length > 140
	//	NSLog(@"Total character are  %d",[[textView text] length]);
	
	if([[textView text] length] > 140)
	{
		//if([text isEqualToString:@"\b"])
		if(range.length ==1)
			return TRUE;
		return FALSE;
    }
	
	
    return TRUE;
}


-(IBAction) textFieldReturn:(id)sender
{
    [sender resignFirstResponder];
}


-(IBAction) backgrondTouched :(id)sende
{
    [titlField resignFirstResponder];
    [locationField resignFirstResponder];
    [descText resignFirstResponder];
}

///////   social media section

-(IBAction) socialButtonPressed:(id)sender
{
    UIButton *button = (UIButton *) sender;
    
    if(button.tag == 1)   //// Twitter button 
    {
        if(!TWShare)
        {
            socailObject = [[SingletonClass sharedInstance ] getSocialObject];
            if(![socailObject TwitterHasKey]){
              
                socailObject.delegate= self;
                [socailObject loginTwitter];
            }
            
            else
            {
                TWShare = TRUE;
                [self.twitterSharing setBackgroundImage:[UIImage imageNamed:@"twitterSelected.png"] forState:UIControlStateNormal];
               
            }
        }
        else
        { 
            TWShare = FALSE;
            [self.twitterSharing setBackgroundImage:[UIImage imageNamed:@"twitter-icon.png"] forState:UIControlStateNormal];
        }
    }
    else if(button.tag == 2)
    {
        if(!FBShare)
        {
                        
                socailObject = [[SingletonClass sharedInstance ] getSocialObject];
                socailObject.delegate= self;
                [socailObject facebookConnectMethod];
              
        }
        else
        {  FBShare = FALSE;
            [self.faceBookSharing setBackgroundImage:[UIImage imageNamed:@"facebook-icon.png"] forState:UIControlStateNormal];
        }

        
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
        TWShare = TRUE;
        [commonUsedMethods setTwitterConfigured:YES];
        [self.twitterSharing setBackgroundImage:[UIImage imageNamed:@"twitterSelected.png"] forState:UIControlStateNormal];
    }
    else
    {
        TWShare = FALSE;
    }
}
-(void) facebookStatus:(NSNumber *)_status
{
    if([_status boolValue])
    {
        FBShare = TRUE;
        [commonUsedMethods setFacebookConfigured:YES];
        [self.faceBookSharing setBackgroundImage:[UIImage imageNamed:@"facebookSelected.png"] forState:UIControlStateNormal];
    }
    else
        FBShare = FALSE;
}

@end
