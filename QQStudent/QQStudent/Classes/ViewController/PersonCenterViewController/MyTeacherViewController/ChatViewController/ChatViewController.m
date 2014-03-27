//
//  ChatViewController.m
//  QQStudent
//
//  Created by lynn on 14-1-31.
//  Copyright (c) 2014年 lynn. All rights reserved.
//

#import "ChatViewController.h"

@interface ChatViewController ()

@end

@implementation ChatViewController
@synthesize tObj;
@synthesize messages;
@synthesize order;
@synthesize listenBtn;
@synthesize employBtn;
@synthesize isFromSearchCondition;

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
    
    //初始化录音
    recordAudio = [[RecordAudio alloc]init];
    recordAudio.delegate = self;
    
    //初始化UI
    isNewData = NO;
    [self initUI];
    [self initPullView];
}

- (void) viewDidUnload
{
    recordAudio.delegate = nil;
    [super viewDidUnload];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [MainViewController setNavTitle:@"和老师沟通"];
    
    [self initBackBarItem];
    
    //获得聊天记录
    [self getChatRecords];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshNewData:)
                                                 name:@"refreshNewData"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showTeacherDetailNotice:)
                                                 name:@"showTeacherDetailNotice"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(dismissComplainNotice:)
                                                 name:@"dismissComplainNotice"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(listenChangedNotice:)
                                                 name:@"listenChanged"
                                               object:nil];
}

- (void) viewDidDisappear:(BOOL)animated
{
    [listenBtn removeFromSuperview];
    listenBtn = nil;
    
    [employBtn removeFromSuperview];
    employBtn = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    CustomNavigationViewController *nav = [MainViewController getNavigationViewController];
    nav.dataSource = nil;
    
    [super viewDidDisappear:animated];
}

- (void) dealloc
{
    [infoView release];
    [employInfoView release];
    [recordAudio release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark - Custom Action
- (void) initInfoPopView
{
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7)
    {
        if (iPhone5)
        {
            //ios7 iphone5
            CLog(@"It's is iphone5 IOS7");
            infoView = [[LBorderView alloc]initWithFrame:[UIView fitCGRect:CGRectMake(10, 44+8,
                                                                                      300,
                                                                                      60)
                                                                isBackView:NO]];
        }
        else
        {
            CLog(@"It's is iphone4 IOS7");
            //ios 7 iphone 4
            infoView = [[LBorderView alloc]initWithFrame:[UIView fitCGRect:CGRectMake(10, 44+20,
                                                                                      300,
                                                                                      60)
                                                                isBackView:NO]];
        }
    }
    else
    {
        if (!iPhone5)
        {
            // ios 6 iphone4
            CLog(@"It's is iphone4 IOS6");
            infoView = [[LBorderView alloc]initWithFrame:[UIView fitCGRect:CGRectMake(10, 20,
                                                                                      300,
                                                                                      60)
                                                                isBackView:NO]];
        }
        else
        {
            //ios 6 iphone5
            CLog(@"It's is iphone5 IOS6");
            infoView = [[LBorderView alloc]initWithFrame:[UIView fitCGRect:CGRectMake(10, 20,
                                                                                      300,
                                                                                      60)
                                                                isBackView:NO]];
        }
    }
    infoView.hidden = NO;
    infoView.borderType   = BorderTypeSolid;
    infoView.dashPattern  = 8;
    infoView.spacePattern = 8;
    infoView.borderWidth  = 1;
    infoView.cornerRadius = 5;
    infoView.alpha = 0.8;
    infoView.borderColor  = [UIColor orangeColor];
    infoView.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:infoView];
    
    UITapGestureRecognizer *tapReg = [[UITapGestureRecognizer alloc]initWithTarget:self
                                                                            action:@selector(doTapGestureReg:)];
    [infoView addGestureRecognizer:tapReg];
    
    UILabel *infoLab = [[UILabel alloc]init];
    infoLab.textColor = [UIColor whiteColor];
    infoLab.text = @"请注意:正式上课一般为2小时/次,上课前试听一般为1小时/次,同一学生同一教师试听一般不超过1次";
    infoLab.backgroundColor = [UIColor clearColor];
    infoLab.frame = CGRectMake(10,0,
                               280,
                               60);
    infoLab.numberOfLines = 0;
    infoLab.font = [UIFont systemFontOfSize:14.f];
    infoLab.lineBreakMode = NSLineBreakByWordWrapping;
    [infoView addSubview:infoLab];
    [infoLab release];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self
                                                                         action:@selector(doEmployClicked:)];
    employInfoView = [[UIView alloc]init];
    employInfoView.hidden = YES;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7)
    {
        if (iPhone5)
        {
            //ios7 iphone5
            CLog(@"It's is iphone5 IOS7");
            employInfoView.frame  = [UIView fitCGRect:CGRectMake(10, 44, 300, 40)
                                           isBackView:NO];
        }
        else
        {
            CLog(@"It's is iphone4 IOS7");
            //ios 7 iphone 4
            employInfoView.frame  = [UIView fitCGRect:CGRectMake(10, 54, 300, 40)
                                           isBackView:NO];
        }
    }
    else
    {
        if (!iPhone5)
        {
            // ios 6 iphone4
            CLog(@"It's is iphone4 IOS6");
            employInfoView.frame  = [UIView fitCGRect:CGRectMake(10, 0, 300, 40)
                                           isBackView:NO];
        }
        else
        {
            //ios 6 iphone5
            CLog(@"It's is iphone5 IOS6");
            employInfoView.frame  = [UIView fitCGRect:CGRectMake(10, 0, 300, 40)
                                           isBackView:NO];
        }
    }
    [employInfoView addGestureRecognizer:tap];
    [self.view addSubview:employInfoView];
    [tap release];
    
    UIImageView *bgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cp_chatinfo_bg"]];
    bgView.frame = CGRectMake(0,0, 300, 40);
    [employInfoView addSubview:bgView];
    [bgView release];
    
    UILabel *employLab  = [[UILabel alloc]init];
    employLab.textColor = [UIColor whiteColor];
    employLab.text = @"选择免费试听一次(1小时)之后聘请更安心！";
    employLab.backgroundColor = [UIColor clearColor];
    employLab.frame = CGRectMake(7,10,300,30);
    employLab.numberOfLines = 0;
    employLab.font = [UIFont systemFontOfSize:14.f];
    employLab.lineBreakMode = NSLineBreakByWordWrapping;
    [employInfoView addSubview:employLab];
    [employLab release];
}

