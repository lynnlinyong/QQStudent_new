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
    [self initUI];
    [self initPullView];
    
    //获得聊天记录
    [self getChatRecords];
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showTeacherDetailNotice:)
                                                 name:@"showTeacherDetailNotice"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(dismissComplainNotice:)
                                                 name:@"dismissComplainNotice"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshNewData:)
                                                 name:@"refreshNewData"
                                               object:nil];
}

- (void) viewDidDisappear:(BOOL)animated
{
    [listenBtn removeFromSuperview];
    listenBtn = nil;
    
    [employBtn removeFromSuperview];
    employBtn = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [super viewDidDisappear:animated];
}

- (void) dealloc
{
    [order release];
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
- (void) initUI
{
    self.delegate = self;
    self.dataSource = self;
    self.messages   = [[NSMutableArray alloc]init];

    listenBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [listenBtn setTitle:@"试听" forState:UIControlStateNormal];
    listenBtn.tag   = 0;
    listenBtn.frame = CGRectMake(320-95, 7, 40, 20);
    [listenBtn addTarget:self
                  action:@selector(doButtonClicked:)
        forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.navigationBar addSubview:listenBtn];
    
    employBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [employBtn setTitle:@"聘请"
               forState:UIControlStateNormal];
    employBtn.tag   = 1;
    employBtn.frame = CGRectMake(320-45, 7, 40, 20);
    [employBtn addTarget:self
                  action:@selector(doButtonClicked:)
        forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.navigationBar addSubview:employBtn];
    
    //是否支持试听、聘用
    [self isShowListenBtn];
    if (!order)
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
        NSString *url    = [NSString stringWithFormat:@"%@%@", webAdd,STUDENT];
        [request requestASyncWith:kServerPostRequest
                         paramDic:pDic
                           urlStr:url];
    }
}

- (void) isShowListenBtn
{
    NSString *ssid = [[NSUserDefaults standardUserDefaults] objectForKey:SSID];
    
    //判断是否显示试听和聘请
    NSArray *paramsArr = [NSArray arrayWithObjects:@"action",@"phone",@"sessid", nil];
    NSArray *valusArr  = [NSArray arrayWithObjects:@"getListening",tObj.phoneNums,ssid, nil];
    NSDictionary *pDic = [NSDictionary dictionaryWithObjects:valusArr
                                                     forKeys:paramsArr];
    
    ServerRequest *request = [ServerRequest sharedServerRequest];
    request.delegate = self;
    NSString *webAddress = [[NSUserDefaults standardUserDefaults] valueForKey:WEBADDRESS];
    NSString *url  = [NSString stringWithFormat:@"%@%@/", webAddress,STUDENT];
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
            int isListening = ((NSNumber *)[resDic objectForKey:@"isListening"]).intValue;
            if (isListening == 1)
            {
                listenBtn.hidden = NO;
            }
            else
            {
                listenBtn.hidden = YES;
            }
        }
    }
    else
    {
        listenBtn.hidden = YES;
    }
}

- (void) isShowEmployBtn
{
    NSString *ssid = [[NSUserDefaults standardUserDefaults] objectForKey:SSID];
    
    //判断是否显示试听和聘请
    NSArray *paramsArr = [NSArray arrayWithObjects:@"action",@"phone",@"sessid", nil];
    NSArray *valusArr  = [NSArray arrayWithObjects:@"getHire",tObj.phoneNums,ssid, nil];
    NSDictionary *pDic = [NSDictionary dictionaryWithObjects:valusArr
                                                     forKeys:paramsArr];
    
    ServerRequest *request = [ServerRequest sharedServerRequest];
    request.delegate = self;
    NSString *webAddress = [[NSUserDefaults standardUserDefaults] valueForKey:WEBADDRESS];
    NSString *url  = [NSString stringWithFormat:@"%@%@/", webAddress,STUDENT];
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
}

