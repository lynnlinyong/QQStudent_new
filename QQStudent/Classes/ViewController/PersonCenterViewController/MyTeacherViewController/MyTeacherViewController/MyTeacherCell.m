//
//  MyTeacherCell.m
//  QQStudent
//
//  Created by lynn on 14-1-31.
//  Copyright (c) 2014年 lynn. All rights reserved.
//

#import "MyTeacherCell.h"

@implementation MyTeacherCell
@synthesize teacher;
@synthesize delegate;
@synthesize order;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        headImgView = [[TTImageView alloc]init];
        headImgView.frame = CGRectMake(10, 15, 50, 50);
        
        UITapGestureRecognizer *tapReg = [[UITapGestureRecognizer alloc]initWithTarget:self
                                                                                action:@selector(tapGestureRecongnizerResponse:)];
        [headImgView addGestureRecognizer:tapReg];
        [tapReg release];
        
        introduceLab  = [[UILabel alloc]init];
        introduceLab.backgroundColor = [UIColor clearColor];
        introduceLab.frame = CGRectMake(65, 5, 100, 20);
        
        starImageView = [[UIStartsImageView alloc]initWithFrame:CGRectMake(65, 25, 100, 20)];
        
        commBtn   = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        commBtn.tag = 1;
        [commBtn setTitle:@"沟通"
                 forState:UIControlStateNormal];
        [commBtn addTarget:self
                    action:@selector(doButtonClicked:)
          forControlEvents:UIControlEventTouchUpInside];
        commBtn.frame = CGRectMake(65, 50, 40, 20);
        
        compBtn   = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        compBtn.tag = 2;
        [compBtn setTitle:@"投诉"
                 forState:UIControlStateNormal];
        [compBtn addTarget:self
                    action:@selector(doButtonClicked:)
          forControlEvents:UIControlEventTouchUpInside];
        compBtn.frame = CGRectMake(110, 50, 40, 20);
        
        recommBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        recommBtn.tag = 3;
        [recommBtn setTitle:@"推荐给同学"
                   forState:UIControlStateNormal];
        [recommBtn addTarget:self
                      action:@selector(doButtonClicked:)
            forControlEvents:UIControlEventTouchUpInside];
        recommBtn.frame = CGRectMake(155, 50, 90, 20);
        
        [self addSubview:headImgView];
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
    [headImgView release];
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
    headImgView.URL = tObj.headUrl;
    
    teacher = nil;
    teacher = [tObj copy];
}

- (id) teacher
{
    return teacher;
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

- (void) tapGestureRecongnizerResponse:(NSNotification *) notice
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
