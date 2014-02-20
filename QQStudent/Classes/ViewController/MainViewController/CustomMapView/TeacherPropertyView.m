//
//  TeacherPropertyView.m
//  QQStudent
//
//  Created by lynn on 14-2-8.
//  Copyright (c) 2014年 lynn. All rights reserved.
//

#import "TeacherPropertyView.h"

@implementation TeacherPropertyView
@synthesize introLab;
@synthesize tsLab;
@synthesize sImgView;
@synthesize headImgView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        float width = self.frame.size.width;
        
        headImgView = [[TTImageView alloc]init];
        headImgView.frame = CGRectMake(0, 0, 50, 50);
        [self addSubview:headImgView];
        
        introLab = [[UILabel alloc]init];
        introLab.frame = CGRectMake(55, 0, width-55, 20);
        introLab.font  = [UIFont systemFontOfSize:12.f];
        introLab.backgroundColor = [UIColor clearColor];
        [self addSubview:introLab];
        
        tsLab = [[UILabel alloc]init];
        tsLab.frame = CGRectMake(55, 20, width-55, 20);
        tsLab.font  = [UIFont systemFontOfSize:12.f];
        tsLab.backgroundColor = [UIColor clearColor];
        [self addSubview:tsLab];
        
        sImgView = [[UIStartsImageView alloc]initWithFrame:CGRectMake(55, 40, 100, 20)];
        [self addSubview:sImgView];
    }
    return self;
}

- (void) dealloc
{
    [tsLab release];
    [sImgView release];
    [introLab release];
    [headImgView release];
    [super dealloc];
}

@end
