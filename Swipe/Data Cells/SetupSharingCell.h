//
//  SetupSharingCell.h
//  Posterboard
//
//  Created by Apptellect5 on 9/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SetupSharingCell : UITableViewCell 
{
    IBOutlet UIImageView *imgView;
    IBOutlet UILabel *lblTitle;
}

@property(nonatomic,retain) IBOutlet UIImageView *imgView;
@property(nonatomic,retain) IBOutlet UILabel *lblTitle;

@end
