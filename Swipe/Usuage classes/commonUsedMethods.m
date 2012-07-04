//
//  commonUsedMethods.m
//  show
//
//  Created by svp on 29/12/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "commonUsedMethods.h"
#import "domainClasses.h"
#import "DataModel.h"
#import "SingletonClass.h"
#import <QuartzCore/QuartzCore.h>
#import "socailConnectObject.h"
#import "SingletonClass.h"
#import "headerfiles.h"



@implementation commonUsedMethods
NSDateFormatter *df;
NSMutableArray *feedArray;

+(void)  removeUserCrediential
{
    
[[NSUserDefaults standardUserDefaults] removeObjectForKey:USER_NAME_KEY];
[[NSUserDefaults standardUserDefaults] removeObjectForKey:USER_PASSWORD_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}
+(void) setSupportNotification:(BOOL )_boolValue
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSNumber numberWithBool:_boolValue] forKey:NOTIFY_SUPPORT];
    [defaults synchronize];
    
    NSLog(@"%@",[[defaults objectForKey:NOTIFY_SUPPORT] boolValue]? @"yes":@"no");
    
}
+(BOOL ) getSupportNotification
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if([defaults objectForKey:NOTIFY_SUPPORT])
      return [[defaults objectForKey:NOTIFY_SUPPORT] boolValue];
    return FALSE;
}
+(void) setCommentNotification:(BOOL )_boolValue
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSNumber numberWithBool:_boolValue] forKey:NOTIFY_COMMENT];
    [defaults synchronize];
    
}
+(BOOL ) getCommentNotification
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
   if([defaults objectForKey:NOTIFY_COMMENT])
    return [[defaults objectForKey:NOTIFY_COMMENT] boolValue];
    return FALSE;
}
+(void) setAutoRegisterLocationNotification:(BOOL )_boolValue
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSNumber numberWithBool:_boolValue] forKey:AUTO_REGISTER];
    [defaults synchronize];
    
}

+(BOOL ) getGeotagEnabled
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if([defaults objectForKey:ENABLE_GEOTAG])
        return [[defaults objectForKey:ENABLE_GEOTAG] boolValue];
    return FALSE;
    
}

+(void) setGeotagEnabled:(BOOL )_boolValue
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSNumber numberWithBool:_boolValue] forKey:ENABLE_GEOTAG];
    [defaults synchronize];
}

+(BOOL ) getAutoRegisterLocationNotification
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if([defaults objectForKey:AUTO_REGISTER])
    return [[defaults objectForKey:AUTO_REGISTER] boolValue];
    return FALSE;
}
+(void) setFBSharingNotification:(BOOL )_boolValue
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSNumber numberWithBool:_boolValue] forKey:FB_SHARING];
    [defaults synchronize];
    
}
+(BOOL ) getFBSharingNotification
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if([defaults objectForKey:FB_SHARING])
        return [[defaults objectForKey:FB_SHARING] boolValue];
    return FALSE;
}
+(void) setTwitterSharingNotification:(BOOL )_boolValue
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSNumber numberWithBool:_boolValue] forKey:TW_SHARING];
    [defaults synchronize];
    
}
+(BOOL ) getTwitterSharingNotification
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if([defaults objectForKey:TW_SHARING])
        return [[defaults objectForKey:TW_SHARING] boolValue];
    return FALSE;
}

+(NSString *) trimString:(NSString *)_string
{
	return [_string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	
}

+(void) setUserNameInDefault:(NSString *)_string
{
     NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
     [defaults setObject:_string forKey:USER_NAME_KEY];
     [defaults synchronize];
}
+(NSString *) getUserNameFromDefault
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults valueForKey:USER_NAME_KEY];
}
+(void) setUserPassInDefault:(NSString *)_string
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setObject:_string forKey:USER_PASSWORD_KEY];
	[defaults synchronize];
}
+(NSString *) getUserPassFromDefault
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults valueForKey:USER_PASSWORD_KEY];
  
    
}

////////////////////////////////

+(void) setFBUserNameInDefault:(NSString *)_string
{
    if(_string)
    {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:_string forKey:FB_NAME_KEY];
    [defaults synchronize];
    }
}
+(NSString *) getFBUserNameFromDefault
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults valueForKey:FB_NAME_KEY];
}
+(void) setFBUserPassInDefault:(NSString *)_string
{   
    if(_string)
    {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setObject:_string forKey:FB_PASSWORD_KEY];
	[defaults synchronize];
    }
}
+(NSString *) getFBUserPassFromDefault
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults valueForKey:FB_PASSWORD_KEY];
    //  return @"232";//encode(<#type-name#>)
    
}

/////////////////////////////////
+(BOOL ) hasUserAlreadyLogin
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	if([defaults valueForKey:USER_NAME_KEY] && [defaults valueForKey:USER_PASSWORD_KEY])
		return TRUE;
	return FALSE;
	
}

