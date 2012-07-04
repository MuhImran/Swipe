//
//  SyncManager.m
//  Penzu
//
//  Created by Michael Lawlor on 11-08-06.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SyncManager.h"
#import "User.h"
#import "ErrorResponse.h"
#import "EnvetFinderDelegate.h"
#import "MySyncEntity.h"


static NSString *kSyncLabelNever = @"Backup & Sync to the Web";
static NSString *kSyncLabelPrefix = @"Last Sync: ";

@implementation SyncManager
@synthesize delegate = __delegate;
@synthesize localContacts = __localContacts;
@synthesize objectToSync=__objectToSync;

@synthesize toolbarSyncView;
@synthesize toolbarSyncButton;
@synthesize toolbarSyncButtonItem;
@synthesize toolbarSyncLabel;
@synthesize toolbarSyncActivityIndicator;
@synthesize toolbarSyncDoneLabel;

+ (NSString *)lastSyncDateString:(NSDate *)date
{
    //NSLog(@"SyncManager+lastSyncDateString: %@", date);
    static NSDateFormatter *dateFormatter = nil;
    if (dateFormatter == nil) {
        dateFormatter = [[NSDateFormatter alloc] init];
    }
    
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDate *now = [NSDate date];
    
    NSDateComponents *todayComponents = [cal components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:now];
    NSDate *today = [cal dateFromComponents:todayComponents];
    if([date compare:today] == NSOrderedDescending)
    {
        // show a time from today
        [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
        [dateFormatter setDateStyle:NSDateFormatterNoStyle];
        //return [NSString stringWithFormat:@"%@%@", kSyncLabelPrefix, [dateFormatter stringFromDate:date]];
        return [NSString stringWithString:[dateFormatter stringFromDate:date]];
    }
    
    NSDateComponents *yesterdayComponents = [[NSDateComponents alloc] init];
    [yesterdayComponents setDay:-1];
    NSDate *yesterday = [cal dateByAddingComponents:yesterdayComponents toDate:today options:0];
    if([date compare:yesterday] == NSOrderedDescending)
    {
        [dateFormatter setDateFormat:@"'Yesterday'"];
        [yesterdayComponents release];
        //return [NSString stringWithFormat:@"%@%@", kSyncLabelPrefix, [dateFormatter stringFromDate:date]];
        return [NSString stringWithString:[dateFormatter stringFromDate:date]];
    }
    [yesterdayComponents release];
    
    NSDateComponents *weekComponents = [[NSDateComponents alloc] init];
    [weekComponents setDay:-7];
    NSDate *weekAgo = [cal dateByAddingComponents:weekComponents toDate:today options:0];
    if([date compare:weekAgo] == NSOrderedDescending)
    {
        [dateFormatter setDateFormat:@"EEEE"];
    }
    else
    {
        // show standard date format
        [dateFormatter setDateFormat:@"MM-dd-YY"];
    }
    [weekComponents release];
    //return [NSString stringWithFormat:@"%@%@", kSyncLabelPrefix, [dateFormatter stringFromDate:date]];
    return [NSString stringWithString:[dateFormatter stringFromDate:date]];
}

- (SyncManager *)initWithDelegate:(id<SyncDelegate>)syncDelegate
{
    self = [super init];
    if(self)
    {
        self.delegate = syncDelegate;
        syncPendingCount = 0;
        syncCompleteCount = 0;
    }
    return self;
}

- (void)dealloc
{
    [__localContacts release];
    [__objectToSync release];
    [toolbarSyncView release];
    [toolbarSyncButton release];
    [toolbarSyncButtonItem release];
    [toolbarSyncLabel release];
    [toolbarSyncActivityIndicator release];
    [toolbarSyncDoneLabel release];
    [super dealloc];
}

- (UIBarButtonItem *)toolbarItemWithTarget:(id)target action:(SEL)selector
{
    if(self.toolbarSyncButtonItem == nil)
    {
        UIView *aToolbarSyncView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 230, 32)];
        aToolbarSyncView.backgroundColor = [UIColor clearColor];
        self.toolbarSyncView = aToolbarSyncView;
        [aToolbarSyncView release];

        UIButton *aSyncButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 35, 32)];
        [aSyncButton setImage:[UIImage imageNamed:@"syncButton.png"] forState:UIControlStateNormal];
        [toolbarSyncView addSubview:aSyncButton];
        self.toolbarSyncButton = aSyncButton;
        [aSyncButton release];
        
        UIActivityIndicatorView *aToolbarSyncActivityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        //aToolbarSyncActivityIndicator.frame = CGRectMake(0, 0, 35, 32);
        //aToolbarSyncActivityIndicator.frame = CGRectMake(3, 3, 29, 29);
        aToolbarSyncActivityIndicator.frame = CGRectMake(5, 5, 25, 25);
        aToolbarSyncActivityIndicator.hidesWhenStopped = YES;
        [aToolbarSyncActivityIndicator stopAnimating];
        [toolbarSyncView addSubview:aToolbarSyncActivityIndicator];
        self.toolbarSyncActivityIndicator = aToolbarSyncActivityIndicator;
        [aToolbarSyncActivityIndicator release];

        UILabel *syncLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, 184, 32)];
        syncLabel.font = [UIFont boldSystemFontOfSize:14]; //[UIFont systemFontOfSize:14];
        syncLabel.text = kSyncLabelNever;
        syncLabel.backgroundColor = [UIColor clearColor];
        syncLabel.textColor = [UIColor whiteColor];
        [toolbarSyncView addSubview:syncLabel];
        self.toolbarSyncLabel = syncLabel;
        [syncLabel release];
        
        UILabel *syncDoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 35, 32)];
        syncDoneLabel.text = @"✓";
        syncDoneLabel.font = [UIFont boldSystemFontOfSize:24];
        syncDoneLabel.hidden = YES;
        syncDoneLabel.backgroundColor = [UIColor clearColor];
        syncDoneLabel.textColor = [UIColor whiteColor];
        syncDoneLabel.textAlignment = UITextAlignmentCenter;
        [toolbarSyncView addSubview:syncDoneLabel];
        self.toolbarSyncDoneLabel = syncDoneLabel;
        [syncDoneLabel release];
        
        UIBarButtonItem *aToolbarSyncButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.toolbarSyncView];
        self.toolbarSyncButtonItem = aToolbarSyncButtonItem;
        [aToolbarSyncButtonItem release];
    }
    [self.toolbarSyncButton addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    
    return self.toolbarSyncButtonItem;
}

