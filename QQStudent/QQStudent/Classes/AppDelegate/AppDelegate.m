//
//  AppDelegate.m
//  QQStudent
//
//  Created by lynn on 14-1-23.
//  Copyright (c) 2014年 lynn. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (void)dealloc
{
    [_window release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    CLog(@"%s", __func__);
    //注册设备推送通知
    [[UIApplication sharedApplication]registerForRemoteNotificationTypes:
                                                         (UIRemoteNotificationTypeAlert |
                                                          UIRemoteNotificationTypeBadge |
                                                          UIRemoteNotificationTypeSound)];
    
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    UIViewController *pVctr = nil;
    if ([self isFirstLauncher])
    {
        SplashViewController *spVctr = [[[SplashViewController alloc]init]autorelease];
        pVctr = spVctr;
    }
    else
    {
        MainViewController *mVctr     = [[[MainViewController alloc]init]autorelease];
        CustomNavigationViewController *nVctr = [[[CustomNavigationViewController alloc]initWithRootViewController:mVctr]autorelease];
        pVctr = nVctr;
    }
    
    //ios5设置NavBar背景图片
    [self isIos5ToUpdateNav];
    
    self.window.rootViewController = pVctr;
    self.window.backgroundColor = [[UIColor whiteColor] retain];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.

    //离线更新
    [self updateLoginStatus:0];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    CLog(@"%s", __func__);
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    CLog(@"%s", __func__);
    
    //清除消息中心消息
    [[UIApplication sharedApplication ] setApplicationIconBadgeNumber:0];
    
    //获得Web服务器地址
    [MainViewController getWebServerAddress];
    
    //初始化MQTT服务器
    [self initMQTTServer];
    
    //获取未读消息列表
    [self getPushMessage];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        //上线更新
        [self updateLoginStatus:1];
        
        dispatch_async(dispatch_get_main_queue(), ^{
        });
    });

    //向微信注册
    [WXApi registerApp:WeiXinAppID withDescription:@"QQ_Student_IOS v1.0"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(closeNoticeWall:)
                                                 name:@"closeNoticeWall"
                                               object:nil];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return  [WXApi handleOpenURL:url delegate:self];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    BOOL isSuc = [WXApi handleOpenURL:url delegate:self];
    CLog(@"url %@ isSuc %d",url,isSuc == YES ? 1 : 0);
    return  isSuc;
}

#pragma mark -
#pragma mark - Custom Action
- (void) closeNoticeWall:(NSNotification *) notice
{
    CustomNavigationViewController *nav = [MainViewController getNavigationViewController];
    [nav dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
}

- (void) getPushMessage
{
    if (![AppDelegate isConnectionAvailable:YES withGesture:NO])
    {
        return;
    }
    
    NSString *webAdd = [[NSUserDefaults standardUserDefaults] objectForKey:WEBADDRESS];
    if (!webAdd)
    {
        CustomNavigationViewController *nav = [MainViewController getNavigationViewController];
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:nav.view
                                                  withText:@"服务器地址不可用"
                                                  animated:YES
                                                  delegate:NULL];
        [hud hide:YES afterDelay:3];
        return;
    }
    
    NSString *ssid = [[NSUserDefaults standardUserDefaults] objectForKey:SSID];
    if (ssid)
    {
        NSArray *paramsArray = [NSArray arrayWithObjects:@"action",@"sessid", nil];
        NSArray *valuesArray = [NSArray arrayWithObjects:@"getPushMessage",ssid,nil];
        
        NSDictionary *pDic     = [NSDictionary dictionaryWithObjects:valuesArray
                                                             forKeys:paramsArray];
        ServerRequest *request = [ServerRequest sharedServerRequest];
        request.delegate = self;
        NSString *url = [NSString stringWithFormat:@"%@%@", webAdd,STUDENT];
        [request requestASyncWith:kServerPostRequest
                         paramDic:pDic
                           urlStr:url];
    }
}

