//
//  LoginViewCotroller.m
//  PosterCard
//
//  Created by Atif on 7/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LoginViewCotroller.h"
#import "OverlayViewController.h"
#import "headerfiles.h"
#import "EnvetFinderDelegate.h"
#import "tokeInfo.h"
#import <QuartzCore/QuartzCore.h>
#import "socailConnectObject.h"
#import "tokeInfo.h"
#import "SignupVC.h"

@implementation LoginViewCotroller
@synthesize facebookButton,SignIncancelButton,viewSwitcherButtons;
@synthesize email,newPassword,newUserName,newconfirmPassword;
@synthesize  fbDictionary;
@synthesize profileImage;
@synthesize TCLabel;
@synthesize barButtonItem;
@synthesize topImageView;


- (void)viewDidLoad {
    [super viewDidLoad];
}

-(IBAction)signUpButtonPressed:(id)sender
{
    SignupVC *signUpVC = [[SignupVC alloc] initWithNibName:@"SignupVC" bundle:nil];
    [self.navigationController pushViewController:signUpVC animated:YES];
    [signUpVC release];
    
    
}


- (void)viewDidUnload 
{
    [super viewDidUnload];
}



-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.title = @"SWIPE";
}
-(IBAction) signInMethod :(id)sender
{
     // if([self validateAppLogin]){
       reqType = 1;
       isFaceBook = FALSE;
       [self syncOnThreadAction];
     // }
}
- (BOOL) validateAppLogin
{
    //Are they blank
    if([self.newUserName.text length] == 0 || [self.email.text length] == 0)
    {
        [AppDelegate showAlertView:@"Please enter all fields."];
        return false;
    }
    /*
    //Is First name valid
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
	NSNumber *n = [f numberFromString:newUserName.text];
    if ([[newUserName.text stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]] length] <= 0)
    {
        [AppDelegate showAlertView:@"Please enter valid user name."];
        return false;
    }
    
    if (n != nil)
    {
        [AppDelegate showAlertView:@"user name should not be numberic."];
        return false;
    }
    
    if ([commonUsedMethods isSpecialChar:newUserName.text])
    {
        [AppDelegate showAlertView:@"Please enter valid user name."];
        return false;
    }*/
    
    //Is email ID valid
    if (![commonUsedMethods validateEmailWithString:self.newUserName.text]) {
        [AppDelegate showAlertView:@"Invalid eMail ID."];
        return false;
    }

    
       // Is Password valid
    if ([[self.email.text stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]] length] <= 0)
    {
        
        [AppDelegate showAlertView:@"Please enter valid password."];
        return false;
    }
    if ([self.email.text length] < 3 || [self.email.text length] > 32)
    {
        [AppDelegate showAlertView:@"Your password must be 4 to 32 characters long."];
        return false;
    }
    if ([self.email.text rangeOfString:@"/"].location != NSNotFound || [self.email.text rangeOfString:@"("].location != NSNotFound || 
        [self.email.text rangeOfString:@")"].location != NSNotFound || [self.email.text rangeOfString:@"\\"].location != NSNotFound)
    {
        [AppDelegate showAlertView:@"Invalid Password."];
        return false;
    }
    return true;
}

