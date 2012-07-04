//
//  SyncManager.h
//  Penzu
//
//  Created by Michael Lawlor on 11-08-06.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>
#import <UIKit/UIKit.h>
#import "User.h"

@protocol SyncDelegate;

@interface SyncManager : NSObject <RKRequestQueueDelegate, RKObjectLoaderDelegate> {
    id<SyncDelegate> __delegate;
    NSArray *__localContacts;
    int syncPendingCount;
    int syncCompleteCount;
    NSManagedObject *__objectToSync;
    
// UI elements
    UIView *toolbarSyncView;
    UIButton *toolbarSyncButton;
    UIBarButtonItem *toolbarSyncButtonItem;
    UILabel *toolbarSyncLabel;
    UIActivityIndicatorView *toolbarSyncActivityIndicator;
    UILabel *toolbarSyncDoneLabel;
}

@property (nonatomic, assign) id<SyncDelegate> delegate;
@property (nonatomic, retain) NSArray *localContacts;

@property (nonatomic, retain) UIView *toolbarSyncView;
@property (nonatomic, retain) UIButton *toolbarSyncButton;
@property (nonatomic, retain) UIBarButtonItem *toolbarSyncButtonItem;
@property (nonatomic, retain) UILabel *toolbarSyncLabel;
@property (nonatomic, retain) UIActivityIndicatorView *toolbarSyncActivityIndicator;
@property (nonatomic, retain) UILabel *toolbarSyncDoneLabel;

@property (nonatomic, retain) NSManagedObject *objectToSync;

+ (NSString *)lastSyncDateString:(NSDate *)date;

- (SyncManager *)initWithDelegate:(id<SyncDelegate>)syncDelegate;

- (UIBarButtonItem *)toolbarItemWithTarget:(id)target action:(SEL)selector;
- (void)updateToobarItem:(NSDate *)lastSyncDate;

/*******************
 *  Sync Functions *
 *******************
 */

- (BOOL)start:(NSError **)error;
- (BOOL)pull:(NSError **)error;


- (User *)getLocalUserByUserId:(NSNumber *)userId;

@end

@protocol SyncDelegate <NSObject>

@required

- (void)syncDidFailWithError:(NSError *)error;

@optional

- (void)syncDidStart;

- (void)syncDidFinish;

- (void)syncDidMakeProgress:(float)percentage;
- (BOOL)merge:(NSArray *)objects error:(NSError **)error;


@end