- (void)updateToobarItem:(NSDate *)lastSyncDate
{
    if(self.toolbarSyncLabel == nil)
        return;
    
    NSLog(@"SyncManager.updateToolbarItem START: %@", lastSyncDate);
    
    if(lastSyncDate == nil)
    {
        self.toolbarSyncLabel.font = [UIFont boldSystemFontOfSize:14];
        self.toolbarSyncLabel.text = kSyncLabelNever;
    }
    else
    {
        self.toolbarSyncLabel.font = [UIFont systemFontOfSize:14];
        //self.toolbarSyncLabel.text = [SyncManager lastSyncDateString:lastSyncDate];
        self.toolbarSyncLabel.text = [NSString stringWithFormat:@"%@%@", kSyncLabelPrefix, [SyncManager lastSyncDateString:lastSyncDate]];
    }
    // TODO: if lastSyncDate was only a few seconds ago, don't show the syncbutton yet.
    self.toolbarSyncDoneLabel.hidden = YES;
    self.toolbarSyncButton.hidden = NO;
    NSLog(@"SyncManager.updateToolbarItem END");
}


#pragma mark Sync methods

// Don't use this method yet. Its not ready! Might not be useful anyway.
- (BOOL)syncObject:(NSManagedObject *)object
{
    NSLog(@"SyncManager.syncObject START: %@", object);
    // First, check that we're even able to sync
    EnvetFinderDelegate *appDelegate = (EnvetFinderDelegate *)[[UIApplication sharedApplication] delegate];
    if(![appDelegate canSync])
    {
        if(self.delegate != nil)
            [self.delegate syncDidFailWithError:[NSError errorWithDomain:@"PZErrorDomain" code:0 userInfo:[NSDictionary dictionaryWithObject:@"Account is not linked." forKey:NSLocalizedDescriptionKey]]];
        return NO;
    }
    if(![appDelegate isOnline])
    {
        if(self.delegate != nil)
            [self.delegate syncDidFailWithError:[NSError errorWithDomain:@"PZErrorDomain" code:-1L userInfo:[NSDictionary dictionaryWithObject:@"No network connection available." forKey:NSLocalizedDescriptionKey]]];
        return NO;
    }
    
    if(object != nil)
        self.objectToSync = object;
    if(self.objectToSync == nil)
    {
        NSLog(@"No object specified to sync");
        if(self.delegate != nil)
        {
            [self.delegate syncDidFailWithError:[NSError errorWithDomain:@"PZErrorDomain" code:1 userInfo:[NSDictionary dictionaryWithObject:@"Sorry, that sync failed." forKey:NSLocalizedDescriptionKey]]];
        }
        return NO;
    }
    if(![self.objectToSync respondsToSelector:@selector(sync:)])
    {
        NSLog(@"objectToSync does not respond to sync %@", self.objectToSync);
        if(self.delegate != nil)
        {
            [self.delegate syncDidFailWithError:[NSError errorWithDomain:@"PZErrorDomain" code:1 userInfo:[NSDictionary dictionaryWithObject:@"Sorry, this item can not be synced." forKey:NSLocalizedDescriptionKey]]];
        }
        return NO;
    }
    
    @try {
        
        if(self.toolbarSyncView != nil)
        {
            [self.toolbarSyncActivityIndicator startAnimating];
            self.toolbarSyncButton.hidden = YES;
        }
        
        [[RKClient sharedClient].requestQueue cancelAllRequests];
        [RKClient sharedClient].requestQueue.delegate = self;
        [RKClient sharedClient].requestQueue.concurrentRequestsLimit = 1;
        [RKClient sharedClient].requestQueue.suspended = YES;
        
        if(!TRUE)
        {
            NSLog(@"Shared Client has oAuth DISABLED");
            NSDictionary *oAuthCredentials = [appDelegate getOauthCredentials];
          //  [[RKClient sharedClient] setOAuth:YES consumerKey:[oAuthCredentials objectForKey:@"consumerKey"] consumerSecret:[oAuthCredentials objectForKey:@"consumerSecret"] accessToken:[oAuthCredentials objectForKey:@"accessToken"] tokenSecret:[oAuthCredentials objectForKey:@"tokenSecret"]];
            [RKClient sharedClient].OAuth1ConsumerKey = [oAuthCredentials objectForKey:@"consumerKey"];
            [RKClient sharedClient].OAuth1ConsumerSecret = [oAuthCredentials objectForKey:@"consumerSecret"];
            [RKClient sharedClient].OAuth1AccessToken = [oAuthCredentials objectForKey:@"accessToken"];
            [RKClient sharedClient].OAuth1AccessTokenSecret = [oAuthCredentials objectForKey:@"tokenSecret"];
        }

        [appDelegate.managedObjectContext refreshObject:self.objectToSync mergeChanges:YES];
        if(![self.objectToSync performSelector:@selector(sync:) withObject:nil])
        {
            NSLog(@"error calling sync: on %@", self.objectToSync);
            if(self.delegate != nil)
            {
                [self.delegate syncDidFailWithError:[NSError errorWithDomain:@"PZErrorDomain" code:1 userInfo:[NSDictionary dictionaryWithObject:@"Sorry, that sync failed." forKey:NSLocalizedDescriptionKey]]];
            }
            return NO;
        }
        
        // TODO: at the moment this just saves UP to the server, it does not pull back down
        // will probably need to implement the down sync here.
        
        syncCompleteCount = 0;
        syncPendingCount = [[RKClient sharedClient].requestQueue count];
        if(self.delegate != nil && [self.delegate respondsToSelector:@selector(syncDidStart)])
        {
            [self.delegate syncDidStart];
        }
        if([[RKClient sharedClient].requestQueue count] == 0)
        {
            if(self.delegate != nil && [self.delegate respondsToSelector:@selector(syncDidFinish)])
            {
                [self.delegate syncDidFinish];
            }
            return YES;
        }
        [RKClient sharedClient].requestQueue.suspended = NO;
        [[RKClient sharedClient].requestQueue start];
        
        
        return YES;
    }
    @catch (NSException *exception) {
        NSLog(@"SyncManager.syncObject exception: %@", exception);
        if(self.delegate != nil)
        {
            [self.delegate syncDidFailWithError:[NSError errorWithDomain:@"PZErrorDomain" code:1 userInfo:[NSDictionary dictionaryWithObject:@"Sorry, that sync failed. Try again or restart the app." forKey:NSLocalizedDescriptionKey]]];
        }
        return NO;
    }
    @finally {
        NSLog(@"SyncManager.syncObject END");
    }
}