- (void) doTapGestureReg:(UIGestureRecognizer *) reg
{
    infoView.hidden = YES;
}

- (void) doEmployClicked:(UIGestureRecognizer *) reg
{
    employInfoView.hidden = YES;
}

- (void) initBackBarItem
{
    CustomNavigationViewController *nav = (CustomNavigationViewController *) [MainViewController getNavigationViewController];
    nav.dataSource = self;
}

- (void) convertAmrToMp3:(NSString *)audioURL
{
    if (![AppDelegate isConnectionAvailable:YES withGesture:NO])
    {
        return;
    }
    
    NSString *ssid = [[NSUserDefaults standardUserDefaults] objectForKey:SSID];
    NSArray *paramsArray = [NSArray arrayWithObjects:@"action",@"audio",@"sessid", nil];
    NSArray *valuesArray = [NSArray arrayWithObjects:@"amrToMp3", audioURL, ssid, nil];
    
    NSDictionary *pDic   = [NSDictionary dictionaryWithObjects:valuesArray
                                                     forKeys:paramsArray];
    NSString *webAdd     = [[NSUserDefaults standardUserDefaults] objectForKey:WEBADDRESS];
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
    NSString *url        = [NSString stringWithFormat:@"%@%@", webAdd, STUDENT];
    ServerRequest *request = [ServerRequest sharedServerRequest];
    request.delegate = self;
    NSData *resVal   = [request requestSyncWith:kServerPostRequest
                                       paramDic:pDic
                                         urlStr:url];
    if (resVal)
    {
        [recordAudio playMP3:resVal];
    }
}

- (void) initUI
{
    self.delegate = self;
    self.dataSource = self;
    messages   = [[NSMutableArray alloc]init];

    listenBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [listenBtn setTitle:@"试听"
               forState:UIControlStateNormal];
    listenBtn.titleLabel.font = [UIFont systemFontOfSize:14.f];
    [listenBtn setTitleColor:[UIColor colorWithHexString:@"#ff6600"]
                    forState:UIControlStateNormal];
    [listenBtn setBackgroundImage:[UIImage imageNamed:@"cp_shiting_normal_bg"]
                         forState:UIControlStateNormal];
    [listenBtn setBackgroundImage:[UIImage imageNamed:@"cp_shiting_hlight_bg"]
                         forState:UIControlStateNormal];
    
    listenBtn.tag   = 0;
    listenBtn.frame = CGRectMake(320-110, 12, 40, 25);
    [listenBtn addTarget:self
                  action:@selector(doButtonClicked:)
        forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.navigationBar addSubview:listenBtn];
    
    employBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    employBtn.hidden = NO;
    employBtn.titleLabel.font = [UIFont systemFontOfSize:14.f];
    [employBtn setTitle:@"聘请TA"
               forState:UIControlStateNormal];
    [employBtn setBackgroundImage:[UIImage imageNamed:@"sp_share_btn_normal"]
                         forState:UIControlStateNormal];
    [employBtn setBackgroundImage:[UIImage imageNamed:@"sp_share_btn_hlight"]
                         forState:UIControlStateHighlighted];
    employBtn.tag   = 1;
    employBtn.frame = CGRectMake(320-65, 12, 60, 25);
    [employBtn addTarget:self
                  action:@selector(doButtonClicked:)
        forControlEvents:UIControlEventTouchUpInside];
    
    [self initInfoPopView];
    
    CustomNavigationViewController *nav = [MainViewController getNavigationViewController];
    [nav.navigationBar addSubview:employBtn];
    
    //是否支持试听、聘用
    [self isShowListenBtn];
    if (!order)
        [self isShowEmployBtn];
    //直接搜索时,调用显示接口
    if (isFromSearchCondition)
        [self isShowEmployBtn];
}

