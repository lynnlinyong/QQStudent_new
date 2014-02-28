//
//  MainViewController.m
//  QQStudent
//
//  Created by lynn on 14-1-28.
//  Copyright (c) 2014年 lynn. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController
@synthesize mapView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //设置Title
    [MainViewController setNavTitle:@"轻轻家教"];
    
    [self initBackBarItem];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    teacherArray = [[NSMutableArray alloc]init];
    
    //初始化地图API
    [self initMapKey];
    
    //初始化UI
    [self initUI];
    
    //获取终端设置属性
    [self setTerminalMapProperty];
    
    //获得Web服务器地址
    [MainViewController getWebServerAddress];
    
    //获得帮助电话
    [self getHelpPhone];

//    //版本检测
//    [self checkNewVersion];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewDidUnload
{
    [annArray removeAllObjects];
    [teacherArray removeAllObjects];
    self.mapView.delegate = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [super viewDidUnload];
}

- (void) dealloc
{
    [appurl release];
    [search release];
    [annArray release];
    [teacherArray release];
    [self.mapView release];
    [super dealloc];
}

#pragma mark -
#pragma mark - Custom Action
- (void) initBackBarItem
{
    CustomNavigationViewController *nav = (CustomNavigationViewController *) [MainViewController getNavigationViewController];
    nav.dataSource = nil;
}

- (void) initUI
{
    _calloutMapAnnotation = [[CalloutMapAnnotation alloc]init];

    //显示地图
    NSDictionary *tpDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"TERMINAL_PROPERTY"];
    int updateMeters = 10;
    float zooms = 13;
    if (tpDic)
    {
        zooms = ((NSNumber *)[tpDic objectForKey:@"mapzoom"]).floatValue;
        updateMeters = ((NSNumber *)[tpDic objectForKey:@"uplocationNumber"]).intValue;
    }
    
    self.mapView = [[MAMapView alloc] initWithFrame:[UIView fitCGRect:CGRectMake(0, 0,
                                                                                 320, 480)
                                                           isBackView:YES]];
    self.mapView.showsScale = NO;
    self.mapView.delegate   = self;
    self.mapView.distanceFilter  = updateMeters;//10米位置更新到服务器
    self.mapView.headingFilter   = 180;
    if (updateMeters<100)
        self.mapView.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    else if (updateMeters>100 && updateMeters<1000)
        self.mapView.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    else if (updateMeters>1000 && updateMeters<3000)
        self.mapView.desiredAccuracy = kCLLocationAccuracyKilometer;
    else
        self.mapView.desiredAccuracy = kCLLocationAccuracyThreeKilometers;
    [self.mapView setZoomLevel:zooms];
    self.mapView.showsUserLocation = YES;
    [self.view addSubview:self.mapView];
    
    UIImage *navImg   = [UIImage imageNamed:@"main_nav_normal_btn@2x"];
    UIButton *navBtn  = [UIButton buttonWithType:UIButtonTypeCustom];
    [navBtn setImage:navImg
            forState:UIControlStateNormal];
    [navBtn setImage:[UIImage imageNamed:@"main_nav_hlight_btn@2x"]
            forState:UIControlStateHighlighted];
    navBtn.frame = [UIView fitCGRect:CGRectMake(0, 0,
                                                navImg.size.width,
                                                navImg.size.height)
                           isBackView:NO];
    [navBtn addTarget:self
                action:@selector(doGotoBtnClicked:)
      forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:navBtn];
    
    UIButton *searchTeacherBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [searchTeacherBtn setImage:[UIImage imageNamed:@"main_st_normal_btn"]
                      forState:UIControlStateNormal];
    [searchTeacherBtn setImage:[UIImage imageNamed:@"main_st_hlight_btn"]
                      forState:UIControlStateHighlighted];
    searchTeacherBtn.frame = [UIView fitCGRect:CGRectMake(20, 460-48-44, 280, 44)
                                    isBackView:NO];
    [searchTeacherBtn addTarget:self
                         action:@selector(doSearchBtnClicked:)
               forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:searchTeacherBtn];
    
    //注册确定下载新版本消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(gotoDownLoad:)
                                                 name:@"gotoDownLoad"
                                               object:nil];
    //注册取消下载新版本消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(cancelDownLoad:)
                                                 name:@"cancelDownLoad"
                                               object:nil];
}