- (BOOL) validateAppRegistration
{
    //Are they blank
    if([newUserName.text length] == 0 || [self.email.text length] == 0 || [newPassword.text length] == 0 || [newconfirmPassword.text length] == 0)
    {
        [AppDelegate showAlertView:@"Please enter all fields."];
        return false;
    }
    
    //Is First name valid
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
	NSNumber *n = [f numberFromString:newUserName.text];
    if ([[newUserName.text stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]] length] <= 0)
    {
        [AppDelegate showAlertView:@"Please enter valid user name."];
        return false;
    }
    
    if (n != nil)
    {
        [AppDelegate showAlertView:@"user name should not be numberic."];
        return false;
    }
    
    if ([commonUsedMethods isSpecialChar:newUserName.text])
    {
        [AppDelegate showAlertView:@"Please enter valid user name."];
        return false;
    }
       
    //Is email ID valid
    if (![commonUsedMethods validateEmailWithString:self.email.text]) {
        [AppDelegate showAlertView:@"Invalid eMail ID."];
        return false;
    }
    
    // Is Password valid
    if ([[newPassword.text stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]] length] <= 0)
    {
        
         [AppDelegate showAlertView:@"Please enter valid password."];
           return false;
    }
    if ([newPassword.text length] < 4 || [newPassword.text length] > 32)
    {
        [AppDelegate showAlertView:@"Your password must be 4 to 32 characters long."];
        return false;
    }
    if ([newPassword.text rangeOfString:@"/"].location != NSNotFound || [newPassword.text rangeOfString:@"("].location != NSNotFound || 
        [newPassword.text rangeOfString:@")"].location != NSNotFound || [newPassword.text rangeOfString:@"\\"].location != NSNotFound)
    {
        [AppDelegate showAlertView:@"Invalid Password."];
        return false;
    }
    // Is Confrim Password valid
    if ([[newconfirmPassword.text stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]] length] <= 0)
    {
        
        [AppDelegate showAlertView:@"Please enter valid password."];
        return false;
    }
    if ([newconfirmPassword.text length] < 4 || [newconfirmPassword.text length] > 32)
    {
        [AppDelegate showAlertView:@"Your password must be 4 to 32 characters long."];
        return false;
    }
    if ([newconfirmPassword.text rangeOfString:@"/"].location != NSNotFound || [newconfirmPassword.text rangeOfString:@"("].location != NSNotFound || 
        [newconfirmPassword.text rangeOfString:@")"].location != NSNotFound || [newconfirmPassword.text rangeOfString:@"\\"].location != NSNotFound)
    {
        [AppDelegate showAlertView:@"Invalid Password."];
        return false;
    }
    //Is password and confirm password same
    if([newPassword.text compare:newconfirmPassword.text options:NSLiteralSearch] != NSOrderedSame)
    {
        [AppDelegate showAlertView:@"Passwords do not match."];
        return false;
    }
    
    return true;
}



-(IBAction) backGroundTouch: (id)sender
{
    
   
    [newUserName resignFirstResponder];
    [newPassword resignFirstResponder];
    [newconfirmPassword resignFirstResponder];
    [self.email resignFirstResponder];
    
}

- (void)dealloc 
{
   // [signInButton release],facebookButton,tweeterButton,SignIncancelButton,TCButton,signUpButton;
   // @synthesize  UserName,email,Password,confirmPassword,newPassword,newUserName,newconfirmPassword,newemail;
   // @synthesize  fbDictionary;
   // @synthesize profileImage;
    //@synthesize TCLabel;
    [fbDictionary release];
    [super dealloc];
}


-(void) clearTextFieldData
{
    
    [newUserName setText:@""];
    [newPassword setText:@""];
    [newconfirmPassword setText:@""];
    [self.email setText:@""];
}

-(NSString *) trimString:(NSString *)temp
{
    return [temp stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
}


- (BOOL) validateEmail: (NSString *) candidate
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"; 
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex]; 
    
    return [emailTest evaluateWithObject:candidate];
}


/*************************** webServiceMethods ***************************/
-(void) syncOnThreadAction
{
   
    overlay = [[SingletonClass sharedInstance] getOverlay];
	[overlay setDelegate:self];
    if(reqType == 1)
    {
        //[overlay getAuthorization:[self getLoginRequest]];
          [self loginResponse:[NSNumber numberWithInt:1]];     // temporary method call to bypass login
    }
    else if(reqType == 2)
        [overlay newUserSignUp:[self getNewUserRequest]];
    else if(reqType == 3)
    {
        if(NOW_LOCATION)
        {
            NSLog(@"now : %@",NOW_LOCATION);
            [overlay getNearByData:[requestStringURLs getUserNearByRequest:NOW_LOCATION:FALSE :0] :FALSE];
        }
        else
            [self callNewView];

    }
    else if(reqType == 4)
        [overlay getProfileURL:[self getProfileImageURL]];
    else if(reqType == 5)
        [overlay getPrifileImage:[self getProfileImageData]];
}

-(NSString *) getLoginRequest
{
   
    NSString *tempname      =  self.newUserName.text;
    NSString *temppassword  = self.email.text;
     NSLog(@"%@",self.newUserName.text);
    NSMutableString *url = [[[NSMutableString alloc] init] autorelease];
    [url setString:kServerIp];
    [url appendFormat:@"/login?email="];
    [url appendString:tempname];
    [url appendString:@"&password="];
    [url appendString:temppassword];
    if([[[SingletonClass sharedInstance] getUserPushKey] length] >0)
        [url appendFormat:@"&device_token=%@",[[SingletonClass sharedInstance] getUserPushKey]];
    [url appendString:@"&client_secret="];
    // [url appendString:[commonUsedMethods getClientSecret]];
    NSString *clientSecrect = [NSString stringWithFormat:@"%@%@%@",[commonUsedMethods getSalt],tempname,temppassword];
    
    // [url appendString:[commonUsedMethods getClientSecret]];returnMD5Hash
    [url appendString:[commonUsedMethods returnMD5Hash:clientSecrect]];
    url = [[url stringByReplacingOccurrencesOfString:@" " withString:@"%20"] mutableCopy];
    NSLog(@"%@",url);
    
    return url;
    
}

