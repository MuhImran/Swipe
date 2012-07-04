//
//  petsObject.h
//  Petstagram
//
//  Created by Haris Jawaid on 4/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface petsObject : NSObject <NSCopying>  {
    NSString               *petName;
    NSMutableArray         *tagArray;
    NSString               *kind,*breed,*dob;
    NSString                *sex;
    petsObject              *obj;
    NSNumber                *iden;
}
@property (nonatomic,retain) NSString  *sex;
@property (nonatomic,retain) NSString *kind,*breed,*dob;
@property (nonatomic,retain) NSString *petName;
@property (nonatomic,retain) NSMutableArray   *tagArray;
@property (nonatomic,retain) petsObject              *obj;
@property (nonatomic,retain) NSNumber  *iden;
@end