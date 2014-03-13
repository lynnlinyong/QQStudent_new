//
//  UpdateOrderViewController.m
//  QQStudent
//
//  Created by lynn on 14-2-12.
//  Copyright (c) 2014年 lynn. All rights reserved.
//

#import "UpdateOrderViewController.h"

@interface UpdateOrderViewController ()

@end

@implementation UpdateOrderViewController
@synthesize order;
@synthesize isEmploy;

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
    
    [self initBackBarItem];
    
    //初始化UI
    [self initUI];
    
    
    //注册设置性别消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(setDateFromNotice:)
                                                 name:@"setDateNotice"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(setSalaryFromNotice:)
                                                 name:@"setSalaryNotice"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(setTimesFromNotice:)
                                                 name:@"setTimesNotice"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(setPosNotice:)
                                                 name:@"setPosNotice"
                                               object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void) viewDidUnload
{
    upTab.delegate   = nil;
    upTab.dataSource = nil;
    
    upTab = nil;
    
    CustomNavigationViewController *nav = [MainViewController getNavigationViewController];
    nav.dataSource = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super viewDidUnload];
}

- (void) viewDidAppear:(BOOL)animated
{
    [MainViewController setNavTitle:@"轻轻家教"];
    [super viewDidAppear:animated];
}

- (void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (void) dealloc
{
    [upTab release];
    if (order)
        [order release];
    [dateValLab    release];
    [posValLab     release];
    [timeValueLab  release];
    [salaryValLab  release];
    [totalMoneyLab release];
    [super dealloc];
}

#pragma mark -
#pragma mark - Custom Action
- (void) initBackBarItem
{
    CustomNavigationViewController *nav = [MainViewController getNavigationViewController];
    nav.dataSource = self;
}

- (void) initUI
{
    upTab = [[UITableView alloc]init];
    upTab.delegate   = self;
    upTab.dataSource = self;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7)
    {
        if (iPhone5)
        {
            //ios7 iphone5
            CLog(@"It's is iphone5 IOS7");
            upTab.frame = [UIView fitCGRect:CGRectMake(0, 44, 320, 480)
                                 isBackView:YES];
        }
        else
        {
            CLog(@"It's is iphone4 IOS7");
            //ios 7 iphone 4
            upTab.frame = [UIView fitCGRect:CGRectMake(0, 44, 320, 480)
                                 isBackView:YES];
        }
    }
    else
    {
        if (!iPhone5)
        {
            // ios 6 iphone4
            CLog(@"It's is iphone4 IOS6");
            upTab.frame = [UIView fitCGRect:CGRectMake(0, 0, 320, 480)
                                 isBackView:YES];
        }
        else
        {
            //ios 6 iphone5
            CLog(@"It's is iphone5 IOS6");
            upTab.frame = [UIView fitCGRect:CGRectMake(0, 0, 320, 480)
                                 isBackView:YES];
        }
    }
    upTab.scrollEnabled  = NO;
    upTab.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:upTab];
    
    upTab.backgroundColor     = [UIColor colorWithHexString:@"E1E0DE"];
    self.view.backgroundColor = [UIColor colorWithHexString:@"E1E0DE"];
    
    CLog(@"order Teacher:%@", order.teacher.name);
}

- (void) sendUpdateOrderMsg
{
    NSData *stuData    = [[NSUserDefaults standardUserDefaults] valueForKey:STUDENT];
    Student *student   = [NSKeyedUnarchiver unarchiveObjectWithData:stuData];
    
    //聘请时修改订单,还是修改订单按钮点击
    if (!isEmploy)
    {
        NSArray *paramsArr = [NSArray arrayWithObjects:@"type",@"phone",@"nickname",@"orderid",@"taPhone",@"deviceId", nil];
        NSArray *valuesArr = [NSArray arrayWithObjects:[NSNumber numberWithInt:PUSH_TYPE_ORDER_CONFIRM],
                              student.phoneNumber,order.teacher.name,order.orderId,order.teacher.phoneNums,[SingleMQTT getCurrentDevTopic], nil];
        NSDictionary *pDic = [NSDictionary dictionaryWithObjects:valuesArr
                                                         forKeys:paramsArr];
        //发送消息
        NSString *json = [pDic JSONFragment];
        CLog(@"update Order Msg:%@,%@", json, order.teacher.deviceId);
        NSData *data   = [json dataUsingEncoding:NSUTF8StringEncoding];
        SingleMQTT *session = [SingleMQTT shareInstance];
        
        [session.session publishData:data
                             onTopic:order.teacher.deviceId];
    }
    else
    {
        NSArray *paramsArr = [NSArray arrayWithObjects:@"type",@"phone",@"nickname",@"orderid",@"taPhone",@"deviceId", nil];
        NSArray *valuesArr = [NSArray arrayWithObjects:[NSNumber numberWithInt:PUSH_TYPE_ORDER_EDIT],student.phoneNumber,order.teacher.name,order.orderId,order.teacher.phoneNums,[SingleMQTT getCurrentDevTopic], nil];
        CLog(@"valArr:%@", valuesArr);
        NSDictionary *pDic = [NSDictionary dictionaryWithObjects:valuesArr
                                                         forKeys:paramsArr];
        //发送消息
        NSString *json = [pDic JSONFragment];
        CLog(@"update Order Msg:%@,%@", json, order.teacher.deviceId);
        NSData *data   = [json dataUsingEncoding:NSUTF8StringEncoding];
        SingleMQTT *session = [SingleMQTT shareInstance];
        
        [session.session publishData:data
                             onTopic:order.teacher.deviceId];
    }
}

