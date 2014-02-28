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
        studyPosLab.textColor       = [UIColor whiteColor];
        studyPosLab.font  = [UIFont systemFontOfSize:12.f];
        studyPosLab.frame = CGRectMake(10, 5, 200, 20);
        studyPosLab.numberOfLines   = 0;
        studyPosLab.backgroundColor = [UIColor clearColor];
        [self addSubview:studyPosLab];
        
        orderInfoLab = [[UILabel alloc]init];
        orderInfoLab.textColor       = [UIColor whiteColor];
        orderInfoLab.font  = [UIFont systemFontOfSize:12.f];
        orderInfoLab.frame = CGRectMake(10, 25, 200, 20);
        orderInfoLab.backgroundColor = [UIColor clearColor];
        [self addSubview:orderInfoLab];
        
        orderDateLab = [[UILabel alloc]init];
        orderDateLab.font  = [UIFont systemFontOfSize:12.f];
        orderDateLab.frame = CGRectMake(210, 5, 100, 20);
        orderDateLab.textColor       = [UIColor whiteColor];
        orderDateLab.textAlignment   = NSTextAlignmentCenter;
        orderDateLab.backgroundColor = [UIColor clearColor];
        [self addSubview:orderDateLab];
        
        noConfirmLab = [[UILabel alloc]init];
        noConfirmLab.font  = [UIFont systemFontOfSize:12.f];
        noConfirmLab.frame = CGRectMake(210, 25, 100, 20);
        noConfirmLab.textColor       = [UIColor whiteColor];
        noConfirmLab.backgroundColor = [UIColor clearColor];
        [self addSubview:noConfirmLab];
        
        finishLab = [[UILabel alloc]init];
        finishLab.textColor       = [UIColor whiteColor];
        finishLab.textAlignment = NSTextAlignmentCenter;
        finishLab.font  = [UIFont systemFontOfSize:12.f];
        finishLab.frame = CGRectMake(210, 25, 100, 20);
        finishLab.backgroundColor = [UIColor clearColor];
        [self addSubview:finishLab];
        
        UIImage *freeImg = [UIImage imageNamed:@"mt_fbook_normal_btn"];
        UILabel *freeLab = [[UILabel alloc]init];
        freeLab.text = @"免费教辅";
        freeLab.backgroundColor = [UIColor clearColor];
        freeLab.font = [UIFont systemFontOfSize:10.f];
        freeLab.textColor = [UIColor colorWithHexString:@"ff6600"];
        freeLab.frame = CGRectMake(0, freeImg.size.height,
                                     freeImg.size.width,
                                     10);
        freeLab.textAlignment = NSTextAlignmentCenter;
        freeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        freeBtn.tag = 0;
        freeBtn.frame = CGRectMake(10, 50,
                                   freeImg.size.width,
                                   freeImg.size.height);
        [freeBtn setImage:freeImg
                    forState:UIControlStateNormal];
        [freeBtn addTarget:self
                       action:@selector(doButtonClicked:)
             forControlEvents:UIControlEventTouchUpInside];
        [freeBtn addSubview:freeLab];
        [self addSubview:freeBtn];
        
        
        UIImage *cmmImg = [UIImage imageNamed:@"mt_comment_normal_btn"];
        UILabel *cmmLab = [[UILabel alloc]init];
        cmmLab.text = @"评价老师";
        cmmLab.backgroundColor = [UIColor clearColor];
        cmmLab.font = [UIFont systemFontOfSize:10.f];
        cmmLab.textColor = [UIColor colorWithHexString:@"ff6600"];
        cmmLab.frame = CGRectMake(0, cmmImg.size.height,
                                  cmmImg.size.width,
                                  10);
        cmmLab.textAlignment = NSTextAlignmentCenter;
        
        commentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        commentBtn.tag   = 1;
        commentBtn.frame = CGRectMake(10+cmmImg.size.width, 50, cmmImg.size.width, cmmImg.size.height);
        [commentBtn setImage:cmmImg forState:UIControlStateNormal];
        [commentBtn addTarget:self
                       action:@selector(doButtonClicked:)
             forControlEvents:UIControlEventTouchUpInside];
        [commentBtn addSubview:cmmLab];
        [self addSubview:commentBtn];
        
        UIImage *updateImg = [UIImage imageNamed:@"mt_update_normal_btn"];
        UILabel *updateLab = [[UILabel alloc]init];
        updateLab.text = @"修改订单";
        updateLab.backgroundColor = [UIColor clearColor];
        updateLab.font = [UIFont systemFontOfSize:10.f];
        updateLab.textColor = [UIColor colorWithHexString:@"ff6600"];
        updateLab.frame = CGRectMake(0, updateImg.size.height,
                                  updateImg.size.width,
                                  10);
        updateLab.textAlignment = NSTextAlignmentCenter;
        
        updateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        updateBtn.tag   = 2;
        updateBtn.frame = CGRectMake(10+2*cmmImg.size.width, 50, updateImg.size.width, updateImg.size.height);
        [updateBtn setImage:updateImg
                   forState:UIControlStateNormal];
        [updateBtn addTarget:self
                      action:@selector(doButtonClicked:)
            forControlEvents:UIControlEventTouchUpInside];
        [updateBtn addSubview:updateLab];
        [self addSubview:updateBtn];
        
        UIImage *finishImg = [UIImage imageNamed:@"mt_finish_nomal_btn"];
        UILabel *finishInfoLab = [[UILabel alloc]init];
        finishInfoLab.text = @"订单审批";
        finishInfoLab.backgroundColor = [UIColor clearColor];
        finishInfoLab.font = [UIFont systemFontOfSize:10.f];
        finishInfoLab.textColor = [UIColor colorWithHexString:@"ff6600"];
        finishInfoLab.frame = CGRectMake(0, finishImg.size.height,
                                     finishImg.size.width,
                                     10);
        finishInfoLab.textAlignment = NSTextAlignmentCenter;
        
        finishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        finishBtn.tag   = 3;
        finishBtn.frame = CGRectMake(10+3*cmmImg.size.width, 50,
                                     finishImg.size.width,
                                     finishImg.size.height);
        [finishBtn setImage:finishImg
                   forState:UIControlStateNormal];
        [finishBtn addTarget:self
                      action:@selector(doButtonClicked:)
            forControlEvents:UIControlEventTouchUpInside];
        [finishBtn addSubview:finishInfoLab];
        [self addSubview:finishBtn];
        
        UIView *bgView = [[UIView alloc]init];
        bgView.backgroundColor = [UIColor colorWithHexString:@"#686868"];
        self.backgroundView  = bgView;
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(getTouchEvent:)
                                                     name:@"TouchEvent"
                                                   object:nil];
        
        buttonArray = [NSArray arrayWithObjects:freeBtn,commentBtn,updateBtn,finishBtn, nil];
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

