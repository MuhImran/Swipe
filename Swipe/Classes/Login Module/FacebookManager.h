//
//  FacebookManager.h
//  EpicRewards
//
//  Created by Eugene Woo on 10-11-12.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FBConnect.h"

@interface FacebookManager : NSObject
<FBRequestDelegate,FBDialogDelegate,FBSessionDelegate> {
	Facebook* _facebook;
	NSArray* _permissions;
	NSArray* _requestResults;
	NSMutableArray *_friends;

}

@property(readonly) Facebook *facebook;
@property(nonatomic,retain) NSArray* requestResults;
@property(nonatomic,retain) NSMutableArray *friends;

-(void) initializeFacebook:(id<FBSessionDelegate>)delegate;
-(BOOL) isInitialized ;
-(void) getFriendsList;
-(void) processFriends:(NSArray*)list;
- (void)postMessage:(NSString*)message link:(NSString*)link delegate:(id <FBRequestDelegate>)delegate ;
- (void)postMessage:(NSString*)message link:(NSString*)link name:(NSString*)name caption:(NSString*)caption
		description:(NSString*)description picture:(NSString*)picture delegate:(id <FBRequestDelegate>)delegate;

-(void)postPhoto:(UIImage*)photo caption:(NSString*)caption delegate:(id <FBRequestDelegate>)delegate;
@end
