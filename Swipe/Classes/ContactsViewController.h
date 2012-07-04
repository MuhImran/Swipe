//
//  ContactsViewController.h
//  Posptercard
//
//  Created by Imran on 7/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>
#import "SyncManager.h"
#import "SDWebImageManager.h"

@class  MySyncEntity;
@interface ContactsViewController : UIViewController <SyncDelegate>{
    
    IBOutlet UITableView        *topicTable;
    NSMutableArray              *topicArray;
    IBOutlet    UISearchBar      *searchbar;
    NSManagedObjectContext      *managedObjectContext;
    SyncManager                 *syncManager;
    BOOL                        isListView;
    MySyncEntity                *synEntity;
    
    
}
@property (retain,nonatomic)   IBOutlet    UISearchBar      *searchbar;
@property (retain,nonatomic)  IBOutlet UITableView        *topicTable;
@property (retain,nonatomic) NSMutableArray              *topicArray;
@property (retain,nonatomic) SyncManager                *syncManager;
@property (retain,nonatomic) MySyncEntity                *synEntity;
-(void) saveDataToLocalPreference:(NSMutableArray *)_array;
- (NSArray*)printAddressBook;
@end
