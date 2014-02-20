//
//  CommentView.h
//  QQStudent
//
//  Created by lynn on 14-2-14.
//  Copyright (c) 2014年 lynn. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CommentView;
@protocol CommentViewDelegate <NSObject>
- (void) commentView:(CommentView *)commentView ClickedIndex:(int) index;
@end

@interface CommentView : UIView
@property (nonatomic, retain) NSString *orderId;
@property (nonatomic, retain) UIView *contentView;
@property (nonatomic, assign) id<CommentViewDelegate> delegate;
- (void) showView:(CGRect) rect;
@end
