//
//  ShareButtonCell.h
//  Posterboard
//
//  Created by Apptellect5 on 9/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ShareButtonCell : UITableViewCell 
{
    IBOutlet UIButton *btnShare;
    IBOutlet UILabel *lblTitle;
    
}
@property (nonatomic, retain) IBOutlet UIButton *btnShare;
@property (nonatomic, retain) IBOutlet UILabel *lblTitle;
@end
