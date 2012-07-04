//
//  ActivityCustomCell.h
//  Petstagram
//
//  Created by Awais Ahmad Qureshi on 4/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface addEmailCell : UITableViewCell {
	
	IBOutlet UITextField       *emailString;
	IBOutlet UIButton		   *userButton;
	IBOutlet UISwitch          *switchButton;
}
@property (retain,nonatomic) IBOutlet UIButton *userButton;
@property (retain,nonatomic) IBOutlet UITextField *emailString;



@end