+(void) logoutUser
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:nil forKey:@"AccessToken"];
	[defaults removeObjectForKey:USER_NAME_KEY];
	[defaults removeObjectForKey:USER_PASSWORD_KEY];
    [defaults removeObjectForKey:NOTIFY_SUPPORT];
    [defaults removeObjectForKey:NOTIFY_COMMENT];
    [defaults removeObjectForKey:AUTO_REGISTER];
    [defaults removeObjectForKey:FB_SHARING];
    [commonUsedMethods setFacebookConfigured:FALSE];
    [commonUsedMethods setTwitterConfigured:FALSE];
     socailConnectObject *social = [[SingletonClass sharedInstance] getSocialObject];
    [[[SingletonClass sharedInstance] getFbDictionary] removeAllObjects];
    [social logoutTwitter];
    [social singOutFacebook];
    
	[defaults synchronize];
	
}
+(NSString *)   getLastTabBarIndex
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults valueForKey:TAB_BAR_KEY];
    
}

+(void)			setLastTabBarIndex:(NSString *)_string
{
    NSLog(@"ANUM--->%@",_string);
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:_string forKey:TAB_BAR_KEY];
    [defaults synchronize];
    
}


+(void)setPreviousTabIndex:(NSString *)_index
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:_index forKey:PRE_TABINDEX];
    [defaults synchronize];

}
+(NSString *)getPreviousTabIndex
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults valueForKey:PRE_TABINDEX];
}

+(void)setCurrentTabIndex:(NSString *)_index
{

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:_index forKey:CURR_TABINDEX];
    [defaults synchronize];
}



+(NSString *)getCurrentTabIndex
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults valueForKey:CURR_TABINDEX];
}


+(void)setTabIndexToReturn:(int)_index
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSNumber numberWithInt:_index] forKey:@"TABINDEXRETURN"];
    [defaults synchronize];
}
+(int)getTabIndexToReturn
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [[defaults valueForKey:@"TABINDEXRETURN"] intValue];
}



+(void) setFaceBookTokenObject:(NSString *)_string
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setObject:_string forKey:FACEBOOK_KEY];
	[defaults synchronize];
}
+(BOOL) hasFaceBookTokenObject
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	if([defaults valueForKey:FACEBOOK_KEY])
		return TRUE;
	return FALSE;
}
+(NSString *) getFaceBookTokenObject
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults valueForKey:FACEBOOK_KEY];
	
}
+(void) removeFBTokenObject
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults removeObjectForKey:FACEBOOK_KEY];
    [defaults synchronize];
    
}


+(void)setMapSpanLatitudeDelta:(float)_span
{
     NSLog(@"%f",_span);
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setObject:[NSString stringWithFormat:@"%f",_span] forKey:@"SPANLATITUDE"];
	[defaults synchronize];
}
+(float)getMapSpanLatitudeDelta
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if([defaults valueForKey:@"SPANLATITUDE"])
        return [[defaults valueForKey:@"SPANLATITUDE"] floatValue];
    return 0.016;
}

+(void)setMapSpanLongitudeDelta:(float)_span
{
    NSLog(@"%f",_span);
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setObject:[NSString stringWithFormat:@"%f",_span] forKey:@"SPANLONGITUDE"];
	[defaults synchronize];
}
+(float)getMapSpanLongitudeDelta
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if([defaults valueForKey:@"SPANLONGITUDE"])
        return [[defaults valueForKey:@"SPANLONGITUDE"] floatValue];
    return 0.016;
}





+(void) setTwitterTokenObject:(NSString *)_string
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setObject:_string forKey:TWITTER_KEY];
	[defaults synchronize];
}
+(BOOL) hasTwitterTokenObject
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	if([defaults valueForKey:TWITTER_KEY])
		return TRUE;
	return FALSE;
}
+(NSString *) getTwitterTokenObject
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults valueForKey:TWITTER_KEY];
	
}
+(void) removeTwitterTokenObject
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults removeObjectForKey:TWITTER_KEY];
    [defaults synchronize];
}
+(NSString *) getClientSecret
{
    return @"c4dbbff1a282f95c44cced6b92ff2215";
}
+(void) setClientSecret:(NSString *)_string
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:_string forKey:@"CLIENT_SECRECT"];
    [defaults synchronize];
}