- (void) initPullView
{
    if (_refreshHeaderView == nil) {
		
		EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.tableView.bounds.size.height, self.view.frame.size.width, self.tableView.bounds.size.height)];
		view.delegate = self;
		[self.tableView addSubview:view];
		_refreshHeaderView = view;
		[view release];
	}
	
	//  update the last update date
	[_refreshHeaderView refreshLastUpdatedDate];
}

- (void) getRecordPage
{
    if (![AppDelegate isConnectionAvailable:YES withGesture:NO])
    {
        return;
    }
    
    if (self.messages.count>0)
    {
        NSDictionary *item = [messages objectAtIndex:messages.count-1];
        CLog(@"item:%@", item);
        NSString *ssid     = [[NSUserDefaults standardUserDefaults] objectForKey:SSID];
        NSArray *paramsArr = [NSArray arrayWithObjects:@"action",@"messageId",@"phone",@"sessid", nil];
        NSArray *valuesArr = [NSArray arrayWithObjects:@"getMessages",[item objectForKey:@"messageId"],tObj.phoneNums,ssid, nil];
        NSDictionary *pDic = [NSDictionary dictionaryWithObjects:valuesArr
                                                         forKeys:paramsArr];
        
        ServerRequest *request = [ServerRequest sharedServerRequest];
        request.delegate = self;
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
        
        NSString *url    = [NSString stringWithFormat:@"%@%@", webAdd,STUDENT];
        [request requestASyncWith:kServerPostRequest
                         paramDic:pDic
                           urlStr:url];
    }
}

- (void) isShowListenBtn
{
    if (![AppDelegate isConnectionAvailable:YES withGesture:NO])
    {
        return;
    }
    
    NSString *ssid = [[NSUserDefaults standardUserDefaults] objectForKey:SSID];
    
    //判断是否显示试听和聘请
    NSArray *paramsArr = [NSArray arrayWithObjects:@"action",@"phone",@"sessid", nil];
    NSArray *valusArr  = [NSArray arrayWithObjects:@"getListening",tObj.phoneNums,ssid, nil];
    NSDictionary *pDic = [NSDictionary dictionaryWithObjects:valusArr
                                                     forKeys:paramsArr];
    
    ServerRequest *request = [ServerRequest sharedServerRequest];
    request.delegate = self;
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
    NSString *url  = [NSString stringWithFormat:@"%@%@", webAddress,STUDENT];
    NSData *resVal = [request requestSyncWith:kServerPostRequest
                                     paramDic:pDic
                                       urlStr:url];
    if (resVal)
    {
        NSString *resStr = [[[NSString alloc]initWithData:resVal
                                                 encoding:NSUTF8StringEncoding]autorelease];
        NSDictionary *resDic  = [resStr JSONValue];
        CLog(@"Listen:%@", resDic);
        NSString *action = [resDic objectForKey:@"action"];
        if ([action isEqualToString:@"getListening"])
        {
            int isListening = ((NSString *)[resDic objectForKey:@"isListening"]).intValue;
            if (isListening == 1)
            {
                listenBtn.hidden = NO;
                employInfoView.hidden = NO;
            }
            else
            {
                listenBtn.hidden = YES;
                employInfoView.hidden = YES;
            }
        }
    }
    else
    {
        listenBtn.hidden = YES;
        employInfoView.hidden = YES;
    }
}

- (void) isShowEmployBtn
{
    if (![AppDelegate isConnectionAvailable:YES withGesture:NO])
    {
        return;
    }
    
    NSString *ssid = [[NSUserDefaults standardUserDefaults] objectForKey:SSID];
    
    //判断是否显示试听和聘请
    NSArray *paramsArr = [NSArray arrayWithObjects:@"action",@"phone",@"sessid", nil];
    NSArray *valusArr  = [NSArray arrayWithObjects:@"getHire",tObj.phoneNums,ssid, nil];
    NSDictionary *pDic = [NSDictionary dictionaryWithObjects:valusArr
                                                     forKeys:paramsArr];
    
    ServerRequest *request = [ServerRequest sharedServerRequest];
    request.delegate = self;
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
    NSString *url  = [NSString stringWithFormat:@"%@%@", webAddress,STUDENT];
    NSData *resVal = [request requestSyncWith:kServerPostRequest
                                     paramDic:pDic
                                       urlStr:url];
    if (resVal)
    {
        NSString *resStr = [[[NSString alloc]initWithData:resVal
                                                 encoding:NSUTF8StringEncoding]autorelease];
        CLog(@"Employ:%@", resStr);
        NSDictionary *resDic  = [resStr JSONValue];
        NSString *action = [resDic objectForKey:@"action"];
        if ([action isEqualToString:@"getHire"])
        {
            int isHire = ((NSNumber *)[resDic objectForKey:@"isHire"]).intValue;
            if (isHire == 0)
            {
                employBtn.hidden = YES;
            }
            else
            {
                employBtn.hidden = NO;
            }
        }
    }
    else
    {
        employBtn.hidden = YES;
    }
    
    //聘请按钮隐藏试听按钮后移动
    if (employBtn.hidden)
        listenBtn.frame = CGRectMake(employBtn.frame.origin.x,
                                     employBtn.frame.origin.y,
                                     listenBtn.frame.size.width,
                                     listenBtn.frame.size.height);
}

