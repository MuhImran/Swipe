//
//  ORBooksAppDelegate.m
//  ORBooks
//
//  Created by Elisabeth Robson on 6/19/09.
//  Copyright Elisabeth Robson 2009. All rights reserved.
//
//////************************************//////////////
// Cent OS 5.5/Debian 5(Lenny) 32 bits
// 1.5 GB RAM any DUAL CORE CPU with 30 GB HD
//  10Mbit minimum recommended 100Mbit


 // elliottfranco
//  GroceryG123

//b2nzktdmtdt7harxbtgn4yx6

///// ***************************************/////////////

#import "EnvetFinderDelegate.h"
#import "EventNavController.h"
#import "HomeScreenViewController.h"
#import "LoginViewCotroller.h"
#import "commonUsedMethods.h"
#import "splashViewController.h"
#import "DataModel.h"
#import "SingletonClass.h"
#import "profileImageFetcher.h"

#import "profileViewController.h"
#import "SocialData.h"
#import "PhoneList.h"
#import "User.h"
#import "EmailList.h"
#import "ContactBook.h"
#import "MySyncEntity.h"

/*
@interface EventNavController (MyCustomNavBar)
@end
@implementation EventNavController (MyCustomNavBar)
- (void) drawRect:(CGRect)rect {
    UIImage *barImage = [UIImage imageNamed:@"navbar_bg_portrait1.png"];
    [barImage drawInRect:rect];
}
@end
*/
@implementation EnvetFinderDelegate

@synthesize window;
@synthesize rootController;
@synthesize hasAlreadyLogin;
@synthesize navigationController;
@synthesize facebookManager;

@synthesize connectionStatus = _connectionStatus;
@synthesize _engine;
@synthesize preTabIndex,currTabIndex;

@synthesize managedObjectContext = __managedObjectContext;
@synthesize managedObjectModel = __managedObjectModel;
@synthesize persistentStoreCoordinator = __persistentStoreCoordinator;
@synthesize syncProgressView;
@synthesize user;





#pragma mark facebook
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
   // NSLog(@"%@",url);
	return [facebookManager.facebook handleOpenURL:url];
}
- (void)applicationDidFinishLaunching:(UIApplication *)application {
    
    LogTrace(@"Swipe didFinishLaunchingWithOptions START");
    
#if TARGET_IPHONE_SIMULATOR
    // For debugging, outputs tons of RK network stuff to the log
    RKLogConfigureByName("RestKit/Network*", RKLogLevelTrace);
    
#else
    
    // Enable TestFlight's remote crash logging and reports
    //[TestFlight takeOff:@"8e0745e1c79907f4580a1fac4298800a_MTg1MjAyMDExLTA5LTEyIDE1OjQ3OjQ4Ljc1NTU3MQ"];
    
#endif
    
    networkStatus = -1;

    
	[[UIApplication sharedApplication] registerForRemoteNotificationTypes: UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeBadge];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque];
    facebookManager = [[FacebookManager alloc] init];
    isActiveAgain = FALSE;
    [self initRestKit];
    [self removeAllViews];
}

-(void) logout
{
	[self switchTabIndex:0];
    [commonUsedMethods logoutUser];
    [self removeAllTabBarViews];
	[DataModel removeAllStoreData];
	[self removeAllViews2];
	
	
}
-(void) removeAllViews
{
	if(![commonUsedMethods hasUserAlreadyLogin])
	 {
        
            login = [[LoginViewCotroller alloc] initWithNibName:@"LoginViewCotroller" bundle:[NSBundle mainBundle]];
            [login retain];
            [window addSubview:login.view];
            [window makeKeyAndVisible];	
            hasAlreadyLogin = FALSE; 
    }
    
	else if([commonUsedMethods hasUserAlreadyLogin])
	{
		hasAlreadyLogin = TRUE;
		[self showTabBarView];
	}
	
}
-(void) removeAllViews2
{
	
       // if(!login)
       // {
            login = [[LoginViewCotroller alloc] initWithNibName:@"LoginViewCotroller" bundle:[NSBundle mainBundle]];
            
        //}
    [login retain];
        [window addSubview:login.view];
        hasAlreadyLogin = FALSE; 
        [window makeKeyAndVisible];	
}


