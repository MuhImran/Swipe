//
//  profileImageFetcher.m
//  Posterboard
//
//  Created by Imran on 8/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "profileImageFetcher.h"
#import "SingletonClass.h"
#import "requestStringURLs.h"
#import "SBJSON.h"
#import "ASINetworkQueue.h"
#import "ASIFormDataRequest.h"
#import "commonUsedMethods.h"
#import "headerfiles.h"
#import "UIImage+Resize.h"

@implementation profileImageFetcher
@synthesize webData;
@synthesize profileImage;
-(id) init
{   
    webData  = [[NSMutableData alloc] init]; 
    return self;
}
-(void) requestForProfileURL
{
    requestTag = PROFILE_URL_TAG;
    NSString *_url = [requestStringURLs getProfileImageURL:[[SingletonClass sharedInstance] getFbDictionary]];
    NSLog(@"%@",_url);
    NSURL *url = [[NSURL alloc] initWithString:_url];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    NSURLConnection *urlconnection = [[NSURLConnection alloc]initWithRequest:urlRequest delegate:self startImmediately:YES];
    [url release];
    [urlconnection release];
}
#pragma mark Parser Response
-(void) getProfileImageRequest:(NSString *)_url
{
    requestTag = PROFILE_IMAGE_TAG;
    NSURL *url = [[NSURL alloc]initWithString:_url];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    NSURLConnection *urlconnection = [[NSURLConnection alloc]initWithRequest:urlRequest delegate:self startImmediately:YES];
    [url release];
    [urlconnection release];
    
}


-(void) profileImageDownload:(NSMutableData *)_imageData
{
    UIImage *image = [[UIImage alloc] initWithData:_imageData];
	
	if(image)
    {   
        self.profileImage  = [image resizedImageWithContentMode:UIViewContentModeScaleAspectFill bounds:CGSizeMake(85.0f, 85.0f) interpolationQuality:kCGInterpolationDefault];
        //self.profileImage = image;
        overlay = [[SingletonClass sharedInstance] getOverlay];
        overlay.delegate = self;
        [overlay editPersonnalInfo1:[requestStringURLs UpdateProfileURL]:image];
    }
    [image release];   
    
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
#pragma mark editProfile resonse

-(void) userFeedData:(NSDictionary *)_dictionary
{
    [overlay dismiss];
	overlay.delegate= nil; 
    
    if([_dictionary valueForKey:@"status"] && [[_dictionary valueForKey:@"status"] isEqualToString:@"OK"])
    {
        [self saveNewProfilePhotoToToken];
        //requestTag = LOGIN_TAG;
        //NSURL *url = [[NSURL alloc]initWithString:[self loginAgain]];
        //NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
        //NSURLConnection *urlconnection = [[NSURLConnection alloc]initWithRequest:urlRequest delegate:self startImmediately:YES];
        //[url release];
        //[urlconnection release];
    }
}  
-(void) saveNewProfilePhotoToToken
{
    if(self.profileImage)
    {
        tokeInfo *token = [[SingletonClass sharedInstance] getTokenInformation];
        if(!token.imgURL)
        {
            token.imgURL = USER_PROFILE_IMAGE;    
            [imageCaches storeImage:profileImage imageData:UIImagePNGRepresentation(self.profileImage) forKey:USER_PROFILE_IMAGE toDisk:YES];
        }
        else
        {
            [imageCaches storeImage:profileImage imageData:UIImagePNGRepresentation(self.profileImage) forKey:token.imgURL toDisk:YES];
        }
    }
}

-(NSString *) loginAgain
{
    NSMutableDictionary *dic = [[SingletonClass sharedInstance] getFbDictionary];
    NSMutableString *url = [[[NSMutableString alloc] init] autorelease];
    [url setString:kServerIp];
    [url appendFormat:@"/login?username="];
    [url appendString:[dic valueForKey:@"name"]];
    [url appendString:@"&password="];
    [url appendString:@""];
    if([[[SingletonClass sharedInstance] getUserPushKey] length] >0)
        [url appendFormat:@"&device_token=%@",[[SingletonClass sharedInstance] getUserPushKey]];
    [url appendString:@"&client_secret="];
    // [url appendString:[commonUsedMethods getClientSecret]];
    NSString *clientSecrect = [NSString stringWithFormat:@"%@%@%@",[commonUsedMethods getSalt],[dic valueForKey:@"name"],@""];
    [url appendString:[commonUsedMethods returnMD5Hash:clientSecrect]];
    url = [[url stringByReplacingOccurrencesOfString:@" " withString:@"%20"] mutableCopy];
    NSLog(@"%@",url);
    
    return url;
    
}
- (void)requestDidFail:(ASIHTTPRequest *)request
{
    
    NSLog(@"profile image download failded");
    
}
- (void)imageQueueDidFinish:(ASIHTTPRequest *)request
{
    NSLog(@"imageQueueDidFinish");
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
    

}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
      NSString *aStr = [[NSString alloc] initWithData:webData encoding:NSASCIIStringEncoding];
    	NSLog(@"%@",aStr);
    switch (requestTag) {
            
        case PROFILE_URL_TAG:
            [self getProfileImageURL:aStr];
            break;
        case PROFILE_IMAGE_TAG:
            [self profileImageDownload:webData];
            break;
        case LOGIN_TAG:
            [self loginStringParse:aStr];
            break;
        
        default:
            break; 
    }
    [aStr release];
    
}

///////   PARSING ISSUES 
-(void) getProfileImageURL:(NSString *)_string
{ 
    SBJSON * json2 = [[SBJSON alloc]init];
    NSMutableDictionary *_dictionary = [json2 objectWithString:_string error:nil];
    NSMutableDictionary *dic = [[SingletonClass sharedInstance] getFbDictionary];
    NSLog(@"%@",_dictionary);
    if([_dictionary valueForKey:@"picture"])
    {
        [dic addEntriesFromDictionary:_dictionary];
         NSLog(@"%@",dic);
        
        tokeInfo *tokeninfo = [[SingletonClass sharedInstance] getTokenInformation];
         tokeninfo.imgURL = [_dictionary valueForKey:@"picture"];
        [[SingletonClass sharedInstance] setFbDictionary:dic];
        [self getProfileImageRequest:[requestStringURLs getProfileImageData:[[SingletonClass sharedInstance] getFbDictionary]]];
    }
    [json2 release];
}

-(void) loginStringParse:(NSString *)_string
{
    SBJSON * json2 = [[SBJSON alloc]init];
	NSMutableDictionary *temp = [json2 objectWithString:_string error:nil];
    NSMutableDictionary *errorData= [temp valueForKey:@"response"];
    if(![[NSNull null] isEqual:[errorData valueForKey:@"status"]] && ![[errorData valueForKey:@"status"] isEqualToString:@"OK"])
    {
       // NSMutableArray *errorArray = [errorData valueForKey:@"errors"];
        return;
    }
	
	NSMutableDictionary *tempData= [temp valueForKey:@"data"];
	NSMutableDictionary *temp2= [tempData valueForKey:@"user_token"]; 
    
    // NSLog(@"%@",temp2.descriptionInStringsFileFormat);
    tokeInfo *e1 = [[tokeInfo alloc] init];
    
    if ([temp2 valueForKey:@"id"])
        e1.iden=[temp2 valueForKey:@"id"];
    if ([temp2 valueForKey:@"profile_picture"])
        e1.imgURL=[temp2 valueForKey:@"profile_picture"];
    if ([temp2 valueForKey:@"assess_token"])
        e1.accessToken=[temp2 valueForKey:@"assess_token"];
    if ([temp2 valueForKey:@"full_name"])
    {
        e1.name=[temp2 valueForKey:@"full_name"];
        e1.userName=[temp2 valueForKey:@"full_name"];
    }
    [[SingletonClass sharedInstance] setTokenInformation:e1];
    [json2 release];
}



@end
