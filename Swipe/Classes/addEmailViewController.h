//
//  addEmailViewController.h
//  Petstagram
//
//  Created by Awais Ahmad Qureshi on 5/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
@protocol emailConfigureDelegate <NSObject>
@optional
-(void) configureEmailIDs:(NSMutableArray*)_emailArray;
@end

@interface addEmailViewController : UIViewController<UITextFieldDelegate,ABPeoplePickerNavigationControllerDelegate> {
	
	IBOutlet UITableView		*addEmailTable;
	NSMutableArray				*dataArray;
	int							reqType;
	id<emailConfigureDelegate>  delegate;

}
@property (retain,nonatomic) id<emailConfigureDelegate>  delegate;
@property (retain,nonatomic) IBOutlet UITableView  *addEmailTable;
@property (retain,nonatomic) NSMutableArray			*dataArray;
@end