/**
 * The following methods: start, pull, merge are the "big three" when we're syncing everything in the app
 * cachePhotos runs in the background afterwards.
 */
- (BOOL)start:(NSError **)error
{
    NSLog(@"===================================== SYNC START ===================================== ");
    if((error != NULL) && (*error != NULL)) { *error = NULL; }    
    EnvetFinderDelegate *appDelegate = (EnvetFinderDelegate *)[[UIApplication sharedApplication] delegate];
    if(![appDelegate canSync])
    {
        NSLog(@"no credentials");
        if(error != NULL)
        {
            *error = [NSError errorWithDomain:@"PZErrorDomain" code:0 userInfo:[NSDictionary dictionaryWithObject:@"Account is not linked." forKey:NSLocalizedDescriptionKey]];
        }
        if(self.delegate != nil)
            [self.delegate syncDidFailWithError:[NSError errorWithDomain:@"PZErrorDomain" code:0 userInfo:[NSDictionary dictionaryWithObject:@"Account is not linked." forKey:NSLocalizedDescriptionKey]]];
        return NO;
    }
    if(![appDelegate isOnline])
    {
        NSLog(@"not online");
        if(error != NULL)
        {
            *error = [NSError errorWithDomain:@"PZErrorDomain" code:-1L userInfo:[NSDictionary dictionaryWithObject:@"No network connection available." forKey:NSLocalizedDescriptionKey]];
        }
        if(self.delegate != nil)
            [self.delegate syncDidFailWithError:[NSError errorWithDomain:@"PZErrorDomain" code:-1L userInfo:[NSDictionary dictionaryWithObject:@"No network connection available." forKey:NSLocalizedDescriptionKey]]];
        return NO;
    }
    
    @try {
    
        if(self.toolbarSyncView != nil)
        {
            [self.toolbarSyncActivityIndicator startAnimating];
            self.toolbarSyncButton.hidden = YES;
        }
        
        [[RKClient sharedClient].requestQueue cancelAllRequests];
        [RKClient sharedClient].requestQueue.delegate = self;
        [RKClient sharedClient].requestQueue.concurrentRequestsLimit = 1;
        [RKClient sharedClient].requestQueue.suspended = YES;
        
        // Make sure we've got the latest journals (self.journals will perform a fresh lookup)
      //  [self setLocalUsers:nil];
        
        NSError *userError = nil;
        
       // MySyncEntity *
        
        MySyncEntity *syncData =  [[MySyncEntity alloc ] init];
        syncData.AddressBookArray =   (NSArray *) [self getAllContactsInfo];
        
        [[RKObjectManager sharedManager] setSerializationMIMEType:RKMIMETypeJSON];
         [[RKObjectManager sharedManager] putObject:(id)syncData delegate:self];   
            if(userError != nil)
            {
                NSLog(@"error calling journal.sync: %@ %@", userError, [userError userInfo]);
                
                // TODO handle this error more gracefully
                
                userError = nil; // set this to nil to continue with remaining journals
            }
        syncCompleteCount = 0;
        syncPendingCount = [[RKClient sharedClient].requestQueue count] + 2; // requests in queue + 1 for before pull and +1 for pull
        if(self.delegate != nil && [self.delegate respondsToSelector:@selector(syncDidStart)])
        {
            [self.delegate syncDidStart];
        }
        NSLog(@"================ Requests in the Queue: %d", [[RKClient sharedClient].requestQueue count]);
        if([[RKClient sharedClient].requestQueue count] == 0)
        {
            NSLog(@"Request Queue is empty, no changes to push, so we just pull");
            [RKClient sharedClient].requestQueue.delegate = nil;
            NSError *innerError = nil;
            [self pull:&innerError];
            if(innerError != nil)
                NSLog(@"pull reported an error: %@ %@", innerError, [innerError userInfo]);
        }
        //NSLog(@"=============== QUEUE IS: %@", [RKRequestQueue sharedQueue]);
        [RKClient sharedClient].requestQueue.suspended = NO;
        [[RKClient sharedClient].requestQueue start];
        return YES;
    }
    @catch (NSException *exception) {
        NSLog(@"SyncManager.start exception: %@", exception);
        if(error != NULL)
        {
            *error = [NSError errorWithDomain:@"PZErrorDomain" code:1 userInfo:[NSDictionary dictionaryWithObject:@"Sorry, that sync failed. Try again or restart the app." forKey:NSLocalizedDescriptionKey]];
        }
        else if(self.delegate != nil)
        {
            [self.delegate syncDidFailWithError:[NSError errorWithDomain:@"PZErrorDomain" code:1 userInfo:[NSDictionary dictionaryWithObject:@"Sorry, that sync failed. Try again or restart the app." forKey:NSLocalizedDescriptionKey]]];
        }
        return NO;
    }
}
/**
 * The following methods: start, pull, merge are the "big three" when we're syncing everything in the app
 * cachePhotos runs in the background afterwards.
 */
