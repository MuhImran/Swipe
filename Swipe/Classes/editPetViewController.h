//
//  editPetViewController.h
//  Petstagram
//
//  Created by Awais Ahmad Qureshi on 5/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OverlayViewController.h"
#import "clientObject.h"
#import "ParserObject.h"
@class petsObject;
@interface editPetViewController : UIViewController<overlayDelegate,ParserProtocolDelegate,clientProtocolDelegate,UITextFieldDelegate> {
  
	OverlayViewController				*overlay;
	BOOL								overScreen,isEditMode;
	IBOutlet UITextField                *petName,*breedName,*badgeName;
	petsObject							*petobject;
   
}

@property (nonatomic,retain) IBOutlet UITextField *petName,*breedName,*badgeName;
@property (nonatomic,retain) petsObject	 *petobject;
@property BOOL isEditMode;
-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil  Editable:(BOOL)_bool;
-(void) loadAlertView:(NSString *)_title1:(NSString *)_msg;
-(void) setDataInTextField;
-(NSString *)getNewPetDataString;
-(void) syncOnThreadAction;
-(void) removeKeyBoard;
@end
