//
//  NoticePopView.m
//  QQStudent
//
//  Created by lynn on 14-2-28.
//  Copyright (c) 2014年 lynn. All rights reserved.
//

#import "NoticePopView.h"

static NoticePopView *popInstance = nil;
@implementation NoticePopView
@synthesize titleLab;
@synthesize contentLab;
@synthesize contentDic;
@synthesize noticeType;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        bgView = [[LBorderView alloc]initWithFrame:CGRectMake(0,0,frame.size.width, 0)];
        bgView.borderType   = BorderTypeSolid;
        bgView.dashPattern  = 8;
        bgView.spacePattern = 8;
        bgView.borderWidth  = 1;
        bgView.cornerRadius = 5;
        bgView.alpha = 0.7;
        bgView.borderColor  = [UIColor whiteColor];
        bgView.backgroundColor = [UIColor colorWithHexString:@"#AED4C9"];
        [self addSubview:bgView];
        
        self.frame = frame;
        
        titleLab = [[UILabel alloc]init];
        titleLab.frame = CGRectMake(0, 10, frame.size.width, 20);
        titleLab.text  = @"";
        titleLab.textColor = [UIColor whiteColor];
        titleLab.textAlignment   = NSTextAlignmentCenter;
        titleLab.backgroundColor = [UIColor clearColor];
        [bgView addSubview:titleLab];
        
        contentLab = [[UILabel alloc]init];
        contentLab.frame = CGRectMake(0, 30, frame.size.width, 40);
        contentLab.text  = @"";
        contentLab.textColor = [UIColor whiteColor];
        contentLab.font  = [UIFont systemFontOfSize:14.f];
        contentLab.textAlignment   = NSTextAlignmentCenter;
        contentLab.backgroundColor = [UIColor clearColor];
        contentLab.numberOfLines   = 0;
        contentLab.lineBreakMode   = NSLineBreakByWordWrapping;
        [bgView addSubview:contentLab];
        
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:bgView];
        
        UITapGestureRecognizer *reg = [[UITapGestureRecognizer alloc]initWithTarget:self
                                                                             action:@selector(tapGestureReg:)];
        [bgView addGestureRecognizer:reg];
        [reg release];
    }
    return self;
}

- (void) dealloc
{
    [titleLab   release];
    [contentLab release];
    [super dealloc];
}

- (void) popView
{
    self.hidden = NO;
    CustomNavigationViewController *nav = (CustomNavigationViewController *) [MainViewController getNavigationViewController];
    [nav.view addSubview:self];
    
    [UIView animateWithDuration:1 animations:^{
        bgView.frame = CGRectMake(0,
                                  0, bgView.frame.size.width, 80);
    }];
}

- (void) dismiss
{
    self.hidden = YES;
}

+(id)shareInstance
{
    if(popInstance == nil)
    {
        @synchronized(self)
        {
            if(popInstance==nil)
            {
                popInstance=[[[self class] alloc] init];
                
                [popInstance initWithFrame:CGRectMake(70, 30, 180, 80)];
            }
        }
    }
    return popInstance;
}

+ (id) allocWithZone:(NSZone *)zone;
{
    if(popInstance==nil)
    {
        popInstance = [super allocWithZone:zone];
    }
    return popInstance;
}

-(id)copyWithZone:(NSZone *)zone
{
    return popInstance;
}

-(id)retain
{
    return popInstance;
}

- (oneway void)release
{
}

- (id)autorelease
{
    return popInstance;
}

- (NSUInteger)retainCount
{
    return UINT_MAX;
}

- (void) tapGestureReg:(UIGestureRecognizer *) reg
{
    [self dismiss];
    
    switch (noticeType)
    {
        case NOTICE_AD:    //广告
        {
            //跳转网页浏览
            NSString *url = [contentDic objectForKey:@"url"];
            CustomNavigationViewController *nav = [MainViewController getNavigationViewController];
            FreeBookViewController *fbVctr = [[FreeBookViewController alloc]init];
            fbVctr.adURL = url;
            [nav pushViewController:fbVctr animated:YES];
            [fbVctr release];
            break;
        }
        case NOTICE_GG:    //公告
        {
            //显示即可
            break;
        }
        case NOTICE_MSG:   //消息
        {
            //跳转到聊天窗口
            Teacher *tObj = [Teacher setTeacherProperty:contentDic];
            ChatViewController *cVctr = [[ChatViewController alloc]init];
            cVctr.tObj = tObj;
            CustomNavigationViewController *nav = [MainViewController getNavigationViewController];
            [nav pushViewController:cVctr animated:YES];
            [cVctr release];
            break;
        }
        default:
            break;
    }
}
@end
