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
        UIImage *starImg = [UIImage imageNamed:@"mt_star_normal"];
        star1ImgView = [[UIImageView alloc]init];
        star1ImgView.frame = CGRectMake(0, 0, starImg.size.width, starImg.size.height);
        star1ImgView.image = starImg;
        
        star2ImgView = [[UIImageView alloc]init];
        star2ImgView.frame = CGRectMake(width/6, 0, starImg.size.width, starImg.size.height);
        star2ImgView.image = starImg;
        
        star3ImgView = [[UIImageView alloc]init];
        star3ImgView.frame = CGRectMake(width/6*2, 0, starImg.size.width, starImg.size.height);
        star3ImgView.image = starImg;
        
        star4ImgView = [[UIImageView alloc]init];
        star4ImgView.frame = CGRectMake(width/6*3, 0, starImg.size.width, starImg.size.height);
        star4ImgView.image = starImg;
        
        star5ImgView = [[UIImageView alloc]init];
        star5ImgView.frame = CGRectMake(width/6*4, 0, starImg.size.width, starImg.size.height);
        star5ImgView.image = starImg;
        
        star6ImgView = [[UIImageView alloc]init];
        star6ImgView.frame = CGRectMake(width/6*5, 0, starImg.size.width, starImg.size.height);
        star6ImgView.image = starImg;
        
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

- (void) setHlightStar:(int) count
{
    CLog(@"TeacherStar:%d", count);
    UIImage *hlightImg = [UIImage imageNamed:@"mt_star_hlight"];
    switch (count)
    {
        case 0:
        {
            break;
        }
        case 1:
        {
            star1ImgView.image = hlightImg;
            break;
        }
        case 2:
        {
            star1ImgView.image = hlightImg;
            star2ImgView.image = hlightImg;
            break;
        }
        case 3:
        {
            star1ImgView.image = hlightImg;
            star2ImgView.image = hlightImg;
            star3ImgView.image = hlightImg;
            break;
        }
        case 4:
        {
            star1ImgView.image = hlightImg;
            star2ImgView.image = hlightImg;
            star3ImgView.image = hlightImg;
            star4ImgView.image = hlightImg;
            break;
        }
        case 5:
        {
            star1ImgView.image = hlightImg;
            star2ImgView.image = hlightImg;
            star3ImgView.image = hlightImg;
            star4ImgView.image = hlightImg;
            star5ImgView.image = hlightImg;
            break;
        }
        case 6:
        {
            star1ImgView.image = hlightImg;
            star2ImgView.image = hlightImg;
            star3ImgView.image = hlightImg;
            star4ImgView.image = hlightImg;
            star5ImgView.image = hlightImg;
            star6ImgView.image = hlightImg;
            break;
        }
        default:
            break;
    }
}
@end
