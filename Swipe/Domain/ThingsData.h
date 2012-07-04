//
//  ThingsData.h
//  Posterboard
//
//  Created by Apptellect5 on 10/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ThingsData : NSObject 
{
    NSString *title;
    int iden;
    int counter;
    
}

@property (nonatomic,retain) NSString *title;
@property int iden;
@property int counter;

@end