+(void)   setUserFeedArray:(NSMutableArray *)_feedArray
{
    if(!feedArray)
    {
        feedArray = [[NSMutableArray alloc] init];
        [feedArray retain];
    }
    [feedArray removeAllObjects];
    [feedArray addObjectsFromArray:_feedArray];

}
+(NSMutableArray *) getUserFeedArray
{
    return feedArray;
    
}
+(NSString *) getFileNameFromURL:(NSString *)_temp
{
	
	return [[[_temp lastPathComponent] componentsSeparatedByString: @"."] objectAtIndex: 0];
}	
+(UIColor *)  getNavTintColor
{
	//return [UIColor blackColor];
    return [UIColor colorWithRed:231/255.f green:52/255.f blue:51/255.f alpha:255/255.f];
}
+(UIColor *)  getNavTintColor1
{
	//return [UIColor blackColor];
    return [UIColor colorWithRed:36/255.f green:132/255.f blue:165/255.f alpha:255/255.f];
}
+(UIView *) navigationlogoView
{
    
   UIImageView *logImage = [[[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 155.0f, 28.0f)] autorelease];
    logImage.backgroundColor = [UIColor clearColor]; 
    logImage.image = [UIImage imageNamed:@"Logo.png"];
    return logImage;
    
}
+(UIView *) EditNavigationView
{
    userProfile *user = [[DataModel getDataInDictionary:6] objectAtIndex:0];
    //tokeInfo *token = [[SingletonClass sharedInstance] getTokenInformation];
    UIView *mylogView = [[[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 155.0f, 38.0f)] autorelease];
    UIImageView *logImage = [[[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 36.0f, 36.0f)] autorelease];
    logImage.backgroundColor = [UIColor clearColor]; 
    logImage.image =  [imageCaches imageFromKey:user.imgURL];// [UIImage imageNamed:@"Logo.png"];
    [mylogView addSubview:logImage];
    UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(40.0f, 0.0f, 100.0f, 36.0f)] autorelease];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont boldSystemFontOfSize:16.0];
    label.textAlignment = UITextAlignmentCenter;
  //  label.frame.origin= CGSizeMake(40, 32);
    label.text = user.userName;// @"Imran Bashir";
    [mylogView addSubview:label];
    return mylogView;
    
}
+(NSString*) timeIntervalWithStartDate:(NSString *)d2
{
  //  NSLog(@"%@",d2);
    //Calculate the delta in seconds between the two dates   // 2011-06-03 06:53:25
	NSDateFormatter* df = [[[NSDateFormatter alloc]init] autorelease];
	//[df setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
	//NSString* str =   @"2009-08-11T06:00:00.000-0700";   // NOTE -0700 is the only change
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [df setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
    NSDate* date1 = [df dateFromString:d2];
//	NSLog(@"AIMI - > %@ and %@ and %@ ",d2,[NSDate date], date1);
   // NSTimeInterval delta = [[NSDate date] timeIntervalSinceDate:date1];
    
  //  int timezoneoffset = [[NSTimeZone systemTimeZone] secondsFromGMT] ;
    
  //  NSLog(@"AIMI NOW %d",timezoneoffset);//[[NSTimeZone systemTimeZone] secondsFromGMT] ;
    NSTimeInterval delta = [[NSDate date] timeIntervalSinceDate:date1];
	
    if (delta < 1 * MINUTE)
    {
        return delta == 1 ? @"1 sec ago" : [NSString stringWithFormat:@"%d sec ago", (int)delta];
    }
    if (delta < 2 * MINUTE)
    {
        return @"1 min ago";
    }
    if (delta < 45 * MINUTE)
    {
        int minutes = floor((double)delta/MINUTE);
        return [NSString stringWithFormat:@"%d mins ago", minutes];
    }
    if (delta < 90 * MINUTE)
    {
        return @"1 hr ago";
    }
    if (delta < 24 * HOUR)
    {
        int hours = floor((double)delta/HOUR);
        return [NSString stringWithFormat:@"%d hrs ago", hours];
    }
    if (delta < 48 * HOUR)
    {
        return @"yesterday";
    }
    if (delta < 30 * DAY)
    {
        int days = floor((double)delta/DAY);
        return [NSString stringWithFormat:@"%d days ago", days];
    }
    if (delta < 12 * MONTH)
    {
        int months = floor((double)delta/MONTH);
        return months <= 1 ? @"1 month ago" : [NSString stringWithFormat:@"%d months ago", months];
    }
    else
    {
        int years = floor((double)delta/MONTH/12.0);
        return years <= 1 ? @"1 year ago" : [NSString stringWithFormat:@"%d years ago", years];
    }
}
+(void) check2:(UILabel *) theLabel:(int)_length
{
	
	CGRect frame = [theLabel frame];
    CGSize size = [theLabel.text sizeWithFont:theLabel.font
							constrainedToSize:CGSizeMake(frame.size.width, _length)
								lineBreakMode:UILineBreakModeWordWrap];
    CGFloat delta = size.height - frame.size.height;
	if(delta > 0)
	{
		frame.size.height = size.height;
		[theLabel setFrame:frame];
		
	}
	
}
+(void) adjustLabelFrame:(UILabel *) theLabel:(UILabel *) theLabel2
{
	
	CGRect frame = [theLabel frame];
    NSLog(@"%f %f %f %f ",frame.origin.x,frame.origin.y,frame.size.width,frame.size.height);
    CGSize size = [theLabel.text sizeWithFont:theLabel.font
							constrainedToSize:CGSizeMake(frame.size.width, 48)
								lineBreakMode:UILineBreakModeWordWrap];
    CGFloat delta = size.height - frame.size.height;
	if(delta > 0)
	{
		frame.size.height = size.height;
		[theLabel setFrame:frame];
         NSLog(@"%f %f %f %f ",frame.origin.x,frame.origin.y,frame.size.width,frame.size.height);
        CGRect frame2 = [theLabel2 frame];
         NSLog(@"%f %f %f %f ",frame.origin.x,frame2.origin.y,frame2.size.width,frame2.size.height);
        frame2.origin.y = frame.origin.y+frame.size.height+5;
        [theLabel2 setFrame:frame2];
         NSLog(@"%f %f %f %f ",frame2.origin.x,frame2.origin.y,frame2.size.width,frame2.size.height);
	}
	
}

// FOR COMMAND LINE echo -n "100grammimran123" | md5 -r
//generate md5 hash from string

+ (NSString *) returnMD5Hash:(NSString*)concat {
    
    NSLog(@"%@",concat);   
    const char *concat_str = [concat UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(concat_str, strlen(concat_str), result);
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < 16; i++)
        [hash appendFormat:@"%02X", result[i]];
    NSLog(@"HERE IS Md5 STRING:%@",[hash lowercaseString]);
    return [hash lowercaseString];
     
    //return @"5446daf6739052031887edbac1d524ad";
}
+(NSString *) getSalt
{
    return @"100gramm2";
}

 
+(NSString *)age:(NSString *)_dob {
 
 int month=0;
 int year=0;
    NSDateFormatter* df = [[[NSDateFormatter alloc]init] autorelease];
     [df setDateFormat:@"yyyyMMdd"];
     NSDate* dob = [df dateFromString:_dob];
 
 NSCalendar *calendar = [NSCalendar currentCalendar];
 unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
 NSDateComponents *dateComponentsNow = [calendar components:unitFlags fromDate:[NSDate date]];
 NSDateComponents *dateComponentsBirth = [calendar components:unitFlags fromDate:dob];
 
 if (([dateComponentsNow month] < [dateComponentsBirth month]) ||
 (([dateComponentsNow month] == [dateComponentsBirth month]) && ([dateComponentsNow day] < [dateComponentsBirth day]))) {
 
 month = 12 + [dateComponentsNow	month] - [dateComponentsBirth month];
 if ([dateComponentsNow day] < [dateComponentsBirth day]) {
 month = month - 1;
 }
 year = [dateComponentsNow year] - [dateComponentsBirth year] - 1;
 } else {
 month = [dateComponentsNow	month] - [dateComponentsBirth month];
 if ([dateComponentsNow day] < [dateComponentsBirth day]) {
 month = month - 1;
 }
 year = [dateComponentsNow year] - [dateComponentsBirth year];
 }
 
 NSString * age = [[NSString alloc] initWithFormat:@"%d yrs %d mths",year,month];
 
 return age;
 }
 /*
 -(void) calculateAge {
 int month=0;
 int year=0;
 
 NSCalendar *calendar = [NSCalendar currentCalendar];
 unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
 NSDateComponents *dateComponentsNow = [calendar components:unitFlags fromDate:[NSDate date]];
 NSDateComponents *dateComponentsBirth = [calendar components:unitFlags fromDate:dob];
 
 if (([dateComponentsNow month] < [dateComponentsBirth month]) ||
 (([dateComponentsNow month] == [dateComponentsBirth month]) && ([dateComponentsNow day] < [dateComponentsBirth day]))) {
 
 month = 12 + [dateComponentsNow	month] - [dateComponentsBirth month];
 if ([dateComponentsNow day] < [dateComponentsBirth day]) {
 month = month - 1;
 }
 year = [dateComponentsNow year] - [dateComponentsBirth year] - 1;
 } else {
 month = [dateComponentsNow	month] - [dateComponentsBirth month];
 if ([dateComponentsNow day] < [dateComponentsBirth day]) {
 month = month - 1;
 }
 year = [dateComponentsNow year] - [dateComponentsBirth year];
 }
 
 [self setAgeText:[[NSString alloc] initWithFormat:@"%d yrs %d mths",year,month]];
 [self setAgeMonths:((year*12)+month)];
 
 
 }

 */
+(void) updatePhotoLikeProperty:(PhotoData *)photo
{
		photo.hasLike = TRUE;
        if(photo.supporterArray)
            [photo.supporterArray insertObject:[DataModel createUserObject2] atIndex:0];
        else
        {
            NSMutableArray *tempArray = [[NSMutableArray alloc] init];
            [tempArray addObject:[self createLikeUserObject]];
            photo.supporterArray = tempArray;
            [tempArray release];
        }
        NSLog(@"%d",[photo.supporterArray count]);
}
+(void) updateLikeProperty:(NSMutableArray *)dataArray:(int)Iden:(BOOL) _value
{
  	BOOL success = FALSE;
	PhotoData *photo;
	for (int i = 0; i < [dataArray count]; i++) {
		
		photo = [dataArray objectAtIndex:i];
        NSLog(@"%d", Iden);
		if([photo.iden intValue] == Iden)
		{
			success = TRUE;
			break;	
		}
	}
	if (success) {
		
        photo.supporters =  _value ? [NSNumber numberWithInt:[photo.supporters intValue] +1]:[NSNumber numberWithInt:[photo.supporters intValue] -1] ;
        
        }
}

+(void) updatePhotoCommentProperty:(PhotoData *)photo:(NSString *)_string
{
    if(photo.commentArray)
            [photo.commentArray insertObject:[self createCommentUserObject:_string] atIndex:0];
        else
        {
            NSMutableArray *tempArray = [[NSMutableArray alloc] init];
            [tempArray addObject:[self createCommentUserObject:_string]];
            photo.commentArray = tempArray;
            [tempArray release];
        }
       
}
+(void) updateCommentProperty:(NSMutableArray *)dataArray:(NSString *)_string:(int)Iden
{
  	BOOL success = FALSE;
	PhotoData *photo;
	for (int i = 0; i < [dataArray count]; i++) {
		
		photo = [dataArray objectAtIndex:i];
        NSLog(@"%d", Iden);
		if([photo.iden intValue] == Iden)
		{
			success = TRUE;
			break;	
		}
	}
	if (success) {
		
        if(photo.commentArray)
            [photo.commentArray insertObject:[self createCommentUserObject:_string] atIndex:0];
        else
        {
            NSMutableArray *tempArray = [[NSMutableArray alloc] init];
            [tempArray addObject:[self createCommentUserObject:_string]];
            photo.commentArray = tempArray;
            [tempArray release];
        }
        NSLog(@"%d",[photo.commentArray count]);
	}    
}
+(CommentsData *) createCommentUserObject:(NSString *)_str
{
	
	CommentsData *e3 = [[[CommentsData alloc] init] autorelease];
	e3.textData=_str;
	
	userProfile *user = [[userProfile alloc] init];
	tokeInfo *tokeninfo = [[SingletonClass sharedInstance] getTokenInformation];
	user.iden = tokeninfo.iden;
    if(tokeninfo.imgURL && [tokeninfo.imgURL length] > 0)
	user.imgURL = tokeninfo.imgURL;
	user.userName = tokeninfo.userName;
	e3.user = user;
	NSDateFormatter* df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [df setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
    NSLog(@"saveDate:%@ and date:%@",[df stringFromDate:[NSDate date]],[NSDate date]);
	//[df setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS-HH:mm"];
    NSLog(@"%@ and %@ ",tokeninfo.userName,user.userName);
	e3.createdDate = [df stringFromDate:[NSDate date]];
    
	[user release];
	[df release];
	return e3;
    
}
+(likeData *) createLikeUserObject
{
	
	likeData *e3 = [[[likeData alloc] init] autorelease];
	
	userProfile *user = [[userProfile alloc] init];
	tokeInfo *tokeninfo = [[SingletonClass sharedInstance] getTokenInformation];
	user.iden = tokeninfo.iden;
	user.imgURL = tokeninfo.imgURL;
	user.userName = tokeninfo.userName;
    e3.user = user;
    [user release];
    
	return e3;
}
+ (void) hideTabBar:(UITabBarController *) tabbarcontroller {
    
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    for(UIView *view in tabbarcontroller.view.subviews)
    {
        if([view isKindOfClass:[UITabBar class]])
        {
            [view setFrame:CGRectMake(view.frame.origin.x, 480, view.frame.size.width, view.frame.size.height)];
        } 
        else 
        {
            [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, 480)];
        }
        
    }
    
    [UIView commitAnimations];
    
    
    
    
    
}

+(void) showTabBar:(UITabBarController *) tabbarcontroller {
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    for(UIView *view in tabbarcontroller.view.subviews)
    {
        NSLog(@"%@", view);
        
        if([view isKindOfClass:[UITabBar class]])
        {
            [view setFrame:CGRectMake(view.frame.origin.x, 431, view.frame.size.width, view.frame.size.height)];
            
        } 
        else 
        {
            [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, 431)];
        }
        
    }
    
    [UIView commitAnimations]; 
}

