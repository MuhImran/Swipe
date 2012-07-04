//
//  supportMethodClass.m
//  FindASitter
//
//  Created by svp on 30/11/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "supportMethodClass.h"


@implementation supportMethodClass


+(NSString *) getTimeFormatString:(NSDate *)_startTime:(NSDate *)_endTime
{
	NSDateFormatter *df = [[NSDateFormatter alloc] init];
	NSLog(@"The dates are %@ and %@ ",[df stringFromDate:_startTime],[df stringFromDate:_endTime]);
	[df setDateFormat:@"MMM dd"];
	
	NSDateFormatter *timeFormat = [[NSDateFormatter alloc] init];
	[timeFormat setDateFormat:@"HH:mm"];
	
	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	
	//NSLog(@"Here are the selected Times %@ and %@ ",[timeFormat stringFromDate:_startTime],[timeFormat stringFromDate:_endTime]);
	NSDateComponents *weekdayComponents =[gregorian components:NSDayCalendarUnit | NSWeekdayCalendarUnit fromDate:_startTime];
	//NSInteger day = [weekdayComponents weekday];
	NSString *str = [NSString stringWithFormat:@"%@,%@ %@-%@",[self getDayOfWeek:[weekdayComponents weekday]],[df stringFromDate:_startTime],[timeFormat stringFromDate:_startTime],[timeFormat stringFromDate:_endTime]];
	
	
	return str;
	
}


+(NSString *) getDayOfWeek:(NSInteger )_num
{
	switch (_num) {
		case 1:
			return @"Sunday";
			break;
		case 2:
			return @"Monday";
			break;
		case 3:
			return @"Tuesday";
			break;
		case 4:
			return @"Wednesday";
			break;
		case 5:
			return @"Thursday";
			break;
		case 6:
			return @"Friday";
			break;
		case 7:
			return @"Saturday";
			break;
			
		default:
			break;
	}
	return @"";
}
+(NSDate *) convertStringToDate:(NSString *)_str
{
	//NSDate *date;
	//_str = @"09-Dec-10 01:15";
	NSDateFormatter *df = [[NSDateFormatter alloc] init];
	[df setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
	[df setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"] autorelease]];
	[df setDateFormat:@"dd-MMM-yy hh:mma"];
	return [df dateFromString:_str];
	//[inputFormatter setDateFormat:@"MMMM, dd yyyy HH:mm:ss"];
//	NSDate *formatterDate = [df dateFromString:_str];
	
	
	//NSDateFormatter *df = [[[NSDateFormatter alloc] init] autorelease];
	//[df setFormatterBehavior:NSDateFormatterBehavior10_4];
	//[df setDateFormat:@"EEE MMM dd HH:mm:ss zzz YYYY"];
	//[df setDateFormat:@"yy MMM dd HH:mm"];
	//date =[df dateFromString:_str];
//	NSLog(@"Before  %@ and after %@ ",_str,[df dateFromString:_str]);
	
	
	//NSDateFormatter *timeFormat = [[NSDateFormatter alloc] init];
	//[timeFormat setDateFormat:@"HH:mm"];
	
	//NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	
	//NSLog(@"Here are the selected Times %@ and %@ ",[timeFormat stringFromDate:_startTime],[timeFormat stringFromDate:_endTime]);
	//NSDateComponents *weekdayComponents =[gregorian components:NSDayCalendarUnit | NSWeekdayCalendarUnit fromDate:_startTime];
	//NSInteger day = [weekdayComponents weekday];
	//NSString *str = [NSString stringWithFormat:@"%@,%@ %@-%@",[self getDayOfWeek:[weekdayComponents weekday]],[df stringFromDate:_startTime],[timeFormat stringFromDate:_startTime],[timeFormat stringFromDate:_endTime]];
	
	
	
}

+(BOOL)emailValidate:(NSString *)email 
{
	
	//Based on the string below
	//NSString *strEmailMatchstring=@"\\b([a-zA-Z0-9%_.+\\-]+)@([a-zA-Z0-9.\\-]+?\\.[a-zA-Z]{2,6})\\b";
	
	//Quick return if @ Or . not in the string
	if([email rangeOfString:@"@"].location==NSNotFound || [email rangeOfString:@"."].location==NSNotFound)
		return NO;
	
	//Break email address into its components
	NSString *accountName=[email substringToIndex: [email rangeOfString:@"@"].location];
	email=[email substringFromIndex:[email rangeOfString:@"@"].location+1];
	
	//'.' not present in substring
	if([email rangeOfString:@"."].location==NSNotFound)
		return NO;
	NSString *domainName=[email substringToIndex:[email rangeOfString:@"."].location];
	NSString *subDomain=[email substringFromIndex:[email rangeOfString:@"."].location+1];
	
	//username, domainname and subdomain name should not contain the following charters below
	//filter for user name
	NSString *unWantedInUName = @" ~!@#$^&*()={}[]|;':\"<>,?/`";
	//filter for domain
	NSString *unWantedInDomain = @" ~!@#$%^&*()={}[]|;':\"<>,+?/`";
	//filter for subdomain 
	NSString *unWantedInSub = @" `~!@#$%^&*()={}[]:\";'<>,?/1234567890";
	
	//subdomain should not be less that 2 and not greater 6
	if(!(subDomain.length>=2 && subDomain.length<=6)) return NO;
	
	if([accountName isEqualToString:@""] || [accountName rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString:unWantedInUName]].location!=NSNotFound || [domainName isEqualToString:@""] || [domainName rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString:unWantedInDomain]].location!=NSNotFound || [subDomain isEqualToString:@""] || [subDomain rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString:unWantedInSub]].location!=NSNotFound)
		return NO;
	
	
	return YES;
}

+ (void) drawPlaceholderInRect:(UITextField *)_textField {
    CGRect rect = [_textField frame];
	[[UIColor blueColor] setFill];
    [[_textField placeholder] drawInRect:rect withFont:[UIFont systemFontOfSize:12]];
}


@end