-(void) showLoginScreen
{
	///////   FOR DUMMY TEMPLATE DATE  ////////////////
	[rootController.view removeFromSuperview];
	[window addSubview:login.view];
	[window makeKeyAndVisible];	

}
-(void) showTabBarView
{
	
    socailObject = [[SingletonClass sharedInstance ] getSocialObject];
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"AccessToken"] != nil)
    {
        [commonUsedMethods setFacebookConfigured:YES];
    }
    else
        [commonUsedMethods setFacebookConfigured:NO];
	if(!hasAlreadyLogin)
	{
	   [login.view removeFromSuperview];
		
	}
	rootController.delegate=self;
	[window addSubview:rootController.view];
	[window makeKeyAndVisible];
}
-(void) fetchImageProfile
{
    
    NSMutableDictionary *dic = [[SingletonClass sharedInstance] getFbDictionary];
    NSLog(@"%@",dic);
    if(dic &&[dic count]>0)
    {
    profileImageFetcher *imageFetcher = [[profileImageFetcher alloc] init];
    [imageFetcher requestForProfileURL];
     [imageFetcher release];
    }
}

- (void)applicationWillTerminate:(UIApplication *)application
{
	NSLog(@"Here at application terminate delegate");
	[self clearAllCacheImage];
}
- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
    [imageCaches cleanDisk];
    application.applicationIconBadgeNumber = 0;
    if ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable) {
        NSString *message = @"There is no internet connection available. Please try again later";
        [self showAlertView:message];
    }
    
}

- (void)applicationWillResignActive:(UIApplication *)application
{
	//applicationResume = TRUE;
	NSLog(@"Here at applicationWillTerminate delegate");
	///[self clearAllCacheImage];
}

-(void) clearAllCacheImage
{
    NSLog(@"Now clearing all cache image, reason -> standby/close/memory warning");
    [imageCaches clearMemory];
}

//-(void) clearAllCacheImage
//{
//	NSLog(@"Now clearing all cache image, reason -> standby/close/memory warning");
//	NSString *tempPath = NSTemporaryDirectory();
//	NSArray *dirContents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:tempPath error:nil];
//	for (NSString *temp in dirContents)
//		[[NSFileManager defaultManager] removeItemAtPath:[tempPath stringByAppendingString:temp] error:nil];
//}


    // social connect delegate
/*
-(void)showTwitterView:(SA_OAuthTwitterController *)_controller
{
}
-(void) TwitterStatus:(NSNumber *)_status
{
}
-(void) facebookStatus:(NSNumber *)_status
{
}
-(void) hasUserProfileData:(NSMutableData *)_dictionary
{
}
 */
#pragma mark Reachability

- (void)checkNetworkConnection {
	_connectionStatus = NotReachable;
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNetworkChange:) name:kReachabilityChangedNotification object:nil];
	
	_internetReachability = [Reachability reachabilityForInternetConnection];
	[_internetReachability startNotifier];
	
	_connectionStatus = [_internetReachability currentReachabilityStatus];
}
-(void)loadProgressViewWithCaption:(NSString *)caption
{
	CGRect progressIndFrame = CGRectMake(110,45, 60, 60);
	
	if(progressAlert != nil)
	{
		progressAlert = nil;
		[progressAlert release];
	}
	progressAlert = [[UIAlertView alloc]  initWithTitle:nil 
												message:caption 
											   delegate:self cancelButtonTitle:nil
									  otherButtonTitles:nil];
	[progressAlert show];
	[progressAlert setBackgroundColor:[UIColor clearColor]];
	if (activityIndicator == nil) {
		activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];	
	}
	activityIndicator.frame = progressIndFrame;
	[progressAlert addSubview:activityIndicator];
	[activityIndicator startAnimating];	
	
}