+(UIImage *)imageWithImage:(UIImage*)image:(CGSize)newSize
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    
    // Return the new image.
    return newImage;
}
+(NSString *) getDefaultSex
{
    return @"male";
}
+(void) removeActivityFromView:(NSArray *)_viewArray
{
    for (UIView *view2 in _viewArray)
    {
        if([view2 isKindOfClass:[UIActivityIndicatorView class]])
            [view2 removeFromSuperview];
    }
    
}
+(NSMutableArray *) sortArray:(NSMutableArray *)_temp:(NSString *)_key:(BOOL)ascending
{   
	NSMutableArray *tempArray = [[_temp mutableCopy] autorelease];
    NSSortDescriptor *sorter;
	sorter=[[NSSortDescriptor alloc] initWithKey:_key ascending:NO];
	NSArray* sortDescriptors = [NSArray arrayWithObject:sorter];
    [tempArray sortUsingDescriptors:sortDescriptors];
	[sorter release];
    return tempArray;
	
}

+(NSString *) stringByStrippingHTML:(NSString *)s {
    NSRange r;
    //NSString *s = [[self copy] autorelease];
    while ((r = [s rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound)
        s = [s stringByReplacingCharactersInRange:r withString:@""];
    return s; 
}
+(void) setTopicsInDefaults:(NSString *)_key:(BOOL)boolValue
{
   
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSNumber numberWithBool:boolValue] forKey:_key];
    [defaults synchronize];
    
     //NSLog(@"%@==> %@",[defaults objectForKey:_key]) ;
}
+(BOOL) getTopicOption:(NSString *)_key
{
   // NSLog(@"%@",_key);
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if([defaults objectForKey:_key])
    {
      //  NSLog(@"%@==> %@",[defaults objectForKey:_key]) ;   
    return [[defaults objectForKey:_key] boolValue];
    }
    return TRUE;
}
+ (NSString *)stripDoubleSpaceFrom:(NSString *)_str {
	NSString *str = [[_str componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@" "];
    while ([str rangeOfString:@"  "].location != NSNotFound) {
        str = [str stringByReplacingOccurrencesOfString:@"  " withString:@" "];
    }
    str = [str stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    return str;
}
+(void) clearImageDownloader:(NSMutableDictionary *)_imageDownloader
{
      
}
+(void) removeActivityFromButton:(UIButton *)_button
{
    for (UIView *view2 in _button.subviews)
    {
        if([view2 isKindOfClass:[UIActivityIndicatorView class]])
            [view2 removeFromSuperview];
    }
}
+ (UIImage*)imageWithBorderFromImage:(UIImage*)image
{
    //image = [Font_size makeRoundImage:image];
    CGImageRef bgimage = [image CGImage];
	float width = CGImageGetWidth(bgimage);
	float height = CGImageGetHeight(bgimage);
    
    // Create a temporary texture data buffer
	void *data = malloc(width * height * 4);
    
	// Draw image to buffer
	CGContextRef ctx = CGBitmapContextCreate(data,
                                             width,
                                             height,
                                             8,
                                             width * 4,
                                             CGImageGetColorSpace(image.CGImage),
                                             kCGImageAlphaPremultipliedLast);
	CGContextDrawImage(ctx, CGRectMake(0, 0, (CGFloat)width, (CGFloat)height), bgimage);
    
	//Set the stroke (pen) color
	CGContextSetStrokeColorWithColor(ctx, [UIColor whiteColor].CGColor);
    
	//Set the width of the pen mark
	CGFloat borderWidth = (float)width*0.04;
	CGContextSetLineWidth(ctx, borderWidth);
    
	//Start at 0,0 and draw a square
	CGContextMoveToPoint(ctx, 0.0, 0.0);	
	CGContextAddLineToPoint(ctx, 0.0, height);
	CGContextAddLineToPoint(ctx, width, height);
	CGContextAddLineToPoint(ctx, width, 0.0);
	CGContextAddLineToPoint(ctx, 0.0, 0.0);
    
	//Draw it
	CGContextStrokePath(ctx);
    
    // write it to a new image
	CGImageRef cgimage = CGBitmapContextCreateImage(ctx);
	UIImage *newImage = [UIImage imageWithCGImage:cgimage];
	CFRelease(cgimage);
	CGContextRelease(ctx);
    
    // auto-released
	return newImage;
}
+(NSString *)getOptionStringValue:(int)_option
{
    switch (_option) {
        case 1:
            return @"Happening";
            break;
        case 2:
            return @"Complaints";
            break;
        case 3:
            return @"Weather";
            break;
            
        default:
            break;
    }
    return 0;
}
+ (UIImage*)resizedImage:(UIImage*)image
{
    CGRect frame = CGRectMake(0, 0, 60, 60);
    UIGraphicsBeginImageContext(frame.size);
    [image drawInRect:frame];
    UIImage* resizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return resizedImage;
}

+(UIImage *)getCheckImage
{
    UIImage *img = [UIImage imageNamed:@"check_geotag.png"];
    return img;
}
+(UIImage *)getUncheckImage
{
    UIImage *img = [UIImage imageNamed:@"uncheck_geotag.png"];
    return img;
}


+(BOOL ) getFacebookConfigured
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if([defaults objectForKey:@"FBConfigured"])
    {
        //  NSLog(@"%@==> %@",[defaults objectForKey:_key]) ;   
        return [[defaults objectForKey:@"FBConfigured"] boolValue];
    }
    return FALSE;
}
+(void) setFacebookConfigured:(BOOL )_boolValue
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSNumber numberWithBool:_boolValue] forKey:@"FBConfigured"];
    [defaults synchronize];
}