#pragma mark -
#pragma mark - Control Event
- (void) doFinishBtnClicked:(id)sender
{
    if (![AppDelegate isConnectionAvailable:YES withGesture:NO])
    {
        return;
    }
    
    CustomNavigationViewController *nav = [MainViewController getNavigationViewController];
    [MBProgressHUD showHUDAddedTo:nav.view animated:YES];;
    
    //封装订单信息
    NSArray *paramsArr = [NSArray arrayWithObjects:@"order_sd",@"order_kcbz",@"order_jyfdnum",
                          @"order_iaddress",@"order_iaddress_data", nil];
    NSArray *valueArr = [NSArray arrayWithObjects:order.orderAddTimes,order.everyTimesMoney,
                         order.orderStudyTimes,order.orderStudyPos,order.addressDataDic, nil];
    NSDictionary *orderDic = [NSDictionary dictionaryWithObjects:valueArr
                                                         forKeys:paramsArr];
    NSString *jsonOrder = [orderDic JSONFragment];
    CLog(@"jsonOrder:%@", jsonOrder);
    
    //封装修改订单提交字段
    NSString *ssid = [[NSUserDefaults standardUserDefaults] objectForKey:SSID];
    NSArray *pArr  = [NSArray arrayWithObjects:@"action",@"orderInfo",@"oid",@"sessid", nil];
    NSArray *vArr  = [NSArray arrayWithObjects:@"editOrder",jsonOrder,order.orderId,ssid, nil];
    NSDictionary *pDic = [NSDictionary dictionaryWithObjects:vArr
                                                     forKeys:pArr];
    CLog(@"pDic:%@", pDic);
    ServerRequest *serverReq = [ServerRequest sharedServerRequest];
    serverReq.delegate = self;
    NSString *webAddress = [[NSUserDefaults standardUserDefaults] valueForKey:WEBADDRESS];
    NSString *url = [NSString stringWithFormat:@"%@%@/", webAddress,STUDENT];
    [serverReq requestASyncWith:kServerPostRequest
                       paramDic:pDic
                         urlStr:url];
}

#pragma mark -
#pragma mark - Notice
- (void) setPosNotice:(NSNotification *) notice
{
    NSString *provice = [notice.userInfo objectForKey:@"PROVICE"];
    NSString *city    = [notice.userInfo objectForKey:@"CITY"];
    NSString *dist    = [notice.userInfo objectForKey:@"DIST"];
    posValLab.text    = [NSString stringWithFormat:@"%@ %@ %@", provice, city, dist];
    order.orderStudyPos = posValLab.text;
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
}

- (void) setDateFromNotice:(NSNotification *) notice
{
    NSString *dateString = [notice.userInfo objectForKey:@"SetDate"];
    dateValLab.text = dateString;
    order.orderAddTimes = dateString;
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
}

- (void) setTimesFromNotice:(NSNotification *)notice
{
    timeValueLab.text = [notice.userInfo objectForKey:@"Time"];
    order.orderStudyTimes = [[notice.userInfo objectForKey:@"Time"] copy];
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
}

- (void) setSalaryFromNotice:(NSNotification *) notice
{
    NSString *salary  = @"";
    if ([[notice.userInfo objectForKey:@"name"] isEqualToString:@"0"])
        salary = @"师生协商";
    else
        salary = [notice.userInfo objectForKey:@"name"];
    
    salaryValLab.text = salary;
    order.everyTimesMoney = salary;
}

#pragma mark -
#pragma mark - UITableViewDelegate and UITableViewDatasource
- (int) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (int) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}