- (void) setTerminalMapProperty
{
    NSDictionary *tpDic= [[NSUserDefaults standardUserDefaults] objectForKey:@"TERMINAL_PROPERTY"];
    if (!tpDic)
    {
        NSArray *paramsArr = [NSArray arrayWithObjects:@"action", nil];
        NSArray *valuesArr = [NSArray arrayWithObjects:@"getMapZoom", nil];
        NSDictionary *pDic = [NSDictionary dictionaryWithObjects:valuesArr
                                                         forKeys:paramsArr];
        
        NSString *webAdd   = [[NSUserDefaults standardUserDefaults] objectForKey:WEBADDRESS];
        NSString *url      = [NSString stringWithFormat:@"%@%@", webAdd, STUDENT];
        ServerRequest *serverReq = [ServerRequest sharedServerRequest];
        NSData *resVal     = [serverReq requestSyncWith:kServerPostRequest
                                               paramDic:pDic
                                                 urlStr:url];
        NSString *resStr = [[[NSString alloc]initWithData:resVal
                                                 encoding:NSUTF8StringEncoding]autorelease];
        NSDictionary *resDic  = [resStr JSONValue];
        if (resDic)
        {
            CLog(@"Map ResDic:%@", resDic);
            
            //保存终端设置
            [[NSUserDefaults standardUserDefaults] setObject:resDic
                                                      forKey:@"TERMINAL_PROPERTY"];
            
            //显示默认中心
            NSString *lg = [tpDic objectForKey:@"longitude"];
            NSString *la = [tpDic objectForKey:@"latitude"];
            self.mapView.centerCoordinate = CLLocationCoordinate2DMake(la.floatValue,
                                                                       lg.floatValue);
            //更新个人位置服务器
            [self searchReGeocode:self.mapView.centerCoordinate];
            meAnn.coordinate = self.mapView.centerCoordinate;
            
            //搜索附近老师
            [self searchNearTeacher];
        }
        else
        {
            CLog(@"setTerminalProperty failed!");
        }
    }
    else
    {
        CLog(@"setTerminalProperty Haved Success!");
    }
}

+ (void) setNavTitle:(NSString *) title
{
    BOOL isSet = NO;
    CustomNavigationViewController *nav = (CustomNavigationViewController *)[MainViewController getNavigationViewController];
    NSArray *subArray = [nav.navigationBar subviews];
    for (UIView *view in subArray)
    {
        if (view.tag == 1010)   //Title View
        {
            UILabel *titleLab = (UILabel *)view;
            titleLab.text     = title;
            isSet = YES;
        }
    }
    if (!isSet)
    {
        UILabel *titleLab     = [[UILabel alloc] initWithFrame:CGRectMake(160-100, 22-15, 200, 30)];
        titleLab.tag             = 1010;
        titleLab.font            = [UIFont systemFontOfSize:18.f];
        titleLab.textColor       = [UIColor colorWithHexString:@"#009f66"];
        titleLab.backgroundColor = [UIColor clearColor];
        titleLab.textAlignment = UITextAlignmentCenter;
        titleLab.text = @"轻轻家教";
        [nav.navigationBar addSubview:titleLab];
        [title release];
    }
}

+ (CustomNavigationViewController *) getNavigationViewController
{
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    return (CustomNavigationViewController *)app.window.rootViewController;
}

+ (void) getWebServerAddress
{
    NSArray *paramsArr = [NSArray arrayWithObjects:@"action", nil];
    NSArray *valuesArr = [NSArray arrayWithObjects:@"lb", nil];
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
        CLog(@"resDic:%@", resDic);
        if (resDic)
        {
            NSString *webAddress  = [resDic objectForKey:@"web"];
            NSString *pushAddress = [MainViewController getPushAddress:[resDic objectForKey:@"push"]];
            NSString *port = [MainViewController getPort:[resDic objectForKey:@"push"]];
            NSString *pushMaxTime = [resDic objectForKey:@"pushMaxTime"];
            NSString *pushPageTime= [resDic objectForKey:@"pushPageTime"];
            
            [[NSUserDefaults standardUserDefaults] setObject:webAddress
                                                      forKey:WEBADDRESS];
            [[NSUserDefaults standardUserDefaults] setObject:pushAddress
                                                      forKey:PUSHADDRESS];
            [[NSUserDefaults standardUserDefaults] setObject:port
                                                      forKey:PORT];
            [[NSUserDefaults standardUserDefaults] setObject:pushMaxTime
                                                      forKey:PUSHMAXTIME];
            [[NSUserDefaults standardUserDefaults] setObject:pushPageTime
                                                      forKey:PUSHPAGETIME];
        }
    }
    else
    {
        CLog(@"getWebAddress failed!");
    }
}

