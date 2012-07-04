//
//  Font+size.m
//  show
//
//  Created by svp on 05/01/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Font+size.h"
#import "settingValues.h"
#import <QuartzCore/QuartzCore.h>
#import "NSString+TruncateToWidth.h"
#import "domainClasses.h"



@implementation Font_size



+(int) cellSelectionValue
{
	// return 0 ,1,2   0 for none and 1 for grey and 2 for blue
	return [NSLocalizedStringFromTable(@"cellSelectionType",@"properties", @"CUSTOMCELL_KEYS") intValue];
}
+(void) adjustLabelHeight:(UILabel *) theLabel:(int)_height
{
	
	CGRect frame = [theLabel frame];
    NSLog(@"%@ and size is %d",theLabel.font.fontName,_height);
    CGSize size = [theLabel.text sizeWithFont:theLabel.font
							constrainedToSize:CGSizeMake(frame.size.width, _height)
								lineBreakMode:UILineBreakModeWordWrap];
    CGFloat delta = size.height - frame.size.height;
	if(delta > 0)
	{
		frame.size.height = size.height;
		[theLabel setFrame:frame];

	}
}
+(NSString *) adjustCommentStartPoint:(UIButton *) theuserButton
{
	
	NSString *str = @"                                     ";
	UILabel *label = theuserButton.titleLabel;
	CGRect frame = [label frame];
	CGSize size = [label.text sizeWithFont:label.font constrainedToSize:CGSizeMake(frame.size.width,frame.size.width) lineBreakMode:UILineBreakModeWordWrap];
	
	[theuserButton setFrame:CGRectMake(theuserButton.frame.origin.x, theuserButton.frame.origin.y, size.width, size.height)];
	str = [str stringByTruncatingToWidth:size withFont:label.font];
	return [str stringByAppendingString:@"   "];
}

+(void) makeRoundImageView:(UIImageView *)_imageView
{
	[_imageView.layer setMasksToBounds:YES];
	[_imageView.layer setCornerRadius:8.0];
	[_imageView.layer setBorderColor:[[UIColor whiteColor] CGColor]];
	[_imageView.layer setBorderWidth:1.0];
	
}
+(UIImage *) makeRoundImage:(UIImage *)_image
{
	int w = _image.size.width;
    int h = _image.size.height;
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL, w, h, 8, 4 * w, colorSpace, kCGImageAlphaPremultipliedFirst);
    
    CGContextBeginPath(context);
    CGRect rect = CGRectMake(0, 0, w, h);
    [self addRoundedRectToPath:context:rect:4:4];
  //  addRoundedRectToPath(context, rect, 4, 4);
    CGContextClosePath(context);
    CGContextClip(context);
    
    CGContextDrawImage(context, CGRectMake(0, 0, w, h), _image.CGImage);
    
    CGImageRef imageMasked = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    return [UIImage imageWithCGImage:imageMasked];
	
}
+(void) addRoundedRectToPath:(CGContextRef ) context:(CGRect) rect:(CGFloat)ovalWidth:(CGFloat)ovalHeight
// addRoundedRectToPath(CGContextRef context, CGRect rect, float ovalWidth, float ovalHeight)
{
    float fw, fh;
    if (ovalWidth == 0 || ovalHeight == 0) {
        CGContextAddRect(context, rect);
        return;
    }
    CGContextSaveGState(context);
    CGContextTranslateCTM (context, CGRectGetMinX(rect), CGRectGetMinY(rect));
    CGContextScaleCTM (context, ovalWidth, ovalHeight);
    fw = CGRectGetWidth (rect) / ovalWidth;
    fh = CGRectGetHeight (rect) / ovalHeight;
    CGContextMoveToPoint(context, fw, fh/2);
    CGContextAddArcToPoint(context, fw, fh, fw/2, fh, 1);
    CGContextAddArcToPoint(context, 0, fh, 0, fh/2, 1);
    CGContextAddArcToPoint(context, 0, 0, fw/2, 0, 1);
    CGContextAddArcToPoint(context, fw, 0, fw, fh/2, 1);
    CGContextClosePath(context);
    CGContextRestoreGState(context);
}


+(UIImage *) getPlaceholderImage
{
	return [UIImage imageNamed:NSLocalizedStringFromTable(@"placeHolder",@"properties", @"Background Image")];
	
}
+(UIImage *) getPersonShahowImage
{
	//return [UIImage imageNamed:NSLocalizedStringFromTable(@"placeHolder",@"properties", @"Background Image")];
    return [UIImage imageNamed:@"personPlaceHolder.jpg"];
	
}

///////////////////////   DETAIL ITEM VIEW SETTINGS VALUES   ///////////////////////

