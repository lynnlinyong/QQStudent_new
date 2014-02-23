//
//  WaitConfirmViewController.m
//  QQStudent
//
//  Created by lynn on 14-2-9.
//  Copyright (c) 2014年 lynn. All rights reserved.
//

#import "WaitConfirmViewController.h"

@interface WaitConfirmViewController ()

@end

@implementation WaitConfirmViewController
@synthesize mapView;
@synthesize tObj;
@synthesize teacherArray;
@synthesize valueDic;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //发起邀请
    [self sendInviteMsg];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void) viewDidAppear:(BOOL)animated
{
    [self initUI];
    
    [super viewDidAppear:animated];
}

- (void) viewDidDisappear:(BOOL)animated
{
    [timer invalidate];
    timer = nil;
    timeLab.text   = @"";
    waitTimeInvite = 20;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super viewDidDisappear:animated];
}

- (void) viewDidUnload
{
    [teacherArray removeAllObjects];
    
    self.mapView.delegate = nil;
    self.mapView = nil;
    [super viewDidUnload];
}

- (void) dealloc
{
    [timeLab release];
    [teacherArray release];
    [self.mapView release];
    [super dealloc];
}

#pragma mark -
#pragma mark - Custom Action
- (void) initUI
{
    //显示地图
    self.mapView=[[MAMapView alloc] initWithFrame:CGRectMake(0, 0, 320, 460)];
    self.mapView.delegate = self;
    [self.view addSubview:self.mapView];
    self.mapView.showsUserLocation = YES;
    [self.view addSubview:self.mapView];
    
    showBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    showBtn.frame = CGRectMake(60, 375, 200, 40);
    [showBtn setTitle:@"剩余"
             forState:UIControlStateNormal];
    showBtn.userInteractionEnabled = NO;
    [showBtn addTarget:self
                action:@selector(doButtonClicked:)
      forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:showBtn];
    
    reBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    reBtn.hidden  = YES;
    reBtn.tag     = 0;
    [reBtn setImage:[UIImage imageNamed:@"cf_bg1"]
           forState:UIControlStateNormal];
    reBtn.frame = CGRectMake(60, 375, 200, 40);
    [reBtn addTarget:self
                action:@selector(doButtonClicked:)
      forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:reBtn];
    
    timeLab = [[UILabel alloc]init];
    timeLab.font  = [UIFont systemFontOfSize:18.f];
    timeLab.frame = CGRectMake(120, 10, 80, 20);
    timeLab.textAlignment   = NSTextAlignmentRight;
    timeLab.backgroundColor = [UIColor clearColor];
    [showBtn addSubview:timeLab];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:1.f
                                             target:self
                                           selector:@selector(startTimer:)
                                           userInfo:nil
                                            repeats:YES];
    [timer fire];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(getOrderFromTeacher:)
                                                 name:@"OrderConfirm"
                                               object:nil];
}

- (void) sendInviteMsg
{
    if (tObj)
    {
        CLog(@"ONLY ONE Teacher");
        [self sendMessage:tObj.deviceId];
    }
    else if (teacherArray)
    {
        CLog(@"ALL Teacher");
        for (Teacher *obj in teacherArray)
        {
            [self sendMessage:obj.deviceId];
        }
    }
}

- (void) startTimer:(NSTimer *) timer
{
    if (waitTimeInvite == 0)
    {
        //更新界面...............
        timeLab.text   = @"0";
        reBtn.hidden   = NO;
        showBtn.hidden = YES;
        
        //该条件
        UIButton *cBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        cBtn.tag   = 1;
        cBtn.frame = CGRectMake(0, 0, 60, 30);
        [cBtn setTitle:@"改条件"
              forState:UIControlStateNormal];
        [cBtn addTarget:self
                 action:@selector(doButtonClicked:)
          forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:cBtn];
        return;
    }
    
    timeLab.text = [NSString stringWithFormat:@"%d", waitTimeInvite];
    waitTimeInvite--;
}

- (void) sendMessage:(NSString *)tId
{
    if (valueDic)
    {
        //个人信息
        NSData *stuData  = [[NSUserDefaults standardUserDefaults] objectForKey:STUDENT];
        Student *student = [NSKeyedUnarchiver unarchiveObjectWithData:stuData];
        
        //个人位置
        NSString *log   = [[NSUserDefaults standardUserDefaults] objectForKey:@"LONGITUDE"];
        NSString *la    = [[NSUserDefaults standardUserDefaults] objectForKey:@"LATITUDE"];
        
        //订单keyId
        NSDate *dateNow  = [NSDate date];
        NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[dateNow timeIntervalSince1970]];
        
        [[NSUserDefaults standardUserDefaults] setObject:timeSp
                                                  forKey:@"TIMESP"];
        
        //获得salary
        NSString *salary = @"";
        NSDictionary *salaryDic = [valueDic objectForKey:@"SalaryDic"];
        if (salaryDic)
        {
            if ([[salaryDic objectForKey:@"name"] isEqualToString:@"师生协商"])
                salary = @"0";
            else
                salary = [salaryDic objectForKey:@"name"];
        }
        
        //总金额
        int studyTimes = ((NSString *)[valueDic objectForKey:@"Time"]).intValue;
        NSNumber *taMount = [NSNumber numberWithInt:salary.intValue*studyTimes];
        
        //封装订单
        NSArray *keyArr = [NSArray arrayWithObjects:@"type", @"nickname", @"grade",@"gender",@"subjectId",@"teacherGender",@"tamount",@"yjfdnum",@"sd",@"iaddress",@"longitude",@"latitude",@"otherText",@"audio",@"deviceId", @"keyId", nil];
        
        NSArray *valArr = [NSArray arrayWithObjects:[NSNumber numberWithInt:PUSH_TYPE_PUSH], student.nickName, student.grade, student.gender,[valueDic objectForKey:@"Subject"],[valueDic objectForKey:@"Sex"],taMount,[valueDic objectForKey:@"Time"],[valueDic objectForKey:@"Date"],[valueDic objectForKey:@"Pos"],log,la,[valueDic objectForKey:@"Message"],[valueDic objectForKey:@"AudioPath"],[SingleMQTT getCurrentDevTopic],timeSp, nil];
        
        NSDictionary *pDic = [NSDictionary dictionaryWithObjects:valArr
                                                         forKeys:keyArr];
        NSString *jsonStr = [pDic JSONFragment];
        NSData *data      = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
        
        CLog(@"jsonStr:%@,%@", jsonStr, tId);
        session = [SingleMQTT shareInstance];
        [session.session publishData:data
                             onTopic:tId];
    }
}

#pragma mark -
#pragma mark - Custom Event
- (void) doButtonClicked:(id)sender
{
    UIButton *btn = sender;
    switch (btn.tag)
    {
        case 0:         //重发邀请
        {
            //更新界面
            self.navigationItem.rightBarButtonItem = nil;
            
            waitTimeInvite = 20;
            [timer fire];
            reBtn.hidden   = YES;
            showBtn.hidden = NO;
            
            //重发邀请
            [self sendInviteMsg];
            break;
        }
        case 1:         //改条件
        {
            [self.navigationController popViewControllerAnimated:YES];
            break;
        }
        default:
            break;
    }
}

- (void) getOrderFromTeacher:(NSNotification *) notice
{
    //个人位置
    NSString *log   = [[NSUserDefaults standardUserDefaults] objectForKey:@"LONGITUDE"];
    NSString *la    = [[NSUserDefaults standardUserDefaults] objectForKey:@"LATITUDE"];
    
    Teacher *teacher = [notice.userInfo objectForKey:@"OrderTeacher"];
    tObj = teacher;
    
    //封装iaddress_data
    NSDictionary *posDic = [valueDic objectForKey:@"POSDIC"];
    NSArray *addParamArr = [NSArray arrayWithObjects:@"name",@"type",@"latitude",@"longitude",@"provinceName",@"cityName",@"districtName",@"cityCode", nil];
    
    //没有具体区名字
    NSString *dst = @"";
    if ([valueDic objectForKey:@"DIST"])
        dst = [valueDic objectForKey:@"DIST"];
    
    NSArray *addValueArr = [NSArray arrayWithObjects:[valueDic objectForKey:@"Pos"], @"InputAddress", la, log, [posDic objectForKey:@"PROVICE"],[posDic objectForKey:@"CITY"],dst,@"0755", nil];
    NSDictionary *dic = [NSDictionary dictionaryWithObjects:addValueArr
                                                    forKeys:addParamArr];
    NSString *jsonAdd = [dic JSONFragment];
    CLog(@"jsonAdd:%@", jsonAdd);
    
    NSData *stuData  = [[NSUserDefaults standardUserDefaults] objectForKey:STUDENT];
    Student *student = [NSKeyedUnarchiver unarchiveObjectWithData:stuData];
    
    //获得salary
    NSString *salary = @"";
    NSDictionary *salaryDic = [valueDic objectForKey:@"SalaryDic"];
    if (salaryDic)
    {
        if ([[salaryDic objectForKey:@"Salary"] isEqualToString:@"师生协商"])
            salary = @"0";
        else
            salary = [salaryDic objectForKey:@"Salary"];
    }
    
    //总金额
    int studyTimes = ((NSString *)[valueDic objectForKey:@"Time"]).intValue;
    NSNumber *taMount = [NSNumber numberWithInt:salary.intValue*studyTimes];
    
    NSArray *paramsArr = [NSArray arrayWithObjects:@"subjectIndex",@"subjectId",@"subjectText",@"kcbzIndex",@"iaddress_data",@"teacher_phone",@"teacher_deviceId",@"phone",@"pushcc",@"type", @"nickname", @"grade",@"gender",@"subjectId",@"teacherGender",@"tamount",@"yjfdnum",@"sd",@"iaddress",@"longitude",@"latitude",@"otherText",@"audio",@"deviceId", @"keyId", nil];
    NSArray *valueArr = [NSArray arrayWithObjects:[valueDic objectForKey:@"Subject"],[valueDic objectForKey:@"Subject"],[Order searchSubjectName:[valueDic objectForKey:@"Subject"]],[salaryDic objectForKey:@"id"],jsonAdd,teacher.phoneNums,teacher.deviceId,student.phoneNumber,@"0",[NSNumber numberWithInt:PUSH_TYPE_PUSH], student.nickName, [Student searchGradeName:student.grade], [Student searchGenderID:student.gender],[valueDic objectForKey:@"Subject"],[Student searchGenderID:[valueDic objectForKey:@"Sex"]],taMount,[valueDic objectForKey:@"Time"],[valueDic objectForKey:@"Date"],[valueDic objectForKey:@"Pos"],log,la,@"",@"",[SingleMQTT getCurrentDevTopic], [[NSUserDefaults standardUserDefaults] objectForKey:@"TIMESP"], nil];
    NSDictionary *orderDic = [NSDictionary dictionaryWithObjects:valueArr
                                                         forKeys:paramsArr];
    NSString *jsonOrder = [orderDic JSONFragment];
    CLog(@"jsonOrder:%@", jsonOrder);
    NSString *ssid = [[NSUserDefaults standardUserDefaults] objectForKey:SSID];
    NSArray *pArr = [NSArray arrayWithObjects:@"action",@"orderInfo",@"sessid", nil];
    NSArray *vArr = [NSArray arrayWithObjects:@"submitOrder",jsonOrder,ssid, nil];
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
#pragma mark - MAMapViewDelegate
- (void) mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation
{
    [self.mapView setCenterCoordinate:userLocation.coordinate];
    self.mapView.showsUserLocation = NO;
}

- (void) mapView:(MAMapView *)mapView didFailToLocateUserWithError:(NSError *)error
{
    CLog(@"Locate User Failed");
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
        [self showAlertWithTitle:@"提示"
                             tag:0
                         message:@"订单提交成功"
                        delegate:self
               otherButtonTitles:@"确定",nil];

        //发送订单成功信息
        NSData *stuData  = [[NSUserDefaults standardUserDefaults] objectForKey:STUDENT];
        Student *student = [NSKeyedUnarchiver unarchiveObjectWithData:stuData];
        NSArray *paramsArr = [NSArray arrayWithObjects:@"type",@"status",@"phone",@"nickname",@"keyId",@"taPhone", nil];
        NSArray *valuesArr = [NSArray arrayWithObjects:[NSNumber numberWithInt:PUSH_TYPE_CONFIRM],@"success",student.phoneNumber,
                                                       student.nickName,[resDic objectForKey:@"orderid"],tObj.phoneNums, nil];
        NSDictionary *pDic = [NSDictionary dictionaryWithObjects:valuesArr forKeys:paramsArr];
        NSString *jsonDic  = [pDic JSONFragment];
        NSData *data = [jsonDic dataUsingEncoding:NSUTF8StringEncoding];
        session = [SingleMQTT shareInstance];
        [session.session publishData:data
                             onTopic:tObj.deviceId];
        CLog(@"pDic:%@", jsonDic);
        
        
        //跳转到聊天窗口
        
        //封装订单
        //没有具体区名字
        NSString *dst = @"";
        if ([valueDic objectForKey:@"DIST"])
            dst = [valueDic objectForKey:@"DIST"];
        NSString *provice = [valueDic objectForKey:@"PROVICE"];
        NSString *city    = [valueDic objectForKey:@"CITY"];
        
        NSDictionary *orderDic    = [NSDictionary dictionaryWithObjectsAndKeys:[resDic objectForKey:@"orderid"],@"oid", [valueDic objectForKey:@"Date"],@"order_addtime",[valueDic objectForKey:@"Pos"],@"order_iaddress",[valueDic objectForKey:@"Time"],@"order_jyfdnum",[valueDic objectForKey:@"Salary"],@"order_kcbz",provice,@"provinceName",city,@"cityName",dst,@"districtName",nil];

        CLog(@"order information:%@", orderDic);
        
        ChatViewController *cVctr = [[ChatViewController alloc]init];
        cVctr.tObj  = tObj;
        cVctr.order = [[Order setOrderProperty:orderDic] copy];
        [self.navigationController pushViewController:cVctr
                                             animated:YES];
        [cVctr release];
    }
    else
    {
        NSString *errorMsg = [resDic objectForKey:@"message"];
        [self showAlertWithTitle:@"提示"
                             tag:0
                         message:[NSString stringWithFormat:@"错误码%@,%@",errorid,errorMsg]
                        delegate:self
               otherButtonTitles:@"确定",nil];
        
        //发送订单成功失败
        NSData *stuData  = [[NSUserDefaults standardUserDefaults] objectForKey:STUDENT];
        Student *student = [NSKeyedUnarchiver unarchiveObjectWithData:stuData];
        NSArray *paramsArr = [NSArray arrayWithObjects:@"type",@"status",@"phone",@"nickname",@"keyId",@"taPhone", nil];
        NSArray *valuesArr = [NSArray arrayWithObjects:@"2",@"failure",student.phoneNumber,
                              student.nickName,[resDic objectForKey:@"orderid"],tObj.phoneNums, nil];
        NSDictionary *pDic = [NSDictionary dictionaryWithObjects:valuesArr forKeys:paramsArr];
        NSString *jsonDic  = [pDic JSONFragment];
        NSData *data = [jsonDic dataUsingEncoding:NSUTF8StringEncoding];
        session = [SingleMQTT shareInstance];
        [session.session publishData:data
                             onTopic:tObj.deviceId];
    }
}

@end
