//
//  commonUsedMethods.h
//  show
//
//  Created by svp on 29/12/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>
#import "domainClasses.h"
#define SECOND 1
#define MINUTE (60 * SECOND)
#define HOUR (60 * MINUTE)
#define DAY (24 * HOUR)
#define MONTH (30 * DAY)
#define WIDTH  100
#define HEIGHT 100
#define GRID_TOTAL 6
#define MAX_COMMENT_FEED 5
#define COMMENT_CELL_HEIGHT 32
#define CELL_THUMBNAIL 12
#define ACTIVITY_CELL_HEIGHT 70

#define KpasswordnotMatch   @"Password mismatch"
#define KuserNameMissing    @"Please enter username"
#define KpasswordMissing    @"Password missing"
#define KconfirmPassword    @"Please confirm password"
#define KInfoIncomplete     @"Incomplete information"
#define KEmailidMissing     @"Email is missing"

#define USER_NAME_KEY			@"username"
#define USER_PASSWORD_KEY		@"password"
#define FB_NAME_KEY			    @"facebookusername"
#define FB_PASSWORD_KEY		    @"facebookpassword"
#define TAB_BAR_KEY             @"tabBar"
#define FACEBOOK_KEY			@"facebook_token"
#define TWITTER_KEY				@"twitter_token"
#define NOTIFY_SUPPORT			@"NOTIFY_SUPPORT"
#define NOTIFY_COMMENT			@"NOTIFY_COMMENT"
#define AUTO_REGISTER			@"AUTO_REGISTER"
#define FB_SHARING			     @"FB_SHARING"
#define TW_SHARING			     @"TW_SHARING"
#define TOPIC_INFO              @"TOPIC_LIST"
#define ENABLE_GEOTAG           @"ENABLE_GEOTAG"

#define PRE_TABINDEX           @"PRE_TABINDEX"
#define CURR_TABINDEX           @"CURR_TABINDEX"

#define BUTTON_WIDTH 70.0
#define BUTTON_SEGMENT_WIDTH 51.0
#define CAP_WIDTH 4.0

typedef enum {
    CapLeft          = 0,
    CapMiddle        = 1,
    CapRight         = 2,
    CapLeftAndRight  = 3
} CapLocation;

@class viewFrame;

@interface commonUsedMethods : NSObject {

}
 ////////////
+(NSString *) getFBUserPassFromDefault;
+(void) setFBUserPassInDefault:(NSString *)_string;
+(NSString *) getFBUserNameFromDefault;
+(void) setFBUserNameInDefault:(NSString *)_string;
+(void)  removeUserCrediential;
///////////////


+(NSString *)   trimString:(NSString *)_string;
+(void)         setUserNameInDefault:(NSString *)_string;
+(void)			setUserPassInDefault:(NSString *)_string;
+(NSString *)   getUserPassFromDefault;
+(NSString *)   getUserNameFromDefault;
+(NSString *)   getClientSecret;
+(void)         setClientSecret:(NSString *)_string;
+(NSString *)   getLastTabBarIndex;
+(void)			setLastTabBarIndex:(NSString *)_string;
+(void) logoutUser;
+(BOOL) hasUserAlreadyLogin;
+(UIColor *)  getNavTintColor1;
+(void)   setUserFeedArray:(NSMutableArray *)_feedArray;
+(NSMutableArray *) getUserFeedArray;
+(NSString *) getFileNameFromURL:(NSString *)_temp;
+(UIColor *)  getNavTintColor;
+(NSString*) timeIntervalWithStartDate:(NSString *)d2;

+(void) setFaceBookTokenObject:(NSString *)_string;
+(BOOL) hasFaceBookTokenObject;
+(NSString *) getFaceBookTokenObject;
+(void) removeFBTokenObject;

+(void) setTwitterTokenObject:(NSString *)_string;
+(BOOL) hasTwitterTokenObject;
+(NSString *) getTwitterTokenObject;
+(void) removeTwitterTokenObject;
+(void) check2:(UILabel *) theLabel:(int)_length;
+(void) adjustLabelFrame:(UILabel *) theLabel:(UILabel *) theLabel2;
+ (NSString *) returnMD5Hash:(NSString*)concat;
+(NSString *) getSalt;
+(NSString *)age:(NSString *)_dob;
+(void) updateLikeProperty:(NSMutableArray *)dataArray:(int)Iden:(BOOL) _value;
+(void) updatePhotoLikeProperty:(PhotoData *)photo;
+(CommentsData *) createCommentUserObject:(NSString *)_str;
+(void) updateCommentProperty:(NSMutableArray *)dataArray:(NSString *)_string:(int)Iden;
+(void) updatePhotoCommentProperty:(PhotoData *)photo:(NSString *)_string;
+(likeData *) createLikeUserObject;
+(void) showTabBar:(UITabBarController *) tabbarcontroller;
+(void)hideTabBar:(UITabBarController *) tabbarcontrolle;
+(UIImage *)imageWithImage:(UIImage*)image:(CGSize)newSize;
+(NSString *) getDefaultSex;
+(void) removeActivityFromView:(NSArray *)_viewArray;
+(NSMutableArray *) sortArray:(NSMutableArray *)_temp:(NSString *)_key:(BOOL)ascending;


