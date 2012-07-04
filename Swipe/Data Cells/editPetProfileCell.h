//
//  editPetProfileCell.h
//  Petstagram
//
//  Created by Awais Ahmad Qureshi on 5/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface editPetProfileCell : UITableViewCell {
	
	IBOutlet UITextField                 *textString;
	IBOutlet UISegmentedControl          *switchButton;
    IBOutlet UISwitch                    *toggleSwitch;
    IBOutlet UILabel                     *labelString;
    IBOutlet UIImageView                 *profileImgView;
}

@property (retain,nonatomic) IBOutlet UITextField *textString;
@property (retain,nonatomic) IBOutlet UISegmentedControl  *switchButton;
@property (retain,nonatomic) IBOutlet UILabel    *labelString;
@property (retain,nonatomic) IBOutlet UISwitch   *toggleSwitch;
@property (retain,nonatomic) IBOutlet UIImageView *profileImgView;
@end