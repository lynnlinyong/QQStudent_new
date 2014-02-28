//
//  OrderFinishViewController.m
//  QQStudent
//
//  Created by lynn on 14-2-14.
//  Copyright (c) 2014年 lynn. All rights reserved.
//

#import "OrderFinishViewController.h"

@interface OrderFinishViewController ()

@end

@implementation OrderFinishViewController
@synthesize order;

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
    [self initUI];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [MainViewController setNavTitle:@"结单审批"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewDidUnload
{
    finishOrderTab.delegate = nil;
    finishOrderTab.dataSource = nil;
    
    finishOrderTab = nil;
    [super viewDidUnload];
}

- (void) dealloc
{
    [payLab release];
    [backMoneyLab release];
    [finishOrderTab release];
    [super dealloc];
}

#pragma mark -
#pragma mark - Custom Action
- (void) initUI
{
    self.view.backgroundColor = [UIColor colorWithHexString:@"#E1E0DE"];
    
    UILabel *infoLab = [[UILabel alloc]init];
    infoLab.text  = @"注意您还未对老师做出评价,批准审批后将自动设为好评!";
    infoLab.backgroundColor = [UIColor clearColor];
    infoLab.textColor = [UIColor colorWithHexString:@"#ff6600"];
    infoLab.frame = [UIView fitCGRect:CGRectMake(10, 10, 320-20, 40)
                           isBackView:NO];
    infoLab.numberOfLines = 0;
    infoLab.lineBreakMode = NSLineBreakByWordWrapping;
    infoLab.font  = [UIFont systemFontOfSize:14.f];
    [self.view addSubview:infoLab];
    [infoLab release];
    
    finishOrderTab = [[UITableView alloc]init];
    finishOrderTab.delegate   = self;
    finishOrderTab.dataSource = self;
    finishOrderTab.frame = [UIView fitCGRect:CGRectMake(20, 60, 320-40, 220)
                                  isBackView:NO];
    [self.view addSubview:finishOrderTab];
    
    UILabel *payInfoLab = [[UILabel alloc]init];
    payInfoLab.frame = [UIView fitCGRect:CGRectMake(20, 290, 80, 20)
                              isBackView:NO];
    payInfoLab.text  = @"消费金额:";
    payInfoLab.font  = [UIFont systemFontOfSize:14.f];
    payInfoLab.backgroundColor = [UIColor clearColor];
    [self.view addSubview:payInfoLab];
    [payInfoLab release];
    
    UILabel *backInfoLab = [[UILabel alloc]init];
    backInfoLab.frame = [UIView fitCGRect:CGRectMake(20, 310, 80, 20)
                              isBackView:NO];
    backInfoLab.text  = @"应退金额:";
    backInfoLab.font  = [UIFont systemFontOfSize:14.f];
    backInfoLab.backgroundColor = [UIColor clearColor];
    [self.view addSubview:backInfoLab];
    
    payLab = [[UILabel alloc]init];
    payLab.frame = [UIView fitCGRect:CGRectMake(120, 290, 140, 20)
                          isBackView:NO];
    payLab.text      = [NSString stringWithFormat:@"￥ %@",order.payMoney];
    payLab.textColor = [UIColor colorWithHexString:@"#ff6600"];
    payLab.font      = [UIFont systemFontOfSize:15.f];
    payLab.backgroundColor = [UIColor clearColor];
    [self.view addSubview:payLab];
    
    backMoneyLab = [[UILabel alloc]init];
    backMoneyLab.frame = [UIView fitCGRect:CGRectMake(120, 310, 140, 20)
                                isBackView:NO];
    backMoneyLab.text  = [NSString stringWithFormat:@"￥ %@", order.backMoney];
    backMoneyLab.textColor = [UIColor colorWithHexString:@"#ff6600"];
    backMoneyLab.font      = [UIFont systemFontOfSize:15.f];
    backMoneyLab.backgroundColor = [UIColor clearColor];
    [self.view addSubview:backMoneyLab];
    
    UIImage *loginImg  = [UIImage imageNamed:@"normal_btn"];
    UIButton *okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    okBtn.tag = 1;
    [okBtn setTitle:@"批准申请"
           forState:UIControlStateNormal];
    [okBtn setBackgroundImage:loginImg
                     forState:UIControlStateNormal];
    okBtn.frame = [UIView fitCGRect:CGRectMake(160-100, 350, 80, 40)
                         isBackView:NO];
    [okBtn setTitleColor:[UIColor blackColor]
                    forState:UIControlStateNormal];
    okBtn.titleLabel.font = [UIFont systemFontOfSize:15.f];
    [okBtn addTarget:self
              action:@selector(doButtonClicked:)
    forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:okBtn];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.tag = 0;
    [cancelBtn setTitle:@"退回申请"
               forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor blackColor]
                    forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:15.f];
    [cancelBtn setBackgroundImage:loginImg
                         forState:UIControlStateNormal];
    cancelBtn.frame = [UIView fitCGRect:CGRectMake(160+20, 350, 80, 40)
                             isBackView:NO];
    [cancelBtn addTarget:self
                  action:@selector(doButtonClicked:)
        forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancelBtn];
}

