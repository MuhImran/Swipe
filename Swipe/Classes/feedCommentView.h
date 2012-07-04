//
//  feedCommentView.h
//  Petstagram
//
//  Created by Awais Ahmad Qureshi on 4/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PhotoData;
@class userProfile;

@protocol commentDelegate <NSObject>
-(void) viewUserProfile:(NSNumber*)_userIden;
-(void) viewAllComment:(NSNumber*)photoIden;
@end

@interface feedCommentView : UIViewController {
	IBOutlet UITableView        *commentTable;
	NSMutableArray              *commentArray;
	PhotoData                   *photodata;
	id<commentDelegate>         delegate;
    userProfile                 *userprofile;
}
@property (retain,nonatomic) id<commentDelegate> delegate;
@property (retain,nonatomic) IBOutlet UITableView *commentTable;
-(void) setCommentData:(PhotoData *)_photoData:(userProfile *)_userprofile;
@end
