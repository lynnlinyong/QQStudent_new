//
//  UINavigationBar+CustomImage.m
//  QQStudent
//
//  Created by lynn on 14-2-7.
//  Copyright (c) 2014年 lynn. All rights reserved.
//

#import "UINavigationBar+CustomImage.h"

@implementation UINavigationBar (CustomImage)
- (void) drawRect:(CGRect)rect
{
    UIImage *image = [UIImage imageNamed:@"navi.png"];
    [image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
}
@end
