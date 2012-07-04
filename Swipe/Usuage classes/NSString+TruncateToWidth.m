//
//  NSString-truncateToSize.m
//  Fast Fonts
//
//  Created by Stuart Shelton on 28/03/2010.
//  Copyright 2010 Stuart Shelton. All rights reserved.
//

#import "NSString+TruncateToWidth.h"

#define ellipsis @" "

@implementation NSString (TruncateToWidth)

- (NSString*)stringByTruncatingToWidth:(CGSize)size withFont:(UIFont *)font
{
	// Create copy that will be the returned result
	NSMutableString *truncatedString = [[self mutableCopy] autorelease];
	
	// Make sure string is longer than requested width
	if ([self sizeWithFont:font].width > size.width)
	{
		// Accommodate for ellipsis we'll tack on the end
		size.width -= [ellipsis sizeWithFont:font].width;
		
		// Get range for last character in string
		NSRange range = {truncatedString.length - 1, 1};
		
		// Loop, deleting characters until string fits within width
		while ([truncatedString sizeWithFont:font].width > size.width) 
		{
			// Delete character at end
			[truncatedString deleteCharactersInRange:range];
			
			// Move back another character
			range.location--;
		}
		
		// Append ellipsis
		[truncatedString replaceCharactersInRange:range withString:ellipsis];
	}
	
	return truncatedString;
}

@end
