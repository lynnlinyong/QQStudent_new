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
    UILabel *infoLab = [[UILabel alloc]init];
    infoLab.text  = @"注意您还未对老师做出评价,批准审批后将自动设为好评!";
    infoLab.backgroundColor = [UIColor clearColor];
    infoLab.frame = [UIView fitCGRect:CGRectMake(10, 10, 320-20, 40) isBackView:NO];
    infoLab.numberOfLines = 0;
    infoLab.lineBreakMode = NSLineBreakByWordWrapping;
    [self.view addSubview:infoLab];
    [infoLab release];
    
    finishOrderTab = [[UITableView alloc]init];
    finishOrderTab.delegate   = self;
    finishOrderTab.dataSource = self;
    finishOrderTab.frame = [UIView fitCGRect:CGRectMake(20, 60, 320-40, 260)
                                  isBackView:NO];
    [self.view addSubview:finishOrderTab];
    
    UILabel *payInfoLab = [[UILabel alloc]init];
    payInfoLab.frame = [UIView fitCGRect:CGRectMake(20, 320, 80, 20)
                          isBackView:NO];
    payInfoLab.text  = @"消费金额:";
    payInfoLab.backgroundColor = [UIColor clearColor];
    [self.view addSubview:payInfoLab];
    [payInfoLab release];
    
    UILabel *backInfoLab = [[UILabel alloc]init];
    backInfoLab.frame = [UIView fitCGRect:CGRectMake(20, 340, 80, 20)
                              isBackView:NO];
    backInfoLab.text  = @"应退金额:";
    backInfoLab.backgroundColor = [UIColor clearColor];
    [self.view addSubview:backInfoLab];
    
    payLab = [[UILabel alloc]init];
    payLab.frame = [UIView fitCGRect:CGRectMake(120, 320, 80, 20)
                          isBackView:NO];
    payLab.text  = @"消费金额:";
    payLab.backgroundColor = [UIColor clearColor];
    [self.view addSubview:payLab];
    
    backMoneyLab = [[UILabel alloc]init];
    backMoneyLab.frame = [UIView fitCGRect:CGRectMake(120, 340, 80, 20)
                                isBackView:NO];
    backMoneyLab.text  = @"应退金额:";
    backMoneyLab.backgroundColor = [UIColor clearColor];
    [self.view addSubview:backMoneyLab];
    
    UIButton *okBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    okBtn.tag = 1;
    [okBtn setTitle:@"批准申请" forState:UIControlStateNormal];
    okBtn.frame = [UIView fitCGRect:CGRectMake(160-100, 370, 80, 40) isBackView:NO];
    [okBtn addTarget:self
              action:@selector(doButtonClicked:)
    forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:okBtn];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    cancelBtn.tag = 0;
    [cancelBtn setTitle:@"退回申请"
               forState:UIControlStateNormal];
    cancelBtn.frame = [UIView fitCGRect:CGRectMake(160+20, 370, 80, 40)
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
    
    switch (indexPath.row)
    {
        case 0:
        {
            UILabel *startDate = [[UILabel alloc]init];
            startDate.text  = @"开始日期";
            startDate.backgroundColor = [UIColor clearColor];
            startDate.frame = [UIView fitCGRect:CGRectMake(0, 0, 80, 44)
                                     isBackView:NO];
            [cell addSubview:startDate];
            [startDate release];
            
            UILabel *dateValLab = [[UILabel alloc]init];
            dateValLab.text  = order.orderAddTimes;
            dateValLab.textAlignment   = NSTextAlignmentCenter;
            dateValLab.backgroundColor = [UIColor clearColor];
            dateValLab.frame = CGRectMake(80, 0, 170, 44);
            [cell addSubview:dateValLab];
            break;
        }
        case 1:
        {
            UILabel *salaryLab = [[UILabel alloc]init];
            salaryLab.text = @"每小时课酬标准";
            salaryLab.backgroundColor = [UIColor clearColor];
            salaryLab.frame = [UIView fitCGRect:CGRectMake(0, 0, 140, 44)
                                     isBackView:NO];
            [cell addSubview:salaryLab];
            [salaryLab release];
            
            UILabel *salaryValLab  = [[UILabel alloc]init];
            salaryValLab.text      = order.everyTimesMoney;
            salaryValLab.backgroundColor = [UIColor clearColor];
            salaryValLab.frame = CGRectMake(140, 0, 140, 44);
            [cell addSubview:salaryValLab];
            break;
        }
        case 2:
        {
            UILabel *timesLab = [[UILabel alloc]init];
            timesLab.text = @"预计辅导小时数";
            timesLab.backgroundColor = [UIColor clearColor];
            timesLab.frame = [UIView fitCGRect:CGRectMake(0, 0, 140, 44)
                                    isBackView:NO];
            [cell addSubview:timesLab];
            [timesLab release];
            
            UILabel *timeValueLab = [[UILabel alloc]init];
            timeValueLab.text  = order.orderStudyTimes;
            timeValueLab.backgroundColor = [UIColor clearColor];
            timeValueLab.frame = CGRectMake(140, 0, 140, 44);
            [cell addSubview:timeValueLab];
            break;
        }
        case 3:
        {
            UILabel *posLab = [[UILabel alloc]init];
            posLab.text = @"授课地点";
            posLab.backgroundColor = [UIColor clearColor];
            posLab.frame = [UIView fitCGRect:CGRectMake(0, 0, 140, 44)
                                  isBackView:NO];
            [cell addSubview:posLab];
            [posLab release];
            
            UILabel *posValLab = [[UILabel alloc]init];
            posValLab.text  = order.orderStudyPos;
            posValLab.backgroundColor = [UIColor clearColor];
            posValLab.frame = CGRectMake(140, 0, 140, 44);
            [cell addSubview:posValLab];
            break;
        }
        case 4:
        {
            UILabel *posLab = [[UILabel alloc]init];
            posLab.text = @"总金额";
            posLab.backgroundColor = [UIColor clearColor];
            posLab.frame = [UIView fitCGRect:CGRectMake(0, 0, 140, 44)
                                  isBackView:NO];
            [cell addSubview:posLab];
            [posLab release];
            
            UILabel *moneyValLab = [[UILabel alloc]init];
            moneyValLab.text  = @"";
            moneyValLab.backgroundColor = [UIColor clearColor];
            moneyValLab.frame = CGRectMake(140, 0, 140, 44);
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
