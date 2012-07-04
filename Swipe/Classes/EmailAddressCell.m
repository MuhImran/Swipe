//
//  EmailAddressCell.m
//  Posterboard
//
//  Created by Apptellect5 on 9/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "EmailAddressCell.h"


@implementation EmailAddressCell

@synthesize lblName,lblEmail,imgButton;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc
{
    [lblName release];
    [lblEmail release];
    [imgButton release];
    [super dealloc];
}




@end