+(BOOL ) getTwitterConfigured
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if([defaults objectForKey:@"TwitterConfigured"])
    {
        //  NSLog(@"%@==> %@",[defaults objectForKey:_key]) ;   
        return [[defaults objectForKey:@"TwitterConfigured"] boolValue];
    }
    return FALSE;
}
+(void) setTwitterConfigured:(BOOL )_boolValue
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSNumber numberWithBool:_boolValue] forKey:@"TwitterConfigured"];
    [defaults synchronize];
}

+(BOOL ) getIsFirstRun
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if([defaults objectForKey:@"ISFIRSTRUNAPP"])
    {
        //  NSLog(@"%@==> %@",[defaults objectForKey:_key]) ;   
        return [[defaults objectForKey:@"ISFIRSTRUNAPP"] boolValue];
    }
    return TRUE;
}
+(void) setIsFirstRun:(BOOL )_boolValue
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSNumber numberWithBool:_boolValue] forKey:@"ISFIRSTRUNAPP"];
    [defaults synchronize];
}



+(void)setPhotoIndexToDelete:(NSString *)_index
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:_index forKey:@"DELETEINDEX"];
    [defaults synchronize];
}
+(NSString *)getPhotoIndexToDelete
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if([defaults objectForKey:@"DELETEINDEX"])
    {
        //  NSLog(@"%@==> %@",[defaults objectForKey:_key]) ;   
        return [defaults objectForKey:@"DELETEINDEX"];
    }
    return @"-1";
}

