//
//  dataSelectViewController.h
//  Lobbyfriends
//
//  Created by Awais Ahmad Qureshi on 5/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OverlayViewController.h"
@protocol dataSelectDelegate <NSObject>
@optional
-(void) dataNameDidSelected:(NSString *)_dataName:(NSIndexPath *)_parentIndex;
@end

@interface DataSelecterViewController : UIViewController {
	
	IBOutlet UITableView            *dataTable;
	id<dataSelectDelegate>          delegate;
    NSIndexPath                     *parentClassIndex;
    IBOutlet UISearchBar            *eventTitleSearchBar;
  
    NSArray *books;
    NSMutableDictionary *sections;
    BOOL searching;

}
@property (retain,nonatomic) IBOutlet UISearchBar  *eventTitleSearchBar;
@property (retain,nonatomic) id<dataSelectDelegate> delegate;
@property (retain,nonatomic) IBOutlet UITableView *dataTable;
@property (retain,nonatomic) NSIndexPath  *parentClassIndex;
@property (retain,nonatomic) NSArray *books;
@property (retain,nonatomic) NSMutableDictionary *sections; 

-(void) setDetailArray:(NSIndexPath *)_indexPath;
-(void) showBreedForKind:(NSString *)_kind:(NSIndexPath *)_indexPath;
- (void)configureSections;
@end
