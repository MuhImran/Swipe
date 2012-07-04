//
//  faceBookObject.m
//  Posterboard
//
//  Created by Imran on 8/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "socailConnectObject.h"
#import "OverlayViewController.h"
#import "EnvetFinderDelegate.h"
#import "SA_OAuthTwitterController.h"
#import "commonUsedMethods.h"
#import "PhotoData.h"
#import "SingletonClass.h"
@implementation socailConnectObject
@synthesize delegate;
@synthesize _photo;
-(id) init
{
    return self;
}
/*
-(void) setDelegate:(id)_delegate
{
     self.delegate = _delegate;
}
*/
//=========================================  TWITTER  ====================================================================================  
//////  FOR TWITTER USE

-(void) loginTwitter
{
	
    EnvetFinderDelegate *appDelegate =(EnvetFinderDelegate *)[[UIApplication sharedApplication]delegate];
    SA_OAuthTwitterEngine *_engine = appDelegate._engine;
    if (_engine == nil){
        
        _engine = [[SA_OAuthTwitterEngine alloc] initOAuthWithDelegate:self]; 
        
        _engine.consumerKey    = kOAuthConsumerKey;  
        _engine.consumerSecret = kOAuthConsumerSecret; 
    }   
    
    if(![_engine isAuthorized]){  
        UIViewController *controller = [SA_OAuthTwitterController controllerToEnterCredentialsWithTwitterEngine:_engine delegate:self];  
        
        if (controller){  
            if( delegate && [delegate respondsToSelector:@selector(showTwitterView:)])
                [delegate performSelector:@selector(showTwitterView:) withObject:controller];
                }  
        else
        {
            if( delegate && [delegate respondsToSelector:@selector(TwitterStatus:)])
                [delegate performSelector:@selector(TwitterStatus:) withObject:[NSNumber numberWithBool:TRUE]];
            
        }
    }  
    else
    {   
        //[_engine sendUpdate:@"I think you would be interested in a iphone photo application. Please visit the itunes to download apps"];
        
        [_engine sendUpdate:[NSString stringWithFormat:@"I just reported \"%@\" @PosterboardApp: %@",_photo.title,_photo.postPageUrl]];
    }
}
-(BOOL) TwitterHasKey
{
    EnvetFinderDelegate *appDelegate =(EnvetFinderDelegate *)[[UIApplication sharedApplication]delegate];
    SA_OAuthTwitterEngine *_engine = appDelegate._engine;
    if (_engine == nil){
        
        _engine = [[SA_OAuthTwitterEngine alloc] initOAuthWithDelegate:self]; 
        
        _engine.consumerKey    = kOAuthConsumerKey;  
        _engine.consumerSecret = kOAuthConsumerSecret; 
    }   
    
    if([_engine isAuthorized])
        return TRUE;
    return FALSE;
}

-(void) TwitterMesasgePost:(PhotoData *)_photodata
{
	
     EnvetFinderDelegate *appDelegate =(EnvetFinderDelegate *)[[UIApplication sharedApplication]delegate];
     SA_OAuthTwitterEngine *_engine = appDelegate._engine;
     [_engine sendUpdate:_photodata.title];
    /*
    if (_engine == nil){
     
     _engine = [[SA_OAuthTwitterEngine alloc] initOAuthWithDelegate:self]; 
     
     _engine.consumerKey    = kOAuthConsumerKey;  
     _engine.consumerSecret = kOAuthConsumerSecret; 
     }   
     
     if(![_engine isAuthorized]){  
     UIViewController *controller = [SA_OAuthTwitterController controllerToEnterCredentialsWithTwitterEngine:_engine delegate:self];  
     
     if (controller){  
         if( delegate && [delegate respondsToSelector:@selector(showTwitterView:)])
             [delegate performSelector:@selector(showTwitterView:) withObject:controller];
             
    // [self presentModalViewController: controller animated:YES];
     //[delegate loginTwitter:controller];
     }  
     }  
     else*/
     //[_engine sendUpdate:@"THis is a test message"];
}
-(void) signOutTwitter
{
    NSUserDefaults          *defaults = [NSUserDefaults standardUserDefaults];  
    [defaults removeObjectForKey: @"authData"];  
    [defaults synchronize]; 
	[commonUsedMethods removeTwitterTokenObject];
    
}
#pragma mark SA_OAuthTwitterEngineDelegate  
- (void) storeCachedTwitterOAuthData: (NSString *) data forUsername: (NSString *) username {  
     NSUserDefaults          *defaults = [NSUserDefaults standardUserDefaults];  
     [defaults setObject: data forKey: @"authData"];  
     [defaults synchronize]; 
     [commonUsedMethods setTwitterTokenObject:data];
	
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
    NSLog(@"Twitter Request %@ succeeded", requestIdentifier); 
	//[self removeView];
	/*UIAlertView *myAlert = [[UIAlertView alloc] 
							initWithTitle:@""
							message:@"Posted on Twitter" 
							delegate:self
							cancelButtonTitle:@"OK"
							otherButtonTitles:nil];
	CGAffineTransform myTransform = CGAffineTransformMakeTranslation(0, 60);
	[myAlert setTransform:myTransform];
	[myAlert show];
	[myAlert release];*/
	
	
}  

