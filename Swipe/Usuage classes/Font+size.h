//
//  Font+size.h
//  show
//
//  Created by svp on 05/01/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PhotoData;
@interface Font_size : NSObject {

}
+(void) adjustLabelHeight:(UILabel *) theLabel:(int)_height;
//+(void) checkDesc:(UILabel *) theLabel:(UIView *)_fView;
+(UIImage *) makeRoundImage:(UIImage *)_image;
+(void) makeRoundImageView:(UIImageView *)_imageView;
+(UIImage *) getPlaceholderImage;
+(int) feedCommentCellHeight:(PhotoData *) photodata;
+(UIImage *) getPersonShahowImage;
+(UIImage *) getLikeImageAfterLike;
+(UIImage *) getLikeImageBeforeLike;
+(UIColor *) cellBackgroundColor;
+(void) dropShahdowToButton:(UIButton *)button;
+(void) dropShahdowToImageView:(UIImageView *)imageView;
+(void) customSearchBarBackground:(UISearchBar *)searchBar;
+(CGRect) getNavRightButtonFrame;
///////////////////////   DETAIL ITEM VIEW SETTINGS VALUES   ///////////////////////
+(void) addRoundedRectToPath:(CGContextRef ) context:(CGRect) rect:(CGFloat)ovalWidth:(CGFloat)ovalHeight;

@end
