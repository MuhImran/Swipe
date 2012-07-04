//
//  OverlayViewController.m
//  TableView
//
//  Created by iPhone SDK Articles on 1/17/09.
//  Copyright www.iPhoneSDKArticles.com 2009. 
//

#import "OverlayViewController.h"
#import "clientObject.h"
#import "headerfiles.h"

#define authenLabelKey				@"Authenticating"							
#define singUpLabelKey				@"Signing in"	
#define RequestProfileLabelKey       @"Requesting profile"
#define ThingLabelKey                 @"fetching Topics"
						
#define SearchLableKey			    @"Searching"	
#define TopFeedLabelKey             @"Top posts"	
#define PostCommentLabelKey         @"Posting comment"
#define PleaseWaitLableKey          @"Please Wait"



#define LDauthenLabelKey			@"Authenticating LinkedIn"	


#define PicUploadLabelKey           @"Uploading picture"
#define PicUpdateLabelKey           @"Updating picture"


#define NearByFeedLabelKey           @"Requesting Nearby posts"
#define JoinEventLabelKey           @"Joining status"
#define PosteventLabelKey           @"Posting event"

#define PoststatusLabelKey           @"Posting status"
#define NearLocLabelKey              @"Finding nearby locations"

#define GuestLabelKey               @"Requesting guests"
#define DealsLabelKey               @"Requesting deals"
#define EventsLabelKey               @"Requesting events"
#define InboxLabelKey               @"Accessing inbox"
#define BlockLabelKey               @"status updating"
#define SignoutLabelKey             @"Logging out"



#define PostMessageLabelKey         @"Sending message"

#define DelMessageLabelKey         @"Deleting message"
#define PullMoreMessageLabelKey    @"Pulling more"






@implementation OverlayViewController

@synthesize delegate;
@synthesize isPull;


- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)pleaseWaitOverlay
{
    [SVProgressHUD showWithStatus:PleaseWaitLableKey maskType:SVProgressHUDMaskTypeClear];
}



-(void) newUserSignUp:(NSString *)_url
{
     [SVProgressHUD showWithStatus:singUpLabelKey maskType:SVProgressHUDMaskTypeClear];
    clientObject *client = [[SingletonClass sharedInstance] getClientObject];
	[client setDelegate:delegate];
    [client newUserSignUp:_url];
    
}
-(void) getAuthorization:(NSString *)_url
{
     [SVProgressHUD showWithStatus:authenLabelKey maskType:SVProgressHUDMaskTypeClear];
     clientObject *client = [[SingletonClass sharedInstance] getClientObject];
	 [client setDelegate:delegate];
     [client getAuthorization:_url];
        
}
-(void) getUserProfileData:(NSString *)_url :(BOOL)_isPull :(BOOL)_firstLoad
{
    if(_firstLoad)
        [SVProgressHUD showWithStatus:RequestProfileLabelKey maskType:SVProgressHUDMaskTypeClear];
    clientObject *client = [[SingletonClass sharedInstance] getClientObject];
	[client setDelegate:delegate];
    client.isPull = _isPull;
    [client getUserProfileData:_url];
    
}
-(void) getFeedData:(NSString *)_url :(BOOL)_isPull
{
    [SVProgressHUD showWithStatus:NearByFeedLabelKey maskType:SVProgressHUDMaskTypeClear];
    clientObject *client = [[SingletonClass sharedInstance] getClientObject];
	[client setDelegate:delegate];
	client.isPull = _isPull;
    [client getFeedData:_url];
    
}
-(void) getPopularData:(NSString *)_url :(BOOL)_isPull

{	
	clientObject *client = [[SingletonClass sharedInstance] getClientObject];
	[client setDelegate:delegate];
	client.isPull = _isPull;
	[client getPopularData:_url];

}
-(void) getNearByData:(NSString *)_url :(BOOL)_isPull
{
	[SVProgressHUD showWithStatus:NearByFeedLabelKey maskType:SVProgressHUDMaskTypeClear];
    clientObject *client = [[SingletonClass sharedInstance] getClientObject];
	[client setDelegate:delegate];
	client.isPull = _isPull;
	[client getNearByData:_url];
}

-(void) getNearByMapData:(NSString *)_url :(BOOL)_isPull
{
	//[SVProgressHUD showWithStatus:NearByFeedLabelKey maskType:SVProgressHUDMaskTypeClear];
    clientObject *client = [[SingletonClass sharedInstance] getClientObject];
	[client setDelegate:delegate];
	client.isPull = _isPull;
	[client getNearByData:_url];
}


