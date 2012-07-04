//
//  ImageManipulator.h
//
//  Class for manipulating images.
//
//  Created by Björn Sållarp on 2008-09-11.
//  Copyright 2008 Björn Sållarp. All rights reserved.
//
//  Read my blog @ http://blog.sallarp.com
//
// Updated on 2009-04-05

#import <UIKit/UIKit.h>

@interface UIImage (Extras)
+(UIImage *)imageByScalingProportionallyToSize:(UIImage *)_sourceImage:(CGSize)targetSize;
@end;

@interface ImageManipulator : NSObject {

}

+(UIImage *)makeRoundCornerImage:(UIImage*)img :(int) cornerWidth :(int) cornerHeight;
+ (UIImage *)scaleImage:(UIImage *)image:(CGSize)targetSize;

@end
