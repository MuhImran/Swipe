//
//  ThingsViewController.h
//  Posterboard
//
//  Created by Apptellect5 on 9/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ParserObject.h"
#import "clientObject.h"
#import "OverlayViewController.h"


@protocol ThingsViewProtocolDelegate <NSObject>

-(void) ThingsViewResponse:(NSString *)_str;

@end


@interface ThingsViewController : UIViewController <UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,overlayDelegate,ParserProtocolDelegate,clientProtocolDelegate,UIAlertViewDelegate>
{
    
    IBOutlet UITableView *tTableView;
    IBOutlet UISearchDisplayController *tSearchBar;
    NSMutableArray *dataArray,*searchArray,*selectedThings;
    BOOL isSearching;
    OverlayViewController               *overlay;
    BOOL                        isPull,overScreen;
    id<ThingsViewProtocolDelegate>                  delegate;
    UITextField *myTextField;
    
}
@property (retain,nonatomic) id<ThingsViewProtocolDelegate> delegate;
@property (nonatomic,retain) UITextField *myTextField;
@property (nonatomic,retain) IBOutlet UITableView *tTableView;
@property (nonatomic,retain) IBOutlet UISearchDisplayController *tSearchBar;
@property (nonatomic,retain) NSMutableArray *dataArray,*searchArray,*selectedThings;

- (void)filterContentForSearchText:(NSString*)searchText;
-(void) backButtonMethod;
-(IBAction) UpdateButtonPressed:(id)sender;
-(void) syncOnThreadAction;
-(void)loadAlertView:(NSString *)title :(NSString *)msg;
-(NSString *) getThingsUrl;

@end
