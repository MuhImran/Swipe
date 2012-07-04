//
//  clientObject.m
//  testXML
//
//  Created by svp on 24/12/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "clientObject.h"
#import "ObjectArrayList.h"
#import "ParserObject.h"
#import "commonUsedMethods.h"
#import "ASINetworkQueue.h"
#import "ASIFormDataRequest.h"
#import "requestStringURLs.h"
#import "SingletonClass.h"

@implementation clientObject
@synthesize webData;
@synthesize sRequest;
@synthesize parser;
@synthesize delegate;
@synthesize isPull;
-(id) init
{
	ParserObject *obj = [[ParserObject alloc] init];
	self.parser = obj;	
	webData = [[NSMutableData alloc] init];
	//webData =[[NSMutableData data] retain];
	return self;
}
-(void) newUserSignUp:(NSString *)_url
{
    requestTag = NEW_USER_TAG;
   
    NSURL *newUserURl = [[NSURL alloc]initWithString:_url];
	NSMutableURLRequest *newUserReq = [NSURLRequest requestWithURL:newUserURl];
	//webData = [[NSMutableData alloc]initWithLength:0];
  //  [newUserReq setHTTPMethod:@"POST"];
	urlconnection = [[NSURLConnection alloc]initWithRequest:newUserReq delegate:self startImmediately:YES];
	[newUserURl release];
    
}
-(void) getAuthorization:(NSString *)_url
{
       
    requestTag = LOGIN_TAG;
    NSURL *url = [[NSURL alloc]initWithString:_url];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    [urlRequest setHTTPMethod:@"POST"];
    urlconnection = [[NSURLConnection alloc]initWithRequest:urlRequest delegate:self startImmediately:YES];
    [url release];
   

}
-(void) getUserProfileData:(NSString *)_url
{
    requestTag = USER_PROFILE_TAG;
    NSURL *loginUrl = [[NSURL alloc]initWithString:_url];
	NSMutableURLRequest *loginReq = [NSURLRequest requestWithURL:loginUrl];
	urlconnection = [[NSURLConnection alloc]initWithRequest:loginReq delegate:self startImmediately:YES];
	[loginUrl release];
    
}
-(void) getFeedData:(NSString *)_url
{
    requestTag = USER_FEED_TAG;
    NSURL *loginUrl = [[NSURL alloc]initWithString:_url];
	NSURLRequest *loginReq = [NSURLRequest requestWithURL:loginUrl];
	urlconnection = [[NSURLConnection alloc]initWithRequest:loginReq delegate:self startImmediately:YES];
	[loginUrl release];
    
}
-(void) getPopularData:(NSString *)_url
{
	requestTag = POPULAR_TAG;
    NSURL *loginUrl = [[NSURL alloc]initWithString:_url];
	NSURLRequest *loginReq = [NSURLRequest requestWithURL:loginUrl];
	urlconnection = [[NSURLConnection alloc]initWithRequest:loginReq delegate:self startImmediately:YES];
	[loginUrl release];
}


-(void) getNearByData:(NSString *)_url
{
		requestTag = NEARBY_TAG;
		NSURL *loginUrl = [[NSURL alloc]initWithString:_url];
		NSURLRequest *loginReq = [NSURLRequest requestWithURL:loginUrl];
		urlconnection = [[NSURLConnection alloc]initWithRequest:loginReq delegate:self startImmediately:YES];
		[loginUrl release];
}

-(void) getNearByLocationData:(NSString *)_url
{
    requestTag = NEARBYLOC_TAG;
    NSURL *loginUrl = [[NSURL alloc]initWithString:_url];
    NSURLRequest *loginReq = [NSURLRequest requestWithURL:loginUrl];
    urlconnection = [[NSURLConnection alloc]initWithRequest:loginReq delegate:self startImmediately:YES];
    [loginUrl release];
}

-(void)getThingsTagsRequest:(NSString *)_url
{
    requestTag = THINGS_TAG;
    NSURL *loginUrl = [[NSURL alloc]initWithString:_url];
    NSURLRequest *loginReq = [NSURLRequest requestWithURL:loginUrl];
    urlconnection = [[NSURLConnection alloc]initWithRequest:loginReq delegate:self startImmediately:YES];
    [loginUrl release];
}


