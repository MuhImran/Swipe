//
//  ErrorResponse.h
//  Penzu
//
//  Created by Michael Lawlor on 11-07-17.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ErrorResponse : NSObject {
    NSString *__title;
    NSString *__message;
    NSString *__URL;
}

@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *message;
@property (nonatomic, retain) NSString *URL;

- (NSString *)toLog;

@end