+ (NSString *) getPushAddress:(NSString *) str
{
    NSRange start = [str rangeOfRegex:@"//"];
//    CLog(@"start:%d %d", start.location, start.length);
    NSString *subStr = [str substringFromIndex:start.location];
    NSRange end = [subStr rangeOfRegex:@":"];
    
    NSString *pushAddress = [str substringWithRange:NSMakeRange(start.location+2, end.location-2)];
//    CLog(@"pushAddress:%@", pushAddress);
    
    return pushAddress;
}

+ (NSString *) getPort:(NSString *) str
{
    NSRange start = [str rangeOfRegex:@"//"];
    //    CLog(@"start:%d %d", start.location, start.length);
    NSString *subStr = [str substringFromIndex:start.location];
    NSRange end = [subStr rangeOfRegex:@":"];
    NSString *port = [subStr substringFromIndex:end.location+1];
    
    return port;
}

- (void) getHelpPhone
{
    NSString *helpPhone = [[NSUserDefaults standardUserDefaults] objectForKey:HELP_PHONE];
    if (!helpPhone)
    {
        NSString *idString  = [SingleMQTT getCurrentDevTopic];
        NSArray *paramsArr  = [NSArray arrayWithObjects:@"action",@"deviceId", nil];
        NSArray *valusArr   = [NSArray arrayWithObjects:@"getCSPhone",idString,nil];
        NSDictionary *pDic  = [NSDictionary dictionaryWithObjects:valusArr
                                                         forKeys:paramsArr];
        ServerRequest *serverReq = [ServerRequest sharedServerRequest];
        serverReq.delegate = self;
        NSString *webAddress = [[NSUserDefaults standardUserDefaults] valueForKey:WEBADDRESS];
        NSString *url = [NSString stringWithFormat:@"%@%@/", webAddress,STUDENT];
        [serverReq requestASyncWith:kServerPostRequest
                           paramDic:pDic
                             urlStr:url];
    }
}

