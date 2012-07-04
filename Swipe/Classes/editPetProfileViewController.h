//
//  editPetProfileViewController.h
//  Petstagram
//
//  Created by Awais Ahmad Qureshi on 5/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataSelecterViewController.h"
#import "OverlayViewController.h"
#import "clientObject.h"
#import "ParserObject.h"
#import "profilePicViewController.h"
#import "socailConnectObject.h"
#import "SliderCell.h"

@class petsObject;
@class userProfile;
@interface editPetProfileViewController : UIViewController <UIActionSheetDelegate,dataSelectDelegate,ParserProtocolDelegate,                                                clientProtocolDelegate,UITextFieldDelegate,overlayDelegate,profilePictureDelegate,socialResponseDelegate> {
    
    IBOutlet UITableView		*settingTable;
	NSMutableArray				*dataArray;
    IBOutlet UIView             *tableHeaderView,*navigationTiteView;
    IBOutlet UIImageView        *userProfileImage,*navProfileImage;
	IBOutlet UILabel            *userName,*navUserName;
    BOOL                         NewPush,overScreen;
    int                         updateType,reqType;
	OverlayViewController       *overlay;
    IBOutlet  UIActivityIndicatorView  *profileActivity;
    userProfile                 *userprofile;
    NSMutableData               *picDownload;
    BOOL                        isNewPhoto,resingKeyBoard;
    UIImage                     *newPhoto;
    IBOutlet UISegmentedControl *segmentedControl;  
    socailConnectObject             *socailObject;
    SliderCell *cellSlider;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withProfileData:(userProfile *)_profile;
@property (retain,nonatomic) userProfile                 *userprofile;
@property (retain,nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (retain,nonatomic) UIImage  *newPhoto;
@property (retain,nonatomic) IBOutlet UIDatePicker   *datePicker;
@property (retain,nonatomic) IBOutlet UILabel  *userName,*navUserName;
@property (retain,nonatomic) IBOutlet UIImageView  *userProfileImage,*navProfileImage;
@property (retain,nonatomic) IBOutlet UIView  *tableHeaderView,*navigationTiteView;
@property (retain,nonatomic) IBOutlet UITableView  *settingTable;
@property (retain,nonatomic)  IBOutlet   UIActivityIndicatorView  *profileActivity;
@property (retain,nonatomic) NSMutableData       *picDownload;
@property (retain,nonatomic) SliderCell *cellSlider;
-(void) loadAlertView:(NSString *)_msg;
-(void) syncOnThreadAction;
-(IBAction) segmentValueChange:(id)sender;
-(void)changeProfileImage;
-(BOOL) validatePersonalData;
-(void) hideKeyBoardIfVisible:(NSIndexPath *)indexPath;
-(NSString *) getPersonalProfileURL;
-(void) createNavigationTitleView;
-(void) saveNewProfilePhotoToToken;
- (void)hideKeybaordViewIfAny;
-(void) singOutButtonPressed;
-(void)sliderChanged:(id)sender;
@end