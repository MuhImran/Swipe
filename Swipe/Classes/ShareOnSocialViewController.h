//
//  ShareOnSocialViewController.h
//  Posterboard
//
//  Created by Apptellect5 on 9/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SharingSetupViewController.h"
#import "PhotoData.h"
#import "ParserObject.h"
#import "clientObject.h"
#import "FacebookManager.h"
#import "SA_OAuthTwitterController.h" 
#import "SA_OAuthTwitterEngine.h"
#import "socailConnectObject.h"
#import "OverlayViewController.h"

@interface ShareOnSocialViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,SetupSharingProtocolDelegate,ParserProtocolDelegate,SA_OAuthTwitterControllerDelegate,socialResponseDelegate,overlayDelegate>
{
    
    NSMutableArray *objectsCount;
    IBOutlet UITableView  *tableView;
    PhotoData *photoData;
    SA_OAuthTwitterEngine		*_engine;
    socailConnectObject         *socailObject;
    FacebookManager             *fmgr;
    OverlayViewController               *overlay;
    BOOL                       overScreen;
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withPhotoData:(PhotoData *)_photoData;
@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) PhotoData *photoData;
@property (nonatomic,retain) SA_OAuthTwitterEngine	*_engine;
@property (nonatomic,retain) FacebookManager         *fmgr;
-(IBAction)ButtonPressed:(id)sender;
-(void)removeOverlayViewReturnBack;

@end
