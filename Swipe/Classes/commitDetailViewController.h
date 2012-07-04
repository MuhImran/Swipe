//
//  feedCommentView.h
//  ;
//
//  Created by Awais Ahmad Qureshi on 4/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoData.h"
#import "clientObject.h"
#import "ParserObject.h"
#import "OverlayViewController.h"
@class userProfileViewController;
@interface commitDetailViewController : UIViewController<overlayDelegate,clientProtocolDelegate,ParserProtocolDelegate> {
	IBOutlet UITableView		*commentTable;
	NSMutableArray				*commentArray;
	PhotoData					*photodata;
	NSMutableDictionary         *imageDownloadsInProgress;
	userProfileViewController   *UPVC;
	OverlayViewController		*overlay;
	BOOL						overScreen;
    int                         iden;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withPhoto:(PhotoData *)_photodata;
@property (retain,nonatomic) IBOutlet UITableView *commentTable;
@property (retain,nonatomic) NSMutableDictionary    *imageDownloadsInProgress;
@property (retain,nonatomic) userProfileViewController   *UPVC;

-(void) setDetailItem:(PhotoData *)_photodata;
-(void) loadAlertView:(NSString *)_title1:(NSString *)_msg;
//-(void) callNewView;
-(void) syncOnThreadAction:(int)_tag;
@end
