//
//  CustomButtonView.h
//  QQStudent
//
//  Created by lynn on 14-2-23.
//  Copyright (c) 2014年 lynn. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CustomButtonView;
@protocol CustomButtonViewDelegate <NSObject>

- (void) view:(CustomButtonView *) view index:(int) index;

@end

@interface CustomButtonView : UIView <UIGestureRecognizerDelegate>
@property (nonatomic, assign) id<CustomButtonViewDelegate> delegate;
@property (nonatomic, retain) UIImageView *imageView;
@property (nonatomic, retain) UILabel  *contentLab;
@end