-(void) getUserSearchData:(NSString *)_url
{
	requestTag = SEARCH_TAG;
	NSURL *loginUrl = [[NSURL alloc]initWithString:_url];
	NSURLRequest *loginReq = [NSURLRequest requestWithURL:loginUrl];
	urlconnection = [[NSURLConnection alloc]initWithRequest:loginReq delegate:self startImmediately:YES];
	[loginUrl release];
	
}
-(void) getTopFeedData:(NSString *)_url
{
	requestTag = ACTIVITY_TAG;
	NSURL *loginUrl = [[NSURL alloc]initWithString:_url];
	NSURLRequest *loginReq = [NSURLRequest requestWithURL:loginUrl];
	urlconnection = [[NSURLConnection alloc]initWithRequest:loginReq delegate:self startImmediately:YES];
	[loginUrl release];
	
}
-(void) setUserLikeRequest:(NSString *)_url
{
	requestTag = LIKE_TAG;
	NSURL *url = [[NSURL alloc]initWithString:_url];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    [urlRequest setHTTPMethod:@"POST"];
    urlconnection = [[NSURLConnection alloc]initWithRequest:urlRequest delegate:self startImmediately:YES];
    [url release];
	
}
-(void) setUserComments:(NSString *)_url
{
	requestTag = COMMENTS_TAG;
	NSURL *url = [[NSURL alloc]initWithString:_url];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    [urlRequest setHTTPMethod:@"POST"];
    urlconnection = [[NSURLConnection alloc]initWithRequest:urlRequest delegate:self startImmediately:YES];
    [url release];
}
-(void) setPhotoDetailRequest:(NSString *)_url
{
	requestTag = PHOTO_DETAIL_TAG;
	NSURL *url = [[NSURL alloc]initWithString:_url];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    urlconnection = [[NSURLConnection alloc]initWithRequest:urlRequest delegate:self startImmediately:YES];
    [url release];
	
}
-(void) getUserPullData:(NSString *)_url
{
    requestTag = PULL_NEXT_TAG;
	NSURL *url = [[NSURL alloc]initWithString:_url];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    urlconnection = [[NSURLConnection alloc]initWithRequest:urlRequest delegate:self startImmediately:YES];
    [url release];
    
}
/*
-(void) sendPhotoForUpload:(NSString *)_url:(UIImage *)_image
{
	requestTag = UPLOADPHOTO_TAG;
	NSData *imageData = UIImageJPEGRepresentation(_image, 90);
    
    NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
	[request setURL:[NSURL URLWithString:_url]];
   
	NSString *boundary = [NSString stringWithString:@"---------------------------14737809831466499882746641449"];
	NSString *contentType = [NSString stringWithFormat:@"multipart/form-data;name=photo;filename=photo boundary=%@",boundary];
	[request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    NSMutableData *body = [NSMutableData data];
    [body appendData:[NSData dataWithData:imageData]];
    NSString *msgLength = [NSString stringWithFormat:@"%d", [body length]];
	[body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:body];
	[request setHTTPMethod:@"POST"];
    urlconnection = [[NSURLConnection alloc]initWithRequest:request delegate:self startImmediately:YES];
	
}*/

-(void) sendPhotoForUpload:(NSString *)url:(UIImage *)_image
{
    requestTag = USER_PHOTO_TAG;
    ASINetworkQueue *networkQueue = [[ASINetworkQueue alloc] init];
    //[networkQueue setUploadProgressDelegate:self];
    [networkQueue setRequestDidFinishSelector:@selector(imageRequestDidFinish:)];
    [networkQueue setQueueDidFinishSelector:@selector(imageQueueDidFinish:)];
    [networkQueue setRequestDidFailSelector:@selector(requestDidFail:)];
    [networkQueue setShowAccurateProgress:true];
    [networkQueue setDelegate:self];
    
    NSData *imageData = UIImageJPEGRepresentation(_image, 1);
    
   // url = [NSURL URLWithString:@"http://myserver/upload.php"];
    ASIFormDataRequest *request = [[[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:url]] autorelease];
    [request setPostValue:@"photo" forKey:@"name"]; 
    [request addData:imageData withFileName:@"name" andContentType:@"multipart/form-data" forKey:@"photo"];
    
    [networkQueue addOperation:request];
    [networkQueue go];
    
}
-(void) editPersonnalInfo:(NSString *)url:(UIImage *)_image
{
    requestTag = EDIT_PROFILE_TAG;
    ASINetworkQueue *networkQueue = [[ASINetworkQueue alloc] init];
    //[networkQueue setUploadProgressDelegate:self];
    [networkQueue setRequestDidFinishSelector:@selector(imageRequestDidFinish:)];
    [networkQueue setQueueDidFinishSelector:@selector(imageQueueDidFinish:)];
    [networkQueue setRequestDidFailSelector:@selector(requestDidFail:)];
    [networkQueue setShowAccurateProgress:true];
    [networkQueue setDelegate:self];
    
    NSData *imageData = UIImageJPEGRepresentation(_image, 1);
    
    // url = [NSURL URLWithString:@"http://myserver/upload.php"];
    ASIFormDataRequest *request = [[[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:url]] autorelease];
    [request setPostValue:@"user_photo" forKey:@"name"]; 
    [request addData:imageData withFileName:@"name" andContentType:@"multipart/form-data" forKey:@"user_photo"];
    
    [networkQueue addOperation:request];
    [networkQueue go];
    
}
-(void) editPersonnalInfowithOutPhoto:(NSString *)_url
{
    requestTag = EDIT_PROFILE_TAG;
    NSURL *url = [[NSURL alloc]initWithString:_url];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    [urlRequest setHTTPMethod:@"POST"];
    urlconnection = [[NSURLConnection alloc]initWithRequest:urlRequest delegate:self startImmediately:YES];
    [url release];
    
}

