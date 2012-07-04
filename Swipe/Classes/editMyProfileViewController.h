//
//  editMyProfileViewController.h
//  Petstagram
//
//  Created by Awais Ahmad Qureshi on 5/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OverlayViewController.h"
#import "clientObject.h"
#import "ParserObject.h"

@interface editMyProfileViewController : UIViewController<UINavigationControllerDelegate,overlayDelegate,ParserProtocolDelegate,clientProtocolDelegate,
															UIImagePickerControllerDelegate> {
	
		IBOutlet UITextField				*fullName;
		IBOutlet UIImageView				*picImageView;
		IBOutlet UISegmentedControl			*flushSwitch,*cameraSwitch;
		BOOL								isFlushOn,isFrontOn;
		BOOL								isfreshPicture,isRetakePicture;
		OverlayViewController				*overlay;
		BOOL								overScreen;

}
@property (retain,nonatomic) IBOutlet UITextField *fullName;
@property (retain,nonatomic) IBOutlet UIImageView *picImageView; 
-(IBAction) getLibraryPicture:(id)sender;
-(IBAction) getCameraPicture:(id)sender;
-(void) openCameraView;
-(void) loadAlertView:(NSString *)_title1:(NSString *)_msg;
@end
