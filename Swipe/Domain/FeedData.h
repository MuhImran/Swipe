//
//  FeedData.h
//  Petstagram
//
//  Created by Haris Jawaid on 4/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface FeedData : NSObject {
    
    NSString        *userName;
    NSString        *fullName;
	NSNumber        *iden;
    NSString        *imgURL;
    NSString        *accessToken;
    NSNumber        *blocksize,*offset;
    NSMutableArray  *photoArray;
}

@property (nonatomic,retain) NSString *userName;
@property (nonatomic,retain) NSNumber *iden;
@property (nonatomic,retain) NSString *imgURL;
@property (nonatomic,retain) NSString *accessToken;
@property (nonatomic,retain) NSString *fullName;
@property (nonatomic,retain) NSMutableArray *photoArray;
@property (nonatomic,retain) NSNumber *blocksize,*offset;
@end