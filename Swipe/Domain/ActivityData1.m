//
//  ActivityData1.m
//  Petstagram
//
//  Created by Awais Ahmad Qureshi on 6/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ActivityData1.h"


@implementation ActivityData1

@synthesize iden,photoId;
@synthesize textString,typeString;
@synthesize thumbnail;
@synthesize user;

- (NSComparisonResult) compareIdentity:(ActivityData1*) h
{
    
    return [self.iden compare:h.iden];
}

@end