- (void) getChatRecords
{
    [self.messages removeAllObjects];
    NSString *ssid = [[NSUserDefaults standardUserDefaults] objectForKey:SSID];
    NSArray *paramsArr = [NSArray arrayWithObjects:@"action",@"messageId",@"phone",@"sessid", nil];
    NSArray *valuesArr = [NSArray arrayWithObjects:@"getMessages",@"0",tObj.phoneNums, ssid, nil];
    NSDictionary *pDic = [NSDictionary dictionaryWithObjects:valuesArr
                                                     forKeys:paramsArr];
    ServerRequest *request = [ServerRequest sharedServerRequest];
    request.delegate = self;
    NSString *webAdd = [[NSUserDefaults standardUserDefaults] objectForKey:WEBADDRESS];
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
            [SVProgressHUD show];
            
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

- (void) doButtonClicked:(id)sender
{
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
            NSString *url  = [NSString stringWithFormat:@"%@%@/", webAddress,STUDENT];
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
                AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                UINavigationController *nav     = (UINavigationController *)app.window.rootViewController;
                UpdateOrderViewController *upVctr = [[UpdateOrderViewController alloc]init];
                upVctr.order = [order copy];
                [nav pushViewController:upVctr
                               animated:YES];
//                [self.navigationController pushViewController:upVctr
//                                                     animated:YES];
                [upVctr release];
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
    NSString *url  = [NSString stringWithFormat:@"%@%@/", webAddress,STUDENT];
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
    NSString *url  = [NSString stringWithFormat:@"%@%@/", webAddress,STUDENT];
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
    UINavigationController *nav     = (UINavigationController *)app.window.rootViewController;
    TeacherDetailViewController *tdVctr = [[TeacherDetailViewController alloc]init];
    tdVctr.tObj = tObj;
    [nav pushViewController:tdVctr
                   animated:YES];
//    [self.navigationController pushViewController:tdVctr
//                                         animated:YES];
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
    NSString *ssid = [[NSUserDefaults standardUserDefaults] objectForKey:SSID];
    NSArray *paramsArr = [NSArray arrayWithObjects:@"action",@"teacher_phone",@"sessid", nil];
    NSArray *valuesArr = [NSArray arrayWithObjects:@"callPhone",tObj.phoneNums, ssid, nil];
    
    NSDictionary *pDic = [NSDictionary dictionaryWithObjects:valuesArr
                                                     forKeys:paramsArr];
    
    NSString *webAdd = [[NSUserDefaults standardUserDefaults] objectForKey:WEBADDRESS];
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
        NSString *action = [resDic objectForKey:@"action"];
        if ([action isEqualToString:@"callPhone"])
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
    NSArray *valuesArr  = [NSArray arrayWithObjects:[NSNumber numberWithInt:PUSH_TYPE_TEXT],student.phoneNumber,student.nickName,@"http://210.5.152.145:8085/Interfaces/uploadfile/file/18610674146/image/20140113231657_49416.jpg",text,timeSp,tObj.phoneNums,[SingleMQTT getCurrentDevTopic], nil];
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
    
    [self finishSend];
}

- (void) clickedMessageForRowAtIndexPath:(NSIndexPath *) indexPath
{
    if (self.messages.count>0)
    {
        int index = self.messages.count-1-indexPath.row;
        NSDictionary *item = [messages objectAtIndex:index];
        NSString *soundPath= [item objectForKey:@"sound"];
        if (soundPath)
        {
            //下载播放
            
            NSString *downPath = [self getRecordURL];
            NSString *webAdd   = [[NSUserDefaults standardUserDefaults] objectForKey:WEBADDRESS];
            soundPath = [NSString stringWithFormat:@"%@%@", webAdd, soundPath];
            
            CLog(@"It's Sound:%@", soundPath);
            
            ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:soundPath]];
            request.userInfo = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:indexPath.row],@"TAG", nil];
            [request setDelegate:self];
            [request setDownloadProgressDelegate:self];
            [request setDownloadDestinationPath:downPath];
            [request startAsynchronous];
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

//- (UIImage *)avatarImageForOutgoingMessage
//{
//    return [UIImage imageNamed:@"demo-avatar-jobs"];
//}

- (NSString *)avatarNameForIncomingMessage
{
    return @"我";
}

//- (NSString *)avatarNameForOutgoingMessage
//{
//    return tObj.name;
//}

#pragma mark -
#pragma mark ServerRequest Delegate
- (void)requestFinished:(ASIHTTPRequest *)request
{
    CLog(@"Down Load Success!");
    
    //播放声音
    NSString *soundPath = [self getRecordURL];
    NSData *soundData   = [NSData dataWithContentsOfFile:soundPath];
    [recordAudio play:soundData];
    
    //显示动画
    [[NSNotificationCenter defaultCenter] postNotificationName:@"startVoiceAnimation"
                                                        object:nil
                                                      userInfo:request.userInfo];
}

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
            for (NSDictionary *item in array)
            {
                [self.messages addObject:item];
            }
            [self.tableView reloadData];
            
            //消息查看更新
            [self updateMessageZT];
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
    
    //聊天记录刷新完成
    [self doneLoadingTableViewData];
}

@end
