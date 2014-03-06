//
//  SelectSalaryViewController.m
//  QQStudent
//
//  Created by lynn on 14-2-5.
//  Copyright (c) 2014年 lynn. All rights reserved.
//

#import "SelectSalaryViewController.h"

@interface SelectSalaryViewController ()

@end

@implementation SelectSalaryViewController
@synthesize money;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //初始化UI
    [self initUI];
    
    //获得课酬列表
    [Student getSalarys];
    
    [self setSalayView];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [MainViewController setNavTitle:@"选择小时课酬"];
}

- (void) viewDidDisappear:(BOOL)animated
{
    NSDictionary *salaryDic = [potMoney objectAtIndex:selIndex];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"setSalaryNotice"
                                                        object:self
                                                      userInfo:salaryDic];
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark - Custom Action
- (void) initUI
{
    UILabel *infoLab = [[UILabel alloc]init];
    infoLab.font = [UIFont systemFontOfSize:12.f];
    infoLab.text = @"  注意:课酬标准中已包含教师交通费";
    infoLab.textColor = [UIColor whiteColor];
    infoLab.backgroundColor = [UIColor colorWithHexString:@"#009f66"];
    infoLab.frame = [UIView fitCGRect:CGRectMake(0, 3, 320, 30)
                           isBackView:NO];
    [self.view addSubview:infoLab];
    [infoLab release];
    
    NSArray *potArr   = [[NSUserDefaults standardUserDefaults] objectForKey:SALARY_LIST];
    if(!potArr)
    {
        [Student getSalarys];
        potMoney = [[NSUserDefaults standardUserDefaults] objectForKey:SALARY_LIST];
    }
    else
        potMoney = potArr;
    
    UIImage *bgImg    = [UIImage imageNamed:@"talk_money"];
    UIButton *navgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [navgBtn setImage:bgImg
             forState:UIControlStateNormal];
    [navgBtn addTarget:self
                action:@selector(doNavgBtnClicked:)
      forControlEvents:UIControlEventTouchUpInside];
    navgBtn.frame = [UIView fitCGRect:CGRectMake(320-50-10, 8,
                                                 50, 20)
                           isBackView:NO];
    [self.view addSubview:navgBtn];
    
    UIImageView *bgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"xc_bg"]];
    bgView.frame = [UIView fitCGRect:CGRectMake(-2, 28,
                                                self.view.frame.size.width+4,
                                                self.view.frame.size.height)
                          isBackView:NO];
    [self.view addSubview:bgView];

    scrollView = [[UIScrollView alloc]init];
    scrollView.frame = [UIView fitCGRect:CGRectMake(0, 35,
                                  self.view.frame.size.width,
                                  self.view.frame.size.height-20)
                              isBackView:NO];
    scrollView.backgroundColor = [UIColor clearColor];
    scrollView.contentSize = CGSizeMake(self.view.frame.size.width, 870);
    [self.view addSubview:scrollView];
    
    UILabel *botomLab = [[UILabel alloc]init];
    botomLab.font = [UIFont systemFontOfSize:12.f];
    botomLab.text = @"                               更高课酬, 更多品牌认证老师!";
    botomLab.textColor = [UIColor whiteColor];
    botomLab.backgroundColor = [UIColor colorWithHexString:@"#009f66"];
    if (!iPhone5)
        botomLab.frame = [UIView fitCGRect:CGRectMake(0, 480-44-20,320, 20)
                                isBackView:NO];
    else
        botomLab.frame = [UIView fitCGRect:CGRectMake(0, 480-44-25,320, 20)
                                isBackView:NO];
    [self.view addSubview:botomLab];
    [botomLab release];
}

- (void) setSalayView
{
    int yOffset = 100;
    NSArray *offsetArr= [NSArray arrayWithObjects:@"37",@"65",@"40",@"60", nil];
    
    scrollView.contentSize = CGSizeMake(320, 100*potMoney.count+80);
    
    int index = 0;
    for (int i=0; i<potMoney.count; i++)
    {
        NSDictionary *item = [potMoney objectAtIndex:i];
        if ([[item objectForKey:@"name"] isEqualToString:money])
        {
            index = i;
            break;
        }
    }
    
    if (money)
        [scrollView scrollRectToVisible:CGRectMake(0, 50*index+30, 320, 50*index+250)
                               animated:NO];
    
    for (int i=0; i<potMoney.count; i++)
    {
        NSDictionary *item = [potMoney objectAtIndex:i];
        
        int offsetIndex = i%4;
        if (offsetIndex == 0)
        {
            UIImage *image  = [UIImage imageNamed:@"line"];
            UIImageView *imageView = [[UIImageView alloc]initWithImage:image];
            imageView.frame = CGRectMake(160-60, i*100, 120, 400);
            [scrollView addSubview:imageView];
        }
        
        NSString *offset   = [offsetArr objectAtIndex:offsetIndex];
        
        SalaryAndFlagView *sfView = [[SalaryAndFlagView alloc]
                                     initWithFrame:CGRectMake(160-offset.intValue, 60+i*yOffset, 100, 20)];
        sfView.tag = i;
        sfView.delegate = self;
        NSString *curMoney =(NSString *)[item objectForKey:@"name"];
        if (offsetIndex == 2)
        {
            if ([curMoney isEqualToString:money])
            {
                selIndex = i;
                [sfView setLeft:NO
                          money:[item objectForKey:@"name"]];
                [self salaryView:sfView tag:i];
                [sfView touchesBegan:NULL withEvent:NULL];
                [sfView setIsSelect:YES];
            }
            else
            {
                [sfView setLeft:NO money:curMoney];
                [sfView setIsSelect:NO];
            }
        }
        else
        {
            if ([curMoney isEqualToString:@"0"] && [money isEqualToString:@"师生协商"])
            {
                selIndex = 0;
                [sfView setLeft:YES
                          money:@"师生协商"];
                [self salaryView:sfView tag:0];
                [sfView touchesBegan:NULL withEvent:NULL];
                [sfView setIsSelect:YES];
            }
            else
            {
                if ([curMoney isEqualToString:money])
                {
                    selIndex = i;
                    [sfView setLeft:YES
                              money:[item objectForKey:@"name"]];
                    [self salaryView:sfView tag:i];
                    [sfView touchesBegan:NULL withEvent:NULL];
                    [sfView setIsSelect:YES];
                }
                else
                {
                    [sfView setIsSelect:NO];
                    [sfView setLeft:YES
                              money:[item objectForKey:@"name"]];
                }
            }
            
        }
        [scrollView addSubview:sfView];
    }
}

#pragma mark -
#pragma mark - Control Event
- (void) doNavgBtnClicked:(id)sender
{
    selIndex = 0;
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark - SalaryAndFlagViewDelegate
- (void) salaryView:(SalaryAndFlagView *) view tag:(int) tag
{
    NSArray *subArr = [scrollView subviews];
    for (UIView *view in subArr)
    {
        if ([view isKindOfClass:[SalaryAndFlagView class]])
        {
            SalaryAndFlagView *curView = (SalaryAndFlagView *)view;
            if (tag == view.tag)
            {
                if (tag == 0)
                    curView.leftMoneyLab.text = @"师生协商";
                selIndex = tag;
                curView.isSelect = YES;
            }
            else
            {
                if (curView.tag == 0)
                    curView.leftMoneyLab.text = @"0";
                
                [curView repickView];
                curView.isSelect = NO;
            }
        }
    }
}

@end
