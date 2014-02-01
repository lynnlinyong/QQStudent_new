//
//  UIStartsImageView.m
//  QQStudent
//
//  Created by lynn on 14-1-30.
//  Copyright (c) 2014年 lynn. All rights reserved.
//

#import "UIStartsImageView.h"

@implementation UIStartsImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        float width  = frame.size.width;
        float height = frame.size.height;
        
        star1ImgView = [[UIImageView alloc]init];
        star1ImgView.frame = CGRectMake(0, 0, width/6, height);
        star1ImgView.image = [UIImage imageNamed:@"star.png"];
        
        star2ImgView = [[UIImageView alloc]init];
        star2ImgView.frame = CGRectMake(width/6, 0, width/6, height);
        star2ImgView.image = [UIImage imageNamed:@"star.png"];
        
        star3ImgView = [[UIImageView alloc]init];
        star3ImgView.frame = CGRectMake(width/6*2, 0, width/6, height);
        star3ImgView.image = [UIImage imageNamed:@"star.png"];
        
        star4ImgView = [[UIImageView alloc]init];
        star4ImgView.frame = CGRectMake(width/6*3, 0, width/6, height);
        star4ImgView.image = [UIImage imageNamed:@"star.png"];
        
        star5ImgView = [[UIImageView alloc]init];
        star5ImgView.frame = CGRectMake(width/6*4, 0, width/6, height);
        star5ImgView.image = [UIImage imageNamed:@"star.png"];
        
        star6ImgView = [[UIImageView alloc]init];
        star6ImgView.frame = CGRectMake(width/6*5, 0, width/6, height);
        star6ImgView.image = [UIImage imageNamed:@"star.png"];
        
        [self addSubview:star1ImgView];
        [self addSubview:star2ImgView];
        [self addSubview:star3ImgView];
        [self addSubview:star4ImgView];
        [self addSubview:star5ImgView];
        [self addSubview:star6ImgView];
    }
    return self;
}

- (void) dealloc
{
    [star1ImgView release];
    [star2ImgView release];
    [star3ImgView release];
    [star4ImgView release];
    [star5ImgView release];
    [star6ImgView release];
    [super dealloc];
}

@end
