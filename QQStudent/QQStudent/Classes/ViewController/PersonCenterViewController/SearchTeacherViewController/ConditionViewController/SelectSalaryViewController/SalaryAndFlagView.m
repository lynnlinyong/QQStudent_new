//
//  SalaryAndFlagView.m
//  QQStudent
//
//  Created by lynn on 14-2-20.
//  Copyright (c) 2014年 lynn. All rights reserved.
//

#import "SalaryAndFlagView.h"

@implementation SalaryAndFlagView
@synthesize leftMoneyLab;
@synthesize isLeft;
@synthesize isSelect;
@synthesize rightMoneyLab;
@synthesize delegate;
@synthesize orginRightRect;
@synthesize orginLeftRect;
@synthesize leftImgView;
@synthesize rightImgView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        float width  = frame.size.width;
        float height = frame.size.height;
        
        leftImgView  = [[UIImageView alloc]init];
        leftImgView.image  = [UIImage imageNamed:@"left_lab.png"];
        leftImgView.frame  = CGRectMake(0, 0, width/2-10, height);
        orginLeftRect = leftImgView.frame;
        
        rightImgView = [[UIImageView alloc]init];
        rightImgView.image = [UIImage imageNamed:@"right_lab.png"];
        rightImgView.frame = CGRectMake(width/2+10, 0, width/2-10, height);
        orginRightRect = rightImgView.frame;
        
        potImgView   = [[UIImageView alloc]init];
        potImgView.image = [UIImage imageNamed:@"pot.png"];
        potImgView.frame = CGRectMake(width/2-10, 0, 20, height);
        
        flagImgView = [[UIImageView alloc]init];
        flagImgView.image  = [UIImage imageNamed:@"flag.png"];
        flagImgView.frame  = CGRectMake(width/2-10, -50, 30, 80);
        flagImgView.hidden = YES;
        
        leftMoneyLab = [[UILabel alloc]init];
        leftMoneyLab.textAlignment   = NSTextAlignmentCenter;
        leftMoneyLab.backgroundColor = [UIColor clearColor];
        leftMoneyLab.font  = [UIFont systemFontOfSize:12.f];
        leftMoneyLab.frame = CGRectMake(0, 0, leftImgView.frame.size.width, leftImgView.frame.size.height);
        [leftImgView addSubview:leftMoneyLab];
        
        rightMoneyLab = [[UILabel alloc]init];
        rightMoneyLab.textAlignment   = NSTextAlignmentCenter;
        rightMoneyLab.backgroundColor = [UIColor clearColor];
        rightMoneyLab.font  = [UIFont systemFontOfSize:12.f];
        rightMoneyLab.frame = CGRectMake(4, 0, rightImgView.frame.size.width, rightImgView.frame.size.height);
        [rightImgView addSubview:rightMoneyLab];
        
        leftBgLab = [[UILabel alloc]init];
        leftBgLab.backgroundColor = [UIColor clearColor];
        leftBgLab.frame = CGRectMake(3, 25, leftImgView.frame.size.width, 20);
        leftBgLab.font      = [UIFont systemFontOfSize:12.f];
        leftBgLab.textColor = [UIColor redColor];
        leftBgLab.textAlignment = NSTextAlignmentLeft;
        
        leftBgImgView = [[UIImageView alloc]init];
        leftBgImgView.hidden = YES;
        leftBgImgView.frame = CGRectMake(leftImgView.frame.origin.x-50, -20,
                                       leftImgView.frame.size.width+50, leftImgView.frame.size.height+30);
        leftBgImgView.image = [UIImage imageNamed:@"money_left"];
        UILabel *leftInfoLab = [[UILabel alloc]init];
        leftInfoLab.text = @"当前默认课酬";
        leftInfoLab.font = [UIFont systemFontOfSize:12.f];
        leftInfoLab.backgroundColor = [UIColor clearColor];
        leftInfoLab.textColor = [UIColor redColor];
        leftInfoLab.frame = CGRectMake(5, 5, leftBgImgView.frame.size.width, 20);
        [leftBgImgView addSubview:leftInfoLab];
        [leftBgImgView addSubview:leftBgLab];
        [self addSubview:leftBgImgView];
        
        rightBgImgView = [[UIImageView alloc]init];
        rightBgImgView.hidden = YES;
        rightBgImgView.frame = CGRectMake(rightImgView.frame.origin.x, -20,
                                          rightImgView.frame.size.width+50, rightImgView.frame.size.height+30);
        rightBgImgView.image = [UIImage imageNamed:@"money_right"];
        UILabel *rightInfoLab = [[UILabel alloc]init];
        rightInfoLab.text = @"当前默认课酬";
        rightInfoLab.font = [UIFont systemFontOfSize:12.f];
        rightInfoLab.backgroundColor = [UIColor clearColor];
        rightInfoLab.textColor = [UIColor redColor];
        rightInfoLab.textAlignment = NSTextAlignmentLeft;
        rightInfoLab.frame = CGRectMake(10, 5, rightImgView.frame.size.width+50, 20);
        [rightBgImgView addSubview:rightInfoLab];
        
        rightBgLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 25, rightImgView.frame.size.width, 20)];
        rightBgLab.font      = [UIFont systemFontOfSize:12.f];
        rightBgLab.textColor = [UIColor redColor];
        rightBgLab.backgroundColor = [UIColor clearColor];
        rightBgLab.textAlignment = NSTextAlignmentLeft;
        [rightBgImgView addSubview:rightBgLab];
        [self addSubview:rightBgImgView];
        
        [self addSubview:leftImgView];
        [self addSubview:rightImgView];
        [self addSubview:potImgView];
        [self addSubview:flagImgView];
    }
    return self;
}

