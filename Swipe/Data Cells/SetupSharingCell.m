//
//  SetupSharingCell.m
//  Posterboard
//
//  Created by Apptellect5 on 9/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SetupSharingCell.h"


@implementation SetupSharingCell
@synthesize imgView,lblTitle;
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
    [imgView release];
    [lblTitle release];
    [super dealloc];
}

@end
