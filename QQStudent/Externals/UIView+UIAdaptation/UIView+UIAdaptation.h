//
//  UIView+UIAdaptation.h
//  DeviceShop
//
//  Created by lynn on 13-5-29.
//  Copyright (c) 2013年 lynn. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * 任何UI视图自适应iPhone和iPad不同分辨率
 **/
@interface UIView (UIAdaptation)

//返回一个比例，以iphone模拟器为基准来进行比较
+(float)currentSize:(BOOL)h;

//返回合适的坐标
+(CGRect)fitCGRect:(CGRect)rect isBackView:(BOOL) isBackView;

@end