/*
- (BOOL)start:(NSError **)error
{
    NSLog(@"===================================== SYNC START ===================================== ");
    if((error != NULL) && (*error != NULL)) { *error = NULL; }    
    EnvetFinderDelegate *appDelegate = (EnvetFinderDelegate *)[[UIApplication sharedApplication] delegate];
    if(![appDelegate canSync])
    {
        NSLog(@"no credentials");
        if(error != NULL)
        {
            *error = [NSError errorWithDomain:@"PZErrorDomain" code:0 userInfo:[NSDictionary dictionaryWithObject:@"Account is not linked." forKey:NSLocalizedDescriptionKey]];
        }
        if(self.delegate != nil)
            [self.delegate syncDidFailWithError:[NSError errorWithDomain:@"PZErrorDomain" code:0 userInfo:[NSDictionary dictionaryWithObject:@"Account is not linked." forKey:NSLocalizedDescriptionKey]]];
        return NO;
    }
    if(![appDelegate isOnline])
    {
        NSLog(@"not online");
        if(error != NULL)
        {
            *error = [NSError errorWithDomain:@"PZErrorDomain" code:-1L userInfo:[NSDictionary dictionaryWithObject:@"No network connection available." forKey:NSLocalizedDescriptionKey]];
        }
        if(self.delegate != nil)
            [self.delegate syncDidFailWithError:[NSError errorWithDomain:@"PZErrorDomain" code:-1L userInfo:[NSDictionary dictionaryWithObject:@"No network connection available." forKey:NSLocalizedDescriptionKey]]];
        return NO;
    }
    
    @try {
        
        if(self.toolbarSyncView != nil)
        {
            [self.toolbarSyncActivityIndicator startAnimating];
            self.toolbarSyncButton.hidden = YES;
        }
        
        [[RKClient sharedClient].requestQueue cancelAllRequests];
        [RKClient sharedClient].requestQueue.delegate = self;
        [RKClient sharedClient].requestQueue.concurrentRequestsLimit = 1;
        [RKClient sharedClient].requestQueue.suspended = YES;
        
        // Make sure we've got the latest journals (self.journals will perform a fresh lookup)
        //  [self setLocalUsers:nil];
        
        NSError *userError = nil;
        for(ContactBook *user in [self getAllContactsInfo])
        {
            [[RKObjectManager sharedManager] putObject:(id)user delegate:self];   
            if(userError != nil)
            {
                NSLog(@"error calling journal.sync: %@ %@", userError, [userError userInfo]);
                
                // TODO handle this error more gracefully
                
                userError = nil; // set this to nil to continue with remaining journals
            }
        }
        syncCompleteCount = 0;
        syncPendingCount = [[RKClient sharedClient].requestQueue count] + 2; // requests in queue + 1 for before pull and +1 for pull
        if(self.delegate != nil && [self.delegate respondsToSelector:@selector(syncDidStart)])
        {
            [self.delegate syncDidStart];
        }
        NSLog(@"================ Requests in the Queue: %d", [[RKClient sharedClient].requestQueue count]);
        if([[RKClient sharedClient].requestQueue count] == 0)
        {
            NSLog(@"Request Queue is empty, no changes to push, so we just pull");
            [RKClient sharedClient].requestQueue.delegate = nil;
            NSError *innerError = nil;
            [self pull:&innerError];
            if(innerError != nil)
                NSLog(@"pull reported an error: %@ %@", innerError, [innerError userInfo]);
        }
        //NSLog(@"=============== QUEUE IS: %@", [RKRequestQueue sharedQueue]);
        [RKClient sharedClient].requestQueue.suspended = NO;
        [[RKClient sharedClient].requestQueue start];
        return YES;
    }
    @catch (NSException *exception) {
        NSLog(@"SyncManager.start exception: %@", exception);
        if(error != NULL)
        {
            *error = [NSError errorWithDomain:@"PZErrorDomain" code:1 userInfo:[NSDictionary dictionaryWithObject:@"Sorry, that sync failed. Try again or restart the app." forKey:NSLocalizedDescriptionKey]];
        }
        else if(self.delegate != nil)
        {
            [self.delegate syncDidFailWithError:[NSError errorWithDomain:@"PZErrorDomain" code:1 userInfo:[NSDictionary dictionaryWithObject:@"Sorry, that sync failed. Try again or restart the app." forKey:NSLocalizedDescriptionKey]]];
        }
        return NO;
    }
}
*/
- (BOOL)pull:(NSError **)error
{
    NSLog(@"===================================== PULL ===================================== ");
    syncCompleteCount++;
    if(self.delegate != nil && [self.delegate respondsToSelector:@selector(syncDidMakeProgress:)])
    {
        float percentage = (float)syncCompleteCount / (float)syncPendingCount;
        [self.delegate syncDidMakeProgress:percentage];
    }
    if((error != NULL) && (*error != NULL)) { *error = NULL; }
    
    // sync down from remote server
    if(![[RKClient sharedClient] isNetworkReachable])
    {
        NSLog(@"RK reports network unavailable");
        if(error != NULL)
        {
            *error = [NSError errorWithDomain:@"PZErrorDomain" code:-1L userInfo:[NSDictionary dictionaryWithObject:@"No network connection available." forKey:NSLocalizedDescriptionKey]];
        }
        return NO;
    }
    
    @try {
    
        if(!TRUE)
        {
            EnvetFinderDelegate *appDelegate = (EnvetFinderDelegate *)[[UIApplication sharedApplication] delegate];
            NSLog(@"ObjectManager client has oAuth DISABLED");
            NSDictionary *oAuthCredentials = [appDelegate getOauthCredentials];
         //   [[RKObjectManager sharedManager].client setOAuth:YES consumerKey:[oAuthCredentials objectForKey:@"consumerKey"] consumerSecret:[oAuthCredentials objectForKey:@"consumerSecret"] accessToken:[oAuthCredentials objectForKey:@"accessToken"] tokenSecret:[oAuthCredentials objectForKey:@"tokenSecret"]];
            [RKClient sharedClient].OAuth1ConsumerKey = [oAuthCredentials objectForKey:@"consumerKey"];
            [RKClient sharedClient].OAuth1ConsumerSecret = [oAuthCredentials objectForKey:@"consumerSecret"];
            [RKClient sharedClient].OAuth1AccessToken = [oAuthCredentials objectForKey:@"accessToken"];
            [RKClient sharedClient].OAuth1AccessTokenSecret = [oAuthCredentials objectForKey:@"tokenSecret"];
        }
        [[RKObjectManager sharedManager] loadObjectsAtResourcePath:@"/get_patients?response_type=json" delegate:self];
        return YES;
    }
    @catch (NSException *exception) {
        NSLog(@"SyncManager.pull exception: %@", exception);
        if(error != NULL)
        {
            *error = [NSError errorWithDomain:@"PZErrorDomain" code:1 userInfo:[NSDictionary dictionaryWithObject:@"Sorry, that sync failed. Try again or restart the app." forKey:NSLocalizedDescriptionKey]];
        }
        else if(self.delegate != nil)
        {
            [self.delegate syncDidFailWithError:[NSError errorWithDomain:@"PZErrorDomain" code:1 userInfo:[NSDictionary dictionaryWithObject:@"Sorry, that sync failed. Try again or restart the app." forKey:NSLocalizedDescriptionKey]]];
        }
        return NO;
    }
}
#pragma mark RKRequestQueueDelegate

