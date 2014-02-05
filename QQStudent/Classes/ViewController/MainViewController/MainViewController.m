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
    
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
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

#pragma mark -
#pragma mark - Custom Action
- (void) initUI
{
    UIButton *gotoBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [gotoBtn setTitle:@"跳转"
             forState:UIControlStateNormal];
    gotoBtn.frame = CGRectMake(110, 100, 100, 40);
    [gotoBtn addTarget:self
                action:@selector(doGotoBtnClicked:)
      forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *searchTeacherBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [searchTeacherBtn setTitle:@"我要找家教"
                      forState:UIControlStateNormal];
    searchTeacherBtn.frame = CGRectMake(110, 160, 100, 40);
    [searchTeacherBtn addTarget:self
                         action:@selector(doSearchBtnClicked:)
               forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:gotoBtn];
    [self.view addSubview:searchTeacherBtn];
    
    //注册确定下载新版本消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(gotoDownLoad:) name:@"gotoDownLoad"
                                               object:nil];
    //注册取消下载新版本消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(cancelDownLoad:) name:@"cancelDownLoad"
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
        NSString *pushAddress = [resDic objectForKey:@"push"];
        
        [[NSUserDefaults standardUserDefaults] setValue:webAddress
                                                 forKey:WEBADDRESS];
        [[NSUserDefaults standardUserDefaults] setValue:pushAddress
                                                 forKey:PUSHADDRESS];
    }
}

- (void) getHelpPhone
{
    NSString *helpPhone = [[NSUserDefaults standardUserDefaults] objectForKey:HELP_PHONE];
    if (!helpPhone)
    {
        NSString *idString  = [[UIDevice currentDevice] uniqueIdentifier];
        NSArray *paramsArr  = [NSArray arrayWithObjects:@"action",@"deviceId", nil];
        NSArray *valusArr   = [NSArray arrayWithObjects:@"getCSPhone",idString,nil];
        NSDictionary *pDic  = [NSDictionary dictionaryWithObjects:valusArr
                                                         forKeys:paramsArr];
        ServerRequest *serverReq = [ServerRequest sharedServerRequest];
        serverReq.delegate = self;
        NSString *webAddress = [[NSUserDefaults standardUserDefaults] valueForKey:WEBADDRESS];
        NSString *url = [NSString stringWithFormat:@"%@/%@/", webAddress,STUDENT];
        [serverReq requestASyncWith:kServerPostRequest
                           paramDic:pDic
                             urlStr:url];
    }
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
        [self.navigationController pushViewController:scVctr animated:YES];
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
    NSString *resStr = [[[NSString alloc]initWithData:resVal
                                             encoding:NSUTF8StringEncoding]autorelease];
    NSDictionary *resDic   = [resStr JSONValue];
//    NSArray      *keysArr  = [resDic allKeys];
//    NSArray      *valsArr  = [resDic allValues];
//
//    CLog(@"***********Result****************");
//    for (int i=0; i<keysArr.count; i++)
//    {
//        CLog(@"%@=%@", [keysArr objectAtIndex:i], [valsArr objectAtIndex:i]);
//    }
//    CLog(@"***********Result****************");
    
    NSNumber *errorid = [resDic objectForKey:@"errorid"];
    if (errorid.intValue == 0)
    {
        NSString *action = [resDic objectForKey:@"action"];
        if ([action isEqualToString:@"getCSPhone"])
        {
            NSString *helpPhone = [resDic objectForKey:@"message"];
            [[NSUserDefaults standardUserDefaults] setObject:helpPhone
                                                      forKey:HELP_PHONE];
        }
        else if ([action isEqualToString:@"pushMessageTeacher"])
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
                appurl = [resDic objectForKey:@"appurl"];
                
                //提示下载
                DownloadInfoViewController *diVctr = [[DownloadInfoViewController alloc]init];
                [self presentPopupViewController:diVctr
                                   animationType:MJPopupViewAnimationFade];
                [diVctr release];
            }
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
#pragma mark - Notice
- (void) gotoDownLoad:(NSNotification *) notice
{
    //跳转去下载
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:appurl]];
    [self dismissModalViewControllerAnimated:YES];
}

- (void) cancelDownLoad:(NSNotification *) notice
{
    [self dismissModalViewControllerAnimated:YES];
}
@end
