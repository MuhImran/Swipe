//
//  addCommentViewController.m
//  Petstagram
//
//  Created by Awais Ahmad Qureshi on 5/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "addCommentViewController.h"
#import "DataModel.h"
#import "SingletonClass.h"
#import "settingValues.h"
#import "requestStringURLs.h"
#import "commonUsedMethods.h"
#import "Font+size.h"
#import "headerfiles.h"

@implementation addCommentViewController

@synthesize delegate;
@synthesize segmentIndex;
@synthesize textView1;
//@synthesize  delegate;

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withDelegate:(id)_delegate photo:(int)_id{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        Iden = _id;
        delegate = _delegate;
    }
    return self;
}
  


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	self.title = @"Add Comment";
	//UIBarButtonItem *submitButton = [[UIBarButtonItem alloc] initWithTitle:@"Post" style:UIBarButtonItemStylePlain target:self action:@selector(submitButtonPressed:)];          
	//self.navigationItem.rightBarButtonItem = submitButton;
	//[submitButton release];
    
    
    
    // New navigation and button code eith effects
    
    UINavigationItem *item = self.navigationItem;
    item.titleView =  [commonUsedMethods navigationlogoView];
    
    item.rightBarButtonItem = [commonUsedMethods navigationButtonWithText:@"Post":FALSE];
    UIButton* rightButton = (UIButton*)item.rightBarButtonItem.customView;
    [rightButton addTarget:self action:@selector(submitButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    
    item.leftBarButtonItem = [commonUsedMethods navigationButtonWithText:@"Back":TRUE];
    UIButton* leftButton = (UIButton*)item.leftBarButtonItem.customView;
    [leftButton addTarget:self action:@selector(backButtonMethod) forControlEvents:UIControlEventTouchUpInside];
    
    // code end
    
   
    /*
    UIImage *image=[UIImage imageNamed:@"postz.png"];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.bounds =  CGRectMake(0, 0, 72, 30);//[Font_size getNavRightButtonFrame];     
    [button setBackgroundImage:image forState:UIControlStateNormal];
    [button addTarget:self action:@selector(submitButtonPressed:) forControlEvents:UIControlEventTouchUpInside];    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = barButtonItem;
    [barButtonItem release];
  // [[GPS_Object sharedInstance] startUpdatingLocating:nil];
    
    
    UIImage *image1=[UIImage imageNamed:@"back.png"];
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    button1.bounds = CGRectMake(0, 0, 72, 30);//[Font_size getNavRightButtonFrame];     
    [button1 setBackgroundImage:image1 forState:UIControlStateNormal];
    
    //UIImage *image=[UIImage imageNamed:@"settings.png"];
    //UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    //button.bounds = [Font_size getNavRightButtonFrame];     
    [button1 setBackgroundImage:image1 forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(backButtonMethod) forControlEvents:UIControlEventTouchUpInside];    
    UIBarButtonItem *barButtonItem1 = [[UIBarButtonItem alloc] initWithCustomView:button1];
    self.navigationItem.leftBarButtonItem = barButtonItem1;
    [barButtonItem1 release];
     */
    
}

-(void) backButtonMethod
{
    [self.navigationController popViewControllerAnimated:YES];
}    

-(void)viewWillAppear:(BOOL)animated 
{
    [super viewWillAppear:animated];
	[self.navigationController setNavigationBarHidden:NO];
    textView1.text=@"";
	[textView1 becomeFirstResponder];
	
}
-(void) setDetailItem:(id)_delegate photo:(int)_id
{
    Iden = _id;
    delegate = _delegate;
}
/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/
-(IBAction) submitButtonPressed:(id)sender
{
	if([[self stripDoubleSpaceFrom:textView1.text] length] > 0)
		[self syncOnThreadAction:[commonUsedMethods stripDoubleSpaceFrom:textView1.text]]; 
	else
		[self loadAlertView:@"To short character to add as comments"];
	
}

- (NSString *)stripDoubleSpaceFrom:(NSString *)_str {
	NSString *str = [[_str componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@" "];
    while ([str rangeOfString:@"  "].location != NSNotFound) {
        str = [str stringByReplacingOccurrencesOfString:@"  " withString:@" "];
    }
    str = [str stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    return str;
}
-(void) syncOnThreadAction:(NSString *)_str
{
    overlay = [[SingletonClass sharedInstance] getOverlay];
    [overlay setDelegate:self];
	[textView1 resignFirstResponder];
	[overlay setUserComments:[requestStringURLs getUserCommentsRequest:[NSNumber numberWithInt:Iden]:_str]];
}

#pragma mark ParserProtocolDelegate
-(void) userFeedData:(NSDictionary *)_dictionary
{
	[overlay dismiss];
	
	[overlay setDelegate:nil];
    if([_dictionary valueForKey:@"status"] && [[_dictionary valueForKey:@"status"] isEqualToString:@"OK"])
    {
        if(delegate && [delegate respondsToSelector:@selector(commentHasAdded::)])
            [delegate performSelector:@selector(commentHasAdded::) withObject:[self stripDoubleSpaceFrom:textView1.text] withObject:[NSNumber numberWithInt:Iden]];
        delegate =nil;
        [self.navigationController popViewControllerAnimated:NO];
        
    } 
	else  if([_dictionary valueForKey:@"status"] && [[_dictionary valueForKey:@"status"] isEqualToString:@"ERROR"])
    {
        NSMutableDictionary *errorDic = [[_dictionary valueForKey:@"errors"] objectAtIndex:0];
        [self loadAlertView:[errorDic valueForKey:@"message"]];
        
        
    }
}
#pragma mark clientProtocolDelegate

-(void) notfiyResponse:(NSNumber *)_value
{
	[overlay dismissError];

	[self loadAlertView:@"Internet connection not available"];

}
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
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        self.textView1.text = [commonUsedMethods stripDoubleSpaceFrom:self.textView1.text];
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
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
	return YES;
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

- (void)dealloc {
	[textView1 release];
    [super dealloc];
}


@end
