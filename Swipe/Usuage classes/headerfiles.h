//
//  headerfiles.h
//  show
//
//  Created by svp on 13/01/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SingletonClass.h"
#import "commonUsedMethods.h"
#import "Font+size.h"
#import "settingValues.h"
#import "SingletonClass.h"
#import "commonUsedMethods.h"
#import "ImageManipulator.h"
#import "DataModel.h"
#import "requestStringURLs.h"
#import "EnvetFinderDelegate.h"
#import "SDImageCache.h"

#define  AppDelegate (EnvetFinderDelegate *)[[UIApplication sharedApplication] delegate]
#define  NOW_LOCATION (CLLocation *)[[SingletonClass sharedInstance] getMyCurrentLocation]
#define  GPX  [GPS_Object sharedInstance]
#define  baseSQLlite         @"Swipe.sqlite"


//#define kServerIp @"https://api.petstagram.com"
//http://174.143.155.231:8080/CurryCloud/api/
//#define kServerIp @"http://174.143.155.231:8080/CurryCloud/api"
//#define kServerIp @"http://174.143.155.231:8080/CurryCloud/api"

#define kServerIp @"http://www.devexpertsteam.com/petstagram2/web/api.php" // commented 22/09/2011
//#define kServerIp @"http://50.57.36.119/web/api.php"


//http://www.devexpertsteam.com/petstagram/web/api.php/
//http://174.143.155.231:8080/CurryCloud/api


#define kSCNavigationBarBackgroundImageTag   6183746
#define makeLoginAgain [[UIApplication sharedApplication] getLoginAgain] 
#define imageGallery [[SingletonClass sharedInstance] getImageDictionary] 
#define imageCaches [SDImageCache sharedImageCache]  
#define sessionKeyValue [[SingletonClass sharedInstance] getSessionID] 
#define markADayKeyValue [[SingletonClass sharedInstance] getMarkADay] 
#define singletonObject [SingletonClass sharedInstance]
#define detailViewController [[SingletonClass sharedInstance] getDetailViewController]
#define USER_PROFILE_IMAGE  @"abcdfghijklm"

//#define _APP_ID_Face   @"134913449904440"
//#define _APP_KEY_Face  @"1be381de5202842ba252649b27dabf12"
//#define _SECRET_KEY_Face @"b35aa264ce387afdf430122975fd0140"

//real credintials
#define _APP_ID_Face   @"300218919992865"
#define _APP_KEY_Face  @"1be381de5202842ba252649b27dabf12"
//#define _SECRET_KEY_Face @"007dae71669e1afde7b0b7900e267c46"

// Talha own personal account app details
//#define _APP_ID_Face   @"214422905289296"
//#define _APP_KEY_Face  @"1be381de5202842ba252649b27dabf12"
//#define _SECRET_KEY_Face @"cccb5bfbee7be22b4ed7325ffc5a8ba9"

@interface headerfiles : NSObject { 

}

@end