- (void)imageRequestDidFinish:(ASIHTTPRequest *)request
{
    NSString *response = [request responseString];
    NSLog(@"%@",response);
    parser.isPull = isPull;
    [parser setDelegate:delegate];
    
    switch (requestTag)
    {
        case USER_PHOTO:
            [parser getPhotoUploadResponse:response];//likeStringPase
            break;
        case EDIT_PROFILE:
            //[parser registrationStringParse:response];
            [parser likeStringPase:response];
            break;
        default:
            break;
    }
    
    
}
- (void)requestDidFail:(ASIHTTPRequest *)request
{
    
    NSLog(@"fail");
    if( delegate && [delegate respondsToSelector:@selector(notfiyResponse:)]) 
        [delegate performSelector:@selector(notfiyResponse:) withObject:[NSNumber numberWithBool:FALSE]];
}
- (void)imageQueueDidFinish:(ASIHTTPRequest *)request
{
    NSLog(@"imageQueueDidFinish");
  //  NSString *response = [request responseString];
   // NSLog(@"%@",response);
    
}

-(void) getUserGuide:(NSString *)_url
{
	requestTag = USERGUIDE_TAG;
	NSURL *url = [[NSURL alloc]initWithString:_url];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
   // [urlRequest setHTTPMethod:@"POST"];
    urlconnection = [[NSURLConnection alloc]initWithRequest:urlRequest delegate:self startImmediately:YES];
    [url release];
	
}
-(void) getPersonalProfileData:(NSString *)_url
{
	requestTag = PERSONAL_PROFILE_TAG;
    NSURL *loginUrl = [[NSURL alloc]initWithString:_url];
	NSURLRequest *loginReq = [NSURLRequest requestWithURL:loginUrl];
	urlconnection = [[NSURLConnection alloc]initWithRequest:loginReq delegate:self startImmediately:YES];
	[loginUrl release];
}
-(void) getPhotoData:(NSString *)_url
{
	requestTag = USER_PHOTO_TAG;
    NSURL *loginUrl = [[NSURL alloc]initWithString:_url];
	NSURLRequest *loginReq = [NSURLRequest requestWithURL:loginUrl];
	urlconnection = [[NSURLConnection alloc]initWithRequest:loginReq delegate:self startImmediately:YES];
	[loginUrl release];
	
}
-(void) getUserFollowingThis:(NSString *)_url
{
	requestTag = USER_FOLLOWING_TAG;
    NSURL *loginUrl = [[NSURL alloc]initWithString:_url];
	NSURLRequest *loginReq = [NSURLRequest requestWithURL:loginUrl];
	urlconnection = [[NSURLConnection alloc]initWithRequest:loginReq delegate:self startImmediately:YES];
	[loginUrl release];
}
-(void) getUserFollowedThis:(NSString *)_url
{
	requestTag = USER_FOLLOWED_TAG;
    NSURL *loginUrl = [[NSURL alloc]initWithString:_url];
	NSURLRequest *loginReq = [NSURLRequest requestWithURL:loginUrl];
	urlconnection = [[NSURLConnection alloc]initWithRequest:loginReq delegate:self startImmediately:YES];
	[loginUrl release];
}
-(void) setNewPetDataRequest:(NSString *)_url
{
	requestTag = NEW_PET_TAG;
	NSURL *url = [[NSURL alloc]initWithString:_url];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
   // [urlRequest setHTTPMethod:@"POST"];
    urlconnection = [[NSURLConnection alloc]initWithRequest:urlRequest delegate:self startImmediately:YES];
    [url release];
	
}
-(void) setRelationShipWithUser:(NSString *)_url
{
    requestTag = USER_RELATION_TAG;
	NSURL *url = [[NSURL alloc]initWithString:_url];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    [urlRequest setHTTPMethod:@"POST"];
    urlconnection = [[NSURLConnection alloc]initWithRequest:urlRequest delegate:self startImmediately:YES];
    [url release];
    
}
-(void) addPetInfo:(NSString *)_url
{
    requestTag = ADD_PET_TAG;
    NSURL *url = [[NSURL alloc]initWithString:_url];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    [urlRequest setHTTPMethod:@"POST"];
    urlconnection = [[NSURLConnection alloc]initWithRequest:urlRequest delegate:self startImmediately:YES];
    [url release];
    
}

