//
//  HomeScreenViewController.h
//  show
//
//  Created by svp on 01/11/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface photosViewController : UIViewController <UITableViewDelegate,UITableViewDataSource> {
    
    NSMutableDictionary         *imageDownloadsInProgress;
    IBOutlet UITableView        *dataTable; 
    NSMutableArray              *dataArray;
    BOOL                        overScreen;
    int                         reqType;
	
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withPhotoArray:(NSMutableArray *)_photoArray ;

@property (retain,nonatomic ) NSNumber *Iden;
@property (retain,nonatomic ) NSMutableDictionary  *imageDownloadsInProgress;
@property (retain,nonatomic ) NSMutableArray              *dataArray;
@property (retain,nonatomic ) IBOutlet UITableView  *dataTable; 


//- (void)startIconDownload:(userProfile *)appRecord:(NSIndexPath *)indexpath;
- (void)startIconDownload:(NSString *)_url:(NSIndexPath *)indexpath:(int)_key;
-(void) loadAlertView:(NSString *)_title1:(NSString *)_msg;
//-(void) syncOnThreadAction;
- (void)startIconDownload:(NSString *)_url:(NSIndexPath *)indexpath:(int)_key;

@end