-(void) getNearByLocationData:(NSString *)_url :(BOOL)_isPull
{
	[SVProgressHUD showWithStatus:NearLocLabelKey maskType:SVProgressHUDMaskTypeClear];
    clientObject *client = [[SingletonClass sharedInstance] getClientObject];
	[client setDelegate:delegate];
	client.isPull = _isPull;
	[client getNearByLocationData:_url];
}

-(void) getThingsTagsRequest:(NSString *)_url 
{
    [SVProgressHUD showWithStatus:ThingLabelKey maskType:SVProgressHUDMaskTypeClear];
    clientObject *client = [[SingletonClass sharedInstance] getClientObject];
	[client setDelegate:delegate];
	//client.isPull = _isPull;
	[client getThingsTagsRequest:_url];
}


-(void) getUserSearchData:(NSString *)_url :(BOOL)_isPull
{
	[SVProgressHUD showWithStatus:SearchLableKey maskType:SVProgressHUDMaskTypeClear];
    clientObject *client = [[SingletonClass sharedInstance] getClientObject];
	[client setDelegate:delegate];
	client.isPull = _isPull;
	[client getUserSearchData:_url];
}
-(void) geTopFeedRequest:(NSString *)_url :(BOOL)_isPull
{
	[SVProgressHUD showWithStatus:TopFeedLabelKey maskType:SVProgressHUDMaskTypeClear];
    clientObject *client = [[SingletonClass sharedInstance] getClientObject];
	[client setDelegate:delegate];
	client.isPull = _isPull;
	[client getTopFeedData:_url];
	
}
-(void) setUserLikeRequest:(NSString *)_url
{
	//[SVProgressHUD showWithStatus:PleaseWaitLableKey maskType:SVProgressHUDMaskTypeClear];
    clientObject *client = [[SingletonClass sharedInstance] getClientObject];
	[client setDelegate:delegate];
	[client setUserLikeRequest:_url];
	
}
-(void) setUserComments:(NSString *)_url
{
	[SVProgressHUD showWithStatus:PostCommentLabelKey maskType:SVProgressHUDMaskTypeClear];
    clientObject *client = [[SingletonClass sharedInstance] getClientObject];
	[client setDelegate:delegate];
	[client setUserComments:_url];
}
-(void) setPhotoDetailRequest:(NSString *)_url
{
	[SVProgressHUD showWithStatus:PleaseWaitLableKey maskType:SVProgressHUDMaskTypeClear];
    clientObject *client = [[SingletonClass sharedInstance] getClientObject];
	[client setDelegate:delegate];
	[client setPhotoDetailRequest:_url];
	
}
-(void) sendPhotoForUpload:(NSString *)_url :(UIImage *)_image
{
	[SVProgressHUD showWithStatus:PleaseWaitLableKey maskType:SVProgressHUDMaskTypeClear];
    clientObject *client = [[SingletonClass sharedInstance] getClientObject];
	[client setDelegate:delegate];
	[client sendPhotoForUpload:_url:_image];
	
}
-(void) getUserGuide:(NSString *)_url
{
	[SVProgressHUD showWithStatus:PleaseWaitLableKey maskType:SVProgressHUDMaskTypeClear];
    clientObject *client = [[SingletonClass sharedInstance] getClientObject];
	[client setDelegate:delegate];
	[client getUserGuide:_url];
	
}
-(void) getPersonalProfileData:(NSString *)_url
{
	[SVProgressHUD showWithStatus:RequestProfileLabelKey maskType:SVProgressHUDMaskTypeClear];
    clientObject *client = [[SingletonClass sharedInstance] getClientObject];
	[client setDelegate:delegate];
	[client getPersonalProfileData:_url];
	
}
-(void) getPhotoData:(NSString *)_url :(BOOL)_isPull
{
	
    [SVProgressHUD showWithStatus:PleaseWaitLableKey maskType:SVProgressHUDMaskTypeClear];
    clientObject *client = [[SingletonClass sharedInstance] getClientObject];
	[client setDelegate:delegate];
	client.isPull = _isPull;
    [client getPhotoData:_url];
	
}
-(void) getUserPullData:(NSString *)_url
{
    [SVProgressHUD showWithStatus:PleaseWaitLableKey maskType:SVProgressHUDMaskTypeClear];
    clientObject *client = [[SingletonClass sharedInstance] getClientObject];
	[client setDelegate:delegate];
    [client getUserPullData:_url];
    
}
-(void) getUserFollowingThis:(NSString *)_url
{
	[SVProgressHUD showWithStatus:PleaseWaitLableKey maskType:SVProgressHUDMaskTypeClear];
    clientObject *client = [[SingletonClass sharedInstance] getClientObject];
	[client setDelegate:delegate];
    [client getUserFollowingThis:_url];
}
-(void) getUserFollowedThis:(NSString *)_url
{
	[SVProgressHUD showWithStatus:PleaseWaitLableKey maskType:SVProgressHUDMaskTypeClear];
    clientObject *client = [[SingletonClass sharedInstance] getClientObject];
	[client setDelegate:delegate];
    [client getUserFollowedThis:_url];
	
}
-(void) setNewPetDataRequest:(NSString *)_url
{
	[SVProgressHUD showWithStatus:PleaseWaitLableKey maskType:SVProgressHUDMaskTypeClear];
    clientObject *client = [[SingletonClass sharedInstance] getClientObject];
	[client setDelegate:delegate];
    [client setNewPetDataRequest:_url];
	
}
-(void) setRelationShipWithUser:(NSString *)_url
{
    
    [SVProgressHUD showWithStatus:PleaseWaitLableKey maskType:SVProgressHUDMaskTypeClear];
    clientObject *client = [[SingletonClass sharedInstance] getClientObject];
	[client setDelegate:delegate];
    [client setRelationShipWithUser:_url];
}
-(void) addPetInfo:(NSString *)_url
{
    [SVProgressHUD showWithStatus:PleaseWaitLableKey maskType:SVProgressHUDMaskTypeClear];
    clientObject *client = [[SingletonClass sharedInstance] getClientObject];
	[client setDelegate:delegate];
    [client addPetInfo:_url];

}
-(void) editPersonnalInfo:(NSString *)_url :(UIImage *)_image
{
   [SVProgressHUD showWithStatus:PleaseWaitLableKey maskType:SVProgressHUDMaskTypeClear];
    clientObject *client = [[SingletonClass sharedInstance] getClientObject];
	[client setDelegate:delegate];
    [client editPersonnalInfo:_url:_image];
}
-(void) editPersonnalInfo1:(NSString *)_url :(UIImage *)_image
{
    //[SVProgressHUD showWithStatus:PleaseWaitLableKey maskType:SVProgressHUDMaskTypeClear];
    clientObject *client = [[SingletonClass sharedInstance] getClientObject];
	[client setDelegate:delegate];
    [client editPersonnalInfo:_url:_image];
}
-(void) editPersonnalInfowithOutPhoto:(NSString *)_url
{
   [SVProgressHUD showWithStatus:PleaseWaitLableKey maskType:SVProgressHUDMaskTypeClear];
    clientObject *client = [[SingletonClass sharedInstance] getClientObject];
	[client setDelegate:delegate];
    [client editPersonnalInfowithOutPhoto:_url];
}
-(void) checkAndUpdateExistingData:(int)_reqType
{
    [SVProgressHUD showWithStatus:PleaseWaitLableKey maskType:SVProgressHUDMaskTypeClear];
    clientObject *client = [[SingletonClass sharedInstance] getClientObject];
	[client setDelegate:delegate];
    [client checkAndUpdateExistingData:_reqType];
}
-(void) getProfileURL:(NSString *)_url
{
    [SVProgressHUD showWithStatus:PleaseWaitLableKey maskType:SVProgressHUDMaskTypeClear];
    clientObject *client = [[SingletonClass sharedInstance] getClientObject];
	[client setDelegate:delegate];
    [client getProfileURL:_url];
    
}
-(void) getPrifileImage:(NSString *)_url
{
    clientObject *client = [[SingletonClass sharedInstance] getClientObject];
	[client setDelegate:delegate];
    [client getPrifileImage:_url];
    
}