- (float) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *idString = @"idString";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:idString];
    if (!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault
                                     reuseIdentifier:idString];
        UILabel *infoLab = nil;
        switch (indexPath.row)
        {
            case 0:
            {
                infoLab = [[UILabel alloc]init];
                infoLab.backgroundColor = [UIColor clearColor];
                infoLab.text = @"开始日期";
                infoLab.frame = CGRectMake(10, 10, cell.frame.size.width-20, cell.frame.size.height-10);
                [cell addSubview:infoLab];
                [infoLab release];
                
                dateValLab = [[UILabel alloc]init];
                dateValLab.text = order.orderAddTimes;
                dateValLab.textColor       = [UIColor colorWithHexString:@"#ff6600"];
                dateValLab.textAlignment   = NSTextAlignmentLeft;
                dateValLab.backgroundColor = [UIColor clearColor];
                dateValLab.frame = CGRectMake(cell.frame.size.width-160-20, 10, 170, cell.frame.size.height-10);
                [cell addSubview:dateValLab];
                
               cell.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"sp_content_normal_cell"]];
                break;
            }
            case 1:
            {
                infoLab = [[UILabel alloc]init];
                infoLab.backgroundColor = [UIColor clearColor];
                infoLab.text = @"每小时课酬标准";
                infoLab.frame = CGRectMake(10, 10, cell.frame.size.width-20, cell.frame.size.height-10);
                [cell addSubview:infoLab];
                [infoLab release];
                
                salaryValLab  = [[UILabel alloc]init];
                if (order.everyTimesMoney.intValue==0)
                    salaryValLab.text  = @"师生协商";
                else
                    salaryValLab.text  = order.everyTimesMoney;
                salaryValLab.backgroundColor = [UIColor clearColor];
                salaryValLab.textColor       = [UIColor colorWithHexString:@"#ff6600"];
                salaryValLab.frame = CGRectMake(cell.frame.size.width-160-20, 10, 170, cell.frame.size.height-10);
                [cell addSubview:salaryValLab];
                
               cell.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"sp_content_normal_cell"]];
                break;
            }
            case 2:
            {
                infoLab = [[UILabel alloc]init];
                infoLab.backgroundColor = [UIColor clearColor];
                infoLab.text = @"预计辅导小时数";
                infoLab.frame = CGRectMake(10, 10, cell.frame.size.width-20, cell.frame.size.height-10);
                [cell addSubview:infoLab];
                [infoLab release];
                
                timeValueLab = [[UILabel alloc]init];
                timeValueLab.text  = order.orderStudyTimes;
                timeValueLab.textColor       = [UIColor colorWithHexString:@"#ff6600"];
                timeValueLab.backgroundColor = [UIColor clearColor];
                timeValueLab.frame = CGRectMake(cell.frame.size.width-160-20, 10, 160, cell.frame.size.height-10);
                [cell addSubview:timeValueLab];
                
               cell.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"sp_content_normal_cell"]];
                break;
            }
            case 3:
            {
                infoLab = [[UILabel alloc]init];
                infoLab.backgroundColor = [UIColor clearColor];
                infoLab.text  = @"授课地点";
                infoLab.frame = CGRectMake(10, 10, cell.frame.size.width-20, cell.frame.size.height-10);
                [cell addSubview:infoLab];
                [infoLab release];
                
                posValLab = [[UILabel alloc]init];
                posValLab.text  = order.orderStudyPos;
                posValLab.textColor       = [UIColor colorWithHexString:@"#ff6600"];
                posValLab.backgroundColor = [UIColor clearColor];
                posValLab.frame = CGRectMake(cell.frame.size.width-160-20, 10, 160, cell.frame.size.height-10);
                [cell addSubview:posValLab];
                
               cell.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"sp_content_normal_cell"]];
                
                break;
            }
            case 4:
            {
                UIImage *loginImg  = [UIImage imageNamed:@"normal_btn"];
                UIButton *finishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                [finishBtn setTitleColor:[UIColor colorWithHexString:@"#ff6600"]
                                forState:UIControlStateNormal];
                [finishBtn setBackgroundImage:loginImg
                                     forState:UIControlStateNormal];
                [finishBtn setBackgroundImage:[UIImage imageNamed:@"hight_btn"]
                                     forState:UIControlStateHighlighted];
                finishBtn.frame = [UIView fitCGRect:CGRectMake(5,
                                                               0,
                                                               cell.frame.size.width-10,
                                                               cell.frame.size.height)
                                         isBackView:NO];
                [finishBtn addTarget:self
                              action:@selector(doFinishBtnClicked:)
                    forControlEvents:UIControlEventTouchUpInside];
                [cell addSubview:finishBtn];

                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                infoLab = [[UILabel alloc]init];
                infoLab.textColor  = [UIColor colorWithHexString:@"#ff6600"];
                infoLab.backgroundColor = [UIColor clearColor];
                infoLab.text  = @"总金额数";
                infoLab.frame = CGRectMake(10, 0, cell.frame.size.width-20, cell.frame.size.height);
                [finishBtn addSubview:infoLab];
                [infoLab release];
                
                totalMoneyLab       = [[UILabel alloc]init];
                totalMoneyLab.textColor       = [UIColor colorWithHexString:@"#ff6600"];
                totalMoneyLab.text  = [NSString stringWithFormat:@"￥%@",order.totalMoney];
                totalMoneyLab.backgroundColor = [UIColor clearColor];
                totalMoneyLab.frame = CGRectMake(finishBtn.frame.size.width-160-10, 0, 160, cell.frame.size.height);
                [finishBtn addSubview:totalMoneyLab];
                
                cell.backgroundColor = [UIColor colorWithHexString:@"E1E0DE"];
                break;
            }
            case 5:
            {
                UIImage *loginImg  = [UIImage imageNamed:@"normal_btn"];
                UIButton *finishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                [finishBtn setTitle:@"完成,等待老师确认"
                          forState:UIControlStateNormal];
                [finishBtn setTitleColor:[UIColor colorWithHexString:@"#ff6600"]
                               forState:UIControlStateNormal];
                [finishBtn setBackgroundImage:loginImg
                                    forState:UIControlStateNormal];
                [finishBtn setBackgroundImage:[UIImage imageNamed:@"hight_btn"]
                                    forState:UIControlStateHighlighted];
                finishBtn.frame = [UIView fitCGRect:CGRectMake(5,
                                                              0,
                                                              cell.frame.size.width-10,
                                                              cell.frame.size.height)
                                        isBackView:NO];
                [finishBtn addTarget:self
                             action:@selector(doFinishBtnClicked:)
                   forControlEvents:UIControlEventTouchUpInside];
                [cell addSubview:finishBtn];
                cell.backgroundColor = [UIColor colorWithHexString:@"E1E0DE"];
                cell.backgroundView = nil;
                break;
            }
            default:
                break;
        }
    }
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath
                             animated:YES];
    
    CustomNavigationViewController *nav = (CustomNavigationViewController *)[MainViewController getNavigationViewController];
    switch (indexPath.row)
    {
        case 0:
        {
            SelectDateViewController *sdVctr = [[SelectDateViewController alloc]init];
            [self presentPopupViewController:sdVctr
                               animationType:MJPopupViewAnimationFade];
            break;
        }
        case 1:
        {
            SelectSalaryViewController *ssVctr = [[SelectSalaryViewController alloc]init];
            ssVctr.money = order.everyTimesMoney;
            [nav pushViewController:ssVctr animated:YES];
            [ssVctr release];
            break;
        }
        case 2:
        {
            SelectTimesViewController *stVctr = [[SelectTimesViewController alloc]init];
            stVctr.curValue = timeValueLab.text;
            [self presentPopupViewController:stVctr
                               animationType:MJPopupViewAnimationFade];
            break;
        }
        case 3:
        {
            SelectPosViewController *spVctr = [[SelectPosViewController alloc]init];
            [nav pushViewController:spVctr animated:YES];
            break;
        }
        default:
            break;
    }
}