- (void) getChatRecords
{
    if (![AppDelegate isConnectionAvailable:YES withGesture:NO])
    {
        return;
    }
    
    isNewData = YES;
    
    NSString *ssid = [[NSUserDefaults standardUserDefaults] objectForKey:SSID];
    NSArray *paramsArr = [NSArray arrayWithObjects:@"action",@"messageId",@"phone",@"sessid", nil];
    NSArray *valuesArr = [NSArray arrayWithObjects:@"getMessages",@"0",tObj.phoneNums, ssid, nil];
    NSDictionary *pDic = [NSDictionary dictionaryWithObjects:valuesArr
                                                     forKeys:paramsArr];
    ServerRequest *request = [ServerRequest sharedServerRequest];
    request.delegate = self;
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
    NSString *url = [NSString stringWithFormat:@"%@%@", webAdd, STUDENT];
    [request requestASyncWith:kServerPostRequest
                     paramDic:pDic
                       urlStr:url];
}

- (NSString *) getRecordURL
{
    NSArray *paths   = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                           NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSMutableString  *path       = [[NSMutableString alloc]initWithString:documentsDirectory];
    [path appendString:VOICE_NAME];
    
    return path;
}

- (void) startRecord
{
    [recordAudio stopPlay];
    [recordAudio startRecord];
}

- (void) stopRecord
{
    //写入amr数据文件
    NSURL *url       = [recordAudio stopRecord];
    CLog(@"URL:%@", url);
    NSData *curAudio = EncodeWAVEToAMR([NSData dataWithContentsOfURL:url],1,16);
    NSString *path   = [self getRecordURL];
    CLog(@"path:%@", path);
    [curAudio writeToFile:path
               atomically:YES];
}

-(void)RecordStatus:(int)status
{
    if (status==0)
    {
        //播放中
    }
    else if(status==1)
    {
        //完成

    }
    else if(status==2)
    {
        //出错
        CLog(@"播放出错");
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"stopVoiceAnimation"
                                                        object:nil];
}


- (void) sendVoiceFile:(int) voiceTimes
{
    if (![AppDelegate isConnectionAvailable:YES withGesture:NO])
    {
        return;
    }
    
    //上传语音文件
    NSString *path = [self getRecordURL];
    
    //获得时间戳
    NSDate *dateNow  = [NSDate date];
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[dateNow timeIntervalSince1970]];
    
    NSString *ssid     = [[NSUserDefaults standardUserDefaults] objectForKey:SSID];
    NSArray *paramsArr = [NSArray arrayWithObjects:@"action",@"edittime",@"uptype",@"sessid",UPLOAD_FILE, nil];
    NSArray *valuesArr = [NSArray arrayWithObjects:@"uploadfile",
                          timeSp,@"audio",ssid,[NSDictionary dictionaryWithObjectsAndKeys:path,@"file", nil],nil];
    NSDictionary *pDic = [NSDictionary dictionaryWithObjects:valuesArr
                                                     forKeys:paramsArr];
    
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
    NSString *url    = [NSString stringWithFormat:@"%@%@", webAdd,STUDENT];
    
    //上传录音文件
    ServerRequest *request = [ServerRequest sharedServerRequest];
    request.delegate = self;
    NSData *resVal   = [request requestSyncWith:kServerPostRequest
                                       paramDic:pDic
                                         urlStr:url];
    if (resVal)
    {
        NSString *resStr = [[[NSString alloc]initWithData:resVal
                                                 encoding:NSUTF8StringEncoding]autorelease];
        NSDictionary *resDic  = [resStr JSONValue];
        NSString *action = [resDic objectForKey:@"action"];
        if ([action isEqualToString:@"uploadfile"])
        {
            path = [resDic objectForKey:@"filepath"];
            CLog(@"filePath:%@", path);
            
            NSData *stuData  = [[NSUserDefaults standardUserDefaults] valueForKey:STUDENT];
            Student *student = [NSKeyedUnarchiver unarchiveObjectWithData:stuData];
            
            NSDate *dateNow  = [NSDate date];
            NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[dateNow timeIntervalSince1970]];
            
            NSArray *paramsArr  = [NSArray arrayWithObjects:@"type", @"phone", @"nickname", @"sound",@"stime",@"time",@"taPhone",@"deviceId",nil];
            NSArray *valuesArr  = [NSArray arrayWithObjects:[NSNumber numberWithInt:PUSH_TYPE_AUDIO],student.phoneNumber,student.nickName,path,[NSNumber numberWithInt:voiceTimes],timeSp,tObj.phoneNums,[SingleMQTT getCurrentDevTopic], nil];
            NSDictionary *pDic  = [NSDictionary dictionaryWithObjects:valuesArr
                                                              forKeys:paramsArr];
            //发送消息
            NSString *jsonMsg   = [pDic JSONFragment];
            NSData *data        = [jsonMsg dataUsingEncoding:NSUTF8StringEncoding];
            SingleMQTT *session = [SingleMQTT shareInstance];
            [session.session publishData:data
                                 onTopic:tObj.deviceId];
            //消息上传服务器
            [self uploadMessageToServer:jsonMsg];
            
            //播放声音
            if((self.messages.count - 1) % 2)
                [JSMessageSoundEffect playMessageSentSound];
            else
                [JSMessageSoundEffect playMessageReceivedSound];
        }
    }
    else
    {
        [self showAlertWithTitle:@"提示"
                             tag:0
                         message:@"上传文件失败"
                        delegate:self
               otherButtonTitles:@"确定",nil];
    }
}

