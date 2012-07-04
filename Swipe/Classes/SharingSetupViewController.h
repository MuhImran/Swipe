//
//  SharingSetupViewController.h
//  Posterboard
//
//  Created by Apptellect5 on 9/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ParserObject.h"
#import "clientObject.h"
#import "FacebookManager.h"
#import "SA_OAuthTwitterController.h" 
#import "SA_OAuthTwitterEngine.h"
#import "socailConnectObject.h"

@protocol SetupSharingProtocolDelegate <NSObject>

-(void) SetupSharingResponse:(NSArray *)_object;

@end


@interface SharingSetupViewController : UIViewController <UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate,ParserProtocolDelegate,SA_OAuthTwitterControllerDelegate,socialResponseDelegate>
{
    IBOutlet UITableView *tableView;
    BOOL isFB,isTWT;
    SA_OAuthTwitterEngine		*_engine;
    socailConnectObject         *socailObject;
    FacebookManager             *fmgr;
    id<SetupSharingProtocolDelegate> delegate;
}
@property (nonatomic,retain) id<SetupSharingProtocolDelegate> delegate;
@property (nonatomic,retain) SA_OAuthTwitterEngine	*_engine;
@property (nonatomic,retain) FacebookManager         *fmgr;

@property (nonatomic,retain) IBOutlet UITableView *tableView;


-(void)showTwitterSheet;
-(void)showFaceBookSheet;

@end