-(void)cancelProgressView
{
	if([activityIndicator isAnimating]){
		[activityIndicator stopAnimating];
	}
	[progressAlert dismissWithClickedButtonIndex:0 animated: YES];
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
	
   // self.preTabIndex = self.currTabIndex;
   // self.currTabIndex = tabBarController.selectedIndex;
   
   // NSLog(@"current tab %d",tabBarController.selectedIndex);
    
   // [commonUsedMethods setPreviousTabIndex:[NSString stringWithFormat:@"%d",self.preTabIndex]];
   // [commonUsedMethods setCurrentTabIndex:[NSString stringWithFormat:@"%d",self.currTabIndex]];
    
	NSArray *vc= tabBarController.viewControllers;
	NSLog(@"TabBar delegate called%d",[vc count]);
	for (int i = 0; i < [vc count]; i++) {
		
		{
			UINavigationController *nc = [vc objectAtIndex:i];
			if (nc == tabBarController.selectedViewController) {
				continue;
			}
			//	NSLog(@"IMRAN TAB %d and %d",i+1,[nc.viewControllers count]);
			[nc popToRootViewControllerAnimated:NO];
			
			
		}
		
	}
	
}
-(void)removeAllTabBarViews
{
	NSArray *vc= self.rootController.viewControllers;
	self.rootController.selectedViewController = [self.rootController.viewControllers objectAtIndex:0];
	NSLog(@"%d",[vc count]);
	for (int i = 0; i < [vc count]; i++) 
		
		{
			UINavigationController *nc = [vc objectAtIndex:i];
			for (int j = [nc.viewControllers count]-1; j > 0; j--) {
				UIView *mainView = [[nc.viewControllers objectAtIndex:j-1] view];
				[mainView removeFromSuperview];
				[nc popToRootViewControllerAnimated:NO];
                if(i == [vc count]-1)
                {
                   // profileViewController *controller = (profileViewController *)[nc.viewControllers objectAtIndex:0];
                   
                }
			}
		}
}
-(void) switchTabIndex:(int)_index
{
  
    NSArray *vc= self.rootController.viewControllers;
    UINavigationController *nc = [vc objectAtIndex:_index];
    [nc popToRootViewControllerAnimated:NO];
    nc = [vc objectAtIndex:0];
	HomeScreenViewController *home = (HomeScreenViewController *)[nc.viewControllers objectAtIndex:0];
    //NSLog(@"Before tab bar is %d",home.segmentControl.selectedSegmentIndex);
    home.reqType = 0;
    //NSLog(@"after tab bar is %d",home.segmentControl.selectedSegmentIndex);
    [self.rootController setSelectedIndex:0];
}
-(void) moveToLastView
{
   // NSLog(@"ANUM-->%@",[commonUsedMethods getLastTabBarIndex]);
    NSArray *vc= self.rootController.viewControllers;
    UINavigationController *nc = [vc objectAtIndex:1];
    [nc popToRootViewControllerAnimated:NO];
   // nc = [vc objectAtIndex:0];
    [self.rootController setSelectedIndex:[[commonUsedMethods getLastTabBarIndex] intValue]];
    
   // NSArray *vc= self.rootController.viewControllers;
	//self.rootController.selectedViewController = [self.rootController.viewControllers objectAtIndex:[[commonUsedMethods //getLastTabBarIndex] intValue]];
    
}

- (void)dealloc {
	
	[facebookManager release];
	[rootController release];
    [window release];
	[navigationController release];
	[super dealloc];
	
} 
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    NSString *deviceTokenStr = [[[[deviceToken description]
                                  stringByReplacingOccurrencesOfString: @"<" withString: @""]
                                 stringByReplacingOccurrencesOfString: @">" withString: @""]
                                stringByReplacingOccurrencesOfString: @" " withString: @""];
    NSLog(@"Retrived device token as %@", deviceTokenStr);
    [[SingletonClass sharedInstance] saveUserPushKey:deviceTokenStr];
}
- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err { 
	
    NSLog(@"Sorry device token not accessbile");
	
}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSString *alertMsg;
    if( [[userInfo objectForKey:@"aps"] objectForKey:@"alert"] != NULL)
    {
        alertMsg = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"]; 
    }
	
    [self showAlertView:alertMsg];
}