#pragma mark -
#pragma mark - UILongPressButtonDelegate
- (void) longPressButton:(UILongPressButton *)btn status:(ButtonStatus)status
{
    switch (status)
    {
        case LONG_PRESS_BUTTON_DOWN:
        {
            //显示动画
            [SVProgressHUD showWithStatus:@""];
            [self startRecord];
            break;
        }
        case LONG_PRESS_BUTTON_SHORT:
        {
            [self showAlertWithTitle:@"提示"
                                 tag:0
                             message:@"录音时间太短"
                            delegate:self
                   otherButtonTitles:@"确定",nil];
            
            //停止动画
            [SVProgressHUD dismiss];
            [self stopRecord];
            break;
        }
        case LONG_PRESS_BUTTON_LONG:
        {
            [self showAlertWithTitle:@"提示"
                                 tag:0
                             message:@"录音时间太长"
                            delegate:self
                   otherButtonTitles:@"确定",nil];
            //停止动画
            [SVProgressHUD dismiss];
            [self stopRecord];
            break;
        }
        case LONG_PRESS_BUTTON_UP:
        {
            //停止动画
            [SVProgressHUD dismiss];
            [self stopRecord];
            
            //发送语音文件
            CLog(@"times:%d", [btn getVoiceTimes]);
            [self sendVoiceFile:[btn getVoiceTimes]];
            break;
        }
        default:
            break;
    }
}
- (void) doBackBtnClicked:(id)sender
{
    CustomNavigationViewController *nav = [MainViewController getNavigationViewController];
    [nav popViewControllerAnimated:YES];
}

- (void) doButtonClicked:(id)sender
{
    if (![AppDelegate isConnectionAvailable:YES withGesture:NO])
    {
        return;
    }
    
    UIButton *btn = sender;
    switch (btn.tag)
    {
        case 0:      //试听
        {
            NSString *ssid     = [[NSUserDefaults standardUserDefaults] objectForKey:SSID];
            NSArray *paramsArr = [NSArray arrayWithObjects:@"action",@"phone",@"sessid", nil];
            NSArray *valueArr  = [NSArray arrayWithObjects:@"setListening",tObj.phoneNums,ssid,nil];
            NSDictionary *pDic = [NSDictionary dictionaryWithObjects:valueArr
                                                             forKeys:paramsArr];
            ServerRequest *request = [ServerRequest sharedServerRequest];
            request.delegate       = self;
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
            [request requestASyncWith:kServerPostRequest
                             paramDic:pDic
                               urlStr:url];
            break;
        }
        case 1:      //聘请
        {
            //跳转到
            if (order)
            {
                CustomNavigationViewController *nav     = (CustomNavigationViewController *)[MainViewController getNavigationViewController];
                UpdateOrderViewController *upVctr = [[UpdateOrderViewController alloc]init];
                upVctr.isEmploy = YES;
                upVctr.order = order;
                [nav pushViewController:upVctr
                               animated:YES];
                [upVctr release];
            }
            else
            {
                //新建订单
                 CustomNavigationViewController *nav     = (CustomNavigationViewController *)[MainViewController getNavigationViewController];
                 SearchConditionViewController *scVctr = [[SearchConditionViewController alloc]init];
                 scVctr.tObj = tObj;
                 [nav pushViewController:scVctr animated:YES];
            }
            break;
        }
        case 2:
        {
            break;
        }
        default:
            break;
    }
}

