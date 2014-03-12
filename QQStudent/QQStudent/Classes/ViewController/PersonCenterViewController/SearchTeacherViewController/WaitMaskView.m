//
//  WaitMaskView.m
//  QQStudent
//
//  Created by lynn on 14-3-7.
//  Copyright (c) 2014年 lynn. All rights reserved.
//

#import "WaitMaskView.h"

@implementation WaitMaskView
@synthesize tObj;
@synthesize second;
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        mainView = [[UIView alloc]init];
        mainView.alpha = 0.7f;
        mainView.frame = [UIScreen getCurrentBounds];
        mainView.backgroundColor = [UIColor grayColor];
        [self addSubview:mainView];
        
        //top
        bgView = [[LBorderView alloc]init];
        bgView.borderWidth  = 1.f;
        bgView.cornerRadius = 3.f;
        bgView.backgroundColor = [UIColor blackColor];
        bgView.alpha = 0.7f;
        bgView.frame = CGRectMake(20, 150, 280, 150);
        [self addSubview:bgView];
        
        headImgView = [[TTImageView alloc]init];
        headImgView.delegate = self;
        headImgView.frame = CGRectMake(40, 160, 60, 60);
        [self addSubview:headImgView];
        
        starImgView = [[UIStartsImageView alloc]initWithFrame:CGRectMake(30, 230, 80, 5)];
        [self addSubview:starImgView];
        
        infoLab = [[UILabel alloc]init];
        infoLab.font  = [UIFont systemFontOfSize:14.f];
        infoLab.frame = CGRectMake(120, 160, 170, 20);
        infoLab.backgroundColor = [UIColor clearColor];
        infoLab.textColor = [UIColor whiteColor];
        [self addSubview:infoLab];
        
        idNumsLab = [[UILabel alloc]init];
        idNumsLab.font  = [UIFont systemFontOfSize:14.f];
        idNumsLab.frame = CGRectMake(120, 180, 170, 20);
        idNumsLab.backgroundColor = [UIColor clearColor];
        idNumsLab.textColor = [UIColor whiteColor];
        [self addSubview:idNumsLab];
        
        fdStudentLab = [[UILabel alloc]init];
        fdStudentLab.font  = [UIFont systemFontOfSize:14.f];
        fdStudentLab.frame = CGRectMake(120, 200, 170, 20);
        fdStudentLab.backgroundColor = [UIColor clearColor];
        fdStudentLab.textColor = [UIColor whiteColor];
        [self addSubview:fdStudentLab];
        
        UIImage *sayImg = [UIImage imageNamed:@"stmp_say_info_bg"];
        sayImgView = [[UIImageView alloc]init];
        sayImgView.alpha = 1.0f;
        sayImgView.image = sayImg;
        sayImgView.frame = CGRectMake(105, 220, sayImg.size.width, sayImg.size.height);
        [self addSubview:sayImgView];
        
        sayLab = [[UILabel alloc]init];
        sayLab.font = [UIFont systemFontOfSize:14.f];
        sayLab.backgroundColor = [UIColor clearColor];
        sayLab.frame = CGRectMake(15, 5, sayImg.size.width-15, 20);
        sayLab.numberOfLines = 0;
        sayLab.lineBreakMode = NSLineBreakByWordWrapping;
        [sayImgView addSubview:sayLab];
        
        secondLab = [[UILabel alloc]init];
        secondLab.text  = @"正在等待和老师建立沟通...3";
        secondLab.font  = [UIFont systemFontOfSize:14.f];
        secondLab.frame = CGRectMake(90, 230+sayImg.size.height, 180, 20);
        secondLab.backgroundColor = [UIColor clearColor];
        secondLab.textColor = [UIColor whiteColor];
        [self addSubview:secondLab];
        
        //bottom
        UIImage *hImg  = [UIImage imageNamed:@"stmp_sinfo_head"];
        sayHeadImgView = [[UIImageView alloc]init];
        sayHeadImgView.image = hImg;
        sayHeadImgView.frame = CGRectMake(20, 330, hImg.size.width, hImg.size.height);
        [self addSubview:sayHeadImgView];
        
        UIImage *bgInfoImg = [UIImage imageNamed:@"stmp_search_info_bg"];
        infoBgView = [[UIImageView alloc]init];
        infoBgView.image = bgInfoImg;
        infoBgView.frame = CGRectMake(60, 310, bgInfoImg.size.width, bgInfoImg.size.height);
        [self addSubview:infoBgView];
        
        infoSecondLab = [[UILabel alloc]init];
        infoSecondLab.backgroundColor = [UIColor clearColor];
        infoSecondLab.font = [UIFont systemFontOfSize:14.f];
        infoSecondLab.text = @"只用了4秒就找到了一个家教老师,太给力了吧!";
        infoSecondLab.frame= CGRectMake(15, 5, bgInfoImg.size.width-15, 20);
        infoSecondLab.numberOfLines = 0;
        infoSecondLab.lineBreakMode = NSLineBreakByWordWrapping;
        infoSecondLab.backgroundColor = [UIColor clearColor];
        [infoBgView addSubview:infoSecondLab];
        
        UIImage *btnImg = [UIImage imageNamed:@"stmp_send_btn"];
        sendFrdBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [sendFrdBtn setImage:btnImg
                    forState:UIControlStateNormal];
        sendFrdBtn.frame = CGRectMake(infoBgView.frame.origin.x+bgInfoImg.size.width-10-btnImg.size.width,
                                      infoBgView.frame.origin.y+bgInfoImg.size.height-10-btnImg.size.height,
                                      btnImg.size.width, btnImg.size.height);
        [sendFrdBtn addTarget:self
                       action:@selector(shareFriend:)
             forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:sendFrdBtn];
        
        curSecond = 3;
        timer  = [NSTimer scheduledTimerWithTimeInterval:1.0f
                                                 target:self
                                               selector:@selector(timeOut)
                                               userInfo:nil
                                                repeats:YES];
        [timer fire];
    }
    return self;
}

