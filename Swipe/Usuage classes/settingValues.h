//
//  settingValues.h
//  Night life
//
//  Created by Ahmad on 02/03/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


////////////////  FIND A SITTER SERVICE NAMES  /////////////////

#define LOGIN_STR   @"LOGIN";
#define REGISTRATION_STR   @"SIGNUP";
#define FORGOT_STR   @"FORGOT_LOGIN";

#define SITTER_LIST_STR   @"SITTER_LIST";
#define PARENTS_LIST_STR   @"TRUSTED_PARENTS";
#define PERSONAL_INFO_STR    @"PERSONAL_INFO"
#define DEFAULT_MSG_STR    @"DEFAULT_MESSAGE"
#define USR_PROFILE_STR    @"PROFILE"
#define TRUSTED_PARENT_DETAIL_STR   @"TRUSTED_PARENTS_SITTER";
#define REMOVE_PARENT_STR   @"REMOVE_TRUSTED_PARENTS";
#define SHARE_SITTER_STR   @"SHARE_MYSITTERS";
#define CONFIRM_INVITATION_STR   @"CONFIRM_INVITATION"; 
#define ADD_BABYSITTER_STR   @"ADD_BABYSITTER";
#define DELELTE_BABYSITTER_STR   @"REMOVE_BABYSITTER";

#define FORGOT_PASS_STR   @"FORGOT_PASSWARD";
#define INVITE_PARENT_STR   @"INVITE_PARENT";




//////////////////////  OTHER CONTSTANTS  /////////////////



#define TIP_OF_WEEK @"TIP_OF_WEEK";
#define DISCLAIMER @"http://www.one45.nl/apps/nightlife/disclaimer"
#define NIGHTLIFE @"http://www.one45.nl/apps/nightlife"

/////////////////////////////////////////////////
#define THIS_WEEK @"This week"
#define NEXT_WEEK @"Next week"
#define SECOND_WEEK @"2nd week"
#define THIRD_WEEK @"3rd week"
#define MAX_SEARCH_DAYS 21
//////////////////////////////////////////////////
#define EXIT_STRING @"Internet connection error"
//#define MAIL_ID @"http://ww.one45.nl/apps/nightlife/feedback"
#define MAIL_ID @"feedback@one45.nl"
   ///www.one45.nl/apps/nightlife/feedback


///////////////////////////////////////////////////
//  local server
//#define HOST_ID @"192.168.1.11"

///  production server
#define HOST_ID @"184.82.107.144"

/////////////////////////////////////////////////////

#define HOST_PORT @"18900"


////////////////////////////////////////////////////////


@interface settingValues : NSObject {

}

///////////////////////////  services list of FINDASitter Project  ////////////////

+(NSString *) getlogin;
+(NSString *) getRegistration;
+(NSString *) getForget;



+(NSString *) getSitterList;
+(NSString *) getParentList;


+(NSString *) setPersonalInfo;
+(NSString *) setDefaultMessage;

+(NSString *) getProfile;
+(NSString *) getParentDetail;
+(NSString *) removeTrustedParent;
+(NSString *) shareSitter;
+(NSString *) getConfirmTrustedParent;

+(NSString *) addBabySitter;
+(NSString *) deleteBabySitter;
+(NSString *) forgotPassword;
+(NSString *) inviteParent;





/////////////////////////////////////////////

+(NSString *) getMailID;

+(UIColor *) getTableSepraterColor;
+(UIColor *) getCellBackColor:(NSInteger) number;
+(UIColor *) getoverLayColor;
+(CGFloat) getoverLayTransparancy;


+(NSString *) getExitString;
+(NSString *) getMailID;


+(NSString *) getHostID;
+(NSString *) getHostPort;






+(NSString *) getDisClaimerLink;
+(NSString *) getNightLifeLink;
/*
+(void) setGPXPoints :(CLLocation *)_newLocation;

+(CLLocation *) getGPXPoints;
 */
 


+(BOOL) getIsLocked;
+(void) setIsLocked:(BOOL) _isLock;

+(UIColor *) getNavTintColor;
+(UIColor *) getButtonFontColor;
+(UIColor *) getPlacehodlerColor;

+(UIColor *) getLabelColor;
+(UIColor *) getCellLabelColor;

/////////////////    FOR SHOW APPLICATION    /////////////////////

+(void) setDelegate:(id)_delegate;
+(id) getDelegate;

@end