- (void) setStudyPos:(NSString *) pos
{
    CGSize size = [pos sizeWithFont:studyPosLab.font constrainedToSize:CGSizeMake(studyPosLab.frame.size.width, MAXFLOAT)
                      lineBreakMode:NSLineBreakByWordWrapping];
    
    int offset = size.height - studyPosLab.frame.size.height;
    
    //根据计算结果重新设置UILabel的尺寸
    [studyPosLab setFrame:CGRectMake(studyPosLab.frame.origin.x,
                                     studyPosLab.frame.origin.y,
                                     studyPosLab.frame.size.width,
                                     size.height)];
    studyPosLab.text = pos;
    
    //其他控件根据上面位置进行调整
    orderInfoLab.frame = CGRectMake(orderInfoLab.frame.origin.x,
                                    orderInfoLab.frame.origin.y+offset,
                                    orderInfoLab.frame.size.width,
                                    orderInfoLab.frame.size.height);
    
    finishLab.frame = CGRectMake(finishLab.frame.origin.x,
                                 finishLab.frame.origin.y+offset,
                                 finishLab.frame.size.width,
                                 finishLab.frame.size.height);
    
    commentBtn.frame = CGRectMake(commentBtn.frame.origin.x,
                                  commentBtn.frame.origin.y+offset,
                                  commentBtn.frame.size.width,
                                  commentBtn.frame.size.height);
    
    updateBtn.frame  = CGRectMake(updateBtn.frame.origin.x,
                                  updateBtn.frame.origin.y+offset,
                                  updateBtn.frame.size.width,
                                  updateBtn.frame.size.height);
    
    freeBtn.frame    = CGRectMake(freeBtn.frame.origin.x,
                               freeBtn.frame.origin.y+offset,
                               freeBtn.frame.size.width,
                               freeBtn.frame.size.height);
    
    finishBtn.frame  = CGRectMake(finishBtn.frame.origin.x,
                                 finishBtn.frame.origin.y+offset,
                                 finishBtn.frame.size.width,
                                 finishBtn.frame.size.height);
}

- (void) setAutoPosForButton
{
    //自动缩进按钮
    UIImage *btnImg = [UIImage imageNamed:@"mt_finish_nomal_btn"];
    if (buttonArray)
    {
        for (int i=0; i<buttonArray.count; i++)
        {
            UIButton *btn = [buttonArray objectAtIndex:i];
            if (btn.hidden)
            {
                CLog(@"btn:%d", i);
                for (int j=i+1; j<buttonArray.count; j++)
                {
                    UIButton *nextBtn = [buttonArray objectAtIndex:j];
                    if (!nextBtn.hidden)
                    {
                        //移动
                        nextBtn.frame = CGRectMake(nextBtn.frame.origin.x-btnImg.size.width, nextBtn.frame.origin.y, nextBtn.frame.size.width, nextBtn.frame.size.height);
                    }
                }
            }
        }
    }
}

- (void) setOrder:(Order *)orderObj
{
    order = nil;
    order = [orderObj copy];
    
    //显示内容
    [self setStudyPos:self.order.orderStudyPos];
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
    
    //自动缩进按钮
    [self setAutoPosForButton];
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
