//
//  editPetViewController.m
//  Petstagram
//
//  Created by Awais Ahmad Qureshi on 5/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "editPetViewController.h"
#import "settingValues.h"
#import "SingletonClass.h"
#import "petsObject.h"
#import "requestStringURLs.h"
#import "headerfiles.h"
@interface editPetViewController (Private)
-(void) setDetailItem:(petsObject *)_petObject;

@end

@implementation editPetViewController
@synthesize isEditMode;
@synthesize petName,breedName,badgeName;
@synthesize petobject;
// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil  Editable:(BOOL)_bool {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
		isEditMode = _bool;
    }
    return self;
}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
   [super viewDidLoad];
	if(!isEditMode)
	{
		self.title =@"Pet info";
		self.navigationItem.rightBarButtonItem =  [[[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStyleDone target:self action:@selector(addNewPetPressed:)] autorelease];
	}
	else
	{
		self.title =@"Edit pet";
		self.navigationItem.rightBarButtonItem =  [[[UIBarButtonItem alloc] initWithTitle:@"Update" style:UIBarButtonItemStyleDone target:self action:@selector(addNewPetPressed:)] autorelease];
	    [self setDataInTextField];
	}
	 
}

-(void) setDataInTextField
{
	petName.text = petobject.petName;
	
}
-(IBAction) addNewPetPressed:(id)sender
{
	[self removeKeyBoard];
	[self syncOnThreadAction];
}
-(void) removeKeyBoard
{
	[petName resignFirstResponder];
	[breedName resignFirstResponder];
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
/*
- (void)viewDidDisAppear:( {
    [super viewDidUnload];
	//overlay.delegate= nil;
	//self.petName=nil;
	//self.breedName=nil;
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}*/
- (void)viewDidUnload {
    [super viewDidUnload];
	//overlay.delegate= nil;
	//self.petName=nil;
	//self.breedName=nil;
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
/*
-(void)setView:(UIView*)aView {
	if (!aView){
		//set outlets to nil here
		self.petName = nil;
		self.breedName = nil;
		self.badgeName = nil;
	}
	[super setView:aView];
}*/
-(void) syncOnThreadAction
{
		overlay = [[SingletonClass sharedInstance] getOverlay];
		//[overlay setDelegate:self];
	
}
//pet_name=Hoppy&tags=
-(NSString *)getNewPetDataString
{
	//NSString *tempString = [[[NSString alloc] init] autorelease];
	//tempString = [tempString stringByAppendingFormat:@"pet_name=%@",petName.text];
	//tempString = [tempString stringByAppendingFormat:@"pet_id=%@",petobject.];
	//tempString = [tempString stringByAppendingFormat:@"&tags=%@",breedName.text];
	//[tempString release];
	//return tempString;
	return @"pet_name=Hoppy&tags=dog,jackrussell,black";
}
#pragma mark ParserProtocolDelegate
-(void) userFeedData:(NSDictionary *)_dictionary
{
	[overlay dismiss];
	if (![[NSNull null] isEqual:[_dictionary valueForKey:@"code"]] && [[_dictionary valueForKey:@"code"] intValue] == 200)
	{
		[self loadAlertView:@"Success" :@"New Pet is added"];
	}
	else if (![[NSNull null] isEqual:[_dictionary valueForKey:@"code"]] && [[_dictionary valueForKey:@"code"] intValue] == 400)
	{
		[self loadAlertView:@"Sorry" :@"you feed can't be update now"];
	}
	
}
#pragma mark clientProtocolDelegate

-(void) notfiyResponse:(NSNumber *)_value
{
	[overlay dismiss];
	[self loadAlertView:@"Sorry" :@"Internet Connection not available"];
		
}
-(void) loadAlertView:(NSString *)_title1:(NSString *)_msg
{
	UIAlertView *alert = [[UIAlertView alloc] 
						  initWithTitle:_title1 
						  message:_msg 
						  delegate:self 
						  cancelButtonTitle:@"OK" 
						  otherButtonTitles:nil];
	[alert show];
	[alert release];
	
}



- (void)dealloc {
	[petobject release];
	[petName release];
	[breedName release];
	[badgeName release];
    [super dealloc];
}


@end