- (void) dealloc
{
    [leftImgView   release];
    [rightImgView  release];
    [potImgView    release];
    
    [leftMoneyLab  release];
    [rightMoneyLab release];
    
    [infoLeftLab  release];
    [infoRightLab release];
    
    [rightBgLab release];
    [leftBgLab release];
    [rightBgImgView release];
    [leftBgImgView release];
    [super dealloc];
}

- (void) setLeft:(BOOL)left money:(NSString *) money
{
    if (left)
    {
        leftImgView.hidden    = NO;
        rightImgView.hidden   = YES;
        leftMoneyLab.text     = money;
        leftBgLab.text = [NSString stringWithFormat:@"￥%@",money];
    }
    else
    {
        leftImgView.hidden  = YES;
        rightImgView.hidden = NO;
        rightMoneyLab.text  = money;
        rightBgLab.text     = [NSString stringWithFormat:@"￥%@", money];
    }
    
    isLeft = left;
}

- (void) setIsSelect:(BOOL)select
{
    if (select)
    {
        flagImgView.hidden = NO;
        potImgView.hidden  = YES;
    }
    else
    {
        flagImgView.hidden = YES;
        potImgView.hidden  = NO;
    }
    
    isSelect = select;
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{    
    if (delegate)
    {
        if ([delegate respondsToSelector:@selector(salaryView:tag:)])
        {
            [delegate salaryView:self tag:self.tag];
            if (self.isLeft)
            {
                leftImgView.hidden = YES;
                
                leftBgImgView.hidden  = NO;
                rightBgImgView.hidden = YES;
            }
            else
            {
                rightImgView.hidden = YES;
                
                leftBgImgView.hidden  = YES;
                rightBgImgView.hidden = NO;
            }
        }
    }
}

- (void) repickView
{
    if (self.isLeft)
    {
        leftImgView.hidden = NO;
        leftBgImgView.hidden = YES;
    }
    else
    {
        rightImgView.hidden = NO;
        rightBgImgView.hidden = YES;
    }
}
@end
