//
//  EmailAddressCell.h
//  Posterboard
//
//  Created by Apptellect5 on 9/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface EmailAddressCell : UITableViewCell 
{
    IBOutlet UILabel *lblName,*lblEmail;
    IBOutlet UIImageView *imgButton;
   
}

@property (nonatomic,retain) IBOutlet UILabel *lblName,*lblEmail;
@property (nonatomic,retain) IBOutlet UIImageView *imgButton;



@end
