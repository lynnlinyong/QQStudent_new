//
//  TeacherOrderCell.m
//  QQStudent
//
//  Created by lynn on 14-2-12.
//  Copyright (c) 2014年 lynn. All rights reserved.
//

#import "TeacherOrderCell.h"

@implementation TeacherOrderCell
@synthesize order;
@synthesize delegate;
@synthesize commentBtn;
@synthesize commView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        studyPosLab = [[UILabel alloc]init];
        studyPosLab.font  = [UIFont systemFontOfSize:12.f];
        studyPosLab.frame = CGRectMake(10, 5, 200, 20);
        studyPosLab.backgroundColor = [UIColor clearColor];
        [self addSubview:studyPosLab];
        
        orderInfoLab = [[UILabel alloc]init];
        orderInfoLab.font  = [UIFont systemFontOfSize:12.f];
        orderInfoLab.frame = CGRectMake(10, 25, 200, 20);
        orderInfoLab.backgroundColor = [UIColor clearColor];
        [self addSubview:orderInfoLab];
        
        orderDateLab = [[UILabel alloc]init];
        orderDateLab.font  = [UIFont systemFontOfSize:12.f];
        orderDateLab.frame = CGRectMake(210, 5, 100, 20);
        orderDateLab.backgroundColor = [UIColor clearColor];
        [self addSubview:orderDateLab];
        
        noConfirmLab = [[UILabel alloc]init];
        noConfirmLab.font  = [UIFont systemFontOfSize:12.f];
        noConfirmLab.frame = CGRectMake(210, 25, 100, 20);
        noConfirmLab.backgroundColor = [UIColor clearColor];
        [self addSubview:noConfirmLab];
        
        finishLab = [[UILabel alloc]init];
        finishLab.textAlignment = NSTextAlignmentCenter;
        finishLab.font  = [UIFont systemFontOfSize:12.f];
        finishLab.frame = CGRectMake(210, 25, 100, 20);
        finishLab.backgroundColor = [UIColor clearColor];
        [self addSubview:finishLab];
        
        freeBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        freeBtn.tag = 2;
        freeBtn.frame = CGRectMake(10, 50, 80, 20);
        [freeBtn setTitle:@"免费教辅"
                    forState:UIControlStateNormal];
        [freeBtn addTarget:self
                       action:@selector(doButtonClicked:)
             forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:freeBtn];
        
        commentBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        commentBtn.tag   = 0;
        commentBtn.frame = CGRectMake(100, 50, 40, 20);
        [commentBtn setTitle:@"评价"
                    forState:UIControlStateNormal];
        [commentBtn addTarget:self
                       action:@selector(doButtonClicked:)
             forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:commentBtn];
        
        updateBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        updateBtn.tag   = 1;
        updateBtn.frame = CGRectMake(150, 50, 80, 20);
        [updateBtn setTitle:@"修改订单"
                   forState:UIControlStateNormal];
        [updateBtn addTarget:self
                      action:@selector(doButtonClicked:)
            forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:updateBtn];
        
        finishBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        finishBtn.tag   = 3;
        finishBtn.frame = CGRectMake(240, 50, 80, 20);
        [finishBtn setTitle:@"结单审批"
                   forState:UIControlStateNormal];
        [finishBtn addTarget:self
                      action:@selector(doButtonClicked:)
            forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:finishBtn];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(getTouchEvent:)
                                                     name:@"TouchEvent"
                                                   object:nil];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [studyPosLab release];
    [super dealloc];
}

- (void) getTouchEvent:(NSNotification *) notice
{
    commView.hidden = YES;
}

- (void) setOrder:(Order *)orderObj
{
    order = nil;
    order = [orderObj copy];
    
    //显示内容
    studyPosLab.text  = self.order.orderStudyPos;
    orderDateLab.text = self.order.orderAddTimes;
    orderInfoLab.text = [NSString stringWithFormat:@"￥%@/小时  %@小时", self.order.everyTimesMoney, self.order.orderStudyTimes];
    switch (order.orderStatus)
    {
        case NO_EMPLOY:         //未聘用
        {
            //不显示订单
            break;
        }
        case NO_CONFIRM:         //未确认
        {
            //评价老师,修改订单按钮显示
            finishLab.text = @"未确认";
            
            freeBtn.hidden    = YES;
            commentBtn.hidden = NO;
            updateBtn.hidden  = NO;
            finishBtn.hidden  = YES;
            break;
        }
        case CONFIRMED:         //已确认
        {
            finishLab.text = @"已确认";
            
            freeBtn.hidden    = NO;
            commentBtn.hidden = NO;
            updateBtn.hidden  = NO;
            finishBtn.hidden  = YES;
            break;
        }
        case NO_FINISH:         //未结单
        {
            finishLab.text = @"未结单";
            
            //显示评价老师,结单审批按钮
            freeBtn.hidden    = YES;
            commentBtn.hidden = NO;
            updateBtn.hidden  = YES;
            finishBtn.hidden  = NO;
            break;
        }
        case FINISH:           //已结单
        {
            finishLab.text    = @"已结单";
            
            freeBtn.hidden    = YES;
            commentBtn.hidden = YES;
            updateBtn.hidden  = YES;
            break;
        }
        default:
            break;
    }
}

#pragma mark -
#pragma mark - Custom Action
- (void) doButtonClicked:(id)sender
{
    UIButton *btn = sender;
    if (delegate)
    {
        if ([delegate respondsToSelector:@selector(cell:buttonTag:)])
        {
            [delegate cell:self buttonTag:btn.tag];
        }
    }
}
@end