- (void) updateLoginStatus:(int) isBackgroud
{
    if (![AppDelegate isConnectionAvailable:YES withGesture:NO])
    {
        return;
    }
    
    //判断是否显示试听和聘请
    NSString *ssid = [[NSUserDefaults standardUserDefaults] objectForKey:SSID];
    if (ssid)
    {
        NSArray *paramsArr = [NSArray arrayWithObjects:@"action",@"online",@"sessid", nil];
        NSArray *valusArr  = [NSArray arrayWithObjects:@"updateLoginStatus",[NSNumber numberWithInt:isBackgroud],ssid, nil];
        NSDictionary *pDic = [NSDictionary dictionaryWithObjects:valusArr
                                                         forKeys:paramsArr];
        
        ServerRequest *request = [ServerRequest sharedServerRequest];
        NSString *webAddress   = [[NSUserDefaults standardUserDefaults] valueForKey:WEBADDRESS];
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
        NSString *url  = [NSString stringWithFormat:@"%@%@", webAddress,STUDENT];
        NSData *resVal = [request requestSyncWith:kServerPostRequest
                                         paramDic:pDic
                                           urlStr:url];
        if (resVal)
        {
            NSString *resStr = [[[NSString alloc]initWithData:resVal
                                                     encoding:NSUTF8StringEncoding]autorelease];
            NSDictionary *resDic  = [resStr JSONValue];
            CLog(@"updateLoginStatus:%@", resDic);
            NSString *action = [resDic objectForKey:@"action"];
            if ([action isEqualToString:@"updateLoginStatus"])
            {
                CLog(@"Update Login Status Success!");
            }
            else
            {
                CLog(@"Update Login Status Failed!");
            }
        }
    }
}

- (void) initMQTTServer
{
    if ([AppDelegate isConnectionAvailable:YES withGesture:NO])
    {
        return;
    }
    
    //连接MQTT服务器
    SingleMQTT *session = [SingleMQTT shareInstance];
    [SingleMQTT connectServer];
    [session.session setDelegate:self];
}

- (void) tapGestureResponse:(UIGestureRecognizer *)reg
{
    MBProgressHUD *hud = (MBProgressHUD *)reg.view;
    [hud removeFromSuperview];
    [hud release];
    hud = nil;
}

+ (BOOL) isConnectionAvailable:(BOOL) animated withGesture:(BOOL) isCan
{
    BOOL isExistenceNetwork = YES;
    Reachability *reach = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    switch ([reach currentReachabilityStatus]) {
        case NotReachable:
            isExistenceNetwork = NO;
            CLog(@"notReachable");
            break;
        case ReachableViaWiFi:
            isExistenceNetwork = YES;
            CLog(@"WIFI");
            break;
        case ReachableViaWWAN:
            isExistenceNetwork = YES;
            CLog(@"3G");
            break;
    }
    
    if (!isExistenceNetwork && animated)
    {
        if (!isCan)
        {
            CustomNavigationViewController *nav = [MainViewController getNavigationViewController];
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:nav.view
                                                      withText:@"当前网络不可用"
                                                      animated:YES
                                                      delegate:NULL];
            [hud hide:YES afterDelay:3];
        }
        return NO;
    }
    
    return isExistenceNetwork;
}

- (BOOL) isFirstLauncher
{
    BOOL isFirst = [[NSUserDefaults standardUserDefaults] boolForKey:LAUNCHERED];
    if (isFirst)
    {
        //表示不是第一次启动软件
        return NO;
    }

    //表示第一次启动软件
    [[NSUserDefaults standardUserDefaults] setBool:YES
                                            forKey:LAUNCHERED];
    
    return YES;
}

- (void) isIos5ToUpdateNav
{
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 50000
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"nav_top_bg"]
                                       forBarMetrics:UIBarMetricsDefault];
//    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
//        self.window.frame = CGRectMake(0,20,self.window.frame.size.width,self.window.frame.size.height-20);
//        CLog(@"windows:%f,%f", self.window.frame.size.height,self.window.frame.size.width);
//    }
#endif
}

+ (void) popToMainViewController
{
    CustomNavigationViewController *nav = [MainViewController getNavigationViewController];
    for (UIViewController *ctr in nav.viewControllers)
    {
        if ([ctr isKindOfClass:[MainViewController class]])
        {
            [nav popToViewController:ctr animated:YES];
            break;
        }
    }
}

+ (BOOL) isInView:(NSString *) vctrName
{
    BOOL isIn = NO;
    
    CustomNavigationViewController *vctr = [MainViewController getNavigationViewController];
    
    UIViewController *lastVctr = [vctr.viewControllers objectAtIndex:vctr.viewControllers.count-1];
    if ([lastVctr isKindOfClass:NSClassFromString(vctrName)])
    {
        isIn = YES;
    }
    
    return isIn;
}

+(void) dealWithMessage:(NSDictionary *)msgDic isPlayVoice:(BOOL) isPlay
{    
    //解析MQTT接收消息
    int msgType = ((NSString *)[msgDic objectForKey:@"type"]).intValue;
    switch (msgType)
    {
        case PUSH_TYPE_APPLY:       //接收到老师抢单信息
        {
            //添加到联系人,订单.等待老师确认。
            Teacher *tObj  = [[Teacher alloc]init];
            tObj.deviceId  = [msgDic objectForKey:@"deviceId"];
            tObj.sex       = ((NSNumber *) [msgDic objectForKey:@"gender"]).intValue;
            tObj.headUrl   = [msgDic objectForKey:@"icon"];
            tObj.idNums    = [msgDic objectForKey:@"idnumber"];
            tObj.info      = [msgDic objectForKey:@"info"];
            tObj.name      = [msgDic objectForKey:@"nickname"];
            tObj.phoneNums = [msgDic objectForKey:@"phone"];
            tObj.comment   = ((NSNumber *) [msgDic objectForKey:@"stars"]).intValue;
            tObj.studentCount = ((NSNumber *) [msgDic objectForKey:@"students"]).intValue;
            tObj.pf = [msgDic objectForKey:@"subjectText"];
            
            //获得是否已经抢单
            BOOL isConfirm = [[NSUserDefaults standardUserDefaults] boolForKey:IS_ORDER_CONFIRM];
            if (!isConfirm)
            {
                NSDictionary *infoDic = [[NSDictionary alloc]initWithObjectsAndKeys:tObj,@"OrderTeacher",nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"OrderConfirm"
                                                                    object:nil
                                                                  userInfo:infoDic];
            }
            else
            {
                //发送订单失败信息
                NSString *orderId  = [[msgDic objectForKey:@"keyId"] copy];
                NSData *stuData    = [[NSUserDefaults standardUserDefaults] objectForKey:STUDENT];
                Student *student   = [NSKeyedUnarchiver unarchiveObjectWithData:stuData];
                NSArray *paramsArr = [NSArray arrayWithObjects:@"type",@"status",@"phone",
                                      @"nickname",@"keyId",@"taPhone", nil];
                NSArray *valuesArr = [NSArray arrayWithObjects:[NSNumber numberWithInt:PUSH_TYPE_CONFIRM],@"failure",
                                      student.phoneNumber,
                                      student.nickName,orderId,tObj.phoneNums, nil];
                NSDictionary *pDic = [NSDictionary dictionaryWithObjects:valuesArr
                                                                 forKeys:paramsArr];
                NSString *jsonDic  = [pDic JSONFragment];
                NSData *data = [jsonDic dataUsingEncoding:NSUTF8StringEncoding];
                
                //发送抢单失败消息
                SingleMQTT *session = [SingleMQTT shareInstance];
                [session.session publishData:data
                                     onTopic:tObj.deviceId];
            }
            break;
        }
        case PUSH_TYPE_CONFIRM:     //确认老师的确认消息
        {
            break;
        }
        case PUSH_TYPE_IMAGE:       //接收到图片消息
        case PUSH_TYPE_AUDIO:       //接收到音频消息
        {
            //判断是否在聊天界面
            if ([AppDelegate isInView:@"ChatViewController"] )
            {
                if (isPlay)
                {
                    //提示音播放,刷新页面显示
                    NSString *path    = [[NSBundle mainBundle] pathForResource:@"sfx_record_start"
                                                                        ofType:@"wav"];
                    NSData *infoSound = [NSData dataWithContentsOfFile:path];
                    [RecordAudio playVoice:infoSound];
                }
                
                //发送刷新数据Notice
                [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshNewData"
                                                                    object:nil];
            }
            else
            {
                
                //播放您有一条新消息,跳转聊天界面显示
                if (isPlay)
                {
                    NSString *path    = [[NSBundle mainBundle] pathForResource:@"sfx_message_text_new"
                                                                        ofType:@"wav"];
                    NSData *infoSound = [NSData dataWithContentsOfFile:path];
                    [RecordAudio playVoice:infoSound];
                }
                
                //pop当前页显示提示
                NoticePopView *popView  = [NoticePopView shareInstance];
                popView.noticeType      = NOTICE_MSG;
                popView.contentDic      = msgDic;
                popView.titleLab.text   = @"您有一条新消息";
                popView.contentLab.text = @"语音消息";
                [popView popView];
            }
            break;
        }
        case PUSH_TYPE_TEXT:        //接收到文本消息
        {
            //判断是否在聊天界面
            if ([AppDelegate isInView:@"ChatViewController"] )
            {
                //提示音播放,刷新页面显示
                if (isPlay)
                {
                    NSString *path    = [[NSBundle mainBundle] pathForResource:@"sfx_record_start"
                                                                        ofType:@"wav"];
                    NSData *infoSound = [NSData dataWithContentsOfFile:path];
                    [RecordAudio playVoice:infoSound];
                }
                
                //发送刷新数据Notice
                [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshNewData"
                                                                    object:nil];
            }
            else
            {
                //播放您有一条新消息,点击跳转聊天界面显示
                if (isPlay)
                {
                    NSString *path    = [[NSBundle mainBundle] pathForResource:@"sfx_message_text_new"
                                                                        ofType:@"wav"];
                    NSData *infoSound = [NSData dataWithContentsOfFile:path];
                    [RecordAudio playVoice:infoSound];
                }
                
                //pop当前页显示提示
                NoticePopView *popView = [NoticePopView shareInstance];
                popView.noticeType     = NOTICE_MSG;
                popView.contentDic     = msgDic;
                popView.titleLab.text  = @"您有一条新消息";
                popView.contentLab.text= [msgDic objectForKey:@"text"];
                [popView popView];
            }
            break;
        }
        case PUSH_TYPE_ORDER_EDIT:    //发送修改订单消息
        {
            break;
        }
        case PUSH_TYPE_ORDER_CONFIRM:
        {
            break;
        }
        case PUSH_TYPE_ORDER_EDIT_SUCCESS:
        {
            CustomNavigationViewController *nav = (CustomNavigationViewController *) [MainViewController getNavigationViewController];
            [nav showAlertWithTitle:@"恭喜您"
                                tag:0
                            message:@"老师已经接受了您的聘请!"
                           delegate:self
                  otherButtonTitles:@"知道了",nil];
            break;
        }
        case PUSH_TYPE_ORDER_CONFIRM_SUCCESS:  //订单修改确认
        {
            CustomNavigationViewController *nav = (CustomNavigationViewController *) [MainViewController getNavigationViewController];
            [nav showAlertWithTitle:@"提示"
                                tag:0
                            message:@"老师已经确认了您的订单修改!"
                           delegate:self
                  otherButtonTitles:@"知道了",nil];
            break;
        }
        case PUSH_TYPE_SYSTEM_MSG:
        {
            break;
        }
        case PUSH_TYPE_LISTENING_CHANG:       //试听改变
        {
            //判断当前是否在聊天窗口
            if ([AppDelegate isInView:@"ChatViewController"])
            {
                //发送教师端试听改变Notice
                [[NSNotificationCenter defaultCenter] postNotificationName:@"listenChanged"
                                                                    object:nil
                                                                  userInfo:msgDic];
            }
            break;
        }
        case PUSH_TYPE_OFFLINE_MSG:           //异地登录,消息下线
        {
            //清除登录标识
            [[NSUserDefaults standardUserDefaults] setBool:NO
                                                    forKey:LOGINE_SUCCESS];
            
            //弹回主界面
            CustomNavigationViewController *nav = [MainViewController getNavigationViewController];
            for (UIViewController *ctr in nav.viewControllers)
            {
                if ([ctr isKindOfClass:[MainViewController class]])
                {
                    [nav popToViewController:ctr animated:YES];
                    break;
                }
            }
            
            //提示用户
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示"
                                                               message:@"您已经在另一台设备上登录!"
                                                              delegate:self
                                                     cancelButtonTitle:nil
                                                     otherButtonTitles:@"确定", nil];
            [alertView show];
            [alertView release];
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
    
    NSString *errorid = (NSString *)[[resDic objectForKey:@"errorid"] copy];
    if (errorid.intValue == 0)
    {
        NSString *action = [[resDic objectForKey:@"action"] copy];
        if ([action isEqualToString:@"getPushMessage"])
        {
            //处理未处理消息
            NSArray *messageArr = [resDic objectForKey:@"messages"];
            for (int i=0; i<messageArr.count; i++)
            {
                NSDictionary *msgDic = [messageArr objectAtIndex:messageArr.count-1-i];
                [AppDelegate dealWithMessage:msgDic
                                 isPlayVoice:NO];
            }
        }
        [action release];
    }
    //重复登录
    else if (errorid.intValue==2)
    {
        //清除sessid,清除登录状态,回到地图页
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:SSID];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:LOGINE_SUCCESS];
        [AppDelegate popToMainViewController];
    }
    [errorid release];
}

#pragma mark - MQtt Callback methods
- (void)session:(MQTTSession*)sender
     newMessage:(NSData*)data
        onTopic:(NSString*)topic
{
    NSDictionary *pDic = nil;
    NSLog(@"new message, %d bytes, topic=%@", [data length], topic);
    NSString *payloadString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    if (payloadString)
    {
        pDic = [[payloadString JSONValue] retain];
        CLog(@"DIC:%@", pDic);
    }
    
    if ([topic isEqualToString:@"adtopic"])         //广告消息
    {
        NoticePopView *popView = [NoticePopView shareInstance];
        popView.noticeType = NOTICE_AD;
        popView.contentDic = pDic;
        popView.titleLab.text   = [pDic objectForKey:@"title"];
        popView.contentLab.text = [pDic objectForKey:@"message"];
        [popView popView];
    }
    else if ([topic isEqualToString:@"ggtopic"])    //公告消息
    {
        NoticeWallViewController *noticeWall = [[NoticeWallViewController alloc]init];
        noticeWall.title   = [pDic objectForKey:@"title"];
        noticeWall.content = [pDic objectForKey:@"message"];
        CustomNavigationViewController *nav  = [MainViewController getNavigationViewController];
        [nav presentPopupViewController:noticeWall
                          animationType:MJPopupViewAnimationFade];
    }
    else //交互消息  1.沟通消息(文本,语音) 2.修改订单确认 3.聘请修改 4.订单确认 5.抢单)
    {
        [AppDelegate dealWithMessage:pDic
                         isPlayVoice:YES];
    }
}

- (void)session:(MQTTSession*)sender handleEvent:(MQTTSessionEvent)eventCode {
    switch (eventCode) {
        case MQTTSessionEventConnected:
            CLog(@"connected");
            break;
        case MQTTSessionEventConnectionRefused:
            CLog(@"connection refused");
            break;
        case MQTTSessionEventConnectionClosed:
            CLog(@"connection closed");
            break;
        case MQTTSessionEventConnectionError:
            CLog(@"connection error");
            CLog(@"reconnecting...");
            // Forcing reconnection
            if ([AppDelegate isConnectionAvailable:YES withGesture:NO])
                [SingleMQTT connectServer];
            break;
        case MQTTSessionEventProtocolError:
            CLog(@"protocol error");
            break;
    }
}

#pragma mark - Remote Notice Action
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    NSString *devToken = [token stringByReplacingOccurrencesOfString:@" "
                                                          withString:@""];
    CLog(@"New Device ToKen:%@", devToken);
    [[NSUserDefaults standardUserDefaults] setObject:devToken
                                              forKey:QQ_STUDENT];
}

- (void) application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    CLog(@"RegisterForRemoteNotifications:%@", [NSString stringWithFormat: @"Error: %@", error]);
    [[NSUserDefaults standardUserDefaults] setObject:@"deviceToken error"
                                              forKey:QQ_STUDENT];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    CLog(@"New APNS Message:%@", userInfo);
}

#pragma mark -
#pragma mark - WXApiDelegate
- (void) onResp:(BaseResp *)resp
{
    if([resp isKindOfClass:[SendMessageToWXResp class]])
    {        
        if (resp.errCode == 0) //分享成功
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"分享成功"
                                                           delegate:self
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
        }
        else                   //分享失败
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:[NSString stringWithFormat:@"分享失败,errCode:%d", resp.errCode]
                                                           delegate:self
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
        }
    }

}
@end
