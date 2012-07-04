//
//  lowResolution.h
//  Petstagram
//
//  Created by Haris Jawaid on 4/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ResolutionInfo : NSObject {
    
    
    int             width;
    int             height;
    NSString        *url;
    
    
}
@property int width,height;
@property (nonatomic,retain) NSString  *url;


@end