- (void) requestFailed: (NSString *) requestIdentifier withError: (NSError *) error {  
    NSLog(@"Twitter Request %@ failed with error: %@", requestIdentifier, error);
	//[self removeView];
		
	
}  

#pragma mark SA_OAuthTwitterController Delegate

- (void) OAuthTwitterController: (SA_OAuthTwitterController *) controller authenticatedWithUsername: (NSString *) username {
	
	NSLog(@"Authenticated with user %@", username);
	if( delegate && [delegate respondsToSelector:@selector(TwitterStatus:)])
        [delegate performSelector:@selector(TwitterStatus:) withObject:[NSNumber numberWithBool:TRUE]];
	
}

- (void) OAuthTwitterControllerFailed: (SA_OAuthTwitterController *) controller {
	
	NSLog(@"Authentication Failure");
    if( delegate && [delegate respondsToSelector:@selector(TwitterStatus:)])
        [delegate performSelector:@selector(TwitterStatus:) withObject:[NSNumber numberWithBool:FALSE]];
}

- (void) OAuthTwitterControllerCanceled: (SA_OAuthTwitterController *) controller {
	
	NSLog(@"Authentication Canceled");
    if( delegate && [delegate respondsToSelector:@selector(TwitterStatus:)])
        [delegate performSelector:@selector(TwitterStatus:) withObject:[NSNumber numberWithBool:FALSE]];
}
/*************************** facebookActions ***************************/

/*
-(void) facebookConnectMethod
{
  
    EnvetFinderDelegate *appDelegate = (EnvetFinderDelegate *)[[UIApplication sharedApplication] delegate];
    
    // [appDelegate loadProgressViewWithCaption:@"Connecting to Facebook..."];
	
	 [appDelegate checkNetworkConnection];
	if (appDelegate.connectionStatus == NotReachable) {
        [appDelegate cancelProgressView];
        UIAlertView * errorAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"An internet connection is required"
                                                             delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [errorAlert show];
        [errorAlert release];
        return;		
	}
	FacebookManager *fmgr = appDelegate.facebookManager;
    
    if ([fmgr isInitialized]) {
		;//[self postFBMessage];
	}else {
        [fmgr initializeFacebook:self];
    }
}
    *//*
	if ([fmgr isInitialized]) {
        if( delegate && [delegate respondsToSelector:@selector(facebookStatus:)])
            [delegate performSelector:@selector(facebookStatus:) withObject:[NSNumber numberWithBool:TRUE]];
	}else {
        [fmgr initializeFacebook:self];
    }*/
    
//}


/**
 * Called when an error prevents the Facebook API request from completing successfully.
 */
- (void)request:(FBRequest *)request didFailWithError:(NSError *)error {
	NSLog(@"Error:%@",error);
    //EnvetFinderDelegate *appDelegate = (EnvetFinderDelegate *)[[UIApplication sharedApplication] delegate];
	//[appDelegate cancelProgressView];
	//[self showAlert:@"Failed to post to facebook. Please try again"];
	
	//Reset the facebook expirationDate so that it will force a reauthentication later
	//[[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"ExpirationDate"];
}


