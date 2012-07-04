//
//  ActivityCustomCell.h
//  Petstagram
//
//  Created by Awais Ahmad Qureshi on 4/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OHAttributedLabel.h"
@interface FeedCustomCell : UITableViewCell <OHAttributedLabelDelegate>{
	
	IBOutlet UILabel                    *titleString,*timeString,*userName,*counterLabel;
	IBOutlet UIButton                   *photoButton,*plusButton,*negativeButton,*userProfileButton;
    IBOutlet    UIWebView *richText;
    IBOutlet OHAttributedLabel          *label1;
    
	
	
}
@property (retain,nonatomic) IBOutlet IBOutlet OHAttributedLabel          *label1;
@property (retain,nonatomic) IBOutlet IBOutlet    UIWebView *richText;
@property (retain,nonatomic) IBOutlet UILabel   *titleString,*timeString,*userName,*counterLabel;
@property (retain,nonatomic) IBOutlet UIButton *photoButton,*plusButton,*negativeButton,*userProfileButton;



@end