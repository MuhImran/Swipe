//
//  LocationCell.h
//  Posterboard
//
//  Created by Apptellect5 on 9/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LocationCell : UITableViewCell 
{
    IBOutlet UILabel *lblLoc_Name,*lblLoc_Address;
}

@property (nonatomic,retain) IBOutlet UILabel *lblLoc_Name,*lblLoc_Address;

@end