- (void) updateMessageZT
{
    if (![AppDelegate isConnectionAvailable:YES withGesture:NO])
    {
        return;
    }
    
    isNewData = NO;
    
    //获得时间戳
    NSDate *dateNow    = [NSDate date];
    NSString *timeSp   = [NSString stringWithFormat:@"%ld", (long)[dateNow timeIntervalSince1970]];
    
    NSString *ssid     = [[NSUserDefaults standardUserDefaults] objectForKey:SSID];
    NSArray *paramsArr = [NSArray arrayWithObjects:@"action",@"phone",
                          @"sendTime",@"sessid", nil];
    NSArray *valuesArr = [NSArray arrayWithObjects:@"updateMessageZT",tObj.phoneNums,
                          timeSp,ssid,nil];
    NSDictionary *pDic = [NSDictionary dictionaryWithObjects:valuesArr
                                                     forKeys:paramsArr];
    
    ServerRequest *request = [ServerRequest sharedServerRequest];
    request.delegate     = self;
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
    NSString *url  = [NSString stringWithFormat:@"%@%@", webAddress,STUDENT];
    NSData *resVal = [request requestSyncWith:kServerPostRequest
                                     paramDic:pDic
                                       urlStr:url];
    NSString *resStr = [[NSString alloc]initWithData:resVal
                                            encoding:NSUTF8StringEncoding];
    NSDictionary *resDic   = [resStr JSONValue];
    NSNumber *errorid = [resDic objectForKey:@"errorid"];
    if (errorid.intValue == 0)
    {
        NSString *action = [resDic objectForKey:@"action"];
        if ([action isEqualToString:@"submitMessage"])
        {
            CLog(@"Upload Message Success!");
            [self getChatRecords];
        }
    }
    else
    {
        [self showAlertWithTitle:@"提示"
                             tag:0
                         message:@"上传信息失败"
                        delegate:self
               otherButtonTitles:@"确定",nil];
    }
}

- (void) uploadMessageToServer:(NSString *) msg
{
    if (![AppDelegate isConnectionAvailable:YES withGesture:NO])
    {
        return;
    }
    
    isNewData = YES;
    
    NSString *ssid     = [[NSUserDefaults standardUserDefaults] objectForKey:SSID];
    NSArray *paramsArr = [NSArray arrayWithObjects:@"action",@"message",
                                                   @"phone",@"sessid", nil];
    NSArray *valuesArr = [NSArray arrayWithObjects:@"submitMessage",msg,
                                                   tObj.phoneNums,ssid,nil];
    NSDictionary *pDic = [NSDictionary dictionaryWithObjects:valuesArr
                                                     forKeys:paramsArr];
    
    ServerRequest *request = [ServerRequest sharedServerRequest];
    request.delegate       = self;
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
    NSString *resStr = [[NSString alloc]initWithData:resVal
                                            encoding:NSUTF8StringEncoding];
    NSDictionary *resDic   = [resStr JSONValue];
    NSNumber *errorid = [resDic objectForKey:@"errorid"];
    if (errorid.intValue == 0)
    {
        NSString *action = [resDic objectForKey:@"action"];
        if ([action isEqualToString:@"submitMessage"])
        {
            CLog(@"Upload Message Success!");
            [self getChatRecords];
        }
    }
    else
    {
        [self showAlertWithTitle:@"提示"
                             tag:0
                         message:@"上传信息失败"
                        delegate:self
               otherButtonTitles:@"确定",nil];
    }
}

#pragma mark -
#pragma mark - Notice
- (void) showTeacherDetailNotice:(NSNotification *) notice
{
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    CustomNavigationViewController *nav     = (CustomNavigationViewController *)app.window.rootViewController;
    TeacherDetailViewController *tdVctr = [[TeacherDetailViewController alloc]init];
    tdVctr.tObj = tObj;
    [nav pushViewController:tdVctr
                   animated:YES];
    [tdVctr release];
}

- (void) dismissComplainNotice:(NSNotification *) notice
{
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
}

- (void) refreshNewData:(NSNotification *) notice
{
    [self getChatRecords];
}

- (void) listenChangedNotice:(NSNotification *) notice
{
    //刷新试听接口
    [self isShowListenBtn];
}

#pragma mark -
#pragma mark Data Source Loading / Reloading Methods
- (void)reloadTableViewDataSource
{
	//  should be calling your tableviews data source model to reload
	//  put here just for demo
	_reloading = YES;
    
    //获得聊天记录
    [self getRecordPage];
}