- (void)requestQueueDidBeginLoading:(RKRequestQueue *)queue
{
    NSLog(@"SyncManager.requestQueueDidBeginLoading");
}

- (void)requestQueueDidFinishLoading:(RKRequestQueue *)queue
{
    NSLog(@"SyncManager.requestQueue:didFinishLoading at %@", [NSDate date]);
    NSLog(@"requests in queue %d", [[RKClient sharedClient].requestQueue count]);
    //sleep(2);
    //NSLog(@"requests in queue after sleep %d", [[RKRequestQueue sharedQueue] count]);
    if([[RKClient sharedClient].requestQueue count] == 0)
    {    
        // remove self as delegate of queue
        [RKClient sharedClient].requestQueue.delegate = nil;
        NSError *error = nil;
        [self pull:&error];
    }
    else
    {
        NSLog(@"push not finished yet");
        syncPendingCount++;
        if(self.delegate != nil && [self.delegate respondsToSelector:@selector(syncDidMakeProgress:)])
        {
            [self.delegate syncDidMakeProgress:(float)syncCompleteCount / (float)syncPendingCount];
        }
    }
}

- (void)requestQueue:(RKRequestQueue *)queue didCancelRequest:(RKRequest *)request
{
    NSLog(@"SyncManager.requestQueue:didCancelRequest");
    syncPendingCount--;
}

