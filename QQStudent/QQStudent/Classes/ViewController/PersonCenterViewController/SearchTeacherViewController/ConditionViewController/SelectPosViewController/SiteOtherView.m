//
//  SiteOtherView.m
//  QQStudent
//
//  Created by lynn on 14-2-20.
//  Copyright (c) 2014年 lynn. All rights reserved.
//

#import "SiteOtherView.h"

@implementation SiteOtherView
@synthesize siteNameLab;
@synthesize infoLab;
@synthesize expenseLab;
@synthesize posLab;
@synthesize telLab;
@synthesize mainImgView;
@synthesize delegate;
@synthesize site;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        siteNameLab = [[UILabel alloc]init];
        siteNameLab.font = [UIFont systemFontOfSize:12.f];
        siteNameLab.textColor = [UIColor colorWithHexString:@"#009f66"];
        siteNameLab.frame= CGRectMake( 5, 5, 100, 20);
        siteNameLab.backgroundColor = [UIColor clearColor];
        [self addSubview:siteNameLab];
        
        infoLab = [[UILabel alloc]init];
        infoLab.font  = [UIFont systemFontOfSize:12.f];
        infoLab.frame = CGRectMake(5, 25, 150, 20);
        infoLab.backgroundColor = [UIColor clearColor];
        [self addSubview:infoLab];
        
        expenseLab = [[UILabel alloc]init];
        expenseLab.font = [UIFont systemFontOfSize:12.f];
        expenseLab.frame= CGRectMake(5, 45, 150, 20);
        expenseLab.backgroundColor = [UIColor clearColor];
        [self addSubview:expenseLab];
        
        posLab = [[UILabel alloc]init];
        posLab.font = [UIFont systemFontOfSize:12.f];
        posLab.frame= CGRectMake(5, 115, 200, 30);
        posLab.numberOfLines   = 0;
        posLab.lineBreakMode   = NSLineBreakByWordWrapping;
        posLab.backgroundColor = [UIColor clearColor];
        [self addSubview:posLab];
        
        telLab = [[UILabel alloc]init];
        telLab.font = [UIFont systemFontOfSize:12.f];
        telLab.frame= CGRectMake(5, 145, 100, 20);
        telLab.textColor = [UIColor colorWithHexString:@"#ff6600"];
        telLab.backgroundColor = [UIColor clearColor];
        [self addSubview:telLab];
        
        mainImgView = [[TTImageView alloc]init];
        mainImgView.tag   = 0;
        mainImgView.frame = CGRectMake(160, 15, 150, 100);
        mainImgView.image = [UIImage imageNamed:@"btn_chuantu"];
        //添加单击手势
        UITapGestureRecognizer *tapRg = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                action:@selector(handleSingleTapFrom:)];
        tapRg.numberOfTapsRequired = 1;
        [mainImgView addGestureRecognizer:tapRg];
        [tapRg release];

        [self addSubview:mainImgView];
        
        calBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        calBtn.tag = 1;
        [calBtn setImage:[UIImage imageNamed:@"tel_s"]
                forState:UIControlStateNormal];
        [calBtn addTarget:self
                   action:@selector(doButtonClicked:)
         forControlEvents:UIControlEventTouchUpInside];
        calBtn.frame = CGRectMake(frame.size.width-45, 125, 40, 40);
        [self addSubview:calBtn];
    }
    return self;
}

- (void) dealloc
{
    [siteNameLab release];
    [infoLab     release];
    [expenseLab  release];
    [posLab      release];
    [telLab      release];
    [mainImgView release];
    
    [super dealloc];
}

- (void) setSite:(Site *)siteObj
{
    siteNameLab.text = [NSString stringWithFormat:@"推荐地址(%@)", siteObj.sid];
    infoLab.text     = siteObj.name;
    expenseLab.text  = [NSString stringWithFormat:@"场地租金:￥%@/小时", siteObj.expense];
    posLab.text      = siteObj.address;
    telLab.text      = siteObj.tel;
    mainImgView.URL  = siteObj.icon;
    
    site = [siteObj copy];
}

#pragma mark -
#pragma mark - Control Event
- (void) doButtonClicked:(id)sender
{
    UIButton *btn = sender;
    if (delegate)
    {
        if ([delegate respondsToSelector:@selector(view:clickedTag:)])
        {
            [delegate view:self clickedTag:btn.tag];
        }
    }
}

- (void) handleSingleTapFrom:(UIGestureRecognizer *) reg
{
    if (delegate)
    {
        if ([delegate respondsToSelector:@selector(view:clickedTag:)])
        {
            [delegate view:self clickedTag:0];
        }
    }
}
@end
