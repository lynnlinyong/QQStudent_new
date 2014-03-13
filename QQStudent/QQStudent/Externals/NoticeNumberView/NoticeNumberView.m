//
//  NoticeNumberView.m
//  QQStudent
//
//  Created by lynn on 14-2-28.
//  Copyright (c) 2014年 lynn. All rights reserved.
//

#import "NoticeNumberView.h"

@implementation NoticeNumberView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //未读消息数量显示
        UIImage *image = [UIImage imageNamed:@"lp_mc_bg"];
        bgImgView = [[UIImageView alloc]initWithImage:image];
        bgImgView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        
        contentLab = [[UILabel alloc]init];
        contentLab.backgroundColor = [UIColor clearColor];
        contentLab.font = [UIFont systemFontOfSize:12.f];
        contentLab.textAlignment = NSTextAlignmentCenter;
        contentLab.textColor = [UIColor whiteColor];
        contentLab.frame=CGRectMake(10, 2.5, frame.size.width-5,
                                    frame.size.height-5);
        [bgImgView addSubview:contentLab];
        [self addSubview:bgImgView];
    }
    return self;
}

- (void) dealloc
{
    [bgImgView release];
    [contentLab release];
    [super dealloc];
}

- (void) setTitle:(NSString *)title
{
    //根据数字内容自动设置宽度
    CGSize size = [title sizeWithFont:[UIFont systemFontOfSize:12.f]
                    constrainedToSize:CGSizeMake(contentLab.frame.size.width, MAXFLOAT)];
    bgImgView.frame = CGRectMake(bgImgView.frame.origin.x,
                                 bgImgView.frame.origin.y,
                                 size.width+5,
                                 size.height+5);
    contentLab.frame = CGRectMake(bgImgView.frame.size.width/2-size.width/2, contentLab.frame.origin.y, size.width, size.height);

    contentLab.text = title;
}
@end
