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
@synthesize goodLab;
@synthesize badLab;
@synthesize goodImgView;
@synthesize badImgView;
@synthesize idImageView;
@synthesize orgNameLab;

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
        introLab.frame = CGRectMake(60, 0, width-55, 20);
        introLab.font  = [UIFont systemFontOfSize:12.f];
        introLab.backgroundColor = [UIColor clearColor];
        [self addSubview:introLab];
        
        tsLab = [[UILabel alloc]init];
        tsLab.frame = CGRectMake(60, 20, width-55, 20);
        tsLab.font  = [UIFont systemFontOfSize:12.f];
        tsLab.backgroundColor = [UIColor clearColor];
        [self addSubview:tsLab];
        
        sImgView = [[UIStartsImageView alloc]initWithFrame:CGRectMake(60, 40, 100, 20)];
        [self addSubview:sImgView];
        
        UILabel *infoLab = [[UILabel alloc]init];
        infoLab.font  = [UIFont systemFontOfSize:15.f];
        infoLab.frame = CGRectMake(0, 65, 40, 20);
        infoLab.text  = @"口碑:";
        infoLab.backgroundColor = [UIColor clearColor];
        infoLab.textColor       = [UIColor colorWithHexString:@"#999999"];
        [self addSubview:infoLab];
        
        UIImage *goodImg = [UIImage imageNamed:@"tdp_good_comment"];
        goodImgView = [[UIImageView alloc]init];
        goodImgView.image = goodImg;
        goodImgView.frame = CGRectMake(45, 65, 20, 20);
        [self addSubview:goodImgView];
        
        goodLab = [[UILabel alloc]init];
        goodLab.textColor = [UIColor orangeColor];
        goodLab.font = [UIFont systemFontOfSize:14.f];
        goodLab.backgroundColor = [UIColor clearColor];
        goodLab.frame = CGRectMake(68, 68, 40, 20);
        [self addSubview:goodLab];
        
        UIImage *badImg = [UIImage imageNamed:@"tdp_bad_comment"];
        badImgView = [[UIImageView alloc]init];
        badImgView.frame = CGRectMake(90, 65, 20, 20);
        badImgView.image = badImg;
        [self addSubview:badImgView];
        
        badLab = [[UILabel alloc]init];
        badLab.backgroundColor = [UIColor clearColor];
        badLab.font  = [UIFont systemFontOfSize:14.f];
        badLab.frame = CGRectMake(113, 68, 40, 20);
        [self addSubview:badLab];
        
        UIImage *idImg = [UIImage imageNamed:@"mp_rz"];
        idImageView = [[UIImageView alloc]init];
        idImageView.hidden = YES;
        idImageView.image  = idImg;
        idImageView.frame  = CGRectMake(self.frame.size.width-idImg.size.width-10,
                                        self.frame.size.height-idImg.size.height-20,
                                        idImg.size.width+10, idImg.size.height+10);
        [self addSubview:idImageView];
        
        orgNameLab = [[UILabel alloc]init];
        orgNameLab.backgroundColor = [UIColor clearColor];
        orgNameLab.frame = CGRectMake(0, self.frame.size.height-30, 100, 20);
        [self addSubview:orgNameLab];
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
    
    [goodImgView release];
    [goodLab release];
    
    [badImgView release];
    [badLab release];
    
    [idImageView release];
    [orgNameLab release];
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
    
    self.goodLab.text    = [NSString stringWithFormat:@"%d", tObj.goodCount];
    self.badLab.text     = [NSString stringWithFormat:@"%d", tObj.badCount];
    self.orgNameLab.text = tObj.idOrgName;
    if (tObj.isId)
    {
        idImageView.hidden = NO;
        orgNameLab.hidden  = NO;
    }
    else
    {
        idImageView.hidden = YES;
        orgNameLab.hidden  = YES;
    }
}

@end
