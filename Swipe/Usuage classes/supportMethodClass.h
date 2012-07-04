//
//  supportMethodClass.h
//  FindASitter
//
//  Created by svp on 30/11/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface supportMethodClass : NSObject {

}
+(NSString *) getDayOfWeek:(NSInteger )_num;
+(NSDate *) convertStringToDate:(NSString *)_str;
+(BOOL)emailValidate:(NSString *)email;
+ (void) drawPlaceholderInRect:(UITextField *)_textField;
+(NSString *) getTimeFormatString:(NSDate *)_startTime:(NSDate *)_endTime;

@end