- (void) uploadPosToServer:(NSString *) posName
{
    CLLocationCoordinate2D  loc = self.mapView.userLocation.coordinate;
    NSString *log = [NSString stringWithFormat:@"%f", loc.longitude];
    NSString *la  = [NSString stringWithFormat:@"%f", loc.latitude];
    
    //地理编码获得地址
    NSString *ssid = [[NSUserDefaults standardUserDefaults] objectForKey:SSID];
    if (ssid)
    {
        NSArray *paramsArr = [NSArray arrayWithObjects:@"action",@"longitude",@"latitude",
                              @"acode",@"address",@"sessid", nil];
        NSArray *valuesArr = [NSArray arrayWithObjects:@"uplocation",log,la,
                              @"0755",posName,ssid, nil];
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
}

- (void)searchReGeocode:(CLLocationCoordinate2D) loc
{
    AMapReGeocodeSearchRequest *regeoRequest = [[AMapReGeocodeSearchRequest alloc] init];
    regeoRequest.searchType = AMapSearchType_ReGeocode;
    regeoRequest.location = [AMapGeoPoint locationWithLatitude:loc.latitude
                                                     longitude:loc.longitude];
    regeoRequest.radius = 10000;
    regeoRequest.requireExtension = YES;
    [search AMapReGoecodeSearch:regeoRequest];
}

- (void) searchNearTeacher
{
    CLLocationCoordinate2D  loc = self.mapView.centerCoordinate;
    NSString *log  = [NSString stringWithFormat:@"%f", loc.longitude];
    NSString *la   = [NSString stringWithFormat:@"%f", loc.latitude];
    NSString *ssid = [[NSUserDefaults standardUserDefaults] objectForKey:SSID];
    if (ssid)
    {
        NSArray *paramsArr = [NSArray arrayWithObjects:@"action",@"latitude",@"longitude",
                              @"page",@"subjectId",@"selectXBIndex",
                              @"kcbzIndex",@"zoom",@"sessid", nil];
        NSArray *valuesArr = [NSArray arrayWithObjects:@"findNearbyTeacher",la,log,
                              @"1",@"0",@"0",
                              @"0",[NSNumber numberWithFloat:self.mapView.zoomLevel],ssid, nil];
        NSDictionary *pDic = [NSDictionary dictionaryWithObjects:valuesArr
                                                         forKeys:paramsArr];
        
        NSString *webAddress = [[NSUserDefaults standardUserDefaults] objectForKey:WEBADDRESS];
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

- (void) initMapKey
{
    [MAMapServices sharedServices].apiKey = (NSString *)MAP_API_KEY;
    search = [[AMapSearchAPI alloc]initWithSearchKey:(NSString *)MAP_API_KEY
                                            Delegate:self];
}

- (void) initTeachersAnnotation
{
    annArray = [[NSMutableArray alloc]init];
    for (Teacher *teacherObj in teacherArray)
    {
        CustomPointAnnotation *ann = [[[CustomPointAnnotation alloc] init]autorelease];
        ann.coordinate = CLLocationCoordinate2DMake(teacherObj.latitude.floatValue, teacherObj.longitude.floatValue);
        ann.teacherObj = teacherObj;
        [annArray addObject:ann];
    }
    [self.mapView addAnnotations:annArray];
}

- (BOOL) isLogin
{
    BOOL login = [[NSUserDefaults standardUserDefaults] boolForKey:LOGINE_SUCCESS];
    if (login)
    {
        return YES;
    }
    
    return NO;
}

- (void) checkNewVersion
{
    NSString *webAdd = [[NSUserDefaults standardUserDefaults] objectForKey:WEBADDRESS];
    NSString *url  = [NSString stringWithFormat:@"%@/%@", webAdd,STUDENT];
    NSString *ssid = [[NSUserDefaults standardUserDefaults] objectForKey:SSID];
    if (ssid)
    {
        NSArray *paramsArr = [NSArray arrayWithObjects:@"action",@"sessid",nil];
        NSArray *valuesArr = [NSArray arrayWithObjects:@"versionCheck",ssid,nil];
        NSDictionary *pDic = [NSDictionary dictionaryWithObjects:valuesArr
                                                         forKeys:paramsArr];
        ServerRequest *serverReq = [ServerRequest sharedServerRequest];
        serverReq.delegate = self;
        [serverReq requestASyncWith:kServerPostRequest
                           paramDic:pDic
                             urlStr:url];
    }
}

- (void) doGotoBtnClicked:(id)sender
{
    //判断是否登录
    if (![self isLogin])
    {
        LoginViewController *loginVctr = [[LoginViewController alloc]init];
        [self.navigationController pushViewController:loginVctr animated:YES];
        [loginVctr release];
    }
    else
    {
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
//        [MainViewController setNavBackButton:pcVctr parentVctr:self];
        [self.navigationController pushViewController:pcVctr
                                             animated:YES];
        [pcVctr release];
    }
}

- (void) doSearchBtnClicked:(id)sender
{
    if (![self isLogin])
    {
        LoginViewController *loginVctr = [[LoginViewController alloc]init];
        [self.navigationController pushViewController:loginVctr animated:YES];
        [loginVctr release];
    }
    else
    {
        SearchConditionViewController *scVctr = [[SearchConditionViewController alloc]init];
//        scVctr.teacherArray = teacherArray;
        [self.navigationController pushViewController:scVctr
                                             animated:YES];
        [scVctr release];
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
        NSString *action = [resDic objectForKey:@"action"];
        if ([action isEqualToString:@"getCSPhone"])
        {
            NSString *helpPhone = [resDic objectForKey:@"message"];
            CLog(@"helpPhone:%@", helpPhone);
            [[NSUserDefaults standardUserDefaults] setObject:helpPhone
                                                      forKey:HELP_PHONE];
        }
        else if ([action isEqualToString:@"versionCheck"])
        {
            //对比版本号
            NSString *newVersion = [resDic objectForKey:@"version"];
            
            //当前版本
            NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
            NSString *oldVersion   = [infoDict objectForKey:@"CFBundleVersion"];
            CLog(@"oldVersion:%@, newVersion:%@", oldVersion, newVersion);
            if (newVersion.integerValue > oldVersion.integerValue)
            {
                //获得最新app下载地址
                appurl = [[resDic objectForKey:@"appurl"] retain];

                //提示下载
                DownloadInfoViewController *diVctr = [[DownloadInfoViewController alloc]init];
                [self presentPopupViewController:diVctr
                                   animationType:MJPopupViewAnimationFade];
            }
            
            NSDictionary *versionDic = [NSDictionary dictionaryWithObjectsAndKeys:newVersion,@"Version",
                                             appurl,@"AppURL", nil];
            [[NSUserDefaults standardUserDefaults] setObject:versionDic
                                                      forKey:APP_VERSION];
        }
        else if ([action isEqualToString:@"findNearbyTeacher"])
        {
            NSArray *items = [resDic objectForKey:@"teachers"];
            for (NSDictionary *item in items)
            {
                //设置老师属性
                Teacher *tObj = [Teacher setTeacherProperty:item];
                [teacherArray addObject:tObj];
            }
            
            //添加老师地图标注
            [self initTeachersAnnotation];
            
            //删除我的位置标注
            if (self.mapView.overlays.count>0)
            {
                [self.mapView removeAnnotation:self.mapView.userLocation];
                [self.mapView removeOverlay:self.mapView.overlays[0]];
            }
        }
        else if ([action isEqualToString:@"uplocation"])
        {
            CLog(@"Upload Location Success!");
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
    }
}

#pragma mark -
#pragma mark - AMapSearchDelegate
- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request
                     response:(AMapReGeocodeSearchResponse *)response;
{
    NSString *posName = response.regeocode.formattedAddress;
    [self uploadPosToServer:posName];
}

#pragma mark -
#pragma mark - Notice
- (void) gotoDownLoad:(NSNotification *) notice
{    
    //跳转去下载
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:appurl]];
   [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
}

- (void) cancelDownLoad:(NSNotification *) notice
{
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
}

#pragma mark -
#pragma mark - MAMapViewDelegate
- (void) mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation
{
    //添加个人位置标注,选择地点标注
    if (!meAnn)
    {
        meAnn = [[[CustomPointAnnotation alloc] init]autorelease];
        meAnn.tag = 1000;
        [self.mapView addAnnotation:meAnn];
    }
    
    if (updatingLocation)
    {
        [self.mapView setCenterCoordinate:userLocation.coordinate];
        meAnn.coordinate = userLocation.location.coordinate;
        
        //保存个人位置
        NSString *log = [NSString stringWithFormat:@"%f",userLocation.coordinate.longitude];
        NSString *la  = [NSString stringWithFormat:@"%f", userLocation.coordinate.latitude];
        [[NSUserDefaults standardUserDefaults] setObject:log
                                                  forKey:LONGITUDE];
        [[NSUserDefaults standardUserDefaults] setObject:la
                                                  forKey:LATITUDE];

        CLog(@"New Loc:%@,%@", log, la);
        //更新个人位置服务器
        [self searchReGeocode:userLocation.coordinate];
    
        //搜索附近老师
        [self searchNearTeacher];
    }
}

- (void) mapView:(MAMapView *)mapView didFailToLocateUserWithError:(NSError *)error
{
    CLog(@"Locate User Failed");
    
    //显示默认中心
    NSDictionary *tpDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"TERMINAL_PROPERTY"];
    if (tpDic)
    {
        NSString *lg = [tpDic objectForKey:@"longitude"];
        NSString *la = [tpDic objectForKey:@"latitude"];
        self.mapView.centerCoordinate = CLLocationCoordinate2DMake(la.floatValue,
                                                                   lg.floatValue);
    }
    
    //更新个人位置服务器
    [self searchReGeocode:self.mapView.centerCoordinate];
    meAnn.coordinate = self.mapView.centerCoordinate;
    
    //搜索附近老师
    [self searchNearTeacher];
}

- (void) mapView:(MAMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{   
    //获得市、区、街道的缩放级别
    NSDictionary *tpDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"TERMINAL_PROPERTY"];
    if (tpDic)
    {
        float cityZooms   = ((NSNumber *)[tpDic objectForKey:@"cityZoom"]).floatValue;
        float distZooms   = ((NSNumber *)[tpDic objectForKey:@"districtZoom"]).floatValue;
        float streatZooms = ((NSNumber *)[tpDic objectForKey:@"streetZoom"]).floatValue;
        
        float cityFilter  = ((NSNumber *)[tpDic objectForKey:@"mapCityDistance"]).floatValue;
        float distFilter  = ((NSNumber *)[tpDic objectForKey:@"mapDistrictDistance"]).floatValue;
        float streatFilter= ((NSNumber *)[tpDic objectForKey:@"mapStreetDistance"]).floatValue;
        CLog(@"city:%f dist:%f streat:%f", cityZooms, distZooms, streatZooms);
        
        //重新设置地图的缩放级别
        if (self.mapView.zoomLevel<cityZooms)
            self.mapView.distanceFilter = cityFilter;
        else if ((self.mapView.zoomLevel>cityZooms)&&(self.mapView.zoomLevel<streatZooms))
            self.mapView.distanceFilter = distFilter;
        else
            self.mapView.distanceFilter = streatFilter;
        
        float updateMeters = self.mapView.distanceFilter;
        if (updateMeters<100)
            self.mapView.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
        else if (updateMeters>100 && updateMeters<1000)
            self.mapView.desiredAccuracy = kCLLocationAccuracyHundredMeters;
        else if (updateMeters>1000 && updateMeters<3000)
            self.mapView.desiredAccuracy = kCLLocationAccuracyKilometer;
        else
            self.mapView.desiredAccuracy = kCLLocationAccuracyThreeKilometers;
    }
    //搜索附近老师
    [self searchNearTeacher];
    
    [self.mapView removeAnnotation:self.mapView.userLocation];
    [self.mapView removeOverlays:self.mapView.overlays];
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
                annView = [[MAAnnotationView alloc] initWithAnnotation:annotation
                                                       reuseIdentifier:pointReuseIndetifier];
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
    //            annView.canShowCallout = YES;    //设置气泡可以弹出,默认为NO
    //            annView.draggable      = YES;    //设置标注可以拖动,默认为NO
            }
            return annView;
        }
    }
    else if ([annotation isKindOfClass:[CalloutMapAnnotation class]])
    {
        //此时annotation就是我们calloutview的annotation
        CalloutMapAnnotation *ann = (CalloutMapAnnotation*)annotation;
        
        //如果可以重用
        CallOutAnnotationView *outAnnView = (CallOutAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:@"calloutview"];
        
        //否则创建新的calloutView
        if (!outAnnView) {
            outAnnView = [[[CallOutAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"calloutview"] autorelease];
            
            Teacher *tObj = [ann.teacherObj copy];
            TeacherPropertyView *tpView = [[TeacherPropertyView alloc]initWithFrame:CGRectMake(0,
                                                                                               0,
                                                                                               outAnnView.contentView.frame.size.width,
                                                                                               outAnnView.contentView.frame.size.height)];
            tpView.tObj = [tObj copy];
            tpView.delegate = self;
            [outAnnView.contentView addSubview:tpView];
            [tObj release];
        }
        
        return outAnnView;  
    }
    return nil;
}

