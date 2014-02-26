//
//  UIImage+CircleImage.m
//  QQStudent
//
//  Created by lynn on 14-2-26.
//  Copyright (c) 2014年 lynn. All rights reserved.
//

#import "UIImage+CircleImage.h"

@implementation UIImage (CircleImage)
+(UIImage*) circleImage:(UIImage*) image withParam:(CGFloat) inset
{
    UIGraphicsBeginImageContext(image.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 2);
    CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
    CGRect rect = CGRectMake(inset, inset, image.size.width - inset * 2.0f, image.size.height - inset * 2.0f);
    CGContextAddEllipseInRect(context, rect);
    CGContextClip(context);
    
    [image drawInRect:rect];
    CGContextAddEllipseInRect(context, rect);
    CGContextStrokePath(context);
    UIImage *newimg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newimg;
}
@end
