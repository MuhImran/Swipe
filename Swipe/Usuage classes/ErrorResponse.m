//
//  ErrorResponse.m
//  Penzu
//
//  Created by Michael Lawlor on 11-07-17.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ErrorResponse.h"


@implementation ErrorResponse
@synthesize title = __title;
@synthesize message = __message;
@synthesize URL = __URL;


- (NSString *)toLog
{
    return [NSString stringWithFormat:@"ErrorResponse @ %@ %@: %@", self.URL, self.title, self.message];
}

@end
