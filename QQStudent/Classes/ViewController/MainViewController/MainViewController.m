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
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //初始化地图API
    [self initMapKey];
    
    //初始化UI
    [self initUI];
    
    //获得Web服务器地址
    [self getWebServerAddress];
    
    //获得帮助电话
    [self getHelpPhone];

    //版本检测
    [self checkNewVersion];

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
- (void) initUI
{
    //显示地图
    self.mapView=[[MAMapView alloc] initWithFrame:[UIView fitCGRect:CGRectMake(0, 0, 320, 460)
                                                         isBackView:NO]];
    self.mapView.showsScale = NO;
    self.mapView.delegate   = self;
    [self.view addSubview:self.mapView];
    self.mapView.showsUserLocation = YES;
    
    UIButton *gotoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [gotoBtn setImage:[UIImage imageNamed:@"loginButton1.png"]
             forState:UIControlStateNormal];
    [gotoBtn setImage:[UIImage imageNamed:@"loginButton2.png"]
             forState:UIControlStateHighlighted];
    gotoBtn.frame = [UIView fitCGRect:CGRectMake(0, 0, 40, 30)
                           isBackView:NO];
    [gotoBtn addTarget:self
                action:@selector(doGotoBtnClicked:)
      forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:gotoBtn];
    
    UIButton *searchTeacherBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [searchTeacherBtn setImage:[UIImage imageNamed:@"InviteTeacher"]
                      forState:UIControlStateNormal];
    searchTeacherBtn.frame = [UIView fitCGRect:CGRectMake(20, 360, 280, 40)
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

- (void) getWebServerAddress
{
    NSArray *paramsArr = [NSArray arrayWithObjects:@"action", nil];
    NSArray *valuesArr = [NSArray arrayWithObjects:@"lb", nil];
    NSDictionary *pDic = [NSDictionary dictionaryWithObjects:valuesArr
                                                     forKeys:paramsArr];
    
    ServerRequest *serverReq = [ServerRequest sharedServerRequest];
    serverReq.delegate = self;
    NSData *resVal     = [serverReq requestSyncWith:kServerPostRequest
                                           paramDic:pDic
                                             urlStr:ServerAddress];
    if (resVal)
    {
        NSString *resStr = [[[NSString alloc]initWithData:resVal
                                                 encoding:NSUTF8StringEncoding]autorelease];
        NSDictionary *resDic  = [resStr JSONValue];
        NSString *webAddress  = [resDic objectForKey:@"web"];
        NSString *pushAddress = [self getPushAddress:[resDic objectForKey:@"push"]];
        NSString *port = [self getPort:[resDic objectForKey:@"push"]];
        [[NSUserDefaults standardUserDefaults] setObject:webAddress
                                                  forKey:WEBADDRESS];
        [[NSUserDefaults standardUserDefaults] setObject:pushAddress
                                                  forKey:PUSHADDRESS];
        [[NSUserDefaults standardUserDefaults] setObject:port
                                                  forKey:PORT];
    }
}

- (NSString *) getPushAddress:(NSString *) str
{
    NSRange start = [str rangeOfRegex:@"//"];
//    CLog(@"start:%d %d", start.location, start.length);
    NSString *subStr = [str substringFromIndex:start.location];
    NSRange end = [subStr rangeOfRegex:@":"];
    
    NSString *pushAddress = [str substringWithRange:NSMakeRange(start.location+2, end.location-2)];
//    CLog(@"pushAddress:%@", pushAddress);
    
    return pushAddress;
}

- (NSString *) getPort:(NSString *) str
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
    CLLocationCoordinate2D  loc = self.mapView.userLocation.coordinate;
    NSString *log = [NSString stringWithFormat:@"%f", loc.longitude];
    NSString *la  = [NSString stringWithFormat:@"%f", loc.latitude];
    NSString *ssid = [[NSUserDefaults standardUserDefaults] objectForKey:SSID];
    if (ssid)
    {
        NSArray *paramsArr = [NSArray arrayWithObjects:@"action",@"latitude",@"longitude",
                              @"page",@"subjectId",@"selectXBIndex",
                              @"kcbzIndex",@"zoom",@"sessid", nil];
        NSArray *valuesArr = [NSArray arrayWithObjects:@"findNearbyTeacher",la,log,
                              @"0",@"0",@"0",
                              @"0",@"0",ssid, nil];
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
    
    _calloutMapAnnotation = [[CalloutMapAnnotation alloc]init];
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
        PersonCenterViewController *pcVctr = [[PersonCenterViewController alloc]init];
        [self.navigationController pushViewController:pcVctr animated:YES];
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
        scVctr.teacherArray = teacherArray;
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
            teacherArray = [[NSMutableArray alloc]init];
            NSArray *items = [resDic objectForKey:@"teachers"];
            for (NSDictionary *item in items)
            {
                //设置老师属性
                Teacher *tObj = [Teacher setTeacherProperty:[item copy]];
                [teacherArray addObject:tObj];
            }
            
            //添加老师地图标注
            [self initTeachersAnnotation];
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
    [self.mapView setCenterCoordinate:userLocation.coordinate];
    
    if (self.mapView.showsUserLocation)
    {
        //保存个人位置
        NSString *log = [NSString stringWithFormat:@"%f",userLocation.coordinate.longitude];
        NSString *la  = [NSString stringWithFormat:@"%f", userLocation.coordinate.latitude];
        [[NSUserDefaults standardUserDefaults] setObject:log
                                                  forKey:@"LONGITUDE"];
        [[NSUserDefaults standardUserDefaults] setObject:la
                                                  forKey:@"LATITUDE"];
        
        //更新个人位置服务器
        [self searchReGeocode:userLocation.coordinate];
        
        //搜索附近老师
        [self searchNearTeacher];
    }
    self.mapView.showsUserLocation = NO;
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
            TeacherPropertyView *tpView = [[TeacherPropertyView alloc]initWithFrame:CGRectMake(0, 0, outAnnView.contentView.frame.size.width, outAnnView.contentView.frame.size.height)];
            [outAnnView.contentView addSubview:tpView];
            tpView.headImgView.URL = tObj.headUrl;
            if (tObj.sex == 1)
            {
                tpView.introLab.text = [NSString stringWithFormat:@"%@ 男", tObj.name];
            }
            else
            {
                tpView.introLab.text = [NSString stringWithFormat:@"%@ 女", tObj.name];
            }
            tpView.tsLab.text = [NSString stringWithFormat:@"已辅导%d位学生", tObj.studentCount];
            [tObj release];
        }
        
        return outAnnView;  
    }
    return nil;
}

- (void) mapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view
{
    CustomPointAnnotation *annn = (CustomPointAnnotation*)view.annotation;
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
        _calloutMapAnnotation = [[[CalloutMapAnnotation alloc] initWithLatitude:view.annotation.coordinate.latitude andLongitude:view.annotation.coordinate.longitude] autorelease];
        _calloutMapAnnotation.teacherObj = annn.teacherObj;
        
        [self.mapView addAnnotation:_calloutMapAnnotation];
        [self.mapView setCenterCoordinate:view.annotation.coordinate
                                 animated:YES];
    }
}

- (void) mapView:(MAMapView *)mapView didDeselectAnnotationView:(MAAnnotationView *)view
{
    if (_calloutMapAnnotation&&![view isKindOfClass:[CallOutAnnotationView class]]) {
        
        if (_calloutMapAnnotation.coordinate.latitude == view.annotation.coordinate.latitude&&
            _calloutMapAnnotation.coordinate.longitude == view.annotation.coordinate.longitude) {
            [self.mapView removeAnnotation:_calloutMapAnnotation];
            _calloutMapAnnotation = nil;
        }
    }
}
@end
