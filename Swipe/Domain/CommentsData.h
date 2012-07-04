//
//  CommentsData.h
//  Petstagram
//
//  Created by Haris Jawaid on 4/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "userProfile.h"
@interface CommentsData : NSObject {
    
    NSString        *createdDate;
    userProfile     *user;
    NSString      *textData;
    
}
@property (nonatomic,retain) NSString     *createdDate;
@property (nonatomic,retain) userProfile  *user;
@property (nonatomic,retain) NSString      *textData;

@end