- (void)requestQueue:(RKRequestQueue *)queue didFailRequest:(RKRequest *)request withError:(NSError *)error
{
    NSLog(@"SyncManager.requestQueue:didFailRequest: %@ withError %@ %@", [[request URL] absoluteString], error, [error userInfo]);
    NSString *str = [[NSString alloc] initWithData:request.HTTPBody encoding:NSUTF8StringEncoding]; 
    NSLog(@"HTTPBody:%@ HTTPBodyString:%@, HTTPMethod:%@",str,request.HTTPBodyString,request.HTTPMethod);
    syncPendingCount--;
}
- (void)requestQueue:(RKRequestQueue *)queue didLoadResponse:(RKResponse *)response
{
    // This delegate method doesn't seem to get called by the request queue
   NSLog(@"SyncManager.requestQueue:didLoadResponse");
    if ([response isJSON]) {
        NSLog(@"Got a JSON response back!");
    }
}
- (void)requestQueue:(RKRequestQueue*)queue didSendRequest:(RKRequest*)request
{
    NSLog(@"SyncManager.requestQueue:didSendRequest %@", [[request URL] absoluteString]);
    syncCompleteCount++;
    if(self.delegate != nil && [self.delegate respondsToSelector:@selector(syncDidMakeProgress:)])
    {
        [self.delegate syncDidMakeProgress:(float)syncCompleteCount / (float)syncPendingCount];
    }
}