-(void) showAlertView :(NSString *)_str
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" 
                                                    message:_str 
                                                   delegate:nil 
                                          cancelButtonTitle:@"OK" 
                                          otherButtonTitles:nil];
    [alert show];
    [alert release];
    
    
}
-(void) landOnAppHomeScreen
{
    [window addSubview:rootController.view];
    [window makeKeyAndVisible];
}
- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managed_object_context = self.managedObjectContext;
    if (managed_object_context != nil)
    {
        if ([managed_object_context hasChanges] && ![managed_object_context save:&error])
        {
            /*
             Replace this implementation with code to handle the error appropriately.
             
             abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
             */
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

#pragma mark - Core Data stack

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *)managedObjectContext
{
    if (__managedObjectContext != nil)
    {
        return __managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil)
    {
        __managedObjectContext = [[NSManagedObjectContext alloc] init];
        [__managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return __managedObjectContext;
}

/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created from the application's model.
 */
- (NSManagedObjectModel *)managedObjectModel
{
    if (__managedObjectModel != nil)
    {
        return __managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"SwipeDataModel" withExtension:@"momd"];
    __managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return __managedObjectModel;
}

/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (__persistentStoreCoordinator != nil)
    {
        return __persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:baseSQLlite];
    
    NSError *error = nil;
    __persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![__persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error])
    {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter: 
         [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return __persistentStoreCoordinator;
}
#pragma mark - Application's Documents directory

/**
 Returns the URL to the application's Documents directory.
 */
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}
/*

- (void)initRestKit
{
    // Initialize RestKit
    RKObjectManager *objectManager = [RKObjectManager objectManagerWithBaseURL:kServerIp];
    
    // Initialize object store
    objectManager.objectStore = [RKManagedObjectStore objectStoreWithStoreFilename:baseSQLlite usingSeedDatabaseName:nil managedObjectModel:self.managedObjectModel delegate:nil];
    // Disable caching on the client
    objectManager.client.cachePolicy = RKRequestCachePolicyNone;
    
    // Enable automatic network activity indicator management
    objectManager.requestQueue.showsNetworkActivityIndicatorWhenBusy = YES;
    objectManager.requestQueue.concurrentRequestsLimit = 1;
    
       
}*/

/*
 -(void) testRun
 {
 
 NSDictionary *param = [NSDictionary dictionaryWithKeysAndObjects:@"response_type",@"json", nil];
 [[RKClient sharedClient] get:@"get_patients" queryParams:param delegate:self];
 }
 */


- (void)initRestKit
{
    // Initialize RestKit
	
    RKObjectManager *objectManager = [RKObjectManager objectManagerWithBaseURL:kServerIp];
    
    // Initialize object store
    objectManager.objectStore = [RKManagedObjectStore objectStoreWithStoreFilename:@"Swipe.sqlite" usingSeedDatabaseName:nil managedObjectModel:self.managedObjectModel delegate:nil];
    // Disable caching on the client
    objectManager.client.cachePolicy = RKRequestCachePolicyNone;
    
    // Enable automatic network activity indicator management
    [RKRequestQueue sharedQueue].showsNetworkActivityIndicatorWhenBusy = YES;
    [RKRequestQueue sharedQueue].concurrentRequestsLimit = 1;
    
    // Enable oAuth
   
    [RKClient setSharedClient:objectManager.client];
    //[oAuthCredentials release];
    
    /** 
     * Generic Error
     * This is not a ManagedObject.
     */
   // RKObjectMapping* errorMapping = [RKObjectMapping mappingForClass:[ErrorResponse class]];
   // [errorMapping mapAttributes:@"title", @"message", nil];
    
    
    /**
     * User
     */
    RKManagedObjectMapping* userMapping = [RKManagedObjectMapping mappingForEntityWithName:@"User"];
    userMapping.setNilForMissingRelationships = NO;
    userMapping.primaryKeyAttribute = @"userId";
    [userMapping mapKeyPath:@"id" toAttribute:@"userId"];
    [userMapping mapKeyPath:@"first_name" toAttribute:@"firstName"];
    [userMapping mapKeyPath:@"last_name" toAttribute:@"lastName"];
   
    
    // routes
    [objectManager.router routeClass:[User class] toResourcePath:@"/Users"];
    [objectManager.router routeClass:[User class] toResourcePath:@"/Users/(userId)" forMethod:RKRequestMethodPUT];
    [objectManager.router routeClass:[User class] toResourcePath:@"/Users/(userId)" forMethod:RKRequestMethodDELETE];
    [objectManager.router routeClass:[User class] toResourcePath:@"/Users/(userId)" forMethod:RKRequestMethodGET];
    
    
    /**
     * AddressBook Mapping
     */
    
    
    // routes
    [objectManager.router routeClass:[ContactBook class] toResourcePath:@"/Contacts"];
    [objectManager.router routeClass:[ContactBook class] toResourcePath:@"/Contacts/:contactId" forMethod:RKRequestMethodPUT];
    [objectManager.router routeClass:[ContactBook class] toResourcePath:@"/Contacts/:contactId" forMethod:RKRequestMethodDELETE];
    [objectManager.router routeClass:[ContactBook class] toResourcePath:@"/Contacts/:contactId" forMethod:RKRequestMethodGET];
    
    
    // object mapping
    RKManagedObjectMapping* contactMapping = [RKManagedObjectMapping mappingForEntityWithName:@"ContactBook"];
    contactMapping.setNilForMissingRelationships = NO;
   //[contactMapping mapAttributes:@"name", nil];
    contactMapping.primaryKeyAttribute = @"contactId";
    [contactMapping mapKeyPath:@"contactId" toAttribute:@"contactId"];
    [contactMapping mapKeyPath:@"dob" toAttribute:@"dob"];
    [contactMapping mapKeyPath:@"firstName" toAttribute:@"firstName"];
    [contactMapping mapKeyPath:@"jobTitle" toAttribute:@"jobTitle"];
    [contactMapping mapKeyPath:@"lastName" toAttribute:@"lastName"];
    [contactMapping mapKeyPath:@"dept" toAttribute:@"dept"];
   
    // Update date format so that we can parse Rails dates: Wed Sep 29 15:31:08 +0000 2010
	//[journalMapping.dateFormatStrings addObject:@"E MMM d HH:mm:ss Z y"];
    
    // serialization
    RKObjectMapping* contactSerializationMapping = [RKObjectMapping mappingForClass:[NSMutableDictionary class]];
    contactSerializationMapping = [contactSerializationMapping inverseMapping];
    [contactSerializationMapping mapKeyPath:@"contactId" toAttribute:@"contactId"];
    [contactSerializationMapping mapKeyPath:@"dob" toAttribute:@"dob"];
    [contactSerializationMapping mapKeyPath:@"firstName" toAttribute:@"firstName"];
    [contactSerializationMapping mapKeyPath:@"jobTitle" toAttribute:@"jobTitle"];
    [contactSerializationMapping mapKeyPath:@"lastName" toAttribute:@"lastName"];
    [contactSerializationMapping mapKeyPath:@"dept" toAttribute:@"dept"];
    
    
    /**
     * Social
     */
    
    
    // object mapping
    RKManagedObjectMapping* SocialMapping = [RKManagedObjectMapping mappingForEntityWithName:@"SocialData"];
    SocialMapping.setNilForMissingRelationships = NO;
    [SocialMapping mapKeyPath:@"facebook" toAttribute:@"facebook"];
    [SocialMapping mapKeyPath:@"facebookURL" toAttribute:@"facebookURL"];
    [SocialMapping mapKeyPath:@"flicker" toAttribute:@"flicker"];
    [SocialMapping mapKeyPath:@"flickerURL" toAttribute:@"flickerURL"];
    [SocialMapping mapKeyPath:@"linkedIn" toAttribute:@"linkedIn"];
    [SocialMapping mapKeyPath:@"linkedInURL" toAttribute:@"linkedInURL"];
    [SocialMapping mapKeyPath:@"mySpace" toAttribute:@"mySpace"];
    [SocialMapping mapKeyPath:@"mySpaceURL" toAttribute:@"mySpaceURL"];
    [SocialMapping mapKeyPath:@"twitter" toAttribute:@"twitter"];
    [SocialMapping mapKeyPath:@"twitterURL" toAttribute:@"twitterURL"];
    // Update date format so that we can parse Rails dates: Wed Sep 29 15:31:08 +0000 2010
	//[journalMapping.dateFormatStrings addObject:@"E MMM d HH:mm:ss Z y"];
    
    // serialization
    RKObjectMapping* SocialSerializationMapping = [RKObjectMapping mappingForClass:[NSMutableDictionary class]];
    [SocialSerializationMapping mapKeyPath:@"facebook" toAttribute:@"facebook"];
    [SocialSerializationMapping mapKeyPath:@"facebookURL" toAttribute:@"facebookURL"];
    [SocialSerializationMapping mapKeyPath:@"flicker" toAttribute:@"flicker"];
    [SocialSerializationMapping mapKeyPath:@"flickerURL" toAttribute:@"flickerURL"];
    [SocialSerializationMapping mapKeyPath:@"linkedIn" toAttribute:@"linkedIn"];
    [SocialSerializationMapping mapKeyPath:@"mySpace" toAttribute:@"mySpace"];
    [SocialSerializationMapping mapKeyPath:@"mySpaceURL" toAttribute:@"mySpaceURL"];
    [SocialSerializationMapping mapKeyPath:@"twitter" toAttribute:@"twitter"];
    [SocialSerializationMapping mapKeyPath:@"twitterURL" toAttribute:@"twitterURL"];
    
    
    
    
    /**
     * Phone
     */
    
       
    // object mapping
    RKManagedObjectMapping* phoneMapping = [RKManagedObjectMapping mappingForEntityWithName:@"PhoneList"];
    phoneMapping.primaryKeyAttribute = @"phoneId";
    [phoneMapping mapKeyPath:@"phoneId" toAttribute:@"phoneId"];
    [phoneMapping mapKeyPath:@"phoneTitle" toAttribute:@"phoneTitle"];
    [phoneMapping mapKeyPath:@"phoneNo" toAttribute:@"phoneNo"];
    
    // Update date format so that we can parse Rails dates: Wed Sep 29 15:31:08 +0000 2010
	//[entryMapping.dateFormatStrings addObject:@"E MMM d HH:mm:ss Z y"];
    
    // serialization
    RKObjectMapping* phoneSerializationMapping = [RKObjectMapping mappingForClass:[NSMutableDictionary class]];
    [phoneSerializationMapping mapKeyPath:@"phoneId" toAttribute:@"phoneId"];
    [phoneSerializationMapping mapKeyPath:@"phoneTitle" toAttribute:@"phoneTitle"];
    [phoneSerializationMapping mapKeyPath:@"phoneNo" toAttribute:@"phoneNo"];
   
    /**
     * Email
     */
    
    // object mapping
    RKManagedObjectMapping* emailMapping = [RKManagedObjectMapping mappingForEntityWithName:@"EmailList"];
     emailMapping.primaryKeyAttribute = @"emailId";
    [emailMapping mapKeyPath:@"emailId" toAttribute:@"emailId"];
    [emailMapping mapKeyPath:@"email" toAttribute:@"email"];
    [emailMapping mapKeyPath:@"emailTitle" toAttribute:@"emailTitle"];
   
    // Update date format so that we can parse Rails dates: Wed Sep 29 15:31:08 +0000 2010
	//[photoMapping.dateFormatStrings addObject:@"E MMM d HH:mm:ss Z y"];
    
    // serialization mapping
    RKObjectMapping* emailSerializationMapping = [RKObjectMapping mappingForClass:[NSMutableDictionary class]];
    [emailSerializationMapping mapKeyPath:@"emailId" toAttribute:@"emailId"];
    [emailSerializationMapping mapKeyPath:@"email" toAttribute:@"email"];
    [emailSerializationMapping mapKeyPath:@"emailTitle" toAttribute:@"emailTitle"];
    
    
    
    /**
     * Relationships between mappings
     */
    
    [userMapping mapRelationship:@"contact" withMapping:contactMapping];
    [contactMapping mapRelationship:@"userEmails" withMapping:emailMapping];
    [contactMapping mapRelationship:@"phones" withMapping:phoneMapping];
    [contactMapping mapRelationship:@"userSocial" withMapping:SocialMapping];
    
   // [journalMapping mapKeyPath:@"recent_entries" toRelationship:@"entries" withObjectMapping:entryMapping serialize:NO];
   // [entryMapping mapKeyPath:@"journal" toRelationship:@"journal" withObjectMapping:journalMapping];
    //[entryMapping mapKeyPath:@"visible_photos" toRelationship:@"photos" withObjectMapping:photoMapping serialize:NO];
    //[photoMapping mapKeyPath:@"entry" toRelationship:@"entry" withObjectMapping:entryMapping serialize:NO];
    
    
    /**
     * Register mappings
     */
    
    // object mappings
   // [objectManager.mappingProvider setObjectMapping:errorMapping forKeyPath:@"error"];
    [objectManager.mappingProvider setObjectMapping:userMapping forKeyPath:@"user"];
    [objectManager.mappingProvider setObjectMapping:SocialMapping forKeyPath:@"Social"];
    [objectManager.mappingProvider setObjectMapping:emailMapping forKeyPath:@"emails"];
    [objectManager.mappingProvider setObjectMapping:phoneMapping forKeyPath:@"phones"];
    [objectManager.mappingProvider setObjectMapping:contactMapping forKeyPath:@"contacts"];
    
    
    [contactSerializationMapping mapKeyPath:@"phones" toRelationship:@"phones" withMapping:phoneMapping];
    [contactSerializationMapping mapKeyPath:@"userEmails" toRelationship:@"userEmails" withMapping:emailMapping];
    
    // serialization mappings
    [objectManager.mappingProvider setSerializationMapping:SocialSerializationMapping forClass:[SocialData class]];
    [objectManager.mappingProvider setSerializationMapping:emailSerializationMapping forClass:[EmailList class]];
    [objectManager.mappingProvider setSerializationMapping:phoneSerializationMapping forClass:[PhoneList class]];
    [objectManager.mappingProvider setSerializationMapping:contactSerializationMapping forClass:[ContactBook class]];
    
    /**
     * MySyncEntity
     */
    
    
    // routes
    [objectManager.router routeClass:[MySyncEntity class] toResourcePath:@"/upload"];
    
    //now, we create mapping for the MySyncEntity
    RKObjectMapping *syncEntityMapping = [RKObjectMapping mappingForClass:[MySyncEntity class]];
  //  [objectManager.mappingProvider setObjectMapping:SocialMapping forKeyPath:@"Social"];
    [syncEntityMapping mapKeyPath:@"AddressBook" toRelationship:@"AddressBookArray" withMapping:contactMapping];
    [objectManager.mappingProvider setSerializationMapping:[syncEntityMapping inverseMapping]
                                              forClass:[MySyncEntity class]];
    /**
     * Subscribe to reachability change events so we know if we're online or not.
     */
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:RKReachabilityDidChangeNotification object:nil];

}

#pragma mark Sync functions

- (void)reachabilityChanged:(NSNotification*)aNotification
{
    LogInfo(@"PenzuAppDelegate.reachabilityChanged! %@", aNotification);
	networkStatus = (int)[[RKClient sharedClient].reachabilityObserver isNetworkReachable];
}

- (BOOL)isOnline
{
    // If networkStatus hasn't been determined yet, try to do it quickly.
    // This typically happens on startup before initial connectivity to our host
    // can be determined. This does not test that our host is healthy, just that
    // a net connection is possible.
    if(networkStatus < 0)
    {
        // IP Address reachability can be determined immediately as opposed to hostname 
        // which happens asynchronously.
        // Alternatively, we could use a Google IP: 8.8.8.8
        RKReachabilityObserver *ro = [[RKReachabilityObserver alloc] initWithHost:@"8.8.8.8"];
        [ro networkStatus];
        LogTrace(@"tmp ro: %d %d", ro.reachabilityEstablished, (RKReachabilityNotReachable != [ro networkStatus]));
        if(ro.reachabilityDetermined && [ro networkStatus] != RKReachabilityNotReachable)
        {
            [ro release];
            return YES;
        }
        [ro release];
    }
   // return ([[RKClient sharedClient] isNetworkReachable] && (networkStatus == 1));
    return YES;
}

- (BOOL)canSync
{
   // NSDictionary *oAuthCredentials = [self getOauthCredentials];
    //LogTrace(@"canSync? %@ %@ %@ %@", self.user, self.user.isLinked, self.user.userId, oAuthCredentials);
    //return (self.user != nil  && oAuthCredentials != nil);
    return YES;
}

#pragma mark SyncDelegate

- (void)syncDidFailWithError:(NSError *)error
{
    LogDebug(@"PenzuAppDelegate.syncDidFailWithError %@", [error localizedDescription]);
    NSArray* detailedErrors = [[error userInfo] objectForKey:NSDetailedErrorsKey];
    if(detailedErrors != nil && [detailedErrors count] > 0) {
        for(NSError* detailedError in detailedErrors) {
            LogError(@"  DetailedError: %@", [detailedError userInfo]);
        }
    }
    else {
        LogError(@"  %@", [error userInfo]);
    }
    
    // release the SyncManager
    //[self setSyncManager:nil]; // crashes, restkit/syncmanager is still doing stuff, possibly caching photos
    [self setSyncProgressView:nil];
    
    // ensure we get a fresh list of journals next time we ask for it
    [self setLocalJournals:nil];
    
    [self showFirstViewController];
}

- (void)syncDidFinish
{
    LogTrace(@"PenzuAppDelegate.syncDidFinish");
    
    // release the SyncManager
    //[self setSyncManager:nil]; // crashes, restkit/syncmanager is still doing stuff, possibly caching photos
    LogTrace(@"clearing setSyncProgressView");
    [self setSyncProgressView:nil];
    
    // ensure we get a fresh list of journals next time we ask for it
    LogTrace(@"clearing localJournals");
    [self setLocalJournals:nil];
    
    // update the lastSyncAt timestamp for the user
    LogTrace(@"fetching local user");
    self.user = nil;
    [self performSelectorOnMainThread:@selector(getLocalUserOrCreateOne:) withObject:NO waitUntilDone:NO];
    // [self getLocalUserOrCreateOne:NO];
    if(self.user != nil)
    {
        LogTrace(@"setting lastSyncAt for local user");
        self.user.lastSyncAt = [NSDate date];
        NSError *error = nil;
        //if(![self.user.managedObjectContext save:&error])
        if(![self.managedObjectContext save:&error])
        {
            LogError(@"problem saving user's lastSyncAt time: %@ %@", error, [error userInfo]);
        }
    }
    LogTrace(@"PenzuAppDelegate.showFirstViewController callling");
    //[self showFirstViewController];
    [self performSelectorOnMainThread:@selector(showFirstViewController) withObject:NO waitUntilDone:NO];
}
- (void)syncDidStart
{
    if(self.syncProgressView != nil)
    {
        [self.syncProgressView setProgress:0.0];
        self.syncProgressView.hidden = NO;
    }
}

- (void)syncDidMakeProgress:(float)percentage
{
    if(self.syncProgressView != nil)
    {
        [self.syncProgressView setProgress:percentage];
    }
}

@end
