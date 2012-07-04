//
//  settingViewController.m
//  Petstagram
//
//  Created by Awais Ahmad Qureshi on 5/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "settingViewController.h"
#import "EnvetFinderDelegate.h"

#import "commonUsedMethods.h"
#import "requestStringURLs.h"


#import "SingletonClass.h"
#import "settingValues.h"
#import "userProfile.h"
#import "DataModel.h"


@implementation settingViewController
@synthesize userName;
@synthesize signOutButton;
@synthesize passTextFiend,emailTextFiend;
@synthesize notificationRinger;
@synthesize scrollView;
@synthesize userButton, checkOutButton,passwordButton;
@synthesize theGuest,theWallPost,theComment,theEvent,theDeal,theMessage;
@synthesize user;

- (void)viewDidLoad {
    [super viewDidLoad];
    UINavigationItem *item = [self.navigationController.navigationBar.items objectAtIndex:0];
    item.title = @"SWIPE";
    
    item.rightBarButtonItem = [commonUsedMethods navigationButtonWithText:@"Add":FALSE];
    UIButton* rightButton = (UIButton*)item.rightBarButtonItem.customView;
    [rightButton addTarget:self action:@selector(syncButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    item.leftBarButtonItem = [commonUsedMethods navigationButtonWithText:@"Back":TRUE];
    UIButton* leftButton = (UIButton*)item.leftBarButtonItem.customView;
    [leftButton addTarget:self action:@selector(backButtonMethod) forControlEvents:UIControlEventTouchUpInside];

	
  
}
-(void) handleGeneralLobbyUser
{
  
    
}
-(IBAction)userButtonPressed:(id)sender
{
    NSLog(@"Button pressed now");
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"Thank you for using LF!" 
                          message:@"Please sign-in with the same User ID (Facebook, Lobbyfriend) by obtaining a new PIN "  
                          delegate:self 
                          cancelButtonTitle:@"Ok"
                          otherButtonTitles:nil,nil];
    [alert setTag:2];
    [alert setDelegate:self];  
    [alert show];
    [alert release];
}
-(void)viewWillAppear:(BOOL)animated 
{
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:NO];
}

-(IBAction) backMethod:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


-(IBAction) doneButtonPressed:(id)sender
{
   if(isEdit)
   {
    reqType = 2;
    [self syncOnThreadAction];
   }
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    
}
-(IBAction) singOutPressed:(id)sender
{
	    
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"Thank you for using LF!" 
                          message:@"Please sign-in with the same User ID (Facebook, Lobbyfriend) to avoid requiring a new PIN when you check-in again"  
                          delegate:self 
                          cancelButtonTitle:@"Ok"
                          otherButtonTitles:nil,nil];
    [alert setTag:1];
    [alert setDelegate:self];  
    [alert show];
    [alert release];
    	
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 1)
    {
    reqType = 1;
	[self syncOnThreadAction];
    }
    else if(alertView.tag == 2)
    {
        reqType = 3;
        [self syncOnThreadAction];
    } 
}


-(void) callDelegateLogout
{
    if(reqType == 1)
    {
	[self.navigationController popToRootViewControllerAnimated:NO];
	EnvetFinderDelegate *appDelegate = (EnvetFinderDelegate *)[[UIApplication sharedApplication] delegate];
	[appDelegate performSelector:@selector(logout) withObject:nil afterDelay:0.0];
    }
    else if (reqType == 3)
    {
    
         EnvetFinderDelegate *appDelegate = (EnvetFinderDelegate *)[[UIApplication sharedApplication] delegate];
        [appDelegate performSelector:@selector(expirePinNow) withObject:nil afterDelay:0.0];
    }
	
}