- (void)doneLoadingTableViewData
{
	//  model should call this when its done loading
	_reloading = NO;
	[_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
}

#pragma mark -
#pragma mark - UIScrollViewDelegate Methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	[_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
	[_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
}

#pragma mark -
#pragma mark - EGORefreshTableHeaderDelegate Methods
- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view
{
	[self reloadTableViewDataSource];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view
{
	return _reloading; // should return if data source model is reloading
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view
{
	return [NSDate date]; // should return date data source was last changed
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.messages.count;
}

#pragma mark - Messages view delegate
- (void) buttonPressed:(UIButton *)sender 
{
    switch (sender.tag)
    {
        case 0:       //投诉
        {
            ComplainViewController *cVctr = [[ComplainViewController alloc]init];
            cVctr.tObj = tObj;
            [self presentPopupViewController:cVctr
                               animationType:MJPopupViewAnimationFade];
            break;
        }
        case 1:       //电话
        {
            //检测老师端是否允许接听电话
            [self checkTeacherPhone];
            break;
        }
        case 2:       //声音
        {
            
            break;
        }
        default:
            break;
    }
}

- (void) checkTeacherPhone
{
    if (![AppDelegate isConnectionAvailable:YES withGesture:NO])
    {
        return;
    }
    
    NSString *ssid = [[NSUserDefaults standardUserDefaults] objectForKey:SSID];
    NSArray *paramsArr = [NSArray arrayWithObjects:@"action",@"teacher_phone",@"sessid", nil];
    NSArray *valuesArr = [NSArray arrayWithObjects:@"callPhone",tObj.phoneNums, ssid, nil];
    
    NSDictionary *pDic = [NSDictionary dictionaryWithObjects:valuesArr
                                                     forKeys:paramsArr];
    
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
    NSString *url    = [NSString stringWithFormat:@"%@%@", webAdd,STUDENT];
    ServerRequest *request = [ServerRequest sharedServerRequest];
    request.delegate = self;
    NSData *resVal = [request requestSyncWith:kServerPostRequest
                                     paramDic:pDic
                                       urlStr:url];
    if (resVal)
    {
        NSString *resStr = [[[NSString alloc]initWithData:resVal
                                                 encoding:NSUTF8StringEncoding]autorelease];
        NSDictionary *resDic  = [resStr JSONValue];
        NSString *errorid = [resDic objectForKey:@"errorid"];
        if (errorid.integerValue==0)
        {
            //拨打电话
            NSString *phone = [NSString stringWithFormat:@"tel://%@", tObj.phoneNums];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phone]];
        }
        else
        {
            [self showAlertWithTitle:@"提示"
                                 tag:0
                             message:@"老师不允许拨打电话"
                            delegate:self
                   otherButtonTitles:@"确定",nil];
        }
    }
    
}

- (void)sendPressed:(UIButton *)sender withText:(NSString *)text
{
    NSData *stuData  = [[NSUserDefaults standardUserDefaults] valueForKey:STUDENT];
    Student *student = [NSKeyedUnarchiver unarchiveObjectWithData:stuData];
    
    NSDate *dateNow  = [NSDate date];
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[dateNow timeIntervalSince1970]];
    
    NSArray *paramsArr  = [NSArray arrayWithObjects:@"type", @"phone", @"nickname", @"icon",@"text",@"time",@"taPhone",@"deviceId",nil];
    NSArray *valuesArr  = [NSArray arrayWithObjects:[NSNumber numberWithInt:PUSH_TYPE_TEXT],student.phoneNumber,student.nickName,@"",text,timeSp,tObj.phoneNums,[SingleMQTT getCurrentDevTopic], nil];
    NSDictionary *pDic  = [NSDictionary dictionaryWithObjects:valuesArr
                                                      forKeys:paramsArr];
    
    //发送消息
    NSString *jsonMsg   = [pDic JSONFragment];
    NSData *data        = [jsonMsg dataUsingEncoding:NSUTF8StringEncoding];
    SingleMQTT *session = [SingleMQTT shareInstance];
    [session.session publishData:data
                         onTopic:tObj.deviceId];

    //消息上传服务器
    [self uploadMessageToServer:jsonMsg];
    
    //播放声音
    [JSMessageSoundEffect playMessageSentSound];
    
    [self finishSend];
}

- (void) clickedMessageForRowAtIndexPath:(NSIndexPath *) indexPath
{
    if (self.messages.count>0)
    {
        int index = self.messages.count-1-indexPath.row;
        NSDictionary *item = [messages objectAtIndex:index];
        NSString *soundPath= [[item objectForKey:@"sound"] retain];
        if (soundPath)
        {
            //下载播放
//            NSString *downPath = [[self getRecordURL] retain];
//            NSString *webAdd   = [[NSUserDefaults standardUserDefaults] objectForKey:WEBADDRESS];
//            soundPath = [NSString stringWithFormat:@"%@%@", webAdd, soundPath];
            
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
               
                //amr转换mp3文件
                [self convertAmrToMp3:soundPath];
            
//                //下载音频文件
//                ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:soundPath]];
//                request.userInfo = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:indexPath.row],@"TAG", nil];
//                [request setDelegate:self];
//                [request setDownloadProgressDelegate:self];
//                [request setDownloadDestinationPath:downPath];
//                [request startAsynchronous];
                dispatch_async(dispatch_get_main_queue(), ^{
                    //更新UI
                    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:indexPath.row],@"TAG", nil];
                    
                    //停止动画
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"stopVoiceAnimation"
                                                                        object:nil
                                                                      userInfo:dic];
                    
                    //显示动画
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"startVoiceAnimation"
                                                                        object:nil
                                                                      userInfo:dic];
                });
                
            });
            
        }
    }
}

