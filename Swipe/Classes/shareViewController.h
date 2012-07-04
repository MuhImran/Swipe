//
//  browseViewController.h
//  Petstagram
//
//  Created by Haris Jawaid on 4/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OverlayViewController.h"
#import "clientObject.h"
#import "ParserObject.h"
#import "FacebookManager.h"
#import "SA_OAuthTwitterController.h"  
#import "SA_OAuthTwitterEngine.h"
#import "addEmailViewController.h"
#import "GPS_Object.h"
#import <MapKit/MapKit.h>

#import "socailConnectObject.h"


//#define kOAuthConsumerKey				@"kVC8qDOsOBMtDoyZZgNHw"							//REPLACE With Twitter App OAuth Key  
//#define kOAuthConsumerSecret			@"IWJ6EazbqHnYHhYFlxPhkDCZU29hUTz5b7Wc9NzNeM"		//REPLACE With Twitter App OAuth Secret


@interface shareViewController : UIViewController <ParserProtocolDelegate,clientProtocolDelegate,UITextFieldDelegate,overlayDelegate,FBRequestDelegate,
													FBSessionDelegate,SA_OAuthTwitterControllerDelegate,emailConfigureDelegate,GPXDelegate, MKReverseGeocoderDelegate,socialResponseDelegate> {
	
	IBOutlet UITextField		*titlField,*locationField;
    IBOutlet UIImageView		*profileImageView,*photoImageView;                                                    
    IBOutlet UIScrollView       *scrollView;
	IBOutlet UISwitch			*facebookSwith;
	IBOutlet UITableView		*shareTableView;
	IBOutlet UITextView        *descText;
	NSArray						*dataArray;
	OverlayViewController       *overlay;
	BOOL						overScreen,FBShare,TWShare;
	SA_OAuthTwitterEngine		*_engine;
	addEmailViewController      *AMVC;
	
	UIImage						*image;
    CLLocation                  *currentLocation;
    int                          option;
    MKReverseGeocoder            *reverseGeocoder;
    MKPlacemark                  *placemark;                                       
    CGFloat                      animatedDistance;
    IBOutlet UIButton             *faceBookSharing,*twitterSharing;
    socailConnectObject             *socailObject;

                                                        

}


@property (retain,nonatomic)  IBOutlet UIButton             *faceBookSharing,*twitterSharing;
@property (retain,nonatomic) IBOutlet UIScrollView       *scrollView;
@property (retain,nonatomic) IBOutlet UITextField		*titlField,*locationField;
@property (retain,nonatomic) IBOutlet UIImageView		*profileImageView,*photoImageView;
@property (retain,nonatomic) IBOutlet UITextView        *descText;
@property (retain,nonatomic) IBOutlet UISwitch  *facebookSwith,*twitterSwitch,*emailSwitch;
@property (retain,nonatomic) IBOutlet UITableView *shareTableView;
@property (retain,nonatomic) NSArray *dataArray;
@property (nonatomic,retain) SA_OAuthTwitterEngine	*_engine;
@property (retain,nonatomic) addEmailViewController  *AMVC;
@property (retain,nonatomic) CLLocation *currentLocation;
@property (retain,nonatomic) MKReverseGeocoder *reverseGeocoder;
@property (nonatomic, retain) MKPlacemark *placemark;
@property int option;
@property (retain,nonatomic) UIImage *image;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withImage:(UIImage *)_image withOption:(int)_option;
-(void) setImageItem:(UIImage *)_image;
-(IBAction) switchValueChanged:(id)sender;
-(void) facebookPressed;
-(void) TwitterButtonPressed;
-(void) loadAlertView:(NSString *)_msg;
-(NSString *) getSharingOption;
-(BOOL) validateExtraField;
-(void) syncOnThreadAction;
-(void) getLocationAddress;
-(IBAction) backgrondTouched :(id)sender;
-(IBAction) doneButtonPressed:(id)sender;
-(void) profilePhoto;
-(IBAction) socialButtonPressed:(id)sender;
@end
