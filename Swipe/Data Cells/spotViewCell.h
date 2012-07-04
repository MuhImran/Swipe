//
//  spotViewCell.h
//  Petstagram
//
//  Created by Awais Ahmad Qureshi on 5/31/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface spotViewCell : UITableViewCell {
    IBOutlet UILabel             *textLabel,*textTitle;
	IBOutlet UIImageView          *imageView;
    
    
    
}


@property (retain,nonatomic) IBOutlet UILabel *textLabel,*textTitle;
@property (retain,nonatomic) IBOutlet UIImageView  *imageView;

@end

// Test purpse