//
//  UIScreen+UIWindowSize.h
//  DeviceShop
//
//  Created by lynn on 13-5-29.
//  Copyright (c) 2013年 lynn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScreen (UIWindowSize)

//获得当前实际的尺寸包括方向
+ (CGRect) getCurrentBounds;

@end
