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
        flagImgView.frame  = CGRectMake(width/2-10, -50, 30, 60);
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
    [super dealloc];
}

- (void) setLeft:(BOOL)left money:(NSString *) money
{
    if (left)
    {
        leftImgView.hidden  = NO;
        rightImgView.hidden = YES;
        leftMoneyLab.text   = money;
    }
    else
    {
        leftImgView.hidden  = YES;
        rightImgView.hidden = NO;
        rightMoneyLab.text  = money;
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
    if (isSelect)
        return;
    
    if (delegate)
    {
        if ([delegate respondsToSelector:@selector(salaryView:tag:)])
        {
            [delegate salaryView:self tag:self.tag];
            
            if (self.isLeft)
            {
                leftImgView.frame = CGRectMake(leftImgView.frame.origin.x-50, -20,
                                               leftImgView.frame.size.width+50, leftImgView.frame.size.height+30);
                
                infoLeftLab = [[UILabel alloc]init];
                infoLeftLab.text = @"当前默认课酬";
                infoLeftLab.font = [UIFont systemFontOfSize:12.f];
                infoLeftLab.backgroundColor = [UIColor clearColor];
                infoLeftLab.textColor = [UIColor redColor];
                infoLeftLab.frame = CGRectMake(5, 5, leftImgView.frame.size.width, 20);
                [leftImgView addSubview:infoLeftLab];

                
                leftMoneyLab.frame = CGRectMake(5, 25, leftImgView.frame.size.width, 20);
                leftMoneyLab.font      = [UIFont systemFontOfSize:12.f];
                leftMoneyLab.textColor = [UIColor redColor];
                leftMoneyLab.textAlignment = NSTextAlignmentLeft;
            }
            else
            {
                rightImgView.frame = CGRectMake(rightImgView.frame.origin.x, -20,
                                                rightImgView.frame.size.width+50, rightImgView.frame.size.height+30);
                
                infoRightLab = [[UILabel alloc]init];
                infoRightLab.text = @"当前默认课酬";
                infoRightLab.font = [UIFont systemFontOfSize:12.f];
                infoRightLab.backgroundColor = [UIColor clearColor];
                infoRightLab.textColor = [UIColor redColor];
                infoRightLab.frame = CGRectMake(15, 5, rightImgView.frame.size.width, 20);
                [rightImgView addSubview:infoRightLab];
                
                rightMoneyLab.frame = CGRectMake(15, 25, rightImgView.frame.size.width, 20);
                rightMoneyLab.font      = [UIFont systemFontOfSize:12.f];
                rightMoneyLab.textColor = [UIColor redColor];
                rightMoneyLab.textAlignment = NSTextAlignmentLeft;
            }
        }
    }
}

- (void) repickView
{
    if (self.isLeft)
    {
        leftImgView.frame  = orginLeftRect;
     
        [infoLeftLab removeFromSuperview];
        leftMoneyLab.frame = CGRectMake(0, 0, leftImgView.frame.size.width, leftImgView.frame.size.height);
        leftMoneyLab.font = [UIFont systemFontOfSize:12.f];
        leftMoneyLab.textColor = [UIColor blackColor];
        leftMoneyLab.textAlignment = NSTextAlignmentCenter;
    }
    else
    {
        rightImgView.frame  = orginRightRect;
        
        [infoRightLab removeFromSuperview];
        rightMoneyLab.frame = CGRectMake(0, 0, rightImgView.frame.size.width, rightImgView.frame.size.height);
        rightMoneyLab.font = [UIFont systemFontOfSize:12.f];
        rightMoneyLab.textColor = [UIColor blackColor];
        rightMoneyLab.textAlignment = NSTextAlignmentCenter;
    }
}
@end
