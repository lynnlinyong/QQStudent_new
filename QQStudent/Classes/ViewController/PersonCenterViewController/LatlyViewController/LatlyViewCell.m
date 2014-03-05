//
//  LatlyViewCell.m
//  QQStudent
//
//  Created by lynn on 14-3-1.
//  Copyright (c) 2014年 lynn. All rights reserved.
//

#import "LatlyViewCell.h"

@implementation LatlyViewCell
@synthesize msgDic;
@synthesize delegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        headBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        headBtn.frame     =  CGRectMake(5, 15, 50, 50);
        [headBtn addTarget:self
                    action:@selector(tapGestureRecongnizer:)
          forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:headBtn];
        
        UIImage *idImg = [UIImage imageNamed:@"mp_rz"];
        idImageView = [[UIImageView alloc]init];
        idImageView.hidden = YES;
        idImageView.image  = idImg;
        idImageView.frame  = CGRectMake(headBtn.frame.size.width-idImg.size.width-5,
                                        headBtn.frame.size.height/2-5,
                                        idImg.size.width+10, idImg.size.height+10);
        [headBtn addSubview:idImageView];
        
        nameLab = [[UILabel alloc]init];
        nameLab.font  = [UIFont systemFontOfSize:12.f];
        nameLab.backgroundColor = [UIColor clearColor];
        nameLab.frame = CGRectMake(70, 10, 60, 20);
        [self addSubview:nameLab];
        
        infoLab = [[UILabel alloc]init];
        infoLab.font  = [UIFont systemFontOfSize:12.f];
        infoLab.backgroundColor = [UIColor clearColor];
        infoLab.frame = CGRectMake(70, 30, 60, 20);
        [self addSubview:infoLab];
        
        msgLab = [[UILabel alloc]init];
        msgLab.font  = [UIFont systemFontOfSize:12.f];
        msgLab.backgroundColor = [UIColor clearColor];
        msgLab.frame = CGRectMake(70, 50, 60, 20);
        [self addSubview:msgLab];
        
        timeLab = [[UILabel alloc]init];
        timeLab.textAlignment = NSTextAlignmentRight;
        timeLab.font  = [UIFont systemFontOfSize:12.f];
        timeLab.backgroundColor = [UIColor clearColor];
        timeLab.frame = CGRectMake(320-60-10, 30, 60, 20);
        [self addSubview:timeLab];
    }
    return self;
}

- (void) dealloc
{
    [nameLab release];
    [infoLab release];
    [msgLab release];
    [timeLab release];
    [idImageView release];
    [super dealloc];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void) setMsgDic:(NSDictionary *)dic
{    
    int num = ((NSNumber *)[dic objectForKey:@"allNumber"]).intValue;
    if (num!=0)
    {
        NoticeNumberView *numView = [[NoticeNumberView alloc]initWithFrame:CGRectMake(headBtn.frame.size.width-3, 5, 40, 40)];
        [numView setTitle:[NSString stringWithFormat:@"%d", num]];
        [headBtn addSubview:numView];
        [numView release];
    }
    
    nameLab.text  = [dic objectForKey:@"nickname"];

    int sex = ((NSNumber *)[dic objectForKey:@"gender"]).intValue;
    if (sex == 1)
    {
        [headBtn setImage:[UIImage circleImage:[UIImage imageNamed:@"s_boy"]
                                     withParam:0 withColor:[UIColor whiteColor]]
                 forState:UIControlStateNormal];
        infoLab.text  = [NSString stringWithFormat:@"男   %@",[dic objectForKey:@"subjectText"]];
    }
    else
    {
        [headBtn setImage:[UIImage circleImage:[UIImage imageNamed:@"s_girl"]
                                     withParam:0 withColor:[UIColor whiteColor]]
                 forState:UIControlStateNormal];
        infoLab.text  = [NSString stringWithFormat:@"女   %@",[dic objectForKey:@"subjectText"]];
    }
    msgLab.text   = [dic objectForKey:@"message"];
    timeLab.text  = [dic objectForKey:@"time"];
    
    NSString *isId= [[dic objectForKey:@"type_stars"] copy];
    if (isId)
    {
        if (isId.intValue == 1)
            idImageView.hidden = NO;
        else
            idImageView.hidden = YES;
    }
    
    TTImageView *headImgView = [[[TTImageView alloc]init]autorelease];
    headImgView.delegate = self;
    NSString *webAdd  = [[NSUserDefaults standardUserDefaults] objectForKey:WEBADDRESS];
    headImgView.URL   = [NSString stringWithFormat:@"%@%@",webAdd,[dic objectForKey:@"icon"]];
}

#pragma mark -
#pragma mark - TTImageViewDelegate
- (void)imageView:(TTImageView*)imageView didLoadImage:(UIImage*)image
{
    int sex = ((NSString *)[msgDic objectForKey:@"gender"]).intValue;
    if (sex == 1)
    {
        [headBtn setImage:[UIImage circleImage:image
                                     withParam:0
                                     withColor:[UIColor greenColor]]
                 forState:UIControlStateNormal];
    }
    else
    {
        [headBtn setImage:[UIImage circleImage:image
                                     withParam:0
                                     withColor:[UIColor orangeColor]]
                 forState:UIControlStateNormal];
    }
}

- (void)imageView:(TTImageView*)imageView didFailLoadWithError:(NSError*)error
{
    
}

- (void) tapGestureRecongnizer:(id)sender
{
    UIButton *btn = sender;
    if (delegate)
    {
        if ([delegate respondsToSelector:@selector(view:clickedIndex:)])
        {
            [delegate view:self clickedIndex:btn.tag];
        }
    }
}
@end
