//
//  ActivityCustomCell.h
//  Petstagram
//
//  Created by Awais Ahmad Qureshi on 4/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OHAttributedLabel.h"
@interface commentDetailCell : UITableViewCell {
	
	IBOutlet UILabel           *name,*textString,*timeInfo;
	IBOutlet UIButton		   *userButton;
	IBOutlet UIView            *photoView;
    IBOutlet OHAttributedLabel          *label1;
}


@property (retain,nonatomic)  IBOutlet OHAttributedLabel          *label1;
@property (retain,nonatomic) IBOutlet UIButton *userButton;
@property (retain,nonatomic) IBOutlet UILabel  *name,*textString,*timeInfo;
@property (retain,nonatomic) IBOutlet UIView *photoView;



@end