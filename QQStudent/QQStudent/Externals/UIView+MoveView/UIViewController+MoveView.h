//
//  UIView+MoveView.h
//  LivAllRadar
//
//  Created by Lynn on 12-10-18.
//  Copyright (c) 2012年 WiMi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (MoveView)

//恢复视图
- (void)repickView:(UIView *)parent;

//检查是否视图挡住一个视图,被挡住视图后只能移动界面
- (void) moveViewWhenViewHidden:(UIView *)view parent:(UIView *) parentView;

- (void) moveViewWhenPointHidden:(CGPoint) point parent:(UIView *) parentView;
@end
