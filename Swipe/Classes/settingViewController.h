//
//  settingViewController.h
//  Petstagram
//
//  Created by Awais Ahmad Qureshi on 5/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.


#import <UIKit/UIKit.h>
#import "ParserObject.h"
#import "clientObject.h"
#import "OverlayViewController.h"

@class userProfile;
@interface settingViewController : UIViewController<ParserProtocolDelegate,clientProtocolDelegate,UITextFieldDelegate,overlayDelegate> {
	
    IBOutlet UITextField		*userName;
	OverlayViewController		*overlay;
	BOOL						overScreen,isEdit,isPasswordChange;
	
	IBOutlet UIButton			*signOutButton;
	IBOutlet UITextField		*passTextFiend,*emailTextFiend;
	IBOutlet UISegmentedControl *notificationRinger;
	int							reqType;	
    IBOutlet UIScrollView       *scrollView;
    IBOutlet UIButton			*userButton, *checkOutButton,*passwordButton;
    IBOutlet UISwitch			*theGuest,*theWallPost,*theComment,*theEvent,*theDeal,*theMessage;
    userProfile                 *user;

}

@property (nonatomic, retain)  userProfile                 *user;
@property (nonatomic, retain) IBOutlet UISwitch *theGuest,*theWallPost,*theComment,*theEvent, *theDeal,*theMessage;
@property (nonatomic, retain) IBOutlet UIButton	*userButton, *checkOutButton;
@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (retain,nonatomic)  IBOutlet UITextField *passTextFiend,*emailTextFiend;
@property (retain,nonatomic)  IBOutlet UISegmentedControl *notificationRinger;

@property (retain,nonatomic)  IBOutlet UIButton	*signOutButton,*passwordButton;
@property (retain,nonatomic)  IBOutlet UITextField *userName;

-(void) handleGeneralLobbyUser;
-(IBAction) singOutPressed:(id)sender;
-(IBAction) switchValueChange:(id)sender;
-(void) syncOnThreadAction;
-(IBAction) backMethod:(id)sender;
-(NSString *) getUpdateUserString;
-(IBAction) changePasswordPressed:(id)sender;
-(IBAction) backInViewTouch:(id)sender;
@end
