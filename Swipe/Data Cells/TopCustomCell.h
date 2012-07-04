//
//  ActivityCustomCell.h
//  Petstagram
//
//  Created by Awais Ahmad Qureshi on 4/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OHAttributedLabel.h"

@interface TopCustomCell : UITableViewCell {
	
	IBOutlet UILabel                    *timeString,*userName,*counterLabel,*titlString;
	IBOutlet UIButton                   *photoButton,*plusButton,*negativeButton,*userProfileButton;
    IBOutlet                            UIWebView *richTex;
   IBOutlet OHAttributedLabel          *label1;
}


@property (retain,nonatomic)  IBOutlet OHAttributedLabel          *label1;
@property (retain,nonatomic) IBOutlet UILabel                 *titleString;
@property (retain,nonatomic) IBOutlet IBOutlet    UIWebView *richText;
@property (retain,nonatomic) IBOutlet UILabel  *timeString,*userName,*counterLabel;
@property (retain,nonatomic) IBOutlet UIButton *photoButton,*plusButton,*negativeButton,*userProfileButton;

@end