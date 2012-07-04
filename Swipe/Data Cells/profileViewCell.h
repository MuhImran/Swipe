//
//  VenueCustomCell.h
//  EventFinder
//
//  Created by Ahmad on 24/02/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OHAttributedLabel.h"

@interface profileViewCell : UITableViewCell {
	
	
	IBOutlet UILabel                    *name,*fullName,*likeCount,*commentsCount,*time;
	
	IBOutlet UIImageView                *smallImg,*bigImg;
	IBOutlet UIButton                   *commentsButton,*likeButton,*mapButton,*btnPhotoOption;
	IBOutlet UIView                     *commentView,*supportedView;
    IBOutlet UIButton                   *profileButton,*increaseButton,*decreaseButton,*addComments;
	IBOutlet UILabel                    *titleString,*descString,*timestring,*userName,*counterLabel,*commentCouneterLabel;
    IBOutlet UIWebView                  *richText;
     IBOutlet OHAttributedLabel          *label1;
    IBOutlet UIProgressView *progressView;
	
	
}
@property (retain,nonatomic)  IBOutlet OHAttributedLabel          *label1;
@property (retain,nonatomic) IBOutlet IBOutlet UIWebView                  *richText;
@property (retain,nonatomic) IBOutlet UILabel *titleString,*descString,*timestring,*userName,*counterLabel,*commentCouneterLabel;
@property (retain,nonatomic) IBOutlet UIButton *profileButton,*increaseButton,*decreaseButton,*addComments,*btnPhotoOption;
@property (retain,nonatomic) IBOutlet UILabel *name,*fullName,*likeCount,*commentsCount,*time;
@property (retain,nonatomic) IBOutlet UIImageView *smallImg,*bigImg;
@property (retain,nonatomic) IBOutlet UIButton  *commentsButton,*likeButton,*mapButton; 
@property (retain,nonatomic) IBOutlet UIView   *commentView,*supportedView;
@property (nonatomic,retain) IBOutlet UIProgressView *progressView;

@end
