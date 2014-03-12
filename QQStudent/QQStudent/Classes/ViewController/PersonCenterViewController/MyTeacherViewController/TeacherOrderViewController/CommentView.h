//
//  CommentView.h
//  QQStudent
//
//  Created by lynn on 14-2-14.
//  Copyright (c) 2014年 lynn. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CommentView;

@interface CommentView : UIView
@property (nonatomic, retain) UIView      *parentView;
@property (nonatomic, retain) NSString    *orderId;
@property (nonatomic, retain) UIImageView *contentView;
@property (nonatomic, retain) NSString    *idStr;

- (void) showView:(CGRect) rect;
- (void) setMeHidden:(BOOL)h;
@end
