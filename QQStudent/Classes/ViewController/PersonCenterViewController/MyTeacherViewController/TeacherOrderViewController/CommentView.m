//
//  CommentView.m
//  QQStudent
//
//  Created by lynn on 14-2-14.
//  Copyright (c) 2014年 lynn. All rights reserved.
//

#import "CommentView.h"

@implementation CommentView
@synthesize contentView;
@synthesize delegate;
@synthesize orderId;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        
        contentView = [[UIView alloc]initWithFrame:frame];
        contentView.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:contentView];
    }
    return self;
}

- (void) dealloc
{
    [contentView release];
    [super dealloc];
}

#pragma mark -
#pragma mark - Custom Action
- (void) showView:(CGRect) rect
{
    contentView.frame = rect;
    
    UILabel *infoLab = [[UILabel alloc]init];
    infoLab.font = [UIFont systemFontOfSize:10.f];
    infoLab.backgroundColor = [UIColor clearColor];
    infoLab.text  = @"评价只有一次机会,慎重选哦!";
    infoLab.frame = CGRectMake(0, rect.size.height-45,rect.size.width, 20);
    [contentView addSubview:infoLab];
    [infoLab release];
    
    UIButton *goodBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    goodBtn.tag = 1;
    goodBtn.frame = CGRectMake(rect.size.width/2-25, rect.size.height-25, 20, 20);
    [goodBtn setTitle:@"赞" forState:UIControlStateNormal];
    [goodBtn addTarget:self
                action:@selector(doButtonClicked:)
      forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:goodBtn];

    UIButton *badBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    badBtn.tag = 2;
    badBtn.frame = CGRectMake(rect.size.width/2+5, rect.size.height-25, 20, 20);
    [badBtn setTitle:@"逊"
            forState:UIControlStateNormal];
    [badBtn addTarget:self
               action:@selector(doButtonClicked:)
     forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:badBtn];
}

- (void) doButtonClicked:(id)sender
{
    UIButton *button = sender;
    if (delegate)
    {
        if ([delegate respondsToSelector:@selector(commentView:ClickedIndex:)])
        {
            [delegate commentView:self ClickedIndex:button.tag];
        }
    }
}

#pragma mark -
#pragma mark - Touch Event
- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.hidden = YES;
    [self removeFromSuperview];
}
@end
