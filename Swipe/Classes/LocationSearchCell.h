//
//  LocationSearchCell.h
//  Posterboard
//
//  Created by Apptellect5 on 9/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LocationSearchCell : UITableViewCell {
    
    IBOutlet UILabel *lblName,*lblDes;
    IBOutlet UIImageView *imgView;
}

@property (nonatomic,retain) IBOutlet UILabel *lblName,*lblDes;
@property (nonatomic,retain) IBOutlet UIImageView *imgView;
@end