+(NSString *) stringByStrippingHTML:(NSString *)s;
+ (NSString *)stripDoubleSpaceFrom:(NSString *)_str;
+(UIView *) navigationlogoView;

+(BOOL ) getFBSharingNotification;
+(void) setFBSharingNotification:(BOOL )_boolValue;
+(BOOL ) getAutoRegisterLocationNotification;
+(void) setAutoRegisterLocationNotification:(BOOL )_boolValue;
+(void) setSupportNotification:(BOOL )_boolValue;
+(BOOL ) getSupportNotification;
+(BOOL ) getCommentNotification;
+(void) setCommentNotification:(BOOL )_boolValue;
+(void) clearImageDownloader:(NSMutableDictionary *)_imageDownloader;
+(void) removeActivityFromButton:(UIButton *)_button;
+ (UIImage*)imageWithBorderFromImage:(UIImage*)image;

+(NSString *)getOptionStringValue:(int)_option;
+(void) setTopicsInDefaults:(NSString *)_key:(BOOL)boolValue;
+(BOOL) getTopicOption:(NSString *)_key;
//+(void) setSortArray:(NSMutableArray *)_feedArray;
//+(NSMutableArray *) setSortArray:(NSMutableArray *)_feedArray;
+(BOOL ) getTwitterSharingNotification;
+(void) setTwitterSharingNotification:(BOOL )_boolValue;
+ (UIImage*)resizedImage:(UIImage*)image;
+(UIView *) EditNavigationView;

+(BOOL ) getGeotagEnabled;
+(void) setGeotagEnabled:(BOOL )_boolValue;

+(void)setPreviousTabIndex:(NSString *)_index;
+(NSString *)getPreviousTabIndex;

+(void)setCurrentTabIndex:(NSString *)_index;
+(NSString *)getCurrentTabIndex;

+(UIImage *)getCheckImage;
+(UIImage *)getUncheckImage;

+(BOOL ) getFacebookConfigured;
+(void) setFacebookConfigured:(BOOL )_boolValue;

+(BOOL ) getTwitterConfigured;
+(void) setTwitterConfigured:(BOOL )_boolValue;


+(BOOL ) getIsFirstRun;
+(void) setIsFirstRun:(BOOL )_boolValue;

+(void)setPhotoIndexToDelete:(NSString *)_index;
+(NSString *)getPhotoIndexToDelete;

+(BOOL ) getIsRefreshData;
+(void) setIsRefreshData:(BOOL )_boolValue;

+(BOOL ) getIsLogout;
+(void) setIsLogout:(BOOL )_boolValue;

+(void)setDefaultRadius:(NSString *)_index;
+(NSString *)getDefaultRadius;

+(BOOL ) getLocationFound;
+(void) setLocationFound:(BOOL )_boolValue;


+(BOOL ) getIsFacebookUser;
+(void) setIsFacebookUser:(BOOL )_boolValue;


+(void)setTabIndexToReturn:(int)_index;
+(int)getTabIndexToReturn;

+(void)setMapSpanLatitudeDelta:(float)_span;
+(float)getMapSpanLatitudeDelta;

+(void)setMapSpanLongitudeDelta:(float)_span;
+(float)getMapSpanLongitudeDelta;


/*******************     NEW METHOD DEFINATION   **********************/
+(UIBarButtonItem*)navigationButtonWithText:(NSString*)buttonText:(BOOL)isLeft;
+(UIButton*)woodButtonWithText:(NSString*)buttonText stretch:(CapLocation)location:(BOOL)isLeft;
+(UIImage*)image:(UIImage*)image withCap:(CapLocation)location capWidth:(NSUInteger)capWidth buttonWidth:(NSUInteger)buttonWidth;

+ (BOOL) isSpecialChar:(NSString *)string;
+ (BOOL) validateEmailWithString:(NSString*)email;
@end
