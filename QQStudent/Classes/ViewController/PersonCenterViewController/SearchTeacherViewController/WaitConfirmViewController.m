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
    
    [self initBackBarItem];
    
    [self initUI];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void) viewDidDisappear:(BOOL)animated
{
    [timer invalidate];
    timer = nil;
    timeLab.text   = @"";
    waitTimeInvite = 20;
    
    CustomNavigationViewController *nav = (CustomNavigationViewController *)[MainViewController getNavigationViewController];
    nav.dataSource = nil;
    
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
- (void) initBackBarItem
{
    CustomNavigationViewController *nav = (CustomNavigationViewController *) [MainViewController getNavigationViewController];
    nav.dataSource = self;
}

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
    
    isLast     = NO;
    curPage    = 0;
    timeTicker = 0;
    waitTimeInvite = 20;//((NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:PUSHMAXTIME]).intValue;
    
    teacherArray = [[NSMutableArray alloc]init];
    
    //搜索附近老师
    [self searchNearTeacher];
    
    CLog(@"getValuesDic:%@", valueDic);
    
    timer      = [NSTimer scheduledTimerWithTimeInterval:1.f
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

- (void) seandInviteOffLineMsg:(NSString *) taPhone
{
    NSString *jsonStr  = [self packageJsonStr];
    if (jsonStr)
    {
        NSString *ssid     = [[NSUserDefaults standardUserDefaults] objectForKey:SSID];
        NSArray *paramsArr = [NSArray arrayWithObjects:@"action",@"toPhone",@"pushMessage",@"sessid", nil];
        NSArray *valuesArr = [NSArray arrayWithObjects:@"pushMessageTeacher",taPhone,jsonStr,ssid, nil];
        NSDictionary *pDic = [NSDictionary dictionaryWithObjects:valuesArr
                                                         forKeys:paramsArr];
        ServerRequest *serverReq = [ServerRequest sharedServerRequest];
        NSData *resVal     = [serverReq requestSyncWith:kServerPostRequest
                                               paramDic:pDic
                                                 urlStr:ServerAddress];
        if (resVal)
        {
            NSString *resStr = [[[NSString alloc]initWithData:resVal
                                                     encoding:NSUTF8StringEncoding]autorelease];
            NSDictionary *resDic  = [resStr JSONValue];
            if (resDic)
            {
                NSString *eerid = [[resDic objectForKey:@"errorid"] copy];
                if (eerid.intValue==0)
                {
                    CLog(@"Send Online Message Success!");
                }
                else
                {
                    CLog(@"Send Online Message Failed!");
                }
            }
        }
        else
        {
            CLog(@"getWebAddress failed!");
        }
    }
}

- (void) sendInviteMsg
{
    if (tObj)
    {
        CLog(@"ONLY ONE Teacher");
        if (tObj.isIos && !tObj.isOnline)
        {
            CLog(@"The Teahcer is OffLine:%@", tObj.phoneNums);
            [self seandInviteOffLineMsg:tObj.phoneNums];
        }
        else
        {
            [self sendMessage:tObj.deviceId];
        }
    }
    else if (teacherArray)
    {
        CLog(@"ALL Teacher");
        for (Teacher *obj in teacherArray)
        {
            CLog(@"The Teahcer is OffLine:%@", tObj.phoneNums);
            if (tObj.isIos && !tObj.isOnline)
            {
                [self seandInviteOffLineMsg:tObj.phoneNums];
            }
            else
            {
                [self sendMessage:obj.deviceId];
            }
        }
    }
    else
        CLog(@"Teacher array is NULL");
}

- (void) startTimer:(NSTimer *) timer
{
    if (waitTimeInvite == 0)
    {
        //更新界面...............
        timeLab.text   = @"0";
        reBtn.hidden   = NO;
        showBtn.hidden = YES;
        
        UIImage *shareImg  = [UIImage imageNamed:@"sp_share_btn_normal"];
        UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        shareBtn.tag = 1;
        [shareBtn setTitle:@"改条件"
                  forState:UIControlStateNormal];
        shareBtn.titleLabel.font = [UIFont systemFontOfSize:14.f];
        [shareBtn setBackgroundImage:shareImg
                            forState:UIControlStateNormal];
        [shareBtn setBackgroundImage:[UIImage imageNamed:@"sp_share_btn_hlight"]
                            forState:UIControlStateHighlighted];
        shareBtn.frame = CGRectMake(0, 0,
                                    shareImg.size.width,
                                    shareImg.size.height);
        [shareBtn addTarget:self
                     action:@selector(doButtonClicked:)
           forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:shareBtn];
        return;
    }
    
    timeLab.text = [NSString stringWithFormat:@"%d", waitTimeInvite];
    waitTimeInvite--;
    
    //间隔5秒钟请求新的一页
    timeTicker++;
    int pageTime = ((NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:PUSHPAGETIME]).intValue;
    if (timeTicker==pageTime && !isLast)
    {
        timeTicker = 0;
        curPage++;
        [self searchNearTeacher];
    }
}

- (void) searchNearTeacher
{
    //删除老师
    [teacherArray removeAllObjects];
    
    NSString *log  = [[NSUserDefaults standardUserDefaults] objectForKey:LONGITUDE];
    NSString *la   = [[NSUserDefaults standardUserDefaults] objectForKey:LATITUDE];
    NSString *ssid = [[NSUserDefaults standardUserDefaults] objectForKey:SSID];
    if (ssid)
    {
        //获得salary
        NSString *salary = @"";
        NSDictionary *salaryDic = [valueDic objectForKey:@"SalaryDic"];
        if (salaryDic)
        {
            salary = [salaryDic objectForKey:@"name"];
        }
        
        NSArray *paramsArr = [NSArray arrayWithObjects:@"action",@"latitude",@"longitude",
                              @"page",@"subjectId",@"selectXBIndex",
                              @"kcbzIndex",@"zoom",@"sessid", nil];
        NSArray *valuesArr = [NSArray arrayWithObjects:@"findNearbyTeacher",la,log,
                              [NSNumber numberWithInt:curPage],[valueDic objectForKey:@"Subject"],[valueDic objectForKey:@"Sex"],
                              salary,[NSNumber numberWithFloat:self.mapView.zoomLevel],ssid, nil];
        NSDictionary *pDic = [NSDictionary dictionaryWithObjects:valuesArr
                                                         forKeys:paramsArr];
        CLog(@"pDic:%@", pDic);
        NSString *webAddress = [[NSUserDefaults standardUserDefaults] objectForKey:WEBADDRESS];
        NSString *url = [NSString stringWithFormat:@"%@%@", webAddress,STUDENT];
        ServerRequest *request = [ServerRequest sharedServerRequest];
        request.delegate = self;
        NSData *resData  = [request requestSyncWith:kServerPostRequest
                                             paramDic:pDic
                                               urlStr:url];
        if (resData)
        {
            NSString *resStr = [[[NSString alloc]initWithData:resData
                                                     encoding:NSUTF8StringEncoding]autorelease];
            NSDictionary *resDic  = [resStr JSONValue];
            NSArray *items = [resDic objectForKey:@"teachers"];
            if (items.count>0)
            {
                CLog(@"Cur Page Teachers:%@", items);
                for (NSDictionary *item in items)
                {
                    //设置老师属性
                    Teacher *obj = [Teacher setTeacherProperty:[item copy]];
                    [teacherArray addObject:obj];
                    
                    //发送邀请
                    [self sendInviteMsg];
                }
            }
            else
            {
                CLog(@"The Last Page");
                //已经是最后一页
                isLast = YES;
            }
        }
    }
    else
    {
        [self.mapView removeAnnotation:self.mapView.userLocation];
        [self.mapView removeOverlays:self.mapView.overlays];
    }
}

- (NSString *) packageJsonStr
{
    NSString *jsonStr = nil;
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
        CLog(@"validDIC:%@, %@", valueDic,[[valueDic objectForKey:@"AudioPath"] copy]);
        
        //总金额
        int studyTimes = ((NSString *)[valueDic objectForKey:@"Time"]).intValue;
        NSNumber *taMount = [NSNumber numberWithInt:salary.intValue*studyTimes];
        
        //封装订单
        NSArray *keyArr = [NSArray arrayWithObjects:@"type", @"nickname", @"grade",@"gender",@"subjectId",@"teacherGender",@"tamount",@"yjfdnum",@"sd",@"iaddress",@"longitude",@"latitude",@"otherText",@"audio",@"deviceId", @"keyId", nil];
        
        NSString *msg = [valueDic objectForKey:@"Message"];
        if (!msg)
            msg = @"";
        
        NSString *audioPath = [valueDic objectForKey:@"AudioPath"];
        if (!audioPath)
            audioPath = @"";
        
        NSArray *valArr = [NSArray arrayWithObjects:[NSNumber numberWithInt:PUSH_TYPE_PUSH], student.nickName, student.grade, student.gender,[valueDic objectForKey:@"Subject"],[valueDic objectForKey:@"Sex"],taMount,[valueDic objectForKey:@"Time"],[valueDic objectForKey:@"Date"],[valueDic objectForKey:@"Pos"],log,la,msg,audioPath,[SingleMQTT getCurrentDevTopic],timeSp, nil];
        
        NSDictionary *pDic = [NSDictionary dictionaryWithObjects:valArr
                                                         forKeys:keyArr];
        jsonStr = [pDic JSONFragment];
    }
    return jsonStr;
}

- (void) sendMessage:(NSString *)tId
{
    NSString *jsonStr = [self packageJsonStr];
    if (jsonStr)
    {
        NSData *data = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
        
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
    CLog(@"valueDic:%@", valueDic);
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

- (void) doBackBtnClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark - CustomNavigationDataSource
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
    titleLab.text     = @"放弃";
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
