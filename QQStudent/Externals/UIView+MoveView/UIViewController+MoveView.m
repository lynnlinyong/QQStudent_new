//
//  UIView+MoveView.m
//  LivAllRadar
//
//  Created by Lynn on 12-10-18.
//  Copyright (c) 2012年 WiMi. All rights reserved.
//

#import "UIViewController+MoveView.h"

@implementation UIViewController (MoveView)

//恢复视图
- (void)repickView:(UIView *)parent
{
    NSTimeInterval animationDuration = 0.30f;         
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];         
    
    [UIView setAnimationDuration:animationDuration];         
    CGRect rect  = CGRectMake(0.0f, 0.0f, parent.frame.size.width,
                                                parent.frame.size.height);         
    parent.frame = rect;  
    
    [UIView commitAnimations]; 
}

//检查是否软键盘挡住编辑框,挡住编辑框后只能移动界面
- (void) moveViewWhenViewHidden:(UIView *)view parent:(UIView *) parentView
{
    CGRect frame = view.frame;  
    
    //键盘高度216  
    int offset = frame.origin.y + 37 - (parentView.frame.size.height - 250.0);
    NSTimeInterval animationDuration = 0.30f;   
    
    [UIView beginAnimations:@"ResizeForKeyBoard" context:nil];                 
    [UIView setAnimationDuration:animationDuration];  
    
    float width  = parentView.frame.size.width;                 
    float height = parentView.frame.size.height;         
    if(offset > 0)  
    {
        CGRect rect      = CGRectMake(0.0f, -offset, width, height);
        parentView.frame = rect;         
    }    
    
    [UIView commitAnimations]; 
}

- (void) moveViewWhenPointHidden:(CGPoint) point parent:(UIView *) parentView
{
    //键盘高度216
    
    int offset = point.y - (parentView.frame.size.height - 250.0);
    NSTimeInterval animationDuration = 0.30f;
    
    [UIView beginAnimations:@"ResizeForKeyBoard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    float width  = parentView.frame.size.width;
    float height = parentView.frame.size.height;
    if(offset > 0)
    {
        CGRect rect      = CGRectMake(0.0f, -offset, width, height);
        parentView.frame = rect;
    }
    
    [UIView commitAnimations];
}
@end
