//
//  settingValues.m
//  Night life
//
//  Created by Ahmad on 02/03/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "settingValues.h"



@implementation settingValues
NSUserDefaults *prefs;

NSString *uniqueKey,*UpComingEventString;
NSString *cityName,*countryName,*eventType,*selectValue;
NSString *cityName1,*countryName1;
NSMutableArray *EventArray;
NSString *latitude,*longitude;
BOOL isLock,networkStatus;
//CLLocation *newLocation;
/////////////////////////////////   FOR SHOW APPLICATION   //////////////////////

id delegate;


/////////////////////////////////// SERVICES NAME FOR FIND A SITTER PROJECT     ////////////////////////////

+(NSString *) getlogin
{
	return  LOGIN_STR;

}
+(NSString *) getRegistration
{
	return REGISTRATION_STR;
}
+(NSString *) getForget
{
	return FORGOT_STR;
	
}

+(NSString *) getSitterList
{
	return SITTER_LIST_STR;
}
+(NSString *) getParentList
{
	return PARENTS_LIST_STR;
}
+(NSString *) setPersonalInfo
{
	return PERSONAL_INFO_STR;
}
+(NSString *) setDefaultMessage
{
	return DEFAULT_MSG_STR;
	
}
+(NSString *) getProfile
{
	return USR_PROFILE_STR;
}
+(NSString *) getParentDetail
{
	return TRUSTED_PARENT_DETAIL_STR;
}
+(NSString *) removeTrustedParent
{
	return REMOVE_PARENT_STR;
	
}
+(NSString *) shareSitter
{
	return SHARE_SITTER_STR;
}
+(NSString *) getConfirmTrustedParent
{
	return CONFIRM_INVITATION_STR;
}
+(NSString *) deleteBabySitter
{
	return DELELTE_BABYSITTER_STR;
}
+(NSString *) forgotPassword
{
	return FORGOT_PASS_STR;
}
+(NSString *) addBabySitter
{
	return ADD_BABYSITTER_STR;
}
+(NSString *) inviteParent
{
	return INVITE_PARENT_STR;
}


/////////////////////////////////// COLOLR SCHEMES FOR FONTS, NAVIGATION BAR, TABLE SEPERATOR etc  /////////////////////
////////////////////////////////////////////////////

+(UIColor *) getTableSepraterColor
{
	return [UIColor colorWithRed:191/255.f green:191/255.f blue:191/255.f alpha:255/255.f];
}

+(UIColor *) getCellBackColor:(NSInteger) number
{
	if(number%2==0)
		return [UIColor blackColor];
	else
		return [UIColor colorWithRed:29/255.f green:29/255.f blue:29/255.f alpha:255/255.f];
	
}

+(UIColor *) getNavTintColor
{	
	//79	121	66
	//RGB # 101, 195, 47
	//  66,170,66   // 153 204 50   122  157  28
	
	//  orange color  251 150 30
	return [UIColor colorWithRed:219/255.f green:43/255.f blue:41/255.f alpha:255/255.f];
	
}

+(UIColor *) getButtonFontColor
{	
	return [UIColor colorWithRed:255/255.f green:255/255.f blue:255/255.f alpha:255/255.f];
}
+(UIColor *) getPlacehodlerColor
{
	return [UIColor colorWithRed:191/255.f green:191/255.f blue:191/255.f alpha:255/255.f];
	
}
+(UIColor *) getLabelColor
{
	return [UIColor colorWithRed:0/255.f green:0/255.f blue:0/255.f alpha:255/255.f];
}

+(UIColor *) getCellLabelColor
{
	return [UIColor colorWithRed:163/255.f green:89/255.f blue:61/255.f alpha:255/255.f];
}

////////////////////////////////////////////////////
/////////////////////////////////// END COLOLR SCHEMES FOR FONTS, NAVIGATION BAR, TABLE SEPERATOR etc  /////////////////////


+(NSString *) getExitString
{
	return EXIT_STRING;
}
+(NSString *) getMailID
{
	return MAIL_ID;
}


+(NSString *) getHostID
{
	return HOST_ID;
}
+(NSString *) getHostPort
{
	//int a=[HOST_PORT intValue];
	return HOST_PORT;
}

+(void )setSearchSegment:(NSInteger) _value
{
	prefs = [NSUserDefaults standardUserDefaults];
	[prefs setInteger:_value forKey:@"setSearchSegment"];
}
+(NSInteger) getSearchSegment
{
	prefs = [NSUserDefaults standardUserDefaults];
	if ([prefs valueForKey:@"setSearchSegment"] == nil)
		return 1;
	return [prefs integerForKey:@"setSearchSegment"];
}
+(NSInteger) getCalenderMAXDays
{
	return MAX_SEARCH_DAYS;
}


+(NSString *) getDisClaimerLink
{
	return DISCLAIMER;
}
+(NSString *) getNightLifeLink
{
	return NIGHTLIFE;
	
}

+(UIColor *) getoverLayColor
{
	return [UIColor blackColor];
}
+(CGFloat) getoverLayTransparancy
{
	return 0.8;
}
+(void) setNetworkStatus:(BOOL)bool_value
{
	networkStatus = bool_value;
	//prefs = [NSUserDefaults standardUserDefaults];
	//[prefs setBool:bool_value forKey:@"networkStatus"];
}
+(BOOL) getNetworkStatus
{
	//return [prefs boolForKey:@"networkStatus"];
	return networkStatus;
}



+(void) setTabOption:(NSInteger)_tabValue
{
	prefs = [NSUserDefaults standardUserDefaults];
	[prefs setInteger:_tabValue forKey:@"secondTabView"];
	
}
+(NSInteger) getTabOption
{
		return [prefs integerForKey:@"secondTabView"];
}

+(BOOL) getIsLocked
{
	return isLock;
}
+(void) setIsLocked:(BOOL) _isLock
{
	isLock=_isLock;
}




/////////////////    FOR SHOW APPLICATION    /////////////////////

+(void) setDelegate:(id)_delegate
{
	delegate = _delegate;
	
}
+(id) getDelegate
{
	return delegate;
}


@end