-(void) syncOnThreadAction
{
	
	overlay = [[SingletonClass sharedInstance] getOverlay];
    [overlay setDelegate:self];
	 if(reqType == 1)
	   [overlay logOffCurrentUser];
	else  if(reqType == 2)
		 [overlay updateCurrentUser:[self getUpdateUserString]];
    else  if(reqType == 3)
        [overlay ExpireLoggedUserPin];
	
}
-(NSString *) getUpdateUserString
{
   // userProfile *userprofile = [[DataModel getDataInDictionary:USERPROFILE_TAB] objectAtIndex:0];
    NSMutableString *parameter = [[[NSMutableString alloc] init] autorelease];
    [parameter setString:@""];
    if(isPasswordChange)
        [parameter appendString:[NSString stringWithFormat:@"&password=%@",passTextFiend.text]];
  //  if([emailTextFiend.text length] > 0)
    //    [parameter appendString:[NSString stringWithFormat:@"&email=%@",emailTextFiend.text]];
   
    if(theGuest.on ||  theWallPost.on || theComment.on || theEvent.on || theMessage.on )
    {
        NSString *str = @"";
        BOOL success = FALSE;
        if(theWallPost.on)
        {
            success = TRUE;
            str = [str stringByAppendingString:@"new_post_wall"];
        }
         if(theGuest.on)
        {
            
            if(success)
              str = [str stringByAppendingString:@",new_guest_check"];
            else
                str = [str stringByAppendingString:@"new_guest_check"];
            success = TRUE;
        }
        if(theComment.on)
        {
            if(success)
            str = [str stringByAppendingString:@",new_comment_wall"];
            else
                str = [str stringByAppendingString:@"new_comment_wall"];
            success = TRUE;
        }
        if(theEvent.on)
        {
            if(success)
            str = [str stringByAppendingString:@",hotel_post_info"];
            else
                str = [str stringByAppendingString:@"hotel_post_info"];
            success = TRUE;
        }
        if(theMessage.on)
        {
            if(success)
            str = [str stringByAppendingString:@",receive_mess"];
            else
                str = [str stringByAppendingString:@"receive_mess"];
            success = TRUE;
        }
        
        [parameter appendString:[NSString stringWithFormat:@"&isettings=%@",str]];
    }
   else
   {
        [parameter appendString:[NSString stringWithFormat:@"&isettings=iphone"]];
   }
    NSLog(@"%@",parameter);
    return parameter;

}

#pragma mark ParserProtocolDelegate
-(void) loginResponse:(NSNumber *)_value
{
	if([_value intValue] == 1)
	{
		if(reqType == 1)
        {
        [overlay dismissSuccess];    
		[self callDelegateLogout];
        }
        else if(reqType == 2)
        {
            [overlay dismissSuccess];
            [self.navigationController popViewControllerAnimated:YES];
        }
        else if(reqType == 3)
        {
            [overlay dismissSuccess];    
            [self callDelegateLogout];
        }
	}  
}
#pragma mark clientProtocolDelegate
-(void) notfiyResponse:(NSError *)_error
{
	
}
-(IBAction) backInViewTouch:(id)sender
{
    [self.emailTextFiend resignFirstResponder];
}
-(IBAction) switchValueChange:(id)sender
{
    UISwitch *thisSwitch = (UISwitch *)sender;
    isEdit = TRUE;
    if(thisSwitch.tag==1)
    {
        
    }
    else if(thisSwitch.tag==2)
    {
        
    }
    else if(thisSwitch.tag==3)
    {
        
    }
    else if(thisSwitch.tag==4)
    {
        
    }
    else if(thisSwitch.tag==5)
    {
        
    }
    else if(thisSwitch.tag==6)
    {
        
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{   
     self.emailTextFiend.text = [commonUsedMethods trimString:self.emailTextFiend.text];
    if(![commonUsedMethods emailValidate:self.emailTextFiend.text ])
    {
        [AppDelegate showAlertView:@"Email not in proper format"];
    }
    else
    {
    [textField resignFirstResponder];
        isEdit = TRUE;
		return YES;
    }
    return TRUE;
}

- (void)dealloc {
	[theGuest release];
	[theWallPost release];
	[theComment release];
	[theEvent release];
	[signOutButton release];
	[userName release];
	[passTextFiend release];
	[emailTextFiend release];
	[notificationRinger release];
    [passwordButton release];
    [super dealloc];
}
-(IBAction) changePasswordPressed:(id)sender
{
      
}
#pragma mark passwordDelegate
-(void) passwordText:(NSString *) _str
{
    self.passTextFiend.text=_str;
    isEdit = TRUE;
    isPasswordChange = TRUE;
}


@end