-(NSString *) getNewUserRequest
{
    
    NSMutableDictionary *tempDic = [[SingletonClass sharedInstance] getFbDictionary];
    NSString *tempname,*temppassword,*tempemail;
    if([tempDic count] > 0 && isFaceBook)
    {
        tempname  =     [tempDic valueForKey:@"name"] ? [tempDic valueForKey:@"name"]:@"";
        temppassword  = [tempDic valueForKey:@"id"] ? [tempDic valueForKey:@"id"]:@"";
         tempemail  =   [tempDic valueForKey:@"email"] ? [tempDic valueForKey:@"email"]:@"";
        [commonUsedMethods setUserNameInDefault:tempemail];
        [commonUsedMethods setUserPassInDefault:temppassword];	
    }
    else if (!isFaceBook)
    {
        tempname  =     newUserName.text;
        temppassword  = newPassword.text; //[tempDic objectForKey:@"id"]
        tempemail  =    email.text;
    }
    
    
    NSMutableString *url = [[[NSMutableString alloc] init] autorelease];
    [url setString:kServerIp];
    [url appendFormat:@"/register?username="];
    [url appendString:tempname];
    [url appendString:@"&password="];
    [url appendString:temppassword];
    [url appendString:@"&full_name="];
    [url appendString:tempname];
    [url appendString:@"&email="];
    [url appendString:tempemail];
    if([[[SingletonClass sharedInstance] getUserPushKey] length] >0)
        [url appendFormat:@"&device_token=%@",[[SingletonClass sharedInstance] getUserPushKey]];
    if(self.profileImage)
        [url appendString:@"&name=user_photo"];
    [url appendString:@"&client_secret="];
    NSString *clientSecrect = [NSString stringWithFormat:@"%@%@%@",[commonUsedMethods getSalt],tempname,tempemail];
    
    // [url appendString:[commonUsedMethods getClientSecret]];returnMD5Hash
    [url appendString:[commonUsedMethods returnMD5Hash:clientSecrect]];
	url = [[url stringByReplacingOccurrencesOfString:@" " withString:@"%20"] mutableCopy];
    NSLog(@"%@",url);
    
    return url;
    
}


-(NSString *) getProfileImageURL
{
    
    
    NSMutableString *url = [[[NSMutableString alloc] init] autorelease];
    [url setString:[NSString stringWithFormat:@"http://graph.facebook.com/%@/?fields=picture&type=small",[self.fbDictionary objectForKey:@"id"]]];
    NSLog(@"%@",url);
    
    return url;
    
}
-(NSString *) getProfileImageData
{
    NSMutableString *url = [[[NSMutableString alloc] init] autorelease];
    [url setString:[NSString stringWithFormat:[self.fbDictionary objectForKey:@"picture"]]];
    NSLog(@"%@",url);
    return url;
    
}


-(NSString *) getUserFeedRequest
{
    tokeInfo *tokeninfo = [[SingletonClass sharedInstance] getTokenInformation];
    
    NSMutableString *url = [[[NSMutableString alloc] init] autorelease];
    [url setString:kServerIp];
    [url appendFormat:@"/users/"];
    [url appendString:[tokeninfo.iden stringValue]];
    [url appendString:@"/feed?access_token="];
    [url appendString:tokeninfo.accessToken];
    //[url appendString:@"&max_id=12"];
    
    NSLog(@"%@",url);
    
    return url;
    
}
#pragma mark Parser Response
-(void) userFeedData:(NSDictionary *)_dictionary
{
    [self.fbDictionary addEntriesFromDictionary:_dictionary];
    NSLog(@"%@",self.fbDictionary);
    reqType = 5;
    [self syncOnThreadAction];
}


-(void) NotifyDC:(NSNumber *) num_value
{
}


-(void) callNewView
{
	[overlay dismiss];
    [self clearTextFieldData];
    
    EnvetFinderDelegate *appDelegate = (EnvetFinderDelegate *)[[UIApplication sharedApplication] delegate];
	[appDelegate performSelector:@selector(showTabBarView) withObject:nil afterDelay:0.0];
    
}