#pragma mark RKObjectLoaderDelegate

- (void)objectLoader:(RKObjectLoader*)objectLoader didFailWithError:(NSError*)error
{
    NSLog(@"SyncManager.objectLoader:didFailWithError");
    NSLog(@"Failed to save to data store: %@", [error localizedDescription]);
    NSArray* detailedErrors = [[error userInfo] objectForKey:NSDetailedErrorsKey];
    if(detailedErrors != nil && [detailedErrors count] > 0) {
        for(NSError* detailedError in detailedErrors) {
            NSLog(@"  DetailedError: %@", [detailedError userInfo]);
        }
    }
    else {
        NSLog(@"  %@", [error userInfo]);
    }
    NSLog(@"===================================== SYNC END ===================================== ");
    
    // TODO handle this more gracefully?
    
    if(self.delegate != nil)
    {
        [self.delegate syncDidFailWithError:error];
    }
    
    syncPendingCount = 0;
    syncCompleteCount = 0;
    [self setLocalUsers:nil];
    if(self.toolbarSyncView != nil)
    {
        [self.toolbarSyncActivityIndicator stopAnimating];
        self.toolbarSyncButton.hidden = NO;
    }
}
- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects
{
    NSLog(@"SyncManager.objectLoader.didLoadObjects");
    //NSLog(@"SyncManager.objectLoader.didLoadObjects: %@", objects);
    syncPendingCount = 0;
    syncCompleteCount = 0;
    NSLog(@"===================================== SYNC END =====================================");
    
    NSError *mergeError = nil;
    [self merge:objects error:&mergeError];
    if(mergeError != nil)
    {
        NSLog(@"Error merging after sync %@ %@", mergeError, [mergeError userInfo]);
        if(self.delegate != nil)
            [self.delegate syncDidFailWithError:mergeError];
    }
    else 
    {
        if(self.delegate != nil && [self.delegate respondsToSelector:@selector(syncDidFinish)])
        {
            [self.delegate syncDidFinish];
        }
    }
    if(self.toolbarSyncView != nil)
    {
        [self.toolbarSyncActivityIndicator stopAnimating];
        self.toolbarSyncButton.hidden = YES;
        self.toolbarSyncDoneLabel.hidden = NO;
    }
}
- (BOOL)merge:(NSArray *)objects error:(NSError **)error
{
    NSLog(@"===================================== MERGE ===================================== ");
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    @try {
        
        EnvetFinderDelegate *appDelegate = (EnvetFinderDelegate *)[[UIApplication sharedApplication] delegate];
        
        for(NSObject *object in objects)
        {
            if([object isKindOfClass:[ErrorResponse class]])
            {
                ErrorResponse *errorResponse = (ErrorResponse *)object;
                NSLog(@"ErrorResponse: %@", errorResponse.toLog);
                continue;
            }
            else if(![object isKindOfClass:[User class]])
            {
                NSLog(@"Unexpected object type: %@", object);
                continue;
            }
            User *remoteUser= (User *)object;
            NSLog(@"remote journal: %d", [remoteUser.userId intValue]);
           
        } 
                       
        [appDelegate saveContext];
        [NSFetchedResultsController deleteCacheWithName:@"Root"];
        [NSFetchedResultsController deleteCacheWithName:@"Entries"];
        self.localContacts = nil; // releases and next call performs a fresh lookup
        
        /*
         for(Journal *lj in self.localJournals)
         {
         //LogTrace(@"Local Journal %d (%@) has %d entries: ", [lj.journalId intValue], [lj objectID], [lj.entries count]);
         //LogTrace(@"RELOAD journal %d: %@", [lj.journalId intValue], lj.entries);
         //[appDelegate.managedObjectContext refreshObject:lj mergeChanges:YES];
         [appDelegate.managedObjectContext refreshObject:lj mergeChanges:NO];
         //LogTrace(@"RESET journal %d: %@", [lj.journalId intValue], lj.entries);
         
         
         for(Entry *e in lj.entries)
         {
         LogTrace(@"    refreshed entry: %d %@", [e.entryId intValue], e.editBody);
         }
         
         }
         [self setLocalJournals:nil];
         */
        return YES;
    }
    @catch (NSException *exception) {
        NSLog(@"SyncManager.merge exception: %@", exception);
        if(error != NULL)
        {
            *error = [NSError errorWithDomain:@"PZErrorDomain" code:1 userInfo:[NSDictionary dictionaryWithObject:@"Sorry, that sync failed. Try again or restart the app." forKey:NSLocalizedDescriptionKey]];
        }
        else if(self.delegate != nil)
        {
            [self.delegate syncDidFailWithError:[NSError errorWithDomain:@"PZErrorDomain" code:1 userInfo:[NSDictionary dictionaryWithObject:@"Sorry, that sync failed. Try again or restart the app." forKey:NSLocalizedDescriptionKey]]];
        }
        return NO;
    }
    @finally {
        [pool drain];
    }
}