-(void) checkAndUpdateExistingData:(int)_reqType
{
    
    if(_reqType == 2)
    {
        requestTag = UPDATE_POPULAR_TAG;
        NSURL *url = [[NSURL alloc]initWithString:[requestStringURLs getUserPopularRequest:FALSE]];
        NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
        urlconnection = [[NSURLConnection alloc]initWithRequest:urlRequest delegate:self startImmediately:YES];
        [url release];
    }
    else if(_reqType == 3)
    {
        requestTag = UPDATE_NEARBY_TAG;
        NSURL *url = [[NSURL alloc]initWithString:[requestStringURLs getUserNearByRequest:[[SingletonClass sharedInstance] getMyCurrentLocation]:FALSE :0]];
        NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
        urlconnection = [[NSURLConnection alloc]initWithRequest:urlRequest delegate:self startImmediately:YES];
        [url release];
    }
    else if(_reqType == 4)
    {
        requestTag = UPDATE_ACTIVITY_TAG;
        NSURL *url = [[NSURL alloc]initWithString:[requestStringURLs getUserActivityRequest:FALSE]];
        NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
        urlconnection = [[NSURLConnection alloc]initWithRequest:urlRequest delegate:self startImmediately:YES];
        [url release];
    }
    
}
-(void) getProfileURL:(NSString *)_url
{
 
    requestTag = PROFILE_URL_TAG;
    NSURL *url = [[NSURL alloc] initWithString:_url];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    urlconnection = [[NSURLConnection alloc]initWithRequest:urlRequest delegate:self startImmediately:YES];
    [url release];
    
}
-(void) getPrifileImage:(NSString *)_url
{
    requestTag = PROFILE_IMAGE_TAG;
    NSURL *url = [[NSURL alloc]initWithString:_url];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    urlconnection = [[NSURLConnection alloc]initWithRequest:urlRequest delegate:self startImmediately:YES];
    [url release];
    
}


-(void) getUserPostDeleteRequest:(NSString *)_url
{
    requestTag = DELETEPOST_TAG;
    NSURL *url = [[NSURL alloc]initWithString:_url];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    urlconnection = [[NSURLConnection alloc]initWithRequest:urlRequest delegate:self startImmediately:YES];
    [url release];
}
-(void) getUserPostFlagRequest:(NSString *)_url;
{
    requestTag = FLAGPOST_TAG;
    NSURL *url = [[NSURL alloc]initWithString:_url];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    urlconnection = [[NSURLConnection alloc]initWithRequest:urlRequest delegate:self startImmediately:YES];
    [url release];
}


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
	
	[webData setLength:0];
	if ([response respondsToSelector:@selector(statusCode)])
	{
		int statusCode = [((NSHTTPURLResponse *)response) statusCode];
		
		responseCode = statusCode;
		
		if (statusCode == 401)
		{
			[connection cancel];  // stop connecting; no more delegate messages
			
			NSDictionary *errorInfo	= [NSDictionary dictionaryWithObject:[NSString stringWithFormat:
																		  NSLocalizedString(@"Unauthorized Access",@""),
																		  statusCode] forKey:NSLocalizedDescriptionKey];
			
			NSString * const NSHTTPPropertyStatusCodeKey = @"NSHTTPPropertyStatusCodeKey";
			
			NSError *statusError = [NSError errorWithDomain:NSHTTPPropertyStatusCodeKey code:statusCode  userInfo:errorInfo];
			
			[self connection:connection didFailWithError:statusError];
			
		
		}
	}
}

-(void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	[webData appendData:data];
   // NSLog(@"Date is recieving at here");
	
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	[connection release];
	//[webData release];
	NSLog(@"Client fail:%@",[error localizedDescription]);
    
    if( delegate && [delegate respondsToSelector:@selector(notfiyResponse:)]) 
     [delegate performSelector:@selector(notfiyResponse:) withObject:[NSNumber numberWithBool:FALSE]];
}
     
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    //NSLog(@"Date recieved at here");
    [parser setDelegate:delegate];
	parser.isPull = isPull;
    NSString *aStr = [[NSString alloc] initWithData:webData encoding:NSASCIIStringEncoding];
	NSLog(@"%@",aStr);
    switch (requestTag) {
        case LOGIN:
             //NSLog(@"%@",aStr);
            [parser loginStringParse:aStr];
            break;
        case NEW_USER:
            [parser registrationStringParse:aStr];
            break;
        case USER_PROFILE:
			//NSLog(@"%@",aStr);
            [parser userProfileStringParse:aStr];
            break;
        case USER_FEED:
			// NSLog(@"%@",aStr);
           // [parser userProfileStringParse:aStr];
            [parser userFeedStringParse:aStr];
            break;
		case POPULAR:
            [parser popularStringParse:aStr];
            break;
		case NEARBY:
            [parser nearByStringParse:aStr];
            break;
		case SEARCH:
            [parser searchStringParse:aStr];
            break;
		case ACTIVITY:
            [parser TopFeedStringParse:aStr];
            break;
		case LIKE:
			//NSLog(@"%@",aStr);
            [parser likeStringPase:aStr];
            break;
		case COMMENTS:
			//NSLog(@"%@",aStr);
            [parser likeStringPase:aStr];
            break;
		case PHOTO_DETAIL:
			//NSLog(@"%@",aStr);
            [parser getPhotoDetail:aStr];
            break;
		case UPLOADPHOTO:
			//NSLog(@"%@",aStr);
            [parser getPhotoUploadResponse:aStr];
            break;
		case USERGUIDE:
			//NSLog(@"%@",aStr);
            [parser guideStringParse:aStr];
            break;
		case PERSONAL_PROFILE:
			//NSLog(@"%@",aStr);
            [parser personalProfileStringParse:aStr];
            break;
		case USER_PHOTO:
			//NSLog(@"%@",aStr);
            [parser userPhotoStringParse:aStr];
            break;
		case USER_FOLLOWING:
			//NSLog(@"%@",aStr);
            [parser userFollowingStringParse:aStr];
            break;
		case USER_FOLLOWED:
			//NSLog(@"%@",aStr);
            [parser userFollowedStringParse:aStr];
            break;
		case NEW_PET:
			//NSLog(@"%@",aStr);
            [parser likeStringPase:aStr];
            break;
        case USER_RELATION:
			//NSLog(@"%@",aStr);
            [parser relationStringParse:aStr];
            break;
        case ADD_PET:
            [parser addPetStringParse:aStr];
            break;
        case EDIT_PROFILE:
            [parser EditProfileStringParse:aStr];
            break;
        case PULL_NEXT:
            [parser userProfilePullData:aStr];
            break;
        case UPDATE_POPULAR:
            [parser updatePopularData:aStr];
            break;
        case UPDATE_NEARBY:
            [parser updateNearByData:aStr];
            break;
        case UPDATE_ACTIVITY:
            [parser updateActivityData:aStr];
            break;
        case PROFILE_URL:
            [parser getProfileImageURL:aStr];
            break;
        case NEARBYLOC:
            [parser userNearByLocationParse:aStr];
            break;
            
        case DELETEPOST:
            [parser getUserPostDeleteData:aStr];
            break;
        case FLAGPOST:
            [parser getUserPostFlagData:aStr];
            break;
            
        case THINGS:
            [parser getThingsTagsData:aStr];
            break;
            
        case PROFILE_IMAGE:
            if( delegate && [delegate respondsToSelector:@selector(profileImageDownload:)]) 
                [delegate performSelector:@selector(profileImageDownload:) withObject:webData];
            
            break;
        default:
            break; 
    }
    [aStr release];
    
}
@end

