//
//  ActivityCustomCell.h
//  Petstagram
//
//  Created by Awais Ahmad Qureshi on 4/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface feedCommentCell : UITableViewCell {
	
	IBOutlet UILabel           *name,*textString;
	IBOutlet UIButton		   *userButton;
	IBOutlet UIView            *photoView;
	
	
}
@property (retain,nonatomic) IBOutlet UIButton *userButton;
@property (retain,nonatomic) IBOutlet UILabel  *name,*textString;
@property (retain,nonatomic) IBOutlet UIView *photoView;



@end