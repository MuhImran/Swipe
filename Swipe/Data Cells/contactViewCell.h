//
//  photosViewCell.h
//  Petstagram
//
//  Created by Imran on 7/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface contactViewCell : UITableViewCell {
	
	
    IBOutlet UILabel                   *nameLabel,*email;
	
}

@property (retain,nonatomic) IBOutlet UILabel *nameLabel,*email;
@end