//
//  NSString-truncateToSize.h
//  Fast Fonts
//
//  Created by Stuart Shelton on 28/03/2010.
//  Copyright 2010 Stuart Shelton. All rights reserved.
//

@interface NSString (TruncateToWidth)

- (NSString*)stringByTruncatingToWidth:(CGSize)size withFont:(UIFont *)font;

@end