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
    [super viewDidUnload];
}

- (void) viewDidAppear:(BOOL)animated
{
    [MainViewController setNavTitle:@"轻轻家教"];
    
    //注册设置性别消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(setDateFromNotice:)
                                                 name:@"setDateNotice"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(setTimesFromNotice:)
                                                 name:@"setTimesNotice"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(setPosNotice:) name:@"setPosNotice"
                                               object:nil];
    [super viewDidAppear:animated];
}

- (void) viewDidDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super viewDidDisappear:animated];
}

- (void) dealloc
{
    [upTab release];
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
- (void) initUI
{
    upTab = [[UITableView alloc]init];
    upTab.delegate   = self;
    upTab.dataSource = self;
    upTab.frame = [UIView fitCGRect:CGRectMake(0, 10, 320, 400)
                         isBackView:NO];
    upTab.scrollEnabled  = NO;
    upTab.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:upTab];
    
    upTab.backgroundColor     = [UIColor colorWithHexString:@"E1E0DE"];
    self.view.backgroundColor = [UIColor colorWithHexString:@"E1E0DE"];
}

- (void) sendUpdateOrderMsg
{
    NSArray *paramsArr = [NSArray arrayWithObjects:@"type",@"phone",@"nickname",@"orderid",@"taPhone",@"deviceId", nil];
//    NSArray *valuesArr = [NSArray arrayWithObjects:[NSNumber numberWithInt:PUSH_TYPE_ORDER_EDIT],,@"", nil];
    
    NSDictionary *pDic = [NSDictionary dictionaryWithObjects:valuesArr forKeys:paramsArr];
    NSString *json = [pDic JSONFragment];
}

#pragma mark -
#pragma mark - Control Event
- (void) doFinishBtnClicked:(id)sender
{
    //修改订单
    
    NSString *log = [[NSUserDefaults standardUserDefaults] objectForKey:@"LONGITUDE"];
    NSString *la  = [[NSUserDefaults standardUserDefaults] objectForKey:@"LATITUDE"];
    
    //封装iaddress_data
    NSArray *addParamArr = [NSArray arrayWithObjects:@"name",@"type",@"latitude",@"longitude",@"provinceName",@"cityName",@"districtName",@"cityCode", nil];
    NSArray *addValueArr = [NSArray arrayWithObjects:posValLab.text,@"InputAddress",log,la,order.orderProvice,order.orderCity,order.orderDist,@"0755", nil];
    NSDictionary *dic = [NSDictionary dictionaryWithObjects:addValueArr
                                                    forKeys:addParamArr];
    NSString *jsonAdd = [dic JSONFragment];
    CLog(@"jsonAdd:%@", jsonAdd);
    
    //封装订单信息
    NSArray *paramsArr = [NSArray arrayWithObjects:@"order_sd",@"order_kcbz",@"order_jyfdnum",@"order_iaddress",@"order_iaddress_data", nil];
    NSArray *valueArr = [NSArray arrayWithObjects:order.orderAddTimes,@"200",order.orderStudyTimes,order.orderStudyPos,jsonAdd, nil];
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
                salaryValLab.text      = @"师生协商";
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
                
                //                int money = timeValueLab.text.intValue*salaryValLab.text.intValue;
                totalMoneyLab       = [[UILabel alloc]init];
                totalMoneyLab.textColor       = [UIColor colorWithHexString:@"#ff6600"];
                totalMoneyLab.text  = @"待定";   //[NSString stringWithFormat:@"%d", money];
                totalMoneyLab.backgroundColor = [UIColor clearColor];
                totalMoneyLab.frame = CGRectMake(finishBtn.frame.size.width-160-10, 0, 160, cell.frame.size.height);
                [finishBtn addSubview:totalMoneyLab];
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
        //像老师端发送修改信息
        
        
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
//{
//type:6|7
//phone:'手机'
//nickname:'呢称'
//orderid:'订单ID'
//taPhone:'接收方手机号'
//    deviceId :'ID'
//}
@end