#pragma mark -
#pragma mark - UITableViewDelegate and UITableViewDataSource
- (int) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (int) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *idString = @"idString";
    UITableViewCell *cell     = [tableView dequeueReusableCellWithIdentifier:idString];
    if (!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault
                                     reuseIdentifier:idString];
    }
    
    cell.backgroundView = [[UIImageView alloc]initWithImage:
                                        [UIImage imageNamed:@"lt_list_bg"]];
    switch (indexPath.row)
    {
        case 0:
        {
            UILabel *startDate = [[UILabel alloc]init];
            startDate.text  = @"开始日期";
            startDate.backgroundColor = [UIColor clearColor];
            startDate.frame = [UIView fitCGRect:CGRectMake(5, 0, 80, 44)
                                     isBackView:NO];
            startDate.font  = [UIFont systemFontOfSize:14.f];
            [cell addSubview:startDate];
            [startDate release];
            
            UILabel *dateValLab = [[UILabel alloc]init];
            dateValLab.text  = order.orderAddTimes;
            dateValLab.backgroundColor = [UIColor clearColor];
            dateValLab.frame = CGRectMake(140, 0, 140, 44);
            dateValLab.font  = [UIFont systemFontOfSize:14.f];
            [cell addSubview:dateValLab];
            break;
        }
        case 1:
        {
            UILabel *salaryLab = [[UILabel alloc]init];
            salaryLab.text = @"每小时课酬标准";
            salaryLab.backgroundColor = [UIColor clearColor];
            salaryLab.frame = [UIView fitCGRect:CGRectMake(5, 0, 140, 44)
                                     isBackView:NO];
            salaryLab.font  = [UIFont systemFontOfSize:14.f];
            [cell addSubview:salaryLab];
            [salaryLab release];
            
            UILabel *salaryValLab  = [[UILabel alloc]init];
            salaryValLab.text      = order.everyTimesMoney;
            salaryValLab.backgroundColor = [UIColor clearColor];
            salaryValLab.frame = CGRectMake(140, 0, 140, 44);
            salaryValLab.font  = [UIFont systemFontOfSize:14.f];
            [cell addSubview:salaryValLab];
            break;
        }
        case 2:
        {
            UILabel *timesLab = [[UILabel alloc]init];
            timesLab.text = @"预计辅导小时数";
            timesLab.backgroundColor = [UIColor clearColor];
            timesLab.frame = [UIView fitCGRect:CGRectMake(5, 0, 140, 44)
                                    isBackView:NO];
            [cell addSubview:timesLab];
            timesLab.font  = [UIFont systemFontOfSize:14.f];
            [timesLab release];
            
            UILabel *timeValueLab = [[UILabel alloc]init];
            timeValueLab.text  = order.orderStudyTimes;
            timeValueLab.backgroundColor = [UIColor clearColor];
            timeValueLab.frame = CGRectMake(140, 0, 140, 44);
            timeValueLab.font  = [UIFont systemFontOfSize:14.f];
            [cell addSubview:timeValueLab];
            break;
        }
        case 3:
        {
            UILabel *posLab = [[UILabel alloc]init];
            posLab.text = @"授课地点";
            posLab.backgroundColor = [UIColor clearColor];
            posLab.frame = [UIView fitCGRect:CGRectMake(5, 0, 140, 44)
                                  isBackView:NO];
            [cell addSubview:posLab];
            posLab.font  = [UIFont systemFontOfSize:14.f];
            [posLab release];
            
            UILabel *posValLab = [[UILabel alloc]init];
            posValLab.text  = order.orderStudyPos;
            posValLab.backgroundColor = [UIColor clearColor];
            posValLab.frame = CGRectMake(140, 0, 140, 44);
            posValLab.numberOfLines = 0;
            posValLab.font  = [UIFont systemFontOfSize:14.f];
            [cell addSubview:posValLab];
            
            CGSize size = [posValLab.text sizeWithFont:posValLab.font
                                constrainedToSize:CGSizeMake(posValLab.frame.size.width, MAXFLOAT)
                                    lineBreakMode:NSLineBreakByWordWrapping];
            posValLab.frame = CGRectMake(posValLab.frame.origin.x, posValLab.frame.origin.y, posValLab.frame.size.width, size.height);
            break;
        }
        case 4:
        {
            UILabel *posLab = [[UILabel alloc]init];
            posLab.text = @"总金额";
            posLab.backgroundColor = [UIColor clearColor];
            posLab.frame = [UIView fitCGRect:CGRectMake(5, 0, 140, 44)
                                  isBackView:NO];
            [cell addSubview:posLab];
            posLab.font  = [UIFont systemFontOfSize:14.f];
            [posLab release];
            
            UILabel *moneyValLab = [[UILabel alloc]init];
            moneyValLab.text  = order.totalMoney;
            moneyValLab.backgroundColor = [UIColor clearColor];
            moneyValLab.frame = CGRectMake(140, 0, 140, 44);
            moneyValLab.font  = [UIFont systemFontOfSize:14.f];
            [cell addSubview:moneyValLab];
            break;
        }
    }
    
    return cell;
}

