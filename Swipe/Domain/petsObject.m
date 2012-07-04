//
//  petsObject.m
//  Petstagram
//
//  Created by Haris Jawaid on 4/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "petsObject.h"


@implementation petsObject

@synthesize  petName;
@synthesize  tagArray;
@synthesize  sex;
@synthesize  kind,breed,dob;
@synthesize  obj;
@synthesize iden;

-(id)copyWithZone:(NSZone *)zone
{
    // We'll ignore the zone for now
    petsObject *another = [[petsObject alloc] init];
     another.petName = [petName copyWithZone: zone];
     another.tagArray = [tagArray copyWithZone: zone];
     another.sex = [sex copyWithZone: zone];
     another.kind = [kind copyWithZone: zone];
     another.breed = [breed copyWithZone: zone];
     another.dob = [dob copyWithZone: zone];
    another.iden = [iden copyWithZone: zone];
    // another.dob = [dob copyWithZone: zone];
    return another;
}

@end
