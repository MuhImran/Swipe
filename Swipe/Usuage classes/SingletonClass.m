//
//  SingletonClass.m
//  FindASitter
//
//  Created by svp on 29/11/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SingletonClass.h"
#import "clientObject.h"
#import "ParserObject.h"
#import "OverlayViewController.h"
#import "commonUsedMethods.h"
#import "EnvetFinderDelegate.h"
#import "requestStringURLs.h"
#import "profileImageFetcher.h"
#import "socailConnectObject.h"

@implementation SingletonClass
@synthesize client;
@synthesize parser;
@synthesize overlay;
@synthesize imageDictionary,fbDictionary;
@synthesize tokeninfo;
@synthesize currentLocation;
@synthesize profileImage;
@synthesize pushKey;
@synthesize socialObj;

static SingletonClass *sharedInstance = nil;

// Get the shared instance and create it if necessary.
+ (SingletonClass*)sharedInstance {
    if (sharedInstance == nil) {
        sharedInstance = [[super allocWithZone:NULL] init];
		
    }
	
    return sharedInstance;
}

-(id)init {
	if ((self = [super init])) {
		clientObject *obj = [[clientObject alloc] init];
		self.client = obj;
	    ParserObject *obj2 = [[ParserObject alloc] init];
		self.parser= obj2;
        tokeInfo *token = [[tokeInfo alloc] init];
		self.tokeninfo= token;
       // CLLocation *loc = [[CLLocation alloc] init];
	//	self.currentLocation= loc;
		OverlayViewController *obj3 = [[OverlayViewController alloc] initWithNibName:@"OverlayView" bundle:[NSBundle mainBundle]];
		self.overlay= obj3;
		imageDictionary = [[NSMutableDictionary alloc] init];
        
        NSMutableDictionary *dic =  [[NSMutableDictionary alloc] init];
        self.fbDictionary = dic;
        pushKey = [[NSString alloc] init];
        socialObj = [[socailConnectObject alloc] init];
	}
	
	return self;
}

// We don't want to allocate a new instance, so return the current one.
+ (id)allocWithZone:(NSZone*)zone {
    return [[self sharedInstance] retain];
}

// Equally, we don't want to generate multiple copies of the singleton.
- (id)copyWithZone:(NSZone *)zone {
    return self;
}

// Once again - do nothing, as we don't have a retain counter for this object.
- (id)retain {
    return self;
}

// Replace the retain counter so we can never release this object.
- (NSUInteger)retainCount {
    return NSUIntegerMax;
}

// This function is empty, as we don't want to let the user release this object.
- (void)release {
	
}


//Do nothing, other than return the shared instance - as this is expected from autorelease.
- (id)autorelease {
    return self;
}

-(clientObject *) getClientObject
{
	return client;
}
-(ParserObject *) getParser
{
	return parser;
}
-(OverlayViewController *) getOverlay
{
	return overlay;
}
-(void) setTokenInformation:(tokeInfo *)_tokeninfo
{
    self.tokeninfo = _tokeninfo;
}
-(tokeInfo *) getTokenInformation
{
    return self.tokeninfo;
}


-(void)setDelegateNull
{
	//[client makeDelegateNull];
}
-(NSMutableDictionary *) getImageDictionary
{
	return imageDictionary;
}


