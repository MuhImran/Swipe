//
//  HomeScreenViewController.h
//  show
//
//  Created by svp on 01/11/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "clientObject.h"
#import "OverlayViewController.h"
#import "ParserObject.h"
#import "clientObject.h"
#import "feedCommentView.h"
#import "addCommentViewController.h"
#import "TransparentToolbar.h"
#import "GPS_Object.h"
#import "photoDetailViewController.h"
#import "SDWebImageManager.h"
#import "UIImage+Resize.h"

@class domainClasses;
@class photoDetailViewController;
@class profileViewController;
@class EGORefreshTableFooterView;
@class commitDetailViewController;

@interface HomeScreenViewController : UIViewController <overlayDelegate,ParserProtocolDelegate,UITableViewDelegate,UITableViewDataSource,
                                                       clientProtocolDelegate,/*UISearchBarDelegate,*/
														commentDelegate,CommentAddedDelegate,GPXDelegate,DeletePhotoProtocolDelegate,SDWebImageManagerDelegate> {
    
	
    IBOutlet TransparentToolbar *toolBar;                                                        
                                                            
    FeedData					*feedData,*serachFeed;
	NSMutableArray              *dataArray;
    NSMutableDictionary         *imageDownloadsInProgress;
    IBOutlet UITableView        *dataTable; 
    IBOutlet UIView             *tableHeaderView;
	IBOutlet UISearchBar		*searchbar;
    OverlayViewController       *overlay;
    BOOL                        overScreen,firtTimeView,searching,isPull;
    int                         reqType;
	EGORefreshTableFooterView   *refreshFooterView;
	BOOL						_reloadingFooter;
	NSMutableArray				*tableHeightArray;                                                    
	int                         Iden;
    IBOutlet UIView             *emptyListView;
                                                            
    CLLocation *currentLocation;
   // BOOL isLocation;
                                                            
}

@property (nonatomic,retain) CLLocation *currentLocation;
//@property (nonatomic,assign) BOOL isLocation;
//-(void)LoadViewAgain:(NSNumber *)_isPull;

@property (retain,nonatomic ) IBOutlet UIView   *emptyListView;
@property (retain,nonatomic ) FeedData	*feedData,*serachFeed;
@property (retain,nonatomic ) NSMutableDictionary  *imageDownloadsInProgress;
@property (retain,nonatomic ) IBOutlet UIView   *tableHeaderView;
@property (retain,nonatomic ) IBOutlet UITableView  *dataTable; 
@property (retain,nonatomic ) IBOutlet IBOutlet UISearchBar	*searchbar;
@property (retain,nonatomic ) NSMutableArray *tableHeightArray,*dataArray;
@property int  reqType;
@property(assign,getter=isReloading) BOOL reloading;

- (void)startIconDownload:(NSString *)_url:(NSIndexPath *)indexpath:(int)_key;
-(void) syncOnThreadAction:(BOOL)_isPull;
- (void)reloadTableViewDataSource;
- (void)doneLoadingTableViewData;
-(void) reloadTableData;
-(void) getFeedDataArray;
-(void) callNewView;
//-(void) loadAlertView:(NSString *)_title:(NSString *)_msg;
-(void) dataForOtherTab:(UITableViewCell *)hlcell:(NSIndexPath *)indexPath;
-(void) loadImagesForOnscreenRows;
@end

