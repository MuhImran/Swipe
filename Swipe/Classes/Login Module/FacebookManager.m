//
//  FacebookManager.m
//  EpicRewards
//
//  Created by Eugene Woo on 10-11-12.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "FacebookManager.h"
#import "Friend.h"
//static NSString* kAppId = @"426787385503"; //previously used
static NSString* kAppId = @"300218919992865"; // modified on 8=-10-2011 test api key

//static NSString* kAppId = @"214422905289296";

@implementation FacebookManager

@synthesize facebook = _facebook;
@synthesize requestResults = _requestResults;
@synthesize friends = _friends;


-(id) init {
	
	if (!kAppId) {
		NSLog(@"missing app id!");
		exit(1);
		return nil;
	}
	
	if ([super init]) {
		_permissions =  [[NSArray arrayWithObjects:
						  @"read_stream",@"publish_stream",@"email",nil] retain];
		_facebook = [[Facebook alloc] initWithAppId:kAppId andDelegate:self];

	}
	
	return self;
	
}
-(void) initializeFacebook:(id<FBSessionDelegate>)delegate{
  
	//[_facebook authorize:kAppId permissions:_permissions delegate:delegate];
    _facebook.sessionDelegate = delegate;
	[_facebook authorize:_permissions];
}



-(BOOL) isInitialized {
	_facebook.accessToken    = [[NSUserDefaults standardUserDefaults] stringForKey:@"AccessToken"];
    _facebook.expirationDate = (NSDate *) [[NSUserDefaults standardUserDefaults] objectForKey:@"ExpirationDate"];
    return [_facebook isSessionValid];
}

-(void) getFriendsList {
	[_facebook requestWithGraphPath:@"me/friends" andDelegate:self];
}

/**
 * Make a REST API call to get a user's name using FQL.
 */
- (void)postMessage:(NSString*)message link:(NSString*)link delegate:(id <FBRequestDelegate>)delegate {
	
	NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
								   message,@"message",
								   link,@"link",
								   nil];
	[_facebook  requestWithGraphPath:@"me/feed" andParams:params
					   andHttpMethod:@"POST"
						 andDelegate:delegate];

}

/**
 * Make a REST API call to get a user's name using FQL.
 */
- (void)postMessage:(NSString*)message link:(NSString*)link name:(NSString*)name caption:(NSString*)caption
		description:(NSString*)description picture:(NSString*)picture delegate:(id <FBRequestDelegate>)delegate
{
    /*
	
	NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
                                   [params setObject:message forKey:@"message"];
                                  // [params setObject:link forKey:@"link"];
                                  // [params setObject:name forKey:@"name"];
                                  // [params setObject:caption forKey:@"caption"];
                                  // [params setObject:description forKey:@"description"];
                                   //[params setObject:picture forKey:@"picture"];
								 */ 
                                   
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   message,@"message",
								   link,@"link",
								   name,@"name",
								   caption,@"caption",
								   description,@"description",
								   picture,@"picture",
								   nil];
    
    NSLog(@"Photo_dictionary : %@",params);

	
	[_facebook  requestWithGraphPath:@"me/feed" andParams:params
					   andHttpMethod:@"POST"
						 andDelegate:delegate];
	
}

-(void)postPhoto:(UIImage*)photo caption:(NSString*)caption delegate:(id <FBRequestDelegate>)delegate {
	
	NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
								   photo, @"picture",
								   caption, @"caption",
								   nil];
	[_facebook requestWithMethodName:@"photos.upload"
						   andParams:params
					   andHttpMethod:@"POST"
						 andDelegate:delegate];
	
}



#pragma mark facebook
/**
 * Called when the user has logged in successfully.
 */
- (void)fbDidLogin {
	NSLog(@"Facebook login");
	[[NSUserDefaults standardUserDefaults] setObject:self.facebook.accessToken forKey:@"AccessToken"];
    [[NSUserDefaults standardUserDefaults] setObject:self.facebook.expirationDate forKey:@"ExpirationDate"];
}

/**
 * Called when the user canceled the authorization dialog.
 */
-(void)fbDidNotLogin:(BOOL)cancelled {
	NSLog(@"did not login");
}

/**
 * Called when the request logout has succeeded.
 */
- (void)fbDidLogout 
{
	NSLog(@"Facebook Logout");
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"AccessToken"];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"ExpirationDate"];
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
	NSLog(@"received response");
}

/**
 * Called when a request returns and its response has been parsed into an object.
 * The resulting object may be a dictionary, an array, a string, or a number, depending
 * on the format of the API response.
 * If you need access to the raw response, use
 * (void)request:(FBRequest *)request didReceiveResponse:(NSURLResponse *)response.
 */
- (void)request:(FBRequest *)request didLoad:(id)result {
	NSLog(@"DIdLoad called");
	
	//NSArray *data = [[result objectForKey:@"data"] retain];
	
	//[self processFriends:data];
}

-(void) processFriends:(NSArray*)data{
	if (_friends != nil) {
		[_friends release];
		_friends = nil;
	}
	
	_friends = [[NSMutableArray alloc] init];
	
	NSDictionary *fr;
	for (fr in data) {
		Friend *aFriend = [[Friend alloc] init];
		[aFriend setName:[fr objectForKey:@"name"]];
		[aFriend setIden:[fr objectForKey:@"id"]];
		[_friends addObject:aFriend];
		[aFriend release];
		aFriend = nil;
	}
}

/**
 * Called when an error prevents the Facebook API request from completing successfully.
 */
- (void)request:(FBRequest *)request didFailWithError:(NSError *)error {
	NSLog(@"Error");
}


///////////////////////////////////////////////////////////////////////////////////////////////////
// FBDialogDelegate

/**
 * Called when a UIServer Dialog successfully return.
 */
- (void)dialogDidComplete:(FBDialog *)dialog {
	NSLog(@"publish successfully");
}



@end
