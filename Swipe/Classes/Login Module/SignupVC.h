//
//  LoginViewCotroller.h
//  PosterCard
//
//  Created by Atif on 7/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ParserObject.h"
#import "clientObject.h"
#import "OverlayViewController.h"
#import "FacebookManager.h"
#import "socailConnectObject.h"
#import "GPS_Object.h"


@interface SignupVC : UIViewController <ParserProtocolDelegate,clientProtocolDelegate,UITextFieldDelegate,overlayDelegate,FBRequestDelegate, FBSessionDelegate,socialResponseDelegate, GPXDelegate>  
{
    
    BOOL                            haveProfileURL,isFaceBook,isRemembered,IsSignUpView;
    IBOutlet UIButton              *facebookButton,*SignIncancelButton,*viewSwitcherButtons;
    IBOutlet UITextField           *email,*newPassword,*newUserName,*newconfirmPassword;
    NSMutableDictionary             *fbDictionary;
    OverlayViewController           *overlay;
    int                             reqType;
    UIImage                         *profileImage;
    IBOutlet UILabel                *TCLabel;
    IBOutlet UIBarButtonItem        *barButtonItem;
    IBOutlet UIImageView            *topImageView;
    CGFloat                         animatedDistance;

}
@property (retain,nonatomic)   IBOutlet UIImageView            *topImageView;
@property (retain,nonatomic)   IBOutlet UIBarButtonItem                 *barButtonItem;
@property (retain,nonatomic)   IBOutlet UILabel                *TCLabel;
@property (retain,nonatomic)   UIImage                         *profileImage; 
@property (retain,nonatomic)   IBOutlet UIButton              *facebookButton,*SignIncancelButton,*viewSwitcherButtons;
@property (retain,nonatomic)   NSMutableDictionary             *fbDictionary;
@property (retain,nonatomic)   IBOutlet UITextField            *email,*newPassword,*newUserName,*newconfirmPassword;
/*************************** UserIBActions ***************************/


-(IBAction) signInMethod :(id)sender;
-(IBAction)signUpButtonPressed:(id)sender;
-(IBAction) backGroundTouch: (id)sender;
-(NSString *) getLoginRequest;
- (IBAction) dismissKeyboard:(id)sender;
-(void) syncOnThreadAction;
-(void) displayView;
-(IBAction) loginButtonPressed:(id)sender;
-(IBAction)signUpButtonPressed:(id)sender;
- (BOOL) validateAppLogin;
- (BOOL) validateAppRegistration;
-(void) clearTextFieldData;
-(void) getNewUserRequestFromFaceBookAPI;
-(void) callNewView;
-(NSString *) getNewUserRequest;
-(NSString *) getProfileImageURL;
-(NSString *) getProfileImageData;
@end
