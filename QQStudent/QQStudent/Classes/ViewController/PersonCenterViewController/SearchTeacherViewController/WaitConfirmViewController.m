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

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self initBackBarItem];
    
    [self initUI];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void) viewDidDisappear:(BOOL)animated
{   
    CustomNavigationViewController *nav = [MainViewController getNavigationViewController];
    nav.dataSource = nil;
    
    timer.delegate = nil;
    timer = nil;
    
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
    [timer      release];
    [cntLab     release];
    [borderView release];
    [infoView   release];
    
    [teacherArray release];
    [mapView      release];
    
    [cntTimeImageView release];
    [inviteCountLab   release];
    [super dealloc];
}

#pragma mark -
#pragma mark - Custom Action
- (void) initBottomBar
{
    cnt = 0;
    inviteCountLab = [[UILabel alloc]init];
    inviteCountLab.text = @"已邀请 0 人";
    inviteCountLab.backgroundColor = [UIColor clearColor];
    inviteCountLab.font = [UIFont systemFontOfSize:18.f];
    inviteCountLab.textColor = [UIColor whiteColor];
    inviteCountLab.frame     = CGRectMake(10, showBtn.frame.size.height/2-10, 120, 20);
    [showBtn addSubview:inviteCountLab];
    
    
    UIImage *bgImg   = [UIImage imageNamed:@"wp_time_bg"];
    cntTimeImageView = [[UIImageView alloc]initWithImage:bgImg];
    cntTimeImageView.frame = CGRectMake(showBtn.frame.size.width-bgImg.size.width/2-10,
                                        cntTimeImageView.frame.origin.y-bgImg.size.height/2,
                                        bgImg.size.width, bgImg.size.height);
    [showBtn addSubview:cntTimeImageView];
    
    
    UILabel *syLab = [[UILabel alloc]init];
    syLab.text = @"剩余";
    syLab.textAlignment = NSTextAlignmentRight;
    syLab.textColor = [UIColor whiteColor];
    syLab.font = [UIFont systemFontOfSize:18.f];
    syLab.backgroundColor = [UIColor clearColor];
    syLab.frame = CGRectMake(showBtn.frame.size.width/2-20,
                             showBtn.frame.size.height/2-10, 40, 20);
    [showBtn addSubview:syLab];
    [syLab release];
    
    cntLab = [[UILabel alloc]init];
    NSNumber *maxTime = [[NSUserDefaults standardUserDefaults] objectForKey:PUSHMAXTIME];
    cntLab.text       = [NSString stringWithFormat:@"%d",maxTime.integerValue];
    cntLab.backgroundColor = [UIColor clearColor];
    cntLab.frame      = CGRectMake(8, 10, 40, 20);
    cntLab.textColor  = [UIColor whiteColor];
    cntLab.textAlignment = NSTextAlignmentCenter;
    cntLab.font       = [UIFont systemFontOfSize:15.f];
    [cntTimeImageView addSubview:cntLab];
    
    UILabel *secondLab  = [[UILabel alloc]init];
    secondLab.textAlignment = NSTextAlignmentCenter;
    secondLab.text      = @"秒";
    secondLab.backgroundColor = [UIColor clearColor];
    secondLab.textColor = [UIColor whiteColor];
    secondLab.font      = [UIFont systemFontOfSize:15.f];
    secondLab.frame     = CGRectMake(cntTimeImageView.frame.size.width/2-10, 27, 20, 20);
    [cntTimeImageView addSubview:secondLab];
    [secondLab release];
}

- (void) initInfoPopView
{
    infoView = [[LBorderView alloc]initWithFrame:CGRectMake(30, 40,
                                                              260,
                                                              80)];
    infoView.hidden = YES;
    infoView.borderType   = BorderTypeSolid;
    infoView.dashPattern  = 8;
    infoView.spacePattern = 8;
    infoView.borderWidth  = 1;
    infoView.cornerRadius = 5;
    infoView.alpha = 0.7;
    infoView.borderColor  = [UIColor grayColor];
    infoView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:infoView];
    
    UIImage *lightImg = [UIImage imageNamed:@"wp_info_light"];
    UIImageView *lightImgView = [[UIImageView alloc]init];
    lightImgView.image = lightImg;
    lightImgView.frame = CGRectMake(15, infoView.frame.size.height/2-lightImg.size.width/2,
                                    lightImg.size.width, lightImg.size.height);
    [infoView addSubview:lightImgView];
    
    UILabel *infoLab = [[UILabel alloc]init];
    infoLab.textColor = [UIColor whiteColor];
    infoLab.text = @"找不到?也许是您的条件不对哦,薪资太低?线路太远?调一下试试!";
    infoLab.backgroundColor = [UIColor clearColor];
    infoLab.frame = CGRectMake(15+lightImg.size.width+10,infoView.frame.size.height/2-20,
                               infoView.frame.size.width-15-lightImg.size.width-10,
                               40);
    infoLab.numberOfLines = 0;
    infoLab.font = [UIFont systemFontOfSize:14.f];
    infoLab.lineBreakMode = NSLineBreakByWordWrapping;
    [infoView addSubview:infoLab];
    [infoLab release];
}

- (void) initWaitPopView
{
    borderView = [[LBorderView alloc]initWithFrame:CGRectMake(30, self.view.frame.size.height/2-100,
                                                                          260,
                                                                          200)];
    borderView.hidden = YES;
    borderView.borderType   = BorderTypeSolid;
    borderView.dashPattern  = 8;
    borderView.spacePattern = 8;
    borderView.borderWidth  = 1;
    borderView.cornerRadius = 5;
    borderView.alpha = 0.7;
    borderView.borderColor  = [UIColor grayColor];
    borderView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:borderView];
    
    UIImage *waitImg = [UIImage imageNamed:@"student_waiting"];
    UIImageView *waitImgView = [[UIImageView alloc]init];
    waitImgView.image = waitImg;
    waitImgView.frame = CGRectMake(borderView.frame.size.width/2-waitImg.size.width/4,
                                   borderView.frame.size.height/2-waitImg.size.height/4,
                                   waitImg.size.width/2,
                                   waitImg.size.height/2);
    [borderView addSubview:waitImgView];
    [waitImgView release];
    
    UILabel *titleLab = [[UILabel alloc]init];
    titleLab.text = @"轻轻小贴士";
    titleLab.textColor = [UIColor whiteColor];
    titleLab.backgroundColor = [UIColor clearColor];
    titleLab.frame = CGRectMake(10, 10, borderView.frame.size.width,
                                20);
    [borderView addSubview:titleLab];
    [titleLab release];
    
    UILabel *infoLab = [[UILabel alloc]init];
    infoLab.textColor = [UIColor whiteColor];
    infoLab.text = @"珍惜每个沟通机会,不要盲目换老师哦,下一个不一定更好!";
    infoLab.backgroundColor = [UIColor clearColor];
    infoLab.frame = CGRectMake(10,borderView.frame.size.height-60,
                               borderView.frame.size.width-20,
                               40);
    infoLab.numberOfLines = 0;
    infoLab.font = [UIFont systemFontOfSize:14.f];
    infoLab.lineBreakMode = NSLineBreakByWordWrapping;
    [borderView addSubview:infoLab];
    [infoLab release];
}

- (void) initBackBarItem
{
    CustomNavigationViewController *nav = [MainViewController getNavigationViewController];
    nav.dataSource = self;
}

- (void) initUI
{
    //显示地图
    self.mapView=[[MAMapView alloc] initWithFrame:[UIView fitCGRect:CGRectMake(0, 0, 320, 460)
                                                    isBackView:YES]];
    self.mapView.delegate = self;
    [self.view addSubview:mapView];
    
    //显示目标位置
    NSDictionary *posDic = [valueDic objectForKey:@"POSDIC"];
    NSString *latitude   = (NSString *)[posDic objectForKey:@"LATITUDE"];
    NSString *longtitude = (NSString *)[posDic objectForKey:@"LONGTITUDE"];
    CLLocationCoordinate2D loc = CLLocationCoordinate2DMake(latitude.floatValue, longtitude.floatValue);
    
    distAnn = [[[CustomPointAnnotation alloc] init]autorelease];
    distAnn.tag = 1000;
    distAnn.coordinate = loc;
    [self.mapView addAnnotation:distAnn];
    [self.mapView setCenterCoordinate:loc];
    self.mapView.showsUserLocation = NO;
    
    UIImage *showImg = [UIImage imageNamed:@"wp_bottom_btn"];
    showBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];

    [showBtn setBackgroundImage:showImg
                       forState:UIControlStateNormal];
    showBtn.userInteractionEnabled = NO;
    [showBtn addTarget:self
                action:@selector(doButtonClicked:)
      forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:showBtn];
    
    UIImage *bgImg = [UIImage imageNamed:@"sdp_resend_normal_btn"];
    reBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    reBtn.hidden  = YES;
    reBtn.tag     = 0;
    [reBtn setImage:bgImg
           forState:UIControlStateNormal];
    [reBtn setImage:[UIImage imageNamed:@"sdp_resend_hlight_btn"]
           forState:UIControlStateNormal];

    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7)
    {
        if (iPhone5)
        {
            //ios7 iphone5
            CLog(@"It's is iphone5 IOS7");
            showBtn.frame = [UIView fitCGRect:CGRectMake(20, 480-44-showImg.size.height,
                                                         showImg.size.width,
                                                         showImg.size.height)
                                   isBackView:NO];
            reBtn.frame = [UIView fitCGRect:CGRectMake(20, 480-44-bgImg.size.height,
                                                       bgImg.size.width, bgImg.size.height)
                                 isBackView:NO];
        }
        else
        {
            CLog(@"It's is iphone4 IOS7");
            //ios 7 iphone 4
            showBtn.frame = [UIView fitCGRect:CGRectMake(20, 480-44-showImg.size.height,
                                                         showImg.size.width,
                                                         showImg.size.height)
                                   isBackView:NO];
            reBtn.frame = [UIView fitCGRect:CGRectMake(20, 480-44-bgImg.size.height,
                                                       bgImg.size.width, bgImg.size.height)
                                 isBackView:NO];
        }
    }
    else
    {
        if (!iPhone5)
        {
            // ios 6 iphone4
            CLog(@"It's is iphone4 IOS6");
            showBtn.frame = [UIView fitCGRect:CGRectMake(20, 480-54-showImg.size.height,
                                                         showImg.size.width,
                                                         showImg.size.height)
                                   isBackView:NO];
            reBtn.frame = [UIView fitCGRect:CGRectMake(20, 480-54-bgImg.size.height,
                                                       bgImg.size.width, bgImg.size.height)
                                 isBackView:NO];
            
        }
        else
        {
            //ios 6 iphone5
            CLog(@"It's is iphone5 IOS6");
            showBtn.frame = [UIView fitCGRect:CGRectMake(20, 480-44-showImg.size.height,
                                                         showImg.size.width,
                                                         showImg.size.height)
                                   isBackView:NO];
            reBtn.frame = [UIView fitCGRect:CGRectMake(20, 480-44-bgImg.size.height,
                                                       bgImg.size.width, bgImg.size.height)
                                 isBackView:NO];
        }
    }
    [reBtn addTarget:self
                action:@selector(doButtonClicked:)
      forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:reBtn];
    
    [self initBottomBar];
    [self initWaitPopView];
    [self initInfoPopView];
    
    isLast     = NO;
    curPage    = 1;
    timeTicker = 0;
    
    teacherArray = [[NSMutableArray alloc]init];
    if (!tObj)
    {
        [self searchNearTeacher];
    }
    else
    {
        [self sendInviteMsg];
    }
    
    //如果不是搜索页面,进入则搜索附近老师,并发送订单信息
    NSNumber *maxWaitTime = [[NSUserDefaults standardUserDefaults] objectForKey:PUSHMAXTIME];
    timer = [[ThreadTimer alloc]init];
    timer.delegate = self;
    [timer setMinutesNum:maxWaitTime.integerValue];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                         selector:@selector(getOrderFromTeacher:)
                                             name:@"OrderConfirm"
                                           object:nil];
}

- (void) seandInviteOffLineMsg:(NSString *) taPhone
{
    if (![AppDelegate isConnectionAvailable:YES withGesture:NO])
    {
        return;
    }
    
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
    borderView.hidden = NO;
    if (tObj)
    {
        cnt++; //邀请人数
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
        cnt += teacherArray.count;
        for (Teacher *obj in teacherArray)
        {
            CLog(@"The Teahcer is OffLine:%@", obj.phoneNums);
            if (obj.isIos && !obj.isOnline)
            {
                [self seandInviteOffLineMsg:obj.phoneNums];
            }
            else
            {
                [self sendMessage:obj.deviceId];
            }
        }
    }
    else
        CLog(@"Teacher array is NULL");
    
    inviteCountLab.text = [NSString stringWithFormat:@"已邀请 %d 人", cnt];
}

- (void) searchNearTeacher
{
    if (![AppDelegate isConnectionAvailable:YES withGesture:NO])
    {
        return;
    }
    
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
        
        NSDictionary *posDic = [valueDic objectForKey:@"POSDIC"];
        NSString *latitude   = [posDic objectForKey:@"LATITUDE"];
        NSString *longtitude = [posDic objectForKey:@"LONGTITUDE"];
        
        NSArray *paramsArr = [NSArray arrayWithObjects:@"action",@"latitude",@"longitude",
                              @"page",@"subjectId",@"selectXBIndex",
                              @"kcbzIndex",@"zoom",@"sd",@"sessid", nil];
        NSArray *valuesArr = [NSArray arrayWithObjects:@"findNearbyTeacher",latitude,longtitude,
                              [NSNumber numberWithInt:curPage],[valueDic objectForKey:@"Subject"],[valueDic objectForKey:@"Sex"],
                              salary,[NSNumber numberWithFloat:self.mapView.zoomLevel],[valueDic objectForKey:@"Date"],ssid, nil];
        NSDictionary *pDic = [NSDictionary dictionaryWithObjects:valuesArr
                                                         forKeys:paramsArr];
        CLog(@"upload params:%@", pDic);
        NSString *webAddress = [[NSUserDefaults standardUserDefaults] objectForKey:WEBADDRESS];
        if (!webAddress)
        {
            CustomNavigationViewController *nav = [MainViewController getNavigationViewController];
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:nav.view
                                                      withText:@"服务器地址不可用"
                                                      animated:YES
                                                      delegate:NULL];
            [hud hide:YES afterDelay:3];
            return;
        }
        NSString *url = [NSString stringWithFormat:@"%@%@", webAddress,STUDENT];
    
        ServerRequest *request = [ServerRequest sharedServerRequest];
        request.delegate = self;
        [request requestASyncWith:kServerPostRequest
                         paramDic:pDic
                           urlStr:url];
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
        CLog(@"salaryDic:%@", salaryDic);
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
        
        NSArray *valArr = [NSArray arrayWithObjects:[NSNumber numberWithInt:PUSH_TYPE_PUSH], student.nickName, [Student searchGradeName:student.grade], student.gender, [valueDic objectForKey:@"Subject"],[valueDic objectForKey:@"Sex"],taMount,[valueDic objectForKey:@"Time"],[valueDic objectForKey:@"Date"],[valueDic objectForKey:@"Pos"],log,la,msg,audioPath,[SingleMQTT getCurrentDevTopic],timeSp, nil];
        
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
        session = [SingleMQTT shareInstance];
        [session.session publishData:data
                             onTopic:tId];
        
        //初始化抢单状态
        [[NSUserDefaults standardUserDefaults] setBool:NO
                                                forKey:IS_ORDER_CONFIRM];
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
            reBtn.hidden    = YES;
            infoView.hidden = YES;
            showBtn.hidden  = NO;
            borderView.hidden = NO;
            
            //重新计数
            NSNumber *maxWaitTime = [[NSUserDefaults standardUserDefaults] objectForKey:PUSHMAXTIME];
            cntLab.text = [NSString stringWithFormat:@"%d", maxWaitTime.intValue];
            [timer setMinutesNum:maxWaitTime.integerValue];
            
            //重发邀请
            [self searchNearTeacher];
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
    if (![AppDelegate isConnectionAvailable:YES withGesture:NO])
    {
        return;
    }
    
    //个人位置
    NSString *log   = [[NSUserDefaults standardUserDefaults] objectForKey:@"LONGITUDE"];
    NSString *la    = [[NSUserDefaults standardUserDefaults] objectForKey:@"LATITUDE"];
    
    tObj = [[notice.userInfo objectForKey:@"OrderTeacher"] copy];
    
    //封装iaddress_data
    NSDictionary *posDic = [valueDic objectForKey:@"POSDIC"];
    NSArray *addParamArr = [NSArray arrayWithObjects:@"name",@"type",@"latitude",
                            @"longitude", @"provinceName",@"cityName",
                            @"districtName",@"cityCode", nil];
    //没有具体区名字
    NSString *dst = @"";
    if ([valueDic objectForKey:@"DIST"])
        dst = [valueDic objectForKey:@"DIST"];
    
    NSArray *addValueArr = [NSArray arrayWithObjects:[valueDic objectForKey:@"Pos"], @"InputAddress", la, log,
                            [posDic objectForKey:@"PROVICE"],
                            [posDic objectForKey:@"CITY"],
                            dst,@"0755", nil];
    NSDictionary *addressDic = [NSDictionary dictionaryWithObjects:addValueArr
                                                           forKeys:addParamArr];
    
    
    
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
            salary = [[salaryDic objectForKey:@"name"] copy];
    }
    
    //总金额
    int studyTimes = ((NSString *)[valueDic objectForKey:@"Time"]).intValue;
    NSNumber *taMount = [NSNumber numberWithInt:(salary.intValue*studyTimes)];
    NSArray *paramsArr = [NSArray arrayWithObjects:@"subjectIndex",@"subjectId",@"subjectText",@"kcbzIndex",@"iaddress_data",@"teacher_phone",@"teacher_deviceId",@"phone",@"pushcc",@"type", @"nickname", @"grade",@"gender",@"subjectId",@"teacherGender",@"tamount",@"yjfdnum",@"sd",@"iaddress",@"longitude",@"latitude",@"otherText",@"audio",@"deviceId", @"keyId", nil];
    NSArray *valueArr = [NSArray arrayWithObjects:[valueDic objectForKey:@"Subject"],[valueDic objectForKey:@"Subject"],[Student searchSubjectName:[valueDic objectForKey:@"Subject"]],salary,addressDic,tObj.phoneNums,tObj.deviceId,student.phoneNumber,@"0",[NSNumber numberWithInt:PUSH_TYPE_PUSH], student.nickName, [Student searchGradeName:student.grade], [Student searchGenderID:student.gender],[valueDic objectForKey:@"Subject"],[Student searchGenderID:[valueDic objectForKey:@"Sex"]],taMount,[valueDic objectForKey:@"Time"],[valueDic objectForKey:@"Date"],[valueDic objectForKey:@"Pos"],log,la,@"",@"",[SingleMQTT getCurrentDevTopic], [[NSUserDefaults standardUserDefaults] objectForKey:@"TIMESP"], nil];
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
    if (!webAddress)
    {
        CustomNavigationViewController *nav = [MainViewController getNavigationViewController];
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:nav.view
                                                  withText:@"服务器地址不可用"
                                                  animated:YES
                                                  delegate:NULL];
        [hud hide:YES afterDelay:3];
        return;
    }
    NSString *url = [NSString stringWithFormat:@"%@%@", webAddress,STUDENT];
    [serverReq requestASyncWith:kServerPostRequest
                       paramDic:pDic
                         urlStr:url];
}

- (void) doBackBtnClicked:(id)sender
{
    CustomNavigationViewController *nav = [MainViewController getNavigationViewController];
    NSArray *ctrsArr = nav.viewControllers;
    for (UIViewController *ctr in ctrsArr)
    {
        if ([ctr isKindOfClass:[MainViewController class]])
        {
            [nav popToViewController:ctr animated:YES];
            break;
        }
        
    }
}

- (void) initTeachersAnnotation
{
    for (Teacher *teacherObj in teacherArray)
    {
        CustomPointAnnotation *ann = [[[CustomPointAnnotation alloc] init]autorelease];
        ann.coordinate = CLLocationCoordinate2DMake(teacherObj.latitude.floatValue,
                                                    teacherObj.longitude.floatValue);

        ann.teacherObj = teacherObj;
        [self.mapView addAnnotation:ann];
    }
}

#pragma mark -
#pragma mark - WaitMaskViewDelegate
- (void) shareClicked:(WaitMaskView *)view
{
    view.hidden = YES;
    
    //跳转到分享页面
    CustomNavigationViewController *nav = [MainViewController getNavigationViewController];
    [nav popToRootViewControllerAnimated:NO];
    
    
    MyTeacherViewController *mVctr = [[MyTeacherViewController alloc]init];
    UINavigationController *navMvctr = [[UINavigationController alloc]initWithRootViewController:mVctr];
    
    LatlyViewController *lVctr = [[LatlyViewController alloc]init];
    UINavigationController *navLVctr = [[UINavigationController alloc]initWithRootViewController:lVctr];
    
    SearchTeacherViewController *sVctr = [[SearchTeacherViewController alloc]init];
    UINavigationController *navSVctr = [[UINavigationController alloc]initWithRootViewController:sVctr];
    
    ShareViewController *shareVctr = [[ShareViewController alloc]initWithNibName:nil
                                                                          bundle:nil];
    UINavigationController *navShareVctr = [[UINavigationController alloc]initWithRootViewController:shareVctr];
    
    SettingViewController *setVctr = [[SettingViewController alloc]initWithNibName:nil
                                                                            bundle:nil];
    UINavigationController *navSetVctr = [[UINavigationController alloc]initWithRootViewController:setVctr];
    
    
    NSMutableDictionary *imgDic = [NSMutableDictionary dictionaryWithCapacity:3];
    [imgDic setObject:[UIImage imageNamed:@"s_1_1"]
               forKey:@"Default"];
    [imgDic setObject:[UIImage imageNamed:@"s_1_2"]
               forKey:@"Highlighted"];
    [imgDic setObject:[UIImage imageNamed:@"s_1_2"]
               forKey:@"Seleted"];
    NSMutableDictionary *imgDic2 = [NSMutableDictionary dictionaryWithCapacity:3];
    [imgDic2 setObject:[UIImage imageNamed:@"s_2_1"]
                forKey:@"Default"];
    [imgDic2 setObject:[UIImage imageNamed:@"s_2_2"]
                forKey:@"Highlighted"];
    [imgDic2 setObject:[UIImage imageNamed:@"s_2_2"]
                forKey:@"Seleted"];
    NSMutableDictionary *imgDic3 = [NSMutableDictionary dictionaryWithCapacity:3];
    [imgDic3 setObject:[UIImage imageNamed:@"s_3_1"]
                forKey:@"Default"];
    [imgDic3 setObject:[UIImage imageNamed:@"s_3_2"]
                forKey:@"Highlighted"];
    [imgDic3 setObject:[UIImage imageNamed:@"s_3_2"]
                forKey:@"Seleted"];
    NSMutableDictionary *imgDic4 = [NSMutableDictionary dictionaryWithCapacity:3];
    [imgDic4 setObject:[UIImage imageNamed:@"s_4_1"]
                forKey:@"Default"];
    [imgDic4 setObject:[UIImage imageNamed:@"s_4_2"]
                forKey:@"Highlighted"];
    [imgDic4 setObject:[UIImage imageNamed:@"s_4_2"]
                forKey:@"Seleted"];
    NSMutableDictionary *imgDic5 = [NSMutableDictionary dictionaryWithCapacity:3];
    [imgDic5 setObject:[UIImage imageNamed:@"s_5_1"]
                forKey:@"Default"];
    [imgDic5 setObject:[UIImage imageNamed:@"s_5_2"]
                forKey:@"Highlighted"];
    [imgDic5 setObject:[UIImage imageNamed:@"s_5_2"]
                forKey:@"Seleted"];
    NSMutableArray *ctrlArr = [NSMutableArray arrayWithObjects:navMvctr,navLVctr,navSVctr,navShareVctr,navSetVctr,nil];
    
    NSArray *imgArr = [NSArray arrayWithObjects:imgDic,imgDic3,imgDic2,
                       imgDic4,imgDic5,nil];
    
    PersonCenterViewController *pcVctr = [[PersonCenterViewController alloc]
                                          initWithViewControllers:ctrlArr
                                          imageArray:imgArr];

    nav.dataSource = pcVctr;
    pcVctr.order   = order;
    [nav pushViewController:pcVctr
                   animated:YES];
    [pcVctr setSelectedIndex:3];
    [pcVctr release];
}

- (void) timeOutView:(WaitMaskView *)view
{
    view.hidden = YES;
    
    //跳转到聊天界面
    ChatViewController *cVctr = [[ChatViewController alloc]init];
    cVctr.tObj  = tObj;
    cVctr.order = order;
    [self.navigationController pushViewController:cVctr
                                         animated:YES];
    [cVctr release];
}

#pragma mark -
#pragma mark - ThreadTimer Delegate
- (void) secondResponse:(ThreadTimer *)tmpTimer
{
    if (tmpTimer.totalSeconds == 0)
    {
        reBtn.hidden      = NO;
        showBtn.hidden    = YES;
        borderView.hidden = YES;
        infoView.hidden   = NO;
        
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
    
    cntLab.text = [NSString stringWithFormat:@"%d", tmpTimer.totalSeconds];
    
    if (!tObj)
    {
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
#pragma mark - MAMapViewDelegate
- (void) mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation
{
    CLog(@"enter update user location");
}

- (void) mapView:(MAMapView *)mapView didFailToLocateUserWithError:(NSError *)error
{
    CLog(@"Locate User Failed");
}

- (MAAnnotationView*)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *pointReuseIndetifier = @"pointReuseIndetifier";
        CustomPointAnnotation *cpAnn = (CustomPointAnnotation *) annotation;
        if (cpAnn.tag == 1000)
        {
            MAAnnotationView *annView = (MAAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndetifier];
            if (annView == nil)
            {
                annView = [[[MAAnnotationView alloc] initWithAnnotation:annotation
                                                        reuseIdentifier:pointReuseIndetifier]autorelease];
            }
            annView.image = [UIImage imageNamed:@"my_location_icon"];
            return annView;
        }
        else
        {
            TTCustomAnnotationView *annView = (TTCustomAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndetifier];
            if (annView == nil)
            {
                annView = [[TTCustomAnnotationView alloc] initWithAnnotation:annotation
                                                             reuseIdentifier:pointReuseIndetifier];
            }
            return annView;
        }
    }
    
    return nil;
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
        NSString *action = [[resDic objectForKey:@"action"] copy];
        if ([action isEqualToString:@"findNearbyTeacher"])
        {
            NSArray *items = [resDic objectForKey:@"teachers"];
            if (items.count>0)
            {
                //删除老师
                [teacherArray removeAllObjects];

                CLog(@"Cur Page Teachers:%@", items);
                for (NSDictionary *item in items)
                {
                    //设置老师属性
                    Teacher *obj = [Teacher setTeacherProperty:item];
                    [teacherArray addObject:obj];
                }
                                
                //显示在地图上
                [self initTeachersAnnotation];
                
                //发送邀请
                [self sendInviteMsg];
            }
            else
            {
                CLog(@"The Last Page");
                //已经是最后一页
                isLast = YES;
            }
        }
        else
        {
            //发送订单成功信息
            NSString *orderId  = [[resDic objectForKey:@"orderid"] copy];
            NSData *stuData    = [[NSUserDefaults standardUserDefaults] objectForKey:STUDENT];
            Student *student   = [NSKeyedUnarchiver unarchiveObjectWithData:stuData];
            NSArray *paramsArr = [NSArray arrayWithObjects:@"type",@"deviceId",@"status",@"phone",@"nickname",@"keyId",@"taPhone", nil];
            NSArray *valuesArr = [NSArray arrayWithObjects:[NSNumber numberWithInt:PUSH_TYPE_CONFIRM],[SingleMQTT getCurrentDevTopic],@"success",student.phoneNumber,
                                                           student.nickName,orderId,tObj.phoneNums, nil];
            NSDictionary *pDic = [NSDictionary dictionaryWithObjects:valuesArr
                                                             forKeys:paramsArr];
            NSString *jsonDic  = [pDic JSONFragment];
            NSData *data = [jsonDic dataUsingEncoding:NSUTF8StringEncoding];
            session = [SingleMQTT shareInstance];
            [session.session publishData:data
                                 onTopic:tObj.deviceId];
            
            //保存抢单状态
            [[NSUserDefaults standardUserDefaults] setBool:YES
                                                    forKey:IS_ORDER_CONFIRM];
            
            /**
             *跳转到聊天窗口
             */
            order = [Order setOrderProperty:[resDic objectForKey:@"order"]];
            order.teacher = tObj;
            
            //显示跳转图层
            NSNumber *maxWaitTime = [[NSUserDefaults standardUserDefaults] objectForKey:PUSHMAXTIME];
            int second = maxWaitTime.integerValue - timer.totalSeconds;

            CustomNavigationViewController *nav = [MainViewController getNavigationViewController];
            WaitMaskView *wmView = [[WaitMaskView alloc]initWithFrame:[UIScreen getCurrentBounds]];
            wmView.delegate = self;
            wmView.second = [NSString stringWithFormat:@"%d", second];
            wmView.tObj   = tObj;
            [nav.view addSubview:wmView];
            [wmView release];
        }
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
        
        //发送订单成功失败
        NSData *stuData    = [[NSUserDefaults standardUserDefaults] objectForKey:STUDENT];
        Student *student   = [NSKeyedUnarchiver unarchiveObjectWithData:stuData];
        NSArray *paramsArr = [NSArray arrayWithObjects:@"type",@"status",@"phone",@"nickname",
                              @"keyId",@"taPhone", nil];
       
        NSString *oid = @"";
        if ([resDic objectForKey:@"orderid"])
            oid = [resDic objectForKey:@"orderid"];
        
        NSArray *valuesArr = [NSArray arrayWithObjects:[NSNumber numberWithInt:PUSH_TYPE_CONFIRM],@"failure",student.phoneNumber,
                              student.nickName,oid,tObj.phoneNums, nil];
        NSDictionary *pDic = [NSDictionary dictionaryWithObjects:valuesArr
                                                         forKeys:paramsArr];
        NSString *jsonDic  = [pDic JSONFragment];
        NSData *data = [jsonDic dataUsingEncoding:NSUTF8StringEncoding];
        session = [SingleMQTT shareInstance];
        [session.session publishData:data
                             onTopic:tObj.deviceId];
    }
}

@end