#pragma mark Helper Methods

- (NSArray *)getAllContactsInfo
{
    //NSLog(@"SyncManager.localJournals START");
    if(__localContacts != nil)
    {
        return __localContacts;
    }
    EnvetFinderDelegate *appDelegate = (EnvetFinderDelegate *)[[UIApplication sharedApplication] delegate];
    NSFetchRequest *userRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *userEntity = [NSEntityDescription entityForName:@"ContactBook" inManagedObjectContext:appDelegate.managedObjectContext];
    [userRequest setEntity:userEntity];
    
    
    NSError *error = nil;
    __localContacts = [[appDelegate.managedObjectContext executeFetchRequest:userRequest error:&error] mutableCopy];
    if(error != nil)
    {
        NSLog(@"error looking up local Contacts: %@", [error userInfo]);
    }
    [userRequest release];
    NSLog(@"Total Local User:%d",[__localContacts count]);
    return __localContacts;
}

- (User *)getLocalUserByUserId:(NSNumber *)userId
{
    //NSLog(@"getLocalJournalByJournalId: %d", [journalId intValue]);
    User *localUser = nil;
    for(User *j in self.localContacts)
    {
        @try {
            if([j.userId isEqualToNumber:userId])
            {
                localUser = j;
                break;
            }
        }
        @catch (NSException *exception) {
            // We hit this exception if the local model has been removed already, typically via a delete
            NSLog(@"Error referencing local journal %@", exception);
            continue;
        }
    }
    return localUser;
}
#pragma mark - Application specific functions

- (BOOL)appStartup:(BOOL)withSync
{
}
/**
 * Gets the local user. If one is not set, it will 
 * perform a lookup in local storage. 
 * If one is not found in local storage, it will only
 * create one if +create+ is YES.
 */
- (User *)getLocalUserOrCreateOne:(BOOL)create
{
}


@end