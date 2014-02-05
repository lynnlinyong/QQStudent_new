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

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        headBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        headBtn.tag   = 0;
        headBtn.frame = CGRectMake(30, 20, 50, 50);
        [headBtn setImage:[UIImage imageNamed:@"star.png"]
                 forState:UIControlStateNormal];
        [headBtn addTarget:self
                    action:@selector(doButtonClicked:)
          forControlEvents:UIControlEventTouchUpInside];
        
        introduceLab  = [[UILabel alloc]init];
        introduceLab.backgroundColor = [UIColor clearColor];
        introduceLab.frame = CGRectMake(80, 20, 100, 20);
        
        starImageView = [[UIStartsImageView alloc]initWithFrame:CGRectMake(80, 40, 100, 20)];
        
        commBtn   = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        commBtn.tag = 1;
        [commBtn setTitle:@"沟通"
                 forState:UIControlStateNormal];
        [commBtn addTarget:self
                    action:@selector(doButtonClicked:)
          forControlEvents:UIControlEventTouchUpInside];
        commBtn.frame = CGRectMake(80, 55, 40, 30);
        
        compBtn   = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        compBtn.tag = 2;
        [compBtn setTitle:@"投诉"
                 forState:UIControlStateNormal];
        [compBtn addTarget:self
                    action:@selector(doButtonClicked:)
          forControlEvents:UIControlEventTouchUpInside];
        compBtn.frame = CGRectMake(130, 55, 40, 30);
        
        recommBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        recommBtn.tag = 3;
        [recommBtn setTitle:@"推荐给同学"
                   forState:UIControlStateNormal];
        [recommBtn addTarget:self
                      action:@selector(doButtonClicked:)
            forControlEvents:UIControlEventTouchUpInside];
        recommBtn.frame = CGRectMake(180, 55, 90, 30);
        
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
    introduceLab.text = [NSString stringWithFormat:@"%@ %@ %@", tObj.name,tObj.sex,tObj.pf];
    teacher = tObj;
}

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
@end
