//
//  CustomButtonView.m
//  QQStudent
//
//  Created by lynn on 14-2-23.
//  Copyright (c) 2014年 lynn. All rights reserved.
//

#import "CustomButtonView.h"

@implementation CustomButtonView
@synthesize contentLab;
@synthesize imageView;
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        float width = frame.size.width;
        
        contentLab = [[UILabel alloc]init];
        contentLab.font = [UIFont systemFontOfSize:13.f];
        contentLab.textAlignment   = NSTextAlignmentCenter;
        contentLab.backgroundColor = [UIColor clearColor];
        contentLab.textColor = [UIColor whiteColor];
        contentLab.frame = CGRectMake(0, 40, width, 20);
        [self addSubview:contentLab];
        
        imageView  = [[UIImageView alloc]init];
        imageView.frame = CGRectMake(30, 10, 20, 20);
        [self addSubview:imageView];
        
//        self.alpha = 0.5;
        self.layer.cornerRadius = 10;
        self.layer.backgroundColor = [[UIColor grayColor] CGColor];
        
        UITapGestureRecognizer *reg = [[UITapGestureRecognizer alloc]initWithTarget:self
                                                                             action:@selector(tapGestureRecongnizer:)];
        reg.delegate = self;
        [self addGestureRecognizer:reg];
        [reg release];
    }
    return self;
}

- (void) dealloc
{
    [contentLab release];
    [imageView  release];
    [super dealloc];
}

- (void) tapGestureRecongnizer:(UITapGestureRecognizer *) reg
{
    if (delegate)
    {
        if ([delegate respondsToSelector:@selector(view:index:)])
        {
            [delegate view:self index:self.tag];
        }
    }
}
@end