- (JSBubbleMessageType)messageTypeForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.messages.count>0)
    {
        NSData *stuData  = [[NSUserDefaults standardUserDefaults] valueForKey:STUDENT];
        Student *student = [NSKeyedUnarchiver unarchiveObjectWithData:stuData];
        int index = self.messages.count-1-indexPath.row;
        NSDictionary *item = [messages objectAtIndex:index];
        NSString *phone    = [item objectForKey:@"phone"];
        if ([student.phoneNumber isEqualToString:phone])
        {
            return JSBubbleMessageTypeIncoming;
        }
        else
        {
            return JSBubbleMessageTypeOutgoing;
        }
    }
    return JSBubbleMessageTypeOutgoing;
}

- (JSBubbleMessageStyle)messageStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return JSBubbleMessageStyleSquare;
}

- (JSMessagesViewTimestampPolicy)timestampPolicy
{
    return JSMessagesViewTimestampPolicyCustom;
}

- (JSMessagesViewAvatarPolicy)avatarPolicy
{
    return JSMessagesViewAvatarPolicyBoth;
}

- (JSAvatarStyle)avatarStyle
{
    return JSAvatarTxtIncomingImgOutgoing;
}

- (JSAvatarStyle) outgoingAvatarStyle
{
    return JSAvatarStyleSquare;
}

- (JSAvatarStyle) incomingAvatarStyle
{
    return JSAvatarStyleText;
}

#pragma mark - Messages view data source
- (MsgType) msgTypeForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.messages.count>0)
    {
        int index = self.messages.count-1-indexPath.row;
        NSDictionary *dic = [self.messages objectAtIndex:index];
        if ([dic objectForKey:@"text"])
        {
            CLog(@"The Message is Text");
            return PUSH_TYPE_TEXT;
        }
        else if ([dic objectForKey:@"sound"])
        {
            CLog(@"The Message is Image");
            return PUSH_TYPE_AUDIO;
        }
    }
    
    return PUSH_TYPE_TEXT;
}

- (NSString *)textForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.messages.count>0)
    {
        int index = self.messages.count-1-indexPath.row;
        NSDictionary *dic = [self.messages objectAtIndex:index];
        return [dic objectForKey:@"text"];
    }
    
    return nil;
}

//- (NSDate *)timestampForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return [self.timestamps objectAtIndex:indexPath.row];
//}

- (BOOL)hasTimestampForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

//- (UIImage *)avatarImageForIncomingMessage
//{
//    return nil;//[UIImage imageNamed:@"demo-avatar-woz"];
//}
//

- (NSString *)avatarImagePathForOutgoingMessage
{
    return tObj.headUrl;
}

- (BOOL) isHaveOrg
{
    return tObj.isId;
}

//- (UIImage *)avatarImageForOutgoingMessage
//{
//    return [UIImage imageNamed:@"demo-avatar-jobs"];
//}

- (NSString *)avatarNameForIncomingMessage
{
    return @"我";
}

#pragma mark -
#pragma mark - CustomNavigationDataSource
- (UIBarButtonItem *) backBarButtomItem
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
- (void)requestFinished:(ASIHTTPRequest *)request
{   
    //播放声音
    NSString *soundPath = [[self getRecordURL] retain];
    NSData *soundData   = [NSData dataWithContentsOfFile:soundPath];
    [recordAudio play:soundData];
    
    //显示动画
    [[NSNotificationCenter defaultCenter] postNotificationName:@"startVoiceAnimation"
                                                        object:nil
                                                      userInfo:request.userInfo];
}

- (void) requestAsyncFailed:(ASIHTTPRequest *)request
{
    //聊天记录刷新完成
    [self doneLoadingTableViewData];
    
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
    //聊天记录刷新完成
    [self doneLoadingTableViewData];
    
    NSData   *resVal = [[request responseData] retain];
    NSString *resStr = [[[NSString alloc]initWithData:resVal
                                            encoding:NSUTF8StringEncoding]retain];
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
        if ([action isEqualToString:@"setListening"])
        {
            [self showAlertWithTitle:@"提示"
                                 tag:0
                             message:@"您申请了试听课程,我们将以短信告知老师"
                            delegate:self
                   otherButtonTitles:@"确定",nil];
        }
        else if ([action isEqualToString:@"getMessages"])
        {
            NSArray *array = [resDic objectForKey:@"messages"];
            if (array)
            {
                if (isNewData)
                    [messages removeAllObjects];
                
                for (int i=0; i<array.count; i++)
                {
                    NSDictionary *item = [array objectAtIndex:i];
                    [messages insertObject:item
                                   atIndex:self.messages.count];
                }
            }
            
            //刷新界面
            [self finishSend];
            
            //消息查看更新
            [self updateMessageZT];
        }
    }
    else
    {
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
