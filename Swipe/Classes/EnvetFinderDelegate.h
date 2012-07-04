//
//  ORBooksAppDelegate.h
//  ORBooks
//
//  Created by Elisabeth Robson on 6/19/09.
//  Copyright Elisabeth Robson 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"
#import "FacebookManager.h"
#import "headerfiles.h"
#import "GPS_Object.h"
#import "socailConnectObject.h"
#import "commonUsedMethods.h"
#import <RestKit/RestKit.h>
#import "ErrorResponse.h"

@class LoginViewCotroller;
@class EventNavController;
@class User;

@class SA_OAuthTwitterEngine;
@interface EnvetFinderDelegate : NSObject <UIApplicationDelegate,UITabBarControllerDelegate,UINavigationControllerDelegate,GPXDelegate,overlayDelegate> {
    
    UIWindow *window;
	IBOutlet UITabBarController         *rootController;
   	LoginViewCotroller                  *login;
	IBOutlet EventNavController         *navigationController;
	BOOL                                isActiveAgain;
    FacebookManager                     *facebookManager;
    SA_OAuthTwitterEngine				*_engine;
	NSInteger                           preTabIndex,currTabIndex;
    BOOL                                isFirstRun;
    socailConnectObject                 *socailObject;
     UIProgressView                     *__syncProgressView;
    
    NSManagedObjectModel *managedObjectModel;
	NSManagedObjectContext *managedObjectContext;	    
	NSPersistentStoreCoordinator *persistentStoreCoordinator;
  
    /** 
     * Possible network statuses:
     * -1 = undetermined
     * 0 = disconnected
     * 1 = connected
     */
    int networkStatus;
@private
    User *__user;
 
    
   
    
     
@private    
    Reachability                        *_internetReachability;
    NetworkStatus                       _connectionStatus;
     UIAlertView                         *progressAlert;
    UIActivityIndicatorView             *activityIndicator;
        
}

@property(nonatomic, assign) BOOL hasAlreadyLogin;
@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *rootController;
@property (nonatomic, retain) FacebookManager *facebookManager;
@property (nonatomic, retain) SA_OAuthTwitterEngine  *_engine;
@property NSInteger  preTabIndex,currTabIndex;
@property (nonatomic, retain) IBOutlet EventNavController  *navigationController;
@property (nonatomic) NetworkStatus connectionStatus;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, retain) UIProgressView *syncProgressView;
@property (nonatomic, retain) User *user;

-(void) displayIntroScreen;
-(void) userHasDismissInto;
-(void) requestForNearByData;
-(void)addCameraOverlayToWindow;
-(void)removeCameraOverlayFromWindows;
-(void)loadProgressViewWithCaption:(NSString *)caption;
-(void) showTabBarView;
- (void)checkNetworkConnection; 
-(void)cancelProgressView;
-(void) removeAllViews;
//-(void) NotifyDC:(NSNumber *) num_value;
-(void) clearAllCacheImage;
-(void) showLoginScreen;
-(void) logout;
-(void) switchTabIndex:(int)_index;
-(void) moveToLastView;
-(void) removeAllViews2;
-(void)removeAllTabBarViews;
-(void) fetchImageProfile;
-(void) showAlertView :(NSString *)_str;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
-(void) removeLoginView:(NSArray *)_array;
-(void) showAlertView:(NSString *)_str;
- (BOOL)isOnline;
- (BOOL)canSync;
- (NSDictionary *)getOauthCredentials;
- (BOOL)setOauthCredentials:(NSDictionary *)credentials;
- (void)initRestKit;
-(void) testRun;
- (void)syncButtonPressed;

@end

