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
@synthesize delegate;
@synthesize tObj;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        float width = self.frame.size.width;
        
//        UITapGestureRecognizer *tapReg = [[UITapGestureRecognizer alloc]initWithTarget:self
//                                                                                action:@selector(tapGestureRecongnizer:)];
        headImgView = [[TTImageView alloc]init];
        headImgView.frame = CGRectMake(0, 0, 50, 50);
        [self addSubview:headImgView];
//        [headImgView addGestureRecognizer:tapReg];
//        [tapReg release];
        
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
    [tObj release];
    [tsLab release];
    [sImgView release];
    [introLab release];
    [headImgView release];
    [super dealloc];
}

- (void) setTObj:(Teacher *)obj
{
    tObj = nil;
    tObj = [obj copy];
    
    if (tObj.sex == 1)
    {
        self.headImgView.defaultImage = [UIImage imageNamed:@"s_boy"];
        self.introLab.text = [NSString stringWithFormat:@"%@ 男", tObj.name];
    }
    else
    {
        self.headImgView.defaultImage = [UIImage imageNamed:@"s_girl"];
        self.introLab.text = [NSString stringWithFormat:@"%@ 女", tObj.name];
    }
    self.headImgView.URL = tObj.headUrl;
    self.tsLab.text = [NSString stringWithFormat:@"已辅导%d位学生", tObj.studentCount];
    [self.sImgView setHlightStar:tObj.comment];
}

@end
