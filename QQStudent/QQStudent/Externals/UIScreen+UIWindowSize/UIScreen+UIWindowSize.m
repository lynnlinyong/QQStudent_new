//
//  UIScreen+UIWindowSize.m
//  DeviceShop
//
//  Created by lynn on 13-5-29.
//  Copyright (c) 2013年 lynn. All rights reserved.
//

#import "UIScreen+UIWindowSize.h"

@implementation UIScreen (UIWindowSize)

//获得当前实际的尺寸包括方向
+ (CGRect) getCurrentBounds
{
    CGRect rect       = [[UIScreen mainScreen] bounds];
    CGSize screenSize = rect.size;
    
    //判断当前设备的方向决定尺寸
    if (([[UIApplication sharedApplication] statusBarOrientation] == UIDeviceOrientationLandscapeLeft) ||
        ([UIDevice currentDevice].orientation == UIDeviceOrientationLandscapeRight))
    {
        int tSize         = screenSize.width;
        screenSize.width  = screenSize.height;
        screenSize.height = tSize;
        rect.size = screenSize;
    }
    return rect;
}

@end