#pragma mark ParserProtocolDelegate
-(void) loginResponse:(NSNumber *)_value
{
	
	[overlay dismiss];
	if([_value intValue] == 1)
	{
        [commonUsedMethods setIsFacebookUser:isFaceBook];
        if(reqType ==1)
        {
            if(!isFaceBook)
             {
                 [commonUsedMethods setUserNameInDefault:newUserName.text];
                 [commonUsedMethods setUserPassInDefault:email.text];
                 
             }
            [commonUsedMethods setIsLogout:NO];// when user sign in logout will be no
            reqType = 3;
            [self syncOnThreadAction];
        }
		else if  (reqType == 2)
		{
           
                if(!isFaceBook)
                {
                    [commonUsedMethods setUserNameInDefault:email.text];
                    [commonUsedMethods setUserPassInDefault:newPassword.text];	
                    
                }
            [commonUsedMethods setIsLogout:NO];// when user sign up logout will be no
            reqType = 3;
			[self syncOnThreadAction];
           
		}
        else if (reqType == 3)
		{
            [self.view insertSubview:overlay.view aboveSubview:self.view];
			[self performSelector:@selector(callNewView) withObject:nil afterDelay:0.0];
		}
       
	}
	
	else {
        if (reqType == 4)
		{
            reqType = 2;
            [self syncOnThreadAction];
            
		}
        else
        {
            // TO DO
        }
		
	}
}


-(void) errorResponseData:(NSDictionary *)_dictionary
{
	[overlay dismiss];

    [AppDelegate showAlertView:[_dictionary valueForKey:@"message"]];
    // [self userMessagesErrors:@"Here error message will be dipslayed"];
	
}
-(void) ParserArraylist:(NSMutableArray *) _array
{
	[overlay dismiss];

    [self callNewView];
}

#pragma mark clientProtocolDelegate

-(void) notfiyResponse:(NSNumber *)_value
{
	[overlay dismiss];
    if(reqType!=5)
    {
	
	NSString	*msg = @"Unable To Connect To Internet Check Your Internet Connection";
    [AppDelegate showAlertView:msg];
    }
    else
    {
        reqType = 2;
        [self syncOnThreadAction];
    }
	
}
-(void) profileImageDownload:(NSMutableData *)_imageData
{
    UIImage *image = [[UIImage alloc] initWithData:_imageData];
	
	if(image)
        self.profileImage = image;
    reqType = 2;
    [self syncOnThreadAction];
    [image release];   
    
}



/*************************** textFieldDelegateActions ***************************/


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    textField.text = [self trimString:textField.text];
    
    if([textField.text length]!=0)	
        textField.text = [commonUsedMethods trimString:textField.text];
    
    if(textField.tag == 1)
    {
        [textField resignFirstResponder];
        [email becomeFirstResponder];
    }
    else  if(textField.tag == 2)
    {
        [textField resignFirstResponder];
    }
    else  if(textField.tag == 3)
    {
        [textField resignFirstResponder];
        [email becomeFirstResponder];
    }
    else  if(textField.tag == 4)
    {
        
        [textField resignFirstResponder];
        [newPassword becomeFirstResponder];
    }
    else  if(textField.tag == 5)
    {
        [textField resignFirstResponder];
        [newconfirmPassword becomeFirstResponder];
        
    }
    else
    {
        [textField resignFirstResponder];
    }
    return YES;
}

-(IBAction) textFieldReturn:(id)sender
{
    [sender resignFirstResponder];
}

- (IBAction) dismissKeyboard:(id)sender
{
	[self backGroundTouch:self];
}

/*************************** facebookActions ***************************/
-(IBAction) facebookConnectMethod :(id)sender
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults removeObjectForKey:USER_NAME_KEY];
	[defaults removeObjectForKey:USER_PASSWORD_KEY];
    [defaults synchronize];
    [commonUsedMethods setFacebookConfigured:FALSE];
    //[commonUsedMethods setTwitterConfigured:FALSE];
    //socailConnectObject *social = [[SingletonClass sharedInstance] getSocialObject];
    [[[SingletonClass sharedInstance] getFbDictionary] removeAllObjects];
    //[social logoutTwitter];
    //[social singOutFacebook];
    
	[defaults synchronize];
    isFaceBook  =  TRUE;
    EnvetFinderDelegate *appDelegate = (EnvetFinderDelegate *)[[UIApplication sharedApplication] delegate];
    

    
	[appDelegate checkNetworkConnection];
	if (appDelegate.connectionStatus == NotReachable) {
        [AppDelegate showAlertView:@"Internet connection not available"];
        return;		
	}
	FacebookManager *fmgr = appDelegate.facebookManager;
    
	if ([fmgr isInitialized]) {
		[fmgr.facebook requestWithGraphPath: @"me" andDelegate: self];
	}else {
        [fmgr initializeFacebook:self];
    }

}
-(void) hasUserProfileData:(NSMutableData *)_dictionary
{
    reqType = 2;
    isFaceBook = TRUE;
    [self syncOnThreadAction];
}