#pragma mark FBSessionDelegate
/**
 * Called when the user has logged in successfully.
 */
- (void)fbDidLogin {
	EnvetFinderDelegate *appDelegate = (EnvetFinderDelegate *)[[UIApplication sharedApplication] delegate];
	FacebookManager *fmgr = appDelegate.facebookManager;
    [[NSUserDefaults standardUserDefaults] setObject:fmgr.facebook.accessToken forKey:@"AccessToken"];
    [[NSUserDefaults standardUserDefaults] setObject:fmgr.facebook.expirationDate forKey:@"ExpirationDate"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    if( delegate && [delegate respondsToSelector:@selector(facebookStatus:)])
        [delegate performSelector:@selector(facebookStatus:) withObject:[NSNumber numberWithBool:TRUE]];
   
}
/**
 * Called when the user canceled the authorization dialog.
 */
-(void)fbDidNotLogin:(BOOL)cancelled {
	NSLog(@"did not login");
    if( delegate && [delegate respondsToSelector:@selector(facebookStatus:)])
        [delegate performSelector:@selector(facebookStatus:) withObject:[NSNumber numberWithBool:FALSE]];
}

/**
 * Called when the request logout has succeeded.
 */
- (void)fbDidLogout {
	NSLog(@"Facebook Logout");
	[self showAlert:@"You've been logged out of facebook"];
    
}

-(void)showAlert:(NSString *)msg
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                    message:msg 
                                                   delegate:nil 
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles: nil];
    [alert show];
    [alert release];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// FBRequestDelegate

/**
 * Called when the Facebook API request has returned a response. This callback
 * gives you access to the raw response. It's called before
 * (void)request:(FBRequest *)request didLoad:(id)result,
 * which is passed the parsed response object.
 */
- (void)request:(FBRequest *)request didReceiveResponse:(NSURLResponse *)response 
{	
    NSLog(@"in social object %@",response);
}

-(void) facebookPost
{
    
    EnvetFinderDelegate *appDelegate = (EnvetFinderDelegate *)[[UIApplication sharedApplication] delegate];
    
    // [appDelegate loadProgressViewWithCaption:@"Connecting to Facebook..."];
	
    [appDelegate checkNetworkConnection];
	if (appDelegate.connectionStatus == NotReachable) {
        [appDelegate cancelProgressView];
        UIAlertView * errorAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"An internet connection is required"
                                                             delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [errorAlert show];
        [errorAlert release];
        return;		
	}
	FacebookManager *fmgr = appDelegate.facebookManager;
    
	if ([fmgr isInitialized]) {
		[self postFBMessage];
	}
    
}
-(void) facebookConnectMethod
{
    
    EnvetFinderDelegate *appDelegate = (EnvetFinderDelegate *)[[UIApplication sharedApplication] delegate];
    
    // [appDelegate loadProgressViewWithCaption:@"Connecting to Facebook..."];
	
    [appDelegate checkNetworkConnection];
	if (appDelegate.connectionStatus == NotReachable) {
        [appDelegate cancelProgressView];
        UIAlertView * errorAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"An internet connection is required"
                                                             delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [errorAlert show];
        [errorAlert release];
        return;		
	}
	FacebookManager *fmgr = appDelegate.facebookManager;
    
    if ([fmgr isInitialized]) {
		if( delegate && [delegate respondsToSelector:@selector(facebookStatus:)])
            [delegate performSelector:@selector(facebookStatus:) withObject:[NSNumber numberWithBool:TRUE]];
	}else {
        [fmgr initializeFacebook:self];
    }
    /*
     if ([fmgr isInitialized]) {
     if( delegate && [delegate respondsToSelector:@selector(facebookStatus:)])
     [delegate performSelector:@selector(facebookStatus:) withObject:[NSNumber numberWithBool:TRUE]];
     }else {
     [fmgr initializeFacebook:self];
     }*/
    
}
- (void)request:(FBRequest *)request didLoad:(id)result {
   
    /*
    if ([result isKindOfClass:[NSDictionary class]])
	{
      
        NSMutableDictionary *fbDictionary = (NSMutableDictionary *)result;
        [[SingletonClass sharedInstance] setFaceBookDictionary:result];
        [commonUsedMethods setUserNameInDefault:[result objectForKey:@"name"]];
        [commonUsedMethods setUserPassInDefault:[result objectForKey:@"id"]];
        [commonUsedMethods setFBSharingNotification:TRUE];
        if( delegate && [delegate respondsToSelector:@selector(hasUserProfileData:)])
            [delegate performSelector:@selector(hasUserProfileData:) withObject:fbDictionary];
  }*/
}

