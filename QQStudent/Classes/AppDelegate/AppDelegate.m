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
    //初始化MQTT Server
    [self initMQTTServer];
    
    //向微信注册
    [WXApi registerApp:WeiXinAppID withDescription:@"QQ_Student_IOS v1.0"];
    
    //注册设备推送通知
    [[UIApplication sharedApplication]registerForRemoteNotificationTypes:
                                                         (UIRemoteNotificationTypeAlert |
                                                          UIRemoteNotificationTypeBadge |
                                                          UIRemoteNotificationTypeSound)];
    
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    UIViewController *pVctr = nil;
    if ([self isFirstLauncher])
    {
        SplashViewController *spVctr = [[SplashViewController alloc]init];
        pVctr = spVctr;
    }
    else
    {
        MainViewController *mVctr     = [[MainViewController alloc]init];
        UINavigationController *nVctr = [[UINavigationController alloc]initWithRootViewController:mVctr];
        pVctr = nVctr;
    }
    
    //ios5设置NavBar背景图片
    [self isIos5ToUpdateNav];
    
    self.window.rootViewController = pVctr;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    [pVctr release];
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
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    //上线更新
    [self updateLoginStatus:1];
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
- (void) updateLoginStatus:(int) isBackgroud
{
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
        NSString *url  = [NSString stringWithFormat:@"%@%@/", webAddress,STUDENT];
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
    //连接MQTT服务器
    SingleMQTT *session = [SingleMQTT shareInstance];
    [session.session setDelegate:self];
    [session.session subscribeTopic:[SingleMQTT getCurrentDevTopic]];
    CLog(@"Topic:%@", [SingleMQTT getCurrentDevTopic]);
    [SingleMQTT connectServer];
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
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"nav_top_bg@2x"]
                                       forBarMetrics:UIBarMetricsDefault];
#endif
}

- (BOOL) isInChatView
{
    BOOL isIn = NO;
    
    UINavigationController *vctr = (UINavigationController *)self.window.rootViewController;
    for (UIViewController *viewController in vctr.viewControllers)
    {
        if ([viewController isKindOfClass:[ChatViewController class]])
        {
            isIn = YES;
            break;
        }
    }
    
    return isIn;
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
        pDic = [payloadString JSONValue];
        CLog(@"DIC:%@", pDic);
    }
    
    //解析MQTT接收消息
    int msgType = ((NSString *)[pDic objectForKey:@"type"]).intValue;
    switch (msgType)
    {
        case PUSH_TYPE_APPLY:       //接收到老师抢单信息
        {
            //添加到联系人,订单.等待老师确认。
            Teacher *tObj = [[Teacher alloc]init];
            tObj.deviceId = [pDic objectForKey:@"deviceId"];
            tObj.sex      = ((NSNumber *) [pDic objectForKey:@"gender"]).intValue;
            tObj.headUrl  = [pDic objectForKey:@"icon"];
            tObj.idNums   = [pDic objectForKey:@"idnumber"];
            tObj.info = [pDic objectForKey:@"info"];
            tObj.name = [pDic objectForKey:@"nickname"];
            tObj.phoneNums = [pDic objectForKey:@"phone"];
            tObj.comment = ((NSNumber *) [pDic objectForKey:@"stars"]).intValue;
            tObj.studentCount = ((NSNumber *) [pDic objectForKey:@"students"]).intValue;
            tObj.pf = [pDic objectForKey:@"subjectText"];
            NSDictionary *infoDic = [NSDictionary dictionaryWithObjectsAndKeys:tObj,@"OrderTeacher",nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"OrderConfirm"
                                                                object:nil
                                                              userInfo:infoDic];
            break;
        }
        case PUSH_TYPE_CONFIRM:     //确认老师的确认消息
        {
            break;
        }
        case PUSH_TYPE_IMAGE:       //接收到图片消息
        case PUSH_TYPE_AUDIO:       //接收到音频消息
        case PUSH_TYPE_TEXT:        //接收到文本消息
        {
            //判断是否在聊天界面
            if ([self isInChatView])
            {
                CLog(@"Chat Message:%@", pDic);
                //提示音播放,刷新页面显示
                NSString *path    = [[NSBundle mainBundle] pathForResource:@"sfx_record_start"
                                                                    ofType:@"wav"];
                NSData *infoSound = [NSData dataWithContentsOfFile:path];
                [RecordAudio playWav:infoSound];
                
                //发送刷新数据Notice
                [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshNewData"
                                                                    object:nil];
            }
            else
            {
                //播放您有一条新消息,跳转聊天界面显示
                CLog(@"Not Chat Message:%@", pDic);
                NSString *path    = [[NSBundle mainBundle] pathForResource:@"sfx_message_text_new"
                                                                    ofType:@"wav"];
                NSData *infoSound = [NSData dataWithContentsOfFile:path];
                [RecordAudio playWav:infoSound];
                
                //跳转聊天记录
                Teacher *tObj = [Teacher setTeacherProperty:pDic];
                CLog(@"phone:%@, lynn:%@", tObj.phoneNums, tObj.name);
                ChatViewController *cVctr   = [[ChatViewController alloc]init];
                UINavigationController *nav = (UINavigationController *)self.window.rootViewController;
                cVctr.tObj = tObj;
                [nav pushViewController:cVctr
                               animated:YES];
                [cVctr release];
            }
            break;
        }
        case PUSH_TYPE_ORDER_EDIT:  //发送修改订单消息
        {
            break;
        }
        case PUSH_TYPE_ORDER_CONFIRM:
        {
            break;
        }
        case PUSH_TYPE_ORDER_EDIT_SUCCESS:
        {
            break;
        }
        case PUSH_TYPE_ORDER_CONFIRM_SUCCESS:
        {
            break;
        }
        case PUSH_TYPE_LISTENING_CHANG:
        {
            break;
        }
        default:
            break;
    }
    
    //转发给各个ViewControllers
}

- (void)session:(MQTTSession*)sender handleEvent:(MQTTSessionEvent)eventCode {
    switch (eventCode) {
        case MQTTSessionEventConnected:
            NSLog(@"connected");
            break;
        case MQTTSessionEventConnectionRefused:
            NSLog(@"connection refused");
            break;
        case MQTTSessionEventConnectionClosed:
            NSLog(@"connection closed");
            break;
        case MQTTSessionEventConnectionError:
            NSLog(@"connection error");
            NSLog(@"reconnecting...");
            // Forcing reconnection
            [SingleMQTT connectServer];
            break;
        case MQTTSessionEventProtocolError:
            NSLog(@"protocol error");
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
    
    //提示有一条新消息
    NSString *path    = [[NSBundle mainBundle] pathForResource:@"sfx_message_text_new"
                                                        ofType:@"wav"];
    NSData *infoSound = [NSData dataWithContentsOfFile:path];
    [RecordAudio playWav:infoSound];
    
    //清除消息中心消息
    [[UIApplication sharedApplication ] setApplicationIconBadgeNumber:0];
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
