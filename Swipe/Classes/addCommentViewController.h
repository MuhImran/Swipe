//
//  addCommentViewController.h
//  Petstagram
//
//  Created by Awais Ahmad Qureshi on 5/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OverlayViewController.h"
#import "clientObject.h"
#import "ParserObject.h"
#import "GPS_Object.h"
@protocol CommentAddedDelegate <NSObject>
@optional
-(void) commentHasAdded:(NSString *)_string:(NSNumber *)_iden;
@end
@interface addCommentViewController : UIViewController<UITextViewDelegate,overlayDelegate,clientProtocolDelegate,ParserProtocolDelegate,GPXDelegate> {
	
	
	IBOutlet UITextView			*textView1;
	int                         Iden;
	id<CommentAddedDelegate>    delegate;
    OverlayViewController		*overlay;
	BOOL						overScreen;
	int							segmentIndex;
    CLLocation                  *currentLocation;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withDelegate:(id)_delegate photo:(int)_id;
@property (retain,nonatomic) id<CommentAddedDelegate> delegate;
@property (retain,nonatomic) IBOutlet UITextView *textView1;
@property int segmentIndex;
- (NSString *)stripDoubleSpaceFrom:(NSString *)_str;
-(void) loadAlertView:(NSString *)_msg;
-(void) setDetailItem:(id)_delegate photo:(int)_id;
-(void) syncOnThreadAction:(NSString *)_str;
-(void) loadAlertView:(NSString *)_msg;
@end
