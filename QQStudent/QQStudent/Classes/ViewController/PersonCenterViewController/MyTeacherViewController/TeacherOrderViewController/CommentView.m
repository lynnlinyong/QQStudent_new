//
//  CommentView.m
//  QQStudent
//
//  Created by lynn on 14-2-14.
//  Copyright (c) 2014年 lynn. All rights reserved.
//

#import "CommentView.h"

@implementation CommentView
@synthesize contentView;
@synthesize orderId;
@synthesize parentView;
@synthesize idStr;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        
        contentView = [[UIImageView alloc]initWithFrame:frame];
        contentView.image = [UIImage imageNamed:@"mtp_commet_bg"];
        [self addSubview:contentView];
        
        CGRect rect = frame;
        UILabel *infoLab = [[UILabel alloc]init];
        infoLab.font = [UIFont systemFontOfSize:12.f];
        infoLab.backgroundColor = [UIColor clearColor];
        infoLab.text  = @"评价只有一次机会,慎重选哦!";
        infoLab.frame = CGRectMake(0, 5,rect.size.width, 20);
        infoLab.textAlignment = NSTextAlignmentCenter;
        [contentView addSubview:infoLab];
        [infoLab release];
        
        UIImage *goodImg  = [UIImage imageNamed:@"tdp_good_comment"];
        UIImageView *goodImgView = [[UIImageView alloc]initWithImage:goodImg];
        goodImgView.frame = CGRectMake(5, 3,
                                       goodImg.size.width,
                                       goodImg.size.height);
        
        UILabel *goodLab = [[UILabel alloc]init];
        goodLab.text  = @"赞";
        goodLab.font  = [UIFont systemFontOfSize:14.f];
        goodLab.backgroundColor = [UIColor clearColor];
        goodLab.frame = CGRectMake(31, 8, 14, 14);
        
        UIButton *goodBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        goodBtn.tag = 1;
        goodBtn.frame = CGRectMake(rect.size.width/2-60,
                                   rect.size.height-45, 50, 30);
        [goodBtn addTarget:self
                    action:@selector(doButtonClicked:)
          forControlEvents:UIControlEventTouchUpInside];
        
        [goodBtn addSubview:goodLab];
        [goodBtn addSubview:goodImgView];
        [self addSubview:goodBtn];
        [goodImgView release];
        [goodLab release];
        
        UIImage *badImg  = [UIImage imageNamed:@"tdp_bad_comment"];
        UIImageView *badImgView = [[UIImageView alloc]initWithImage:badImg];
        badImgView.frame = CGRectMake(5, 5,
                                      badImg.size.width,
                                      badImg.size.height);
        
        UILabel *badLab = [[UILabel alloc]init];
        badLab.text  = @"逊";
        badLab.font  = [UIFont systemFontOfSize:14.f];
        badLab.backgroundColor = [UIColor clearColor];
        badLab.frame = CGRectMake(50-5-14, 8, 14, 14);
        
        UIButton *badBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        badBtn.tag = 2;
        badBtn.frame = CGRectMake(rect.size.width/2+10, rect.size.height-45, 50, 30);
        [badBtn addTarget:self
                   action:@selector(doButtonClicked:)
         forControlEvents:UIControlEventTouchUpInside];
        [badBtn addSubview:badLab];
        [badBtn addSubview:badImgView];
        [self addSubview:badBtn];
        [badLab release];
        [badImgView release];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(doDismissNotice:)
                                                     name:@"CommentViewNoticeDismiss"
                                                   object:nil];
    }
    return self;
}

- (void) dealloc
{
    [contentView release];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}

#pragma mark -
#pragma mark - Custom Action
- (void) doDismissNotice:(NSNotification *) notice
{
    if (notice.userInfo)
    {
        NSString *idNums = (NSString *)[notice.userInfo objectForKey:@"TAG"];
        CLog(@"idStr:%@, self.idStr:%@", idNums, idStr);
        if (![idNums isEqualToString:self.idStr])
        {
            self.hidden = YES;
        }
    }
    else
    {
        self.hidden = YES;
    }
}

- (void) setMeHidden:(BOOL)h
{
    self.hidden = h;
    if (!h)  //显示通知其他控件,消失
    {
        NSDictionary *tagDic = [NSDictionary dictionaryWithObjectsAndKeys:self.idStr, @"TAG", nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"CommentViewNoticeDismiss"
                                                            object:self
                                                          userInfo:tagDic];
    }
}

- (void) doButtonClicked:(id)sender
{
    //发送评价消息
    NSDictionary *userDic = [NSDictionary dictionaryWithObjectsAndKeys:self.idStr,@"OrderID",
                                               [NSNumber numberWithInt:((UIButton *)sender).tag],@"Index", nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"commentOrderNotice"
                                                        object:self
                                                      userInfo:userDic];
}

@end