/**
 * Called when an error prevents the Facebook API request from completing successfully.
 */
- (void)request:(FBRequest *)request didFailWithError:(NSError *)error {
	NSLog(@"Error");
    EnvetFinderDelegate *appDelegate = (EnvetFinderDelegate *)[[UIApplication sharedApplication] delegate];
	[appDelegate cancelProgressView];
	[appDelegate showAlertView:@"Failed to open facebook. Please try again"];
	
	//Reset the facebook expirationDate so that it will force a reauthentication later
	[[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"ExpirationDate"];
}


#pragma mark FBSessionDelegate
/**
 * Called when the user has logged in successfully.
 */
- (void)fbDidLogin {
	EnvetFinderDelegate *appDelegate = (EnvetFinderDelegate *)[[UIApplication sharedApplication] delegate];
	FacebookManager *fmgr = appDelegate.facebookManager;
    NSLog(@"%@",fmgr.facebook.accessToken);
    [[NSUserDefaults standardUserDefaults] setObject:fmgr.facebook.accessToken forKey:@"AccessToken"];
    [[NSUserDefaults standardUserDefaults] setObject:fmgr.facebook.expirationDate forKey:@"ExpirationDate"];
	//[commonUsedMethods setFaceBookTokenObject:fmgr.facebook.accessToken];
    [[NSUserDefaults standardUserDefaults] synchronize];
	[self getNewUserRequestFromFaceBookAPI];
}
-(void) getNewUserRequestFromFaceBookAPI
{
	
    [SVProgressHUD showWithStatus:@"Please wait" maskType:SVProgressHUDMaskTypeClear];
	EnvetFinderDelegate *appDelegate = (EnvetFinderDelegate *)[[UIApplication sharedApplication] delegate];
	FacebookManager *fmgr = appDelegate.facebookManager;
	[fmgr.facebook requestWithGraphPath: @"me" andDelegate: self];
	
}
/**
 * Called when the user canceled the authorization dialog.
 */
-(void)fbDidNotLogin:(BOOL)cancelled {
	NSLog(@"did not login");
    [overlay dismissError];
    EnvetFinderDelegate *appDelegate = (EnvetFinderDelegate *)[[UIApplication sharedApplication] delegate];
	[appDelegate cancelProgressView];
}

/**
 * Called when the request logout has succeeded.
 */
- (void)fbDidLogout {
	NSLog(@"Facebook Logout");
	//[self showAlert:@"You've been logged out of facebook"];
    
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// FBRequestDelegate

/**
 * Called when the Facebook API request has returned a response. This callback
 * gives you access to the raw response. It's called before
 * (void)request:(FBRequest *)request didLoad:(id)result,
 * which is passed the parsed response object.
 */
- (void)request:(FBRequest *)request didReceiveResponse:(NSURLResponse *)response {	
	
}

/**
 * Called when a request returns and its response has been parsed into an object.
 * The resulting object may be a dictionary, an array, a string, or a number, depending
 * on the format of the API response.
 * If you need access to the raw response, use
 * (void)request:(FBRequest *)request didReceiveResponse:(NSURLResponse *)response.
 */
- (void)request:(FBRequest *)request didLoad:(id)result {
    
    [overlay dismissSuccess];
	if ([result isKindOfClass:[NSDictionary class]])
	{
        NSLog(@"in login %@",(NSMutableDictionary *)result);
       self.fbDictionary = (NSMutableDictionary *)result;
        [[SingletonClass sharedInstance] setFaceBookDictionary:result];
        [commonUsedMethods setUserNameInDefault:[result valueForKey:@"email"]]; 
         [commonUsedMethods setFacebookConfigured:TRUE];
        reqType = 2;
        isFaceBook = TRUE;
        
        [self syncOnThreadAction];
      
       
		
	}
}
/*************************** textFieldDelegateActions ***************************/

// This code handles the scrolling when tabbing through input fields
static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.5;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 250;
static const CGFloat LANDSCAPE_KEYBOARD_HEIGHT = 140;


- (void)textFieldDidBeginEditing:(UITextField *)textField 
{
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

- (void)textFieldDidEndEditing:(UITextField *)textField 
{
	CGRect viewFrame = self.view.frame;
	viewFrame.origin.y += animatedDistance;
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
	[UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
	[self.view setFrame:viewFrame];
 	[UIView commitAnimations];
}



@end
