//
//  NSString+StringToImage.m
//  QQStudent
//
//  Created by lynn on 14-2-15.
//  Copyright (c) 2014年 lynn. All rights reserved.
//

#import "NSObject+StringToImage.h"

@implementation NSObject (StringToImage)
- (UIImage *)imageFromText:(NSString *)text
                    width:(float)width
                   height:(float)height
{
    // set the font type and size
    UIFont *font = [UIFont systemFontOfSize:14.0];
    CGSize size  = CGSizeMake(width, height);// [text sizeWithFont:font];
    
    // check if UIGraphicsBeginImageContextWithOptions is available (iOS is 4.0+)
    if (UIGraphicsBeginImageContextWithOptions != NULL)
        UIGraphicsBeginImageContextWithOptions(size,NO,0.0);
    else
        // iOS is < 4.0
        UIGraphicsBeginImageContext(size);
    
    // optional: add a shadow, to avoid clipping the shadow you should make the context size bigger
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetShadowWithColor(ctx, CGSizeMake(1.0, 1.0), 5.0, [[UIColor grayColor] CGColor]);
    
    // draw in context, you can use  drawInRect/drawAtPoint:withFont:
    //[text drawAtPoint:CGPointMake(0.0, 0.0) withFont:font];
    [text drawInRect:CGRectMake(0, 0, width, height) withFont:font];
    
    // transfer image
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    [image retain];
    UIGraphicsEndImageContext();
    
    return image;
}
@end