+(BOOL ) getIsRefreshData
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if([defaults objectForKey:@"ISREFRESHDATA"])
    {
        //  NSLog(@"%@==> %@",[defaults objectForKey:_key]) ;   
        return [[defaults objectForKey:@"ISREFRESHDATA"] boolValue];
    }
    return FALSE;
}
+(void) setIsRefreshData:(BOOL )_boolValue
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSNumber numberWithBool:_boolValue] forKey:@"ISREFRESHDATA"];
    [defaults synchronize];
}

+(BOOL ) getIsLogout
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if([defaults objectForKey:@"ISLOGOUT"])
    {
        //  NSLog(@"%@==> %@",[defaults objectForKey:_key]) ;   
        return [[defaults objectForKey:@"ISLOGOUT"] boolValue];
    }
    return FALSE;
}
+(void) setIsLogout:(BOOL )_boolValue
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSNumber numberWithBool:_boolValue] forKey:@"ISLOGOUT"];
    [defaults synchronize];
}


+(BOOL ) getLocationFound
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if([defaults objectForKey:@"LOCATIONFOUND"])
    {
        //  NSLog(@"%@==> %@",[defaults objectForKey:_key]) ;   
        return [[defaults objectForKey:@"LOCATIONFOUND"] boolValue];
    }
    return FALSE;
}
+(void) setLocationFound:(BOOL )_boolValue
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSNumber numberWithBool:_boolValue] forKey:@"LOCATIONFOUND"];
    [defaults synchronize];
}