- (void) mapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view
{
    CustomPointAnnotation *annn = (CustomPointAnnotation*)view.annotation;
    if (annn == meAnn)     //我的位置
        return;
    
    if ([view.annotation isKindOfClass:[MAPointAnnotation class]]) {
        //如果点到了这个marker点，什么也不做
        if (_calloutMapAnnotation.coordinate.latitude == view.annotation.coordinate.latitude&&
            _calloutMapAnnotation.coordinate.longitude == view.annotation.coordinate.longitude) {
            return;
        }
        
        //如果当前显示着calloutview，又触发了select方法，删除这个calloutview annotation
        if (_calloutMapAnnotation) {
            [self.mapView removeAnnotation:_calloutMapAnnotation];
            _calloutMapAnnotation=nil;
            
        }
        
        //创建搭载自定义calloutview的annotation
        CLog(@"Old:%f,%f", view.annotation.coordinate.latitude,view.annotation.coordinate.longitude)
        _calloutMapAnnotation = [[CalloutMapAnnotation alloc] initWithLatitude:view.annotation.coordinate.latitude andLongitude:view.annotation.coordinate.longitude];
        _calloutMapAnnotation.teacherObj = annn.teacherObj;
        
        [self.mapView addAnnotation:_calloutMapAnnotation];
        [self.mapView setCenterCoordinate:view.annotation.coordinate
                                 animated:YES];
    }
}

- (void) mapView:(MAMapView *)mapView didDeselectAnnotationView:(MAAnnotationView *)view
{
    if (_calloutMapAnnotation &&![view isKindOfClass:[CallOutAnnotationView class]]) {
        CLog(@"%f,%f  %f,%f", _calloutMapAnnotation.latitude,_calloutMapAnnotation.longitude, view.annotation.coordinate.latitude,view.annotation.coordinate.longitude);
        if (_calloutMapAnnotation.latitude == view.annotation.coordinate.latitude&&
            _calloutMapAnnotation.longitude == view.annotation.coordinate.longitude) {
            [self.mapView removeAnnotation:_calloutMapAnnotation];
            _calloutMapAnnotation = nil;
        }
    }
}
@end