+(CGSize) itemDetailLabelSize
{
	return CGSizeMake(200, 999);
	
}
+(CGSize) itemDetailDescriptionSize
{
	return CGSizeMake(285, 999);
	
}
+(int) feedCommentCellHeight:(PhotoData *) photodata
{
	CGFloat		result = 0.0f;
	NSString*	text = nil;
	int noOfComments = 0;
    if(!photodata.commentArray )
    {
        return result;
    }
	if([photodata.commentArray count] > 5)
		noOfComments = 5 ;
	else
		noOfComments = [photodata.commentArray count];	
    
    for (int i = 0 ;  i < noOfComments ; i ++ )
	{
		CommentsData *obj = [photodata.commentArray objectAtIndex:i];
		text =[NSString stringWithFormat:@"%@",obj.textData];
        if(text)
        {
            CGSize		textSize = {190, 30};		// width and height of text area
            //(UIFont *)fontWithName:(NSString *)fontName size:(CGFloat)fontSize;
            //CGSize		size = [text sizeWithFont:[UIFont systemFontOfSize:12.0f] constrainedToSize:textSize lineBreakMode:UILineBreakModeWordWrap];
            CGSize		size = [text sizeWithFont:[UIFont fontWithName:@"Helvetica Neue" size:12.0f] constrainedToSize:textSize lineBreakMode:UILineBreakModeWordWrap];
            result += size.height; 
        }
	}
	if([photodata.commentArray count] > 5)
		result += 45 ;
	else
		result += 20;	
	return result;
}

+(UIImage *) getLikeImageAfterLike
{
     return [UIImage imageNamed:@"like2.png"];
    
}
+(UIImage *) getLikeImageBeforeLike
{
     return [UIImage imageNamed:@"like1.png"];
    
}
+(UIColor *) cellBackgroundColor
{
    return  [UIColor colorWithRed:235/255.f green:235/255.f blue:235/255.f alpha:255/255.f];
}
+(void) dropShahdowToImageView:(UIImageView *)imageView
{
    /*
     imageView.layer.shadowColor = [UIColor blackColor].CGColor;
     imageView.layer.shadowOffset = CGSizeMake(0, 1);
     imageView.layer.shadowOpacity = 1;
     imageView.layer.shadowRadius = 5.0;*/
    
    imageView.layer.shadowColor = [UIColor darkGrayColor].CGColor;
    imageView.layer.cornerRadius = 0.0;
    imageView.layer.masksToBounds = NO;
    imageView.layer.shadowOffset = CGSizeMake(7,7);
    imageView.layer.shadowOpacity = 0.8f;
    imageView.layer.shadowRadius = 10.0;
    
    
}
+(void) dropShahdowToButton:(UIButton *)button
{
    button.layer.cornerRadius = 0.0f;
    button.layer.masksToBounds = NO;
    button.layer.borderWidth = 0.0f;
    
    button.layer.shadowColor = [UIColor darkGrayColor].CGColor;
    button.layer.shadowOpacity = 0.6;
    button.layer.shadowRadius = 6;
    button.layer.shadowOffset = CGSizeMake(6.0f, 6.0f);
}



+(void) customSearchBarBackground:(UISearchBar *)searchBar
{
    UIImageView *searchBarOverlay = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"searchBar.png"]];
    searchBarOverlay.frame = CGRectMake(-3, -2, 322, 46);
    [searchBar addSubview:searchBarOverlay];
    [searchBar sendSubviewToBack:searchBarOverlay];
   // UITextField *searchField = (UITextField *)[[searchBar subviews] objectAtIndex:0];
  //  searchField.borderStyle = UITextBorderStyleBezel;
   // searchField.background = [UIImage imageNamed:@"Submitbutton.png"];
   // UITextField *searchField1 = [searchBar valueForKey:@"_searchField"];
   // searchField1.textColor = [UIColor redColor]; //You can put any color here.
    
    for (UIView *v in [searchBar subviews]) {
        
        if ([NSStringFromClass([v class]) isEqualToString:@"UISearchBarBackground"]) 
        {
            [searchBar sendSubviewToBack:v];
        }
        
        if ([NSStringFromClass([v class]) isEqualToString:@"UIImageView"] && v != searchBarOverlay) 
        {
            [searchBar sendSubviewToBack:v];
        }
        if([v isKindOfClass:[UITextField class]] )
        {
            UITextField *searchField = (UITextField *) v;
            searchField.borderStyle = UITextBorderStyleBezel;
            searchField.background = [UIImage imageNamed:@"searchTextField.png"];
            UITextField *searchField1 = [searchBar valueForKey:@"_searchField"];
            searchField1.textColor = [UIColor redColor];
            
            
        }
    }
}
+(CGRect) getNavRightButtonFrame

{
    //return  CGRectMake( 0, 0,75,32);
    return CGRectMake(0, 0, 70, 29);
}
/*
+(void) customSearchBarBackground:(UISearchBar *)searchBar
{
    for (UIView *subview in searchBar.subviews) {
        if ([subview isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
            UIView *bg = [[UIView alloc] initWithFrame:subview.frame];
            bg.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Submitbutton"]];
            [searchBar insertSubview:bg aboveSubview:subview];
            [subview removeFromSuperview];
            break;
        }
    }   
}*/

@end