-(UIImage *) getCacheImage:(NSString *)_key
{
	NSLog(@"%@",_key);
    NSString *uniquePath = [NSTemporaryDirectory() stringByAppendingPathComponent:[commonUsedMethods getFileNameFromURL:_key]];
	
	if([[NSFileManager defaultManager] fileExistsAtPath: uniquePath])
	{
		uniquePath = [uniquePath stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
		uniquePath  = [@"//" stringByAppendingString:uniquePath];	
	}
	
	return [UIImage imageWithContentsOfFile:uniquePath];
	
}
/*
-(BOOL) checkCacheImage:(NSString *)_key
{
	//NSLog(@"%@",_key);
    if([_key length] == 0)
        return FALSE;
	NSString *uniquePath = [NSTemporaryDirectory() stringByAppendingPathComponent:[commonUsedMethods getFileNameFromURL:_key]];
	if([[NSFileManager defaultManager] fileExistsAtPath: uniquePath])
		return TRUE;
	return FALSE;
	
}*/
-(void) setCacheImage:(UIImage *)_img:(NSString *)_key
{
		NSData *data;// = UIImageJPEGRepresentation(image, 1.0);
	
	
	if([_key rangeOfString: @".png" options: NSCaseInsensitiveSearch].location != NSNotFound)
	{
		data = UIImagePNGRepresentation(_img);
	}
	else if(
			[_key rangeOfString: @".jpg" options: NSCaseInsensitiveSearch].location != NSNotFound || 
			[_key rangeOfString: @".jpeg" options: NSCaseInsensitiveSearch].location != NSNotFound
			)
	{
		data = UIImageJPEGRepresentation(_img, 1.0);
	}
	else
		data = UIImageJPEGRepresentation(_img, 1.0);
		
	
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSString *documentsDirectory = NSTemporaryDirectory();
	NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:[commonUsedMethods getFileNameFromURL:_key]];
	//NSLog(@"%@",fullPath);
	[fileManager createFileAtPath:fullPath contents:data attributes:nil];
	// [delegate appImageDidLoad:self.indexPathInTableView];
	
}
-(void) handleMemoryWarning
{
	NSLog(@"At singleton class handling memoryWarning");
	[imageDictionary removeAllObjects];
	//TapFormsAppDelegate *appDelegate = (TapFormsAppDelegate *)[[UIApplication sharedApplication] delegate];
	EnvetFinderDelegate *appDelegate = (EnvetFinderDelegate *)[[UIApplication sharedApplication] delegate];
	[appDelegate clearAllCacheImage];
	
}

-(void) setMyCurrentLocation:(CLLocation *)_location
{
    if(!self.currentLocation)
    {
        self.currentLocation = [[CLLocation alloc] init];
    }
        self.currentLocation = _location;
}
-(CLLocation *) getMyCurrentLocation
{
    if(self.currentLocation)
        return self.currentLocation;
    return 0;
    //NSLog(@"%@",self.currentLocation);
    //return self.currentLocation;
}
-(void) setFaceBookDictionary:(NSMutableDictionary *)_fbDictionary
{
  
     self.fbDictionary   = _fbDictionary; //addEntriesFromDictionary:_fbDictionary];
}
-(void) requestForProfileURL
{
    self.overlay.delegate = self; 
   [overlay getProfileURL:[requestStringURLs getProfileImageURL:self.fbDictionary]];
}
#pragma mark Parser Response
-(void) userFeedData:(NSDictionary *)_dictionary
{
    [self.fbDictionary addEntriesFromDictionary:_dictionary];
    NSLog(@"%@",self.fbDictionary);
   
}
-(void) profileImageDownload:(NSMutableData *)_imageData
{
    UIImage *image = [[UIImage alloc] initWithData:_imageData];
	
	if(image)
    {
        self.profileImage = image;
         self.overlay.delegate = self;
        [overlay editPersonnalInfo:[requestStringURLs UpdateProfileURL]:self.profileImage];
    }
   // [self syncOnThreadAction];
    [image release];   
    
}
-(void) loginResponse:(NSNumber *)_value
{
	
	
         self.overlay.delegate = nil; 
        [overlay getAuthorization:[requestStringURLs getLoginRequest]];
}

-(NSMutableDictionary *) getFbDictionary
{
    return self.fbDictionary;
    
}

-(NSString *) getProfileImageURL
{
    
    
    NSMutableString *url = [[[NSMutableString alloc] init] autorelease];
    [url setString:[NSString stringWithFormat:@"http://graph.facebook.com/%@/?fields=picture&type=small",[self.fbDictionary objectForKey:@"id"]]];
   // NSLog(@"%@",url);
    
    return url;
    
}
-(NSString *) getProfileImageData
{
    NSMutableString *url = [[[NSMutableString alloc] init] autorelease];
    [url setString:[NSString stringWithFormat:[self.fbDictionary objectForKey:@"picture"]]];
    NSLog(@"%@",url);
    return url;
    
}
-(void) saveUserPushKey:(NSString *)_key
{
    self.pushKey = _key;
    
    
}
-(NSString *) getUserPushKey
{
    return self.pushKey;
    
}

-(socailConnectObject *) getSocialObject
{
    return self.socialObj;
}

@end