#pragma mark -
#pragma mark - CustomNavigationDataSource
- (void) doBackBtnClicked:(id)sender
{
    CustomNavigationViewController *nav = [MainViewController getNavigationViewController];
    [nav popViewControllerAnimated:YES];
}

- (UIBarButtonItem *)backBarButtomItem
{
    //设置返回按钮
    UIImage *backImg  = [UIImage imageNamed:@"nav_back_normal_btn@2x"];
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame     = CGRectMake(0, 0,
                                   50,
                                   30);
    [backBtn setBackgroundImage:backImg
                       forState:UIControlStateNormal];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"nav_back_hlight_btn@2x"]
                       forState:UIControlStateHighlighted];
    [backBtn addTarget:self
                action:@selector(doBackBtnClicked:)
      forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *titleLab = [[UILabel alloc]init];
    titleLab.text     = @"返回";
    titleLab.textColor= [UIColor whiteColor];
    titleLab.font     = [UIFont systemFontOfSize:12.f];
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.frame = CGRectMake(8, 0,
                                50,
                                30);
    titleLab.backgroundColor = [UIColor clearColor];
    [backBtn addSubview:titleLab];
    [titleLab release];
    
    return [[UIBarButtonItem alloc]
            initWithCustomView:backBtn];
}

#pragma mark -
#pragma mark ServerRequest Delegate
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
    
    CustomNavigationViewController *nav = [MainViewController getNavigationViewController];
    [MBProgressHUD hideHUDForView:nav.view animated:YES];
}

- (void) requestAsyncSuccessed:(ASIHTTPRequest *)request
{
    CustomNavigationViewController *nav = [MainViewController getNavigationViewController];
    [MBProgressHUD hideHUDForView:nav.view animated:YES];
    
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
        //向老师端发送修改信息
        [self sendUpdateOrderMsg];
        
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
        
        //重复登录
        if (errorid.intValue==2)
        {
            //清除sessid,清除登录状态,回到地图页
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:SSID];
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:LOGINE_SUCCESS];
            [AppDelegate popToMainViewController];
        }
    }
}

@end
