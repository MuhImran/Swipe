//
//  splashViewController.m
//  Petstagram
//
//  Created by Awais Ahmad Qureshi on 5/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "splashViewController.h"
#import "requestStringURLs.h"
#import "EnvetFinderDelegate.h"
#import "SingletonClass.h"

@implementation splashViewController
@synthesize activity;
@synthesize currentLocation;
//@synthesize isLocation;

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //isLocation = NO;
   // [[GPS_Object sharedInstance] startUpdatingLocating:self];
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    [AppDelegate clearAllCacheImage];
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
-(void) getUserFeed
{ 
	[activity startAnimating];
	reqType = 1;
	[self syncOnThreadAction];
}
-(void) syncOnThreadAction
{
	
    overlay = [[SingletonClass sharedInstance] getOverlay];
	overlay.delegate = self;
	if(reqType == 1)
	 [overlay getAuthorization:[requestStringURLs getLoginRequest]];
	else if(reqType == 2)
    {
		//[overlay getFeedData:[requestStringURLs getUserFeedRequest:FALSE]:FALSE];
        //[overlay geTopFeedRequest:[requestStringURLs getTopFeedRequest:FALSE]:FALSE];
        //if(isLocation)
        self.currentLocation = [[SingletonClass sharedInstance] getMyCurrentLocation];
        [overlay getNearByData:[requestStringURLs getUserNearByRequest:self.currentLocation :FALSE :0] :FALSE];
//        else
//            [self performSelector:@selector(LoadViewAgain) withObject:nil afterDelay:6.0];
       
	}
	
}

//-(void)LoadViewAgain
//{
//    NSLog(@"LoadAgainCalled %d",[[NSNumber numberWithBool:isLocation] intValue]);
//    [overlay getNearByData:[requestStringURLs getUserNearByRequest:self.currentLocation :FALSE] :FALSE];
//}

//#pragma mark GPXPointDelegate
//-(void) newGPXPoints:(NSNumber*)_boolValue:(CLLocation *)_newlocation
//{
//    if([_boolValue boolValue])
//    {
//        self.currentLocation = _newlocation;
//        isLocation = YES;
//        [overlay getNearByData:[requestStringURLs getUserNearByRequest:self.currentLocation :FALSE] :FALSE];
//    }
//    else
//    {
//        isLocation = NO;
//        
//        overlay.delegate=nil;
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" 
//                                                        message:@"Either location service is disable or issue in recognizing your location"
//                                                       delegate:nil
//                                              cancelButtonTitle:@"OK" 
//                                              otherButtonTitles: nil];
//        
//        [alert show];
//        [alert release];
//    }
//    
//}

#pragma mark ParserProtocolDelegate
-(void) loginResponse:(NSNumber *)_value
{
	if([_value intValue] == 1)
	{
		if(reqType == 1)
		{
			reqType = 2;
			[self syncOnThreadAction];
		}
		else if(reqType == 2)
		{
		     [self callNewView];
		}
	} 
    /*
	else {
		UIAlertView *myAlert = [[UIAlertView alloc] initWithTitle:@"Sorry"
														  message:@"Cant able to get feed."
														 delegate:nil 
												cancelButtonTitle:@"Ok" 
												otherButtonTitles:nil, nil];
		CGAffineTransform myTransform = CGAffineTransformMakeTranslation(0, 60);
		[myAlert setTransform:myTransform];
		[myAlert show];
		[myAlert release];*/
	
}
-(void) errorResponseData:(NSDictionary *)_dictionary
{
	[overlay dismiss];
    [self loadAlertView:@"":[_dictionary valueForKey:@"message"]];
	
}

-(void) ParserArraylist:(NSMutableArray *) _array
{
    //signInButton.enabled=YES;
	[overlay dismiss];
    [self callNewView];
}


#pragma mark clientProtocolDelegate

-(void) notfiyResponse:(NSNumber *)_value
{
	[activity stopAnimating];
    /*
	NSString	*msg = @"Internet connection error";
	UIAlertView *alert = [[UIAlertView alloc] 
						  initWithTitle:@"Sorry" 
						  message:msg 
						  delegate:self 
						  cancelButtonTitle:@"Retry" 
						  otherButtonTitles:nil];
	[alert show];
	[alert release];*/
    [self loadAlertView:@"":@"Internet connection error"];
	
}
-(void) loadAlertView:(NSString *)_title1:(NSString *)_msg
{
	UIAlertView *alert = [[UIAlertView alloc] 
						  initWithTitle:_title1 
						  message:_msg 
						  delegate:self 
						  cancelButtonTitle:@"Retry" 
						  otherButtonTitles:@"Cancel",nil];
	[alert show];
	[alert release];
	
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if(buttonIndex == 0)
		[self getUserFeed];
   else if(buttonIndex == 1)
   {
       EnvetFinderDelegate *appDelegate = (EnvetFinderDelegate *)[[UIApplication sharedApplication] delegate];
       [appDelegate performSelector:@selector(removeAllViews2) withObject:nil afterDelay:0.0];
   }
}

-(void) callNewView
{
    EnvetFinderDelegate *appDelegate = (EnvetFinderDelegate *)[[UIApplication sharedApplication] delegate];
	[appDelegate performSelector:@selector(showTabBarView) withObject:nil afterDelay:0.0];
}


- (void)dealloc {
	[activity release];
    [super dealloc];
}


@end