+(BOOL ) getIsFacebookUser
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if([defaults objectForKey:@"ISFACEBOOKUSER"])
    {
        return [[defaults objectForKey:@"ISFACEBOOKUSER"] boolValue];
    }
    return FALSE;
}
+(void) setIsFacebookUser:(BOOL )_boolValue
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSNumber numberWithBool:_boolValue] forKey:@"ISFACEBOOKUSER"];
    [defaults synchronize];
}


+(void)setDefaultRadius:(NSString *)_index
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:_index forKey:@"DEFAULTRADIUS"];
    [defaults synchronize];
}
+(NSString *)getDefaultRadius
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if([defaults objectForKey:@"DEFAULTRADIUS"])
    {
        //  NSLog(@"%@==> %@",[defaults objectForKey:_key]) ;   
        return [defaults objectForKey:@"DEFAULTRADIUS"];
    }
    return @"1500";
}

/***********************   NEW METHOD NOW   ***************/

+(UIBarButtonItem*)navigationButtonWithText:(NSString*)buttonText:(BOOL)isLeft
{
    return [[[UIBarButtonItem alloc] initWithCustomView:[self woodButtonWithText:buttonText stretch:CapLeftAndRight:isLeft]] autorelease];
}

+(UIImage*)image:(UIImage*)image withCap:(CapLocation)location capWidth:(NSUInteger)capWidth buttonWidth:(NSUInteger)buttonWidth
{
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(buttonWidth, image.size.height), NO, 0.0);
    
    if (location == CapLeft)
        // To draw the left cap and not the right, we start at 0, and increase the width of the image by the cap width to push the right cap out of view
        [image drawInRect:CGRectMake(0, 0, buttonWidth + capWidth, image.size.height)];
    else if (location == CapRight)
        // To draw the right cap and not the left, we start at negative the cap width and increase the width of the image by the cap width to push the left cap out of view
        [image drawInRect:CGRectMake(0.0-capWidth, 0, buttonWidth + capWidth, image.size.height)];
    else if (location == CapMiddle)
        // To draw neither cap, we start at negative the cap width and increase the width of the image by both cap widths to push out both caps out of view
        [image drawInRect:CGRectMake(0.0-capWidth, 0, buttonWidth + (capWidth * 2), image.size.height)];
    
    UIImage* resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return resultImage;
}

