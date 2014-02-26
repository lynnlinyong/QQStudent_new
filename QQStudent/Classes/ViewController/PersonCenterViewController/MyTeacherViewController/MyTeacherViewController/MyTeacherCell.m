//
//  MyTeacherCell.m
//  QQStudent
//
//  Created by lynn on 14-1-31.
//  Copyright (c) 2014年 lynn. All rights reserved.
//

#import "MyTeacherCell.h"
#import "TTImageView.h"
@implementation MyTeacherCell
@synthesize teacher;
@synthesize delegate;
@synthesize order;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"lt_list_bg"]];
        
        headBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        headBtn.frame =  CGRectMake(10, 15, 50, 50);
        [headBtn addTarget:self
                    action:@selector(tapGestureRecongnizerResponse:)
          forControlEvents:UIControlEventTouchUpInside];
        
        introduceLab  = [[UILabel alloc]init];
        introduceLab.font = [UIFont systemFontOfSize:14.f];
        introduceLab.backgroundColor = [UIColor clearColor];
        introduceLab.frame = CGRectMake(65, 5, 100, 20);
        
        starImageView = [[UIStartsImageView alloc]initWithFrame:CGRectMake(65, 27, 100, 20)];
        
        UIImage *chatImg = [UIImage imageNamed:@"mt_chat_normal_btn"];
        commBtn   = [UIButton buttonWithType:UIButtonTypeCustom];
        commBtn.tag = 1;
        [commBtn setImage:chatImg
                 forState:UIControlStateNormal];
        [commBtn addTarget:self
                    action:@selector(doButtonClicked:)
          forControlEvents:UIControlEventTouchUpInside];
        commBtn.frame = CGRectMake(65, 50, chatImg.size.width, chatImg.size.height);
        
        UIImage *cmpImg = [UIImage imageNamed:@"mt_confirm_normal_btn"];
        compBtn   = [UIButton buttonWithType:UIButtonTypeCustom];
        compBtn.tag = 2;
        [compBtn setImage:cmpImg
                 forState:UIControlStateNormal];
        [compBtn addTarget:self
                    action:@selector(doButtonClicked:)
          forControlEvents:UIControlEventTouchUpInside];
        compBtn.frame = CGRectMake(110, 50, cmpImg.size.width, cmpImg.size.height);
        
        UIImage *recmmImg = [UIImage imageNamed:@"mt_recomment_normal_btn"];
        recommBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        recommBtn.tag = 3;
        [recommBtn setImage:recmmImg
                   forState:UIControlStateNormal];
        [recommBtn addTarget:self
                      action:@selector(doButtonClicked:)
            forControlEvents:UIControlEventTouchUpInside];
        recommBtn.frame = CGRectMake(155, 50, recmmImg.size.width, recmmImg.size.height);
        
        [self addSubview:headBtn];
        [self addSubview:introduceLab];
        [self addSubview:starImageView];
        [self addSubview:commBtn];
        [self addSubview:compBtn];
        [self addSubview:recommBtn];
    }
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void) dealloc
{
    [starImageView release];
    [introduceLab  release];
    [super dealloc];
}

#pragma mark -
#pragma mark - Custom Action
- (void) setTeacher:(Teacher *)tObj
{
    if (tObj.sex == 1)
    {
        introduceLab.text = [NSString stringWithFormat:@"%@ 男 %@", tObj.name,tObj.pf];
    }
    else
    {
        introduceLab.text = [NSString stringWithFormat:@"%@ 女 %@", tObj.name,tObj.pf];
    }
    TTImageView *hImgView = [[[TTImageView alloc]init]autorelease];
    hImgView.delegate = self;
    hImgView.URL = tObj.headUrl;
    
    [starImageView setHlightStar:tObj.comment];
    
    teacher = nil;
    teacher = [tObj copy];
}

- (id) teacher
{
    return teacher;
}

#pragma mark -
#pragma mark - TTImageViewDelegate
- (void)imageView:(TTImageView*)imageView didLoadImage:(UIImage*)image
{
    [headBtn setImage:[UIImage circleImage:image withParam:0]
             forState:UIControlStateNormal];
}

- (void)imageView:(TTImageView*)imageView didFailLoadWithError:(NSError*)error
{
    
}

#pragma mark -
#pragma mark - Control Event
- (void) doButtonClicked:(id)sender
{
    UIButton *btn = sender;
    if (delegate)
    {
        if ([delegate respondsToSelector:@selector(tableViewCell:ClickedButton:)])
        {
            [delegate tableViewCell:self ClickedButton:btn.tag];
        }
    }
}

- (void) tapGestureRecongnizerResponse:(id) sender
{
    if (delegate)
    {
        if ([delegate respondsToSelector:@selector(tableViewCell:ClickedButton:)])
        {
            [delegate tableViewCell:self ClickedButton:0];
        }
    }
}
@end
