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
    [self getSalarys];
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
    infoLab.text = @"注意:课酬标准中已包含教师交通费";
    infoLab.textColor = [UIColor whiteColor];
    infoLab.backgroundColor = [UIColor colorWithHexString:@"#009f66"];
    infoLab.frame = [UIView fitCGRect:CGRectMake(0, 5, 320, 20)
                           isBackView:NO];
    [self.view addSubview:infoLab];
    [infoLab release];
    
    UIButton *navgBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [navgBtn setTitle:@"师生协商" forState:UIControlStateNormal];
    [navgBtn addTarget:self
                action:@selector(doNavgBtnClicked:)
      forControlEvents:UIControlEventTouchUpInside];
    navgBtn.frame = [UIView fitCGRect:CGRectMake(320-105, 5, 100, 20)
                           isBackView:NO];
    [self.view addSubview:navgBtn];
    
    UIImageView *bgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"xc_bg.9.png"]];
    bgView.frame = [UIView fitCGRect:CGRectMake(-2, 20,
                                                self.view.frame.size.width+4,
                                                self.view.frame.size.height)
                          isBackView:NO];
    [self.view addSubview:bgView];

    scrollView = [[UIScrollView alloc]init];
    scrollView.frame = [UIView fitCGRect:CGRectMake(0, 25,
                                  self.view.frame.size.width,
                                  self.view.frame.size.height-20)
                              isBackView:NO];
    scrollView.backgroundColor = [UIColor clearColor];
    scrollView.contentSize = CGSizeMake(self.view.frame.size.width, 800);
    [self.view addSubview:scrollView];
    
    UILabel *botomLab = [[UILabel alloc]init];
    botomLab.font = [UIFont systemFontOfSize:12.f];
    botomLab.text = @"                               更高课酬, 更多品牌认证老师!";
    botomLab.textColor = [UIColor whiteColor];
    botomLab.backgroundColor = [UIColor colorWithHexString:@"#009f66"];
    botomLab.frame = [UIView fitCGRect:CGRectMake(0, self.view.frame.size.height-20-44-9,
                                                  320, 20)
                            isBackView:NO];
    [self.view addSubview:botomLab];
    [botomLab release];
}

- (void) getSalarys
{
    NSString *ssid = [[NSUserDefaults standardUserDefaults] objectForKey:SSID];
    NSArray *paramsArr = [NSArray arrayWithObjects:@"action",@"sessid", nil];
    NSArray *valuesArr = [NSArray arrayWithObjects:@"getkcbzs",ssid, nil];
    NSDictionary *pDic = [NSDictionary dictionaryWithObjects:valuesArr
                                                     forKeys:paramsArr];
    
    NSString *webAdd = [[NSUserDefaults standardUserDefaults] objectForKey:WEBADDRESS];
    NSString *url = [NSString stringWithFormat:@"%@%@", webAdd, STUDENT];
    ServerRequest *request = [ServerRequest sharedServerRequest];
    request.delegate = self;
    [request requestASyncWith:kServerPostRequest
                     paramDic:pDic
                       urlStr:url];
}

#pragma mark -
#pragma mark - Control Event
- (void) doNavgBtnClicked:(id)sender
{
    selIndex = 0;
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark - ServerRequestDelegate
- (void) requestAsyncFailed:(ASIHTTPRequest *)request
{
    [self showAlertWithTitle:@"提示"
                         tag:1
                     message:@"网络繁忙"
                    delegate:self
           otherButtonTitles:@"确定",nil];
    
    CLog(@"***********Result****************");
    CLog(@"ERROR");
    CLog(@"***********Result****************");
}

- (void) requestAsyncSuccessed:(ASIHTTPRequest *)request
{
    NSData   *resVal = [request responseData];
    NSString *resStr = [[NSString alloc]initWithData:resVal
                                            encoding:NSUTF8StringEncoding];
    NSDictionary *resDic   = [resStr JSONValue];
    NSArray      *keysArr  = [resDic allKeys];
    NSArray      *valsArr  = [resDic allValues];
    CLog(@"***********Result****************");
    for (int i=0; i<keysArr.count; i++)
    {
        CLog(@"%@=%@", [keysArr objectAtIndex:i], [valsArr objectAtIndex:i]);
    }
    CLog(@"***********Result****************");
    
    NSNumber *errorid = [resDic objectForKey:@"errorid"];
    if (errorid.intValue == 0)
    {
        NSString *action = [resDic objectForKey:@"action"];
        if ([action isEqualToString:@"getkcbzs"])
        {
            int yOffset = 100;
            NSArray *offsetArr= [NSArray arrayWithObjects:@"37",@"65",@"40",@"60", nil];
            potMoney = [[resDic objectForKey:@"kcbzs"] copy];
            scrollView.contentSize = CGSizeMake(320, 100*potMoney.count+30);
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
                if (offsetIndex == 2)
                    [sfView setLeft:NO money:[item objectForKey:@"name"]];
                else
                {
                    if (i==0)
                        [sfView setLeft:YES money:@"师生协商"];
                    [sfView setLeft:YES money:[item objectForKey:@"name"]];
                }
                [scrollView addSubview:sfView];
            }
        }
    }
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
                selIndex = tag;
                curView.isSelect = YES;
            }
            else
            {
                [curView repickView];
                curView.isSelect = NO;
            }
        }
    }
}

@end
