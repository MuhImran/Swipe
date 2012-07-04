//
//  Friend.m
//  EpicRewards
//
//  Created by Eugene Woo on 10-11-12.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Friend.h"


@implementation Friend

@synthesize name,iden;

-(void) dealloc {
	[name release];
	[iden release];
	[super dealloc];
}
@end
