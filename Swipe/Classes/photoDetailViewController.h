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
#import "SDWebImageManager.h"
#import "clientObject.h"
#import "addCommentViewController.h"
#import "feedCommentView.h"
#import "commentDetailCell.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>


@class PhotoData;
@class userProfile;
@class ASINetworkQueue;


@protocol DeletePhotoProtocolDelegate <NSObject>

-(void) DeletePhotoResponse:(NSString *)_index;

@end

@interface photoDetailViewController : UIViewController <overlayDelegate,ParserProtocolDelegate,UITableViewDelegate,UITableViewDataSource,SDWebImageManagerDelegate,clientProtocolDelegate,CommentAddedDelegate,commentDelegate,UIActionSheetDelegate,MFMailComposeViewControllerDelegate,UIAlertViewDelegate> {
    
    IBOutlet UITableView        *dataTable; 
    IBOutlet UIView             *tableHeaderView;
    IBOutlet UIImageView        *userProfileImage,*petImage;
    IBOutlet UILabel            *userName;
    OverlayViewController       *overlay;
    BOOL                        overScreen;
    int                         reqType;
	PhotoData					*photodata;
    NSNumber					*Iden;
	
    UIImage *imgToSend;
    NSData *imgData;
	tokeInfo *tokeninfo;
	
	NSString *strFlagForReview;
    UITextField *myTextField;
    
    id<DeletePhotoProtocolDelegate>                  delegate;

    BOOL isCommentAdded;
    
	ASINetworkQueue *downloadQueue;
    //UIProgressView *progressView;
    
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withPhoto:(PhotoData *)_photodata ;

@property (retain,nonatomic) id<DeletePhotoProtocolDelegate> delegate;

@property (nonatomic,retain) tokeInfo *tokeninfo;
@property (nonatomic,retain)     NSData *imgData;
@property (retain,nonatomic ) PhotoData  *photodata;
@property (retain,nonatomic ) NSNumber *Iden;
@property (retain,nonatomic ) IBOutlet UIView   *tableHeaderView;
@property (retain,nonatomic ) IBOutlet UIImageView  *userProfileImage,*petImage;
@property (retain,nonatomic ) IBOutlet UILabel    *userName;
@property (retain,nonatomic ) IBOutlet UITableView  *dataTable; 
@property (retain, nonatomic) UIImage *imgToSend;
@property (retain,nonatomic) NSString *strFlagForReview;
@property (retain,nonatomic) UITextField *myTextField;

//- (void)startIconDownload:(userProfile *)appRecord:(NSIndexPath *)indexpath;
- (void)startIconDownload:(NSString *)_url:(NSIndexPath *)indexpath:(int)_key;
//-(void) getTableHeaderView:(PhotoData *)_photoData;
-(void) setChildTableDisplay:(commentDetailCell *)cell:(NSIndexPath *)indexPath;
//-(IBAction) searchButtonPressed:(id)sender;
-(void) SetDetailItem:(PhotoData *)_photodata;
//-(void) loadAlertView:(NSString *)_title:(NSString *)_msg;
-(void) syncOnThreadAction;
-(NSString *)DeletePhotoRequest;
-(NSString *)FlagPhotoRequest;
-(void)launchMailAppOnDevice;
-(void) removeAllCacheImagesFromMemory;
@end