+(UIButton*)woodButtonWithText:(NSString*)buttonText stretch:(CapLocation)location:(BOOL)isLeft
{
    UIImage* buttonImage = nil;
    UIImage* buttonPressedImage = nil;
    NSUInteger buttonWidth = 0;
    
  if(!isLeft)
  {
    if (location == CapLeftAndRight)
    {
        buttonWidth = BUTTON_WIDTH;
        buttonImage = [[UIImage imageNamed:@"saveButton.png"] stretchableImageWithLeftCapWidth:CAP_WIDTH topCapHeight:0.0];
        buttonPressedImage = [[UIImage imageNamed:@"saveButton.png"] stretchableImageWithLeftCapWidth:CAP_WIDTH topCapHeight:0.0];
    }
    else
    {
        buttonWidth = BUTTON_SEGMENT_WIDTH;
        
        buttonImage = [self image:[[UIImage imageNamed:@"saveButton.png"] stretchableImageWithLeftCapWidth:CAP_WIDTH topCapHeight:0.0] withCap:location capWidth:CAP_WIDTH buttonWidth:buttonWidth];
        buttonPressedImage = [self image:[[UIImage imageNamed:@"saveButton.png"] stretchableImageWithLeftCapWidth:CAP_WIDTH topCapHeight:0.0] withCap:location capWidth:CAP_WIDTH buttonWidth:buttonWidth];
    }
  }
    else
    {
        if (location == CapLeftAndRight)
        {
            buttonWidth = BUTTON_WIDTH;
            buttonImage = [[UIImage imageNamed:@"saveButton.png"] stretchableImageWithLeftCapWidth:CAP_WIDTH topCapHeight:0.0];
            buttonPressedImage = [[UIImage imageNamed:@"saveButton.png"] stretchableImageWithLeftCapWidth:CAP_WIDTH topCapHeight:0.0];
        }
        else
        {
            buttonWidth = BUTTON_SEGMENT_WIDTH;
            
            buttonImage = [self image:[[UIImage imageNamed:@"saveButton.png"] stretchableImageWithLeftCapWidth:CAP_WIDTH topCapHeight:0.0] withCap:location capWidth:CAP_WIDTH buttonWidth:buttonWidth];
            buttonPressedImage = [self image:[[UIImage imageNamed:@"saveButton.png"] stretchableImageWithLeftCapWidth:CAP_WIDTH topCapHeight:0.0] withCap:location capWidth:CAP_WIDTH buttonWidth:buttonWidth];
        }
        
    }
    
    
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0.0, 0.0, buttonWidth, buttonImage.size.height);
    button.titleLabel.font = [UIFont boldSystemFontOfSize:[UIFont smallSystemFontSize]];
    button.titleLabel.textColor = [UIColor whiteColor];
    button.titleLabel.shadowOffset = CGSizeMake(0,-1);
    button.titleLabel.shadowColor = [UIColor darkGrayColor];
    
    [button setTitle:buttonText forState:UIControlStateNormal];
    [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [button setBackgroundImage:buttonPressedImage forState:UIControlStateHighlighted];
    [button setBackgroundImage:buttonPressedImage forState:UIControlStateSelected];
    button.adjustsImageWhenHighlighted = NO;
    
    return button;
}
+ (BOOL) isSpecialChar:(NSString *)string
{
    for(int i =0 ; i < [string length]; i++)
    {
        char c = [string characterAtIndex:i];
        if (isalpha(c))
            NSLog(@"Alphabates");
        else
            return TRUE;
    }
    return FALSE;
}

+ (BOOL) validateEmailWithString:(NSString*)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"; 
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex]; 
    return [emailTest evaluateWithObject:email];
}



@end