-(void) postFBMessage
{
     EnvetFinderDelegate *appDelegate = (EnvetFinderDelegate *)[[UIApplication sharedApplication] delegate];
      NSMutableDictionary *fbArguments = [[NSMutableDictionary alloc] init];
    /*
    NSString *wallPost = _photo.title;
    NSString *linkURL  = _photo.postPageUrl;
    NSString *imgURL   = _photo.standResolution.url;
    
    [fbArguments setObject:wallPost forKey:@"message"];
    [fbArguments setObject:linkURL  forKey:@"link"];
    [fbArguments setObject:imgURL   forKey:@"picture"];
    */
    
    NSLog(@"Photo_url : %@ , link : %@, desc : %@",_photo.standResolution.url,_photo.postPageUrl,_photo.desc);
    FacebookManager *fmgr = appDelegate.facebookManager;
    [fmgr postMessage:_photo.title
				 link:_photo.postPageUrl 
				 name:@"Posterboard" 
			  caption:@"Posterboard for iOS"
		  description:@"by Posterboard" 
			  picture:_photo.standResolution.url
			 delegate:self];
    
   // [fmgr postMessage:(NSString*)message link:(NSString*)link name:(NSString*)name caption:(NSString*)caption
//description:(NSString*)description picture:(NSString*)picture delegate:(id <FBRequestDelegate>)delegate
    
    
   /*
    [fmgr.facebook requestWithGraphPath:@"me/feed" 
                         andParams:fbArguments
                     andHttpMethod:@"POST"
                       andDelegate:self];*/
    
   // [fmgr requestWithGraphPath:@"me/feed" andParams:fbArguments andHttpMethod:@"POST" andDelegate:nil];
    NSLog(@"FBArguments dictionary : %@",fbArguments);
}
 /*

 -(void) postFBMessage
 {
 EnvetFinderDelegate *appDelegate = (EnvetFinderDelegate *)[[UIApplication sharedApplication] delegate];
 NSMutableDictionary *fbArguments = [[NSMutableDictionary alloc] init];
 
 NSString *wallPost = @"the super wall post";
 NSString *linkURL  = @"http://www.apptellect.com";
 NSString *imgURL   = @"http://www.apptellect.com";
 
 [fbArguments setObject:wallPost forKey:@"message"];
 [fbArguments setObject:linkURL  forKey:@"link"];
 [fbArguments setObject:imgURL   forKey:@"picture"];
 FacebookManager *fmgr = appDelegate.facebookManager;
 
 [fmgr.facebook requestWithGraphPath:@"me/feed" 
 andParams:fbArguments
 andHttpMethod:@"POST"
 andDelegate:self];
 
 // [fmgr requestWithGraphPath:@"me/feed" andParams:fbArguments andHttpMethod:@"POST" andDelegate:nil];
 
 }
  */
 
-(void) facebookLogoutMethod
{
   
    
}
-(void) logoutTwitter
{
    NSUserDefaults          *defaults = [NSUserDefaults standardUserDefaults];  
    [defaults removeObjectForKey: @"authData"];  
    [defaults synchronize]; 
	[commonUsedMethods removeTwitterTokenObject];
    
}
-(void) singOutFacebook
{
    EnvetFinderDelegate *appDelegate = (EnvetFinderDelegate *)[[UIApplication sharedApplication] delegate];
    FacebookManager *fmgr = appDelegate.facebookManager;
    [fmgr fbDidLogout];
    [fmgr.facebook logout:fmgr];
    
}

-(void) postSocialData:(PhotoData *)_photo1:(BOOL)_isTw:(BOOL)_isFb
{
    self._photo= _photo1;
    if(_isFb)
        [self postFBMessage];
    if(_isTw)
        [self loginTwitter];
}

@end