-(void) getUserPostDeleteRequest:(NSString *)_url
{
    [SVProgressHUD showWithStatus:PleaseWaitLableKey maskType:SVProgressHUDMaskTypeClear];
    clientObject *client = [[SingletonClass sharedInstance] getClientObject];
	[client setDelegate:delegate];
    [client getUserPostDeleteRequest:_url];
}
-(void) getUserPostFlagRequest:(NSString *)_url
{
    [SVProgressHUD showWithStatus:PleaseWaitLableKey maskType:SVProgressHUDMaskTypeClear];
    clientObject *client = [[SingletonClass sharedInstance] getClientObject];
	[client setDelegate:delegate];
    [client getUserPostFlagRequest:_url];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    [AppDelegate clearAllCacheImage];
    // Release anything that's not essential, such as cached data
}
- (void)overlayTask {
	//clientObject *client = [[SingletonClass sharedInstance] getClientObject];
	//[client setDelegate:delegate];
	
	}
- (void)dismiss {
    isPull= FALSE;
	[SVProgressHUD dismiss];
}

- (void)dismissSuccess {
    isPull= FALSE;
	[SVProgressHUD dismissWithSuccess:@"Success!"];
}

- (void)dismissError {
    isPull= FALSE;
	[SVProgressHUD dismissWithError:@"Failed with Error"];
}

- (void)dealloc {
    delegate = nil;
	[delegate release];
    [super dealloc];
}


@end