- (void) dealloc
{
    [timer invalidate];
    timer = nil;
    
    delegate = nil;
    
    [headImgView release];
    [starImgView release];
    [mainView release];
    [bgView release];
    [infoLab release];
    [idNumsLab release];
    [fdStudentLab release];
    [sayLab release];
    [sayImgView release];
    
    [sayHeadImgView release];
    [infoBgView release];
    [infoSecondLab release];
    [super dealloc];
}

- (void) setTObj:(Teacher *)obj
{
    tObj = nil;
    tObj = [obj copy];
    
    if (obj.sex == 1)
        headImgView.defaultImage = [UIImage imageNamed:@"s_boy"];
    else
        headImgView.defaultImage = [UIImage imageNamed:@"s_gril"];
    headImgView.URL   = obj.headUrl;
    
    [starImgView setHlightStar:obj.comment];
    
    infoLab.text      = [NSString stringWithFormat:@"%@    %@     %@", obj.name, [Student searchGenderName:[NSString stringWithFormat:@"%d",obj.sex]], obj.pf];
    
    idNumsLab.text    = obj.idNums;
    fdStudentLab.text = [NSString stringWithFormat:@"已辅导%d位学生", obj.studentCount];
    sayLab.text       = obj.info;
    
    NSString *secondStr = [NSString stringWithFormat:@"只用了%@秒就找到了个家教老师,太给力了吧!", second];
    CGSize size = [secondStr sizeWithFont:infoSecondLab.font constrainedToSize:CGSizeMake(infoSecondLab.frame.size.width, MAXFLOAT)
                            lineBreakMode:NSLineBreakByWordWrapping];
    infoSecondLab.text  = secondStr;
    infoSecondLab.frame = CGRectMake(infoSecondLab.frame.origin.x, infoSecondLab.frame.origin.y, size.width, size.height);
    
    //自适应
    [self setAutoSayContent];
}

- (void) setAutoSayContent
{
    float offset = 0;
    CGSize size = [tObj.info sizeWithFont:sayLab.font constrainedToSize:CGSizeMake(sayLab.frame.size.width, MAXFLOAT)
                            lineBreakMode:NSLineBreakByWordWrapping];
    if (size.height>sayImgView.frame.size.height)
    {
        offset = size.height - sayImgView.frame.size.height+5;
    }
    sayLab.frame = CGRectMake(sayLab.frame.origin.x, sayLab.frame.origin.y+offset/5, size.width, size.height);
    sayImgView.frame = CGRectMake(sayImgView.frame.origin.x, sayImgView.frame.origin.y,
                                  sayImgView.frame.size.width, sayImgView.frame.size.height+offset);
    
    secondLab.frame  = CGRectMake(secondLab.frame.origin.x,   secondLab.frame.origin.y+offset,
                                  secondLab.frame.size.width, secondLab.frame.size.height);
    
    float sayLabPos = sayImgView.frame.origin.y+sayImgView.frame.size.height;
    float bgViewPos = bgView.frame.origin.y+bgView.frame.size.height;
    if (sayLabPos>bgViewPos)
    {
        offset = sayLabPos - bgViewPos;
        bgView.frame = CGRectMake(bgView.frame.origin.x, bgView.frame.origin.y,
                                  bgView.frame.size.width, bgView.frame.size.height+offset);
        
        
        sayHeadImgView.frame = CGRectMake(sayHeadImgView.frame.origin.x, sayHeadImgView.frame.origin.y+offset,
                                          sayHeadImgView.frame.size.width, sayHeadImgView.frame.size.height);
        infoBgView.frame  = CGRectMake(infoBgView.frame.origin.x, infoBgView.frame.origin.y+offset,
                                       infoBgView.frame.size.width, infoBgView.frame.size.height);
    }
}

- (void)timeOut
{
    curSecond--;
    if (curSecond==0)
    {
        secondLab.text  = @"正在等待和老师建立沟通...0";
        if (delegate)
        {
            if ([delegate respondsToSelector:@selector(timeOutView:)])
                [delegate timeOutView:self];
        }
        
        [timer invalidate];
        timer = nil;
    }
    else
    {
        secondLab.text  = [NSString stringWithFormat:@"正在等待和老师建立沟通...%d", curSecond];
    }
}

- (void) shareFriend:(id)sender
{
    [timer invalidate];
    timer = nil;
    CLog(@"shareFriendClicked:");
    if (delegate)
    {
        if ([delegate respondsToSelector:@selector(shareClicked:)])
            [delegate shareClicked:self];
    }
}
@end