#pragma mark -
#pragma mark - Control Event
- (void) doButtonClicked:(id)sender
{
    UIButton *btn  = sender;
    NSString *ssid = [[NSUserDefaults standardUserDefaults] objectForKey:SSID];
    NSString *webAdd   = [[NSUserDefaults standardUserDefaults] objectForKey:WEBADDRESS];
    NSString *url      = [NSString stringWithFormat:@"%@%@", webAdd,STUDENT];
    NSArray *paramsArr = [NSArray arrayWithObjects:@"action",@"orderid",@"value",@"sessid",nil];
    NSArray *valuesArr = [NSArray arrayWithObjects:@"submitApply",order.orderId,[NSNumber numberWithInt:btn.tag],ssid, nil];
    
    CLog(@"values:%@", valuesArr);
    NSDictionary *pDic = [NSDictionary dictionaryWithObjects:valuesArr
                                                     forKeys:paramsArr];
    ServerRequest *request = [ServerRequest sharedServerRequest];
    request.delegate = self;
    [request requestASyncWith:kServerPostRequest
                     paramDic:pDic
                       urlStr:url];
        
}

#pragma mark -
#pragma mark - ServerRequest Delegate
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
    NSString *resStr = [[[NSString alloc]initWithData:resVal
                                             encoding:NSUTF8StringEncoding]autorelease];
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
        CLog(@"Submit Order Success!");
        //返回上一页
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        NSString *errorMsg = [resDic objectForKey:@"message"];
        [self showAlertWithTitle:@"提示"
                             tag:0
                         message:[NSString stringWithFormat:@"错误码%@,%@",errorid,errorMsg]
                        delegate:self
               otherButtonTitles:@"确定",nil];
    }
}
@end
