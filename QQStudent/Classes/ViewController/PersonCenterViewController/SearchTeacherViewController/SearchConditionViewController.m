//
//  SearchConditionViewController.m
//  QQStudent
//
//  Created by lynn on 14-1-30.
//  Copyright (c) 2014年 lynn. All rights reserved.
//

#import "SearchConditionViewController.h"

@interface SearchConditionViewController ()

@end

@implementation SearchConditionViewController
@synthesize tObj;
@synthesize posDic;

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
    [MainViewController setNavTitle:@"轻轻家教"];
}

- (void)viewDidDisappear:(BOOL)animated
{
    CustomNavigationViewController *nav = [MainViewController getNavigationViewController];
    nav.dataSource = nil;
    [super viewDidDisappear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //初始化录音
    recordAudio = [[RecordAudio alloc]init];
    recordAudio.delegate = self;
    
    [self initBackBarItem];
    
//    [Student getSubjects];
    
    //初始化UI
    [self initUI];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewDidUnload
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    messageField.delegate = nil;
    messageField = nil;
    
    recordAudio.delegate = nil;
    
    orderTab.delegate = nil;
    orderTab.dataSource = nil;
    [super viewDidUnload];
}

- (void) dealloc
{
    [posDic       release];
    [salaryDic    release];
    [recordAudio  release];
    [subValLab    release];
    [dateValLab   release];
    [orderTab release];
    [timeValueLab release];
    [messageField release];
    [sexValLab release];
    [super dealloc];
}

#pragma mark -
#pragma mark - Custom Action
- (void) initBackBarItem
{
    CustomNavigationViewController *nav = [MainViewController getNavigationViewController];
    nav.dataSource = self;
}

- (void) doBackBtnClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) initUI
{
    UIImage *titleImg = [UIImage imageNamed:@"sd_title"];
    UIImageView *titleImgView = [[UIImageView alloc]init];
    titleImgView.image = titleImg;
    titleImgView.frame = [UIView fitCGRect:CGRectMake(self.view.frame.size.width/2-titleImg.size.width/2, 13,
                                                      titleImg.size.width, titleImg.size.height)
                                isBackView:NO];
    [self.view addSubview:titleImgView];
    [titleImgView release];
    
    orderTab = [[UITableView alloc]init];
    orderTab.delegate = self;
    orderTab.dataSource = self;
    orderTab.scrollEnabled = NO;
    orderTab.frame = [UIView fitCGRect:CGRectMake(self.view.frame.size.width/2-titleImg.size.width/2, titleImg.size.height+10,
                                                  titleImg.size.width, 340)
                            isBackView:YES];
    orderTab.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:orderTab];

    orderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    orderBtn.tag   = 1;
    UIImage *img   = [UIImage imageNamed:@"main_invit_invide_btn"];
    orderBtn.frame = [UIView fitCGRect:CGRectMake(160-img.size.width/2,
                                                  480-44-img.size.height,
                                                  img.size.width,
                                                  img.size.height)
                            isBackView:NO];
    orderBtn.enabled = NO;
    [orderBtn setImage:img
              forState:UIControlStateNormal];
    [orderBtn setImage:[UIImage imageNamed:@"main_invit_hlight_btn"]
              forState:UIControlStateHighlighted];
    [orderBtn addTarget:self
                 action:@selector(doButtonClicked:)
       forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:orderBtn];
    
    NSDictionary *userDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"Condition"];
    CLog(@"sdfjsidjfUserDic:%@", userDic);
    posDic = [[userDic objectForKey:@"POSDIC"] copy];
    CLog(@"sdfsdfsjijiji:%@", posDic);
    //注册设置性别消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(setSexFromNotice:)
                                                 name:@"setSexNotice"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(setSalaryFromNotice:)
                                                 name:@"setSalaryNotice"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(setDateFromNotice:)
                                                 name:@"setDateNotice"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(setTimesFromNotice:)
                                                 name:@"setTimesNotice"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(setSubjectFromNotice:)
                                                 name:@"setSubjectNotice"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(setPosNotice:) name:@"setPosNotice"
                                               object:nil];
}

- (NSString *) getRecordURL
{
    NSArray *paths   = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                           NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSMutableString  *path       = [[[NSMutableString alloc]initWithString:documentsDirectory]autorelease];
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
    NSString *path   = [[self getRecordURL] retain];
    CLog(@"path:%@", path);
    [curAudio writeToFile:path
               atomically:YES];
    [path release];
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
        CLog(@"播放完成");
    }
    else if(status==2)
    {
        //出错
        CLog(@"播放出错");
    }
}

- (void) checkConditionIsFinish
{
    if (dateValLab.text.length!=0 && subValLab.text.length!=0 &&
         sexValLab.text.length!=0 && salaryValLab.text.length!=0 &&
            timeValueLab.text.length!=0 && posValLab.text.length!=0)
    {
        orderBtn.enabled = YES;
        [orderBtn setImage:[UIImage imageNamed:@"main_invit_normal_btn"]
                  forState:UIControlStateNormal];
        [orderBtn setImage:[UIImage imageNamed:@"main_invit_hlight_btn"]
                  forState:UIControlStateHighlighted];
    }
}

#pragma mark -
#pragma mark - Control Event
- (void) longPressButton:(UILongPressButton *)button status:(ButtonStatus)status
{
    switch (status)
    {
        case LONG_PRESS_BUTTON_DOWN:      //长按开始
        {
            //显示动画
            [SVProgressHUD show];
            
            [self startRecord];
            break;
        }
        case LONG_PRESS_BUTTON_SHORT:    //长按太短
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
        case LONG_PRESS_BUTTON_LONG:     //长按太长
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
        case LONG_PRESS_BUTTON_UP:       //长按结束
        {
            //停止动画
            [SVProgressHUD dismiss];
            [self stopRecord];
            
            recordLongPressBtn.hidden = YES;
            recordSuccessBtn.hidden   = NO;
            
            //显示喇叭
            
            break;
        }
        default:
            break;
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
#pragma mark - Control Event
- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self repickView:self.view];
    return YES;
}

- (void) textFieldDidBeginEditing:(UITextField *)textField
{
    [self moveViewWhenViewHidden:orderBtn
                          parent:self.view];
}

- (void) doButtonClicked:(id)sender
{
    UIButton *button = sender;
    switch (button.tag)
    {
        case 0: //返回
        {
            [self.navigationController popViewControllerAnimated:YES];
            break;
        }
        case 1: //邀请
        {
            if (dateValLab.text.length==0||subValLab.text.length==0||salaryValLab.text.length==0||sexValLab.text.length==0||timeValueLab.text.length==0||posValLab.text.length==0)
            {
                [self showAlertWithTitle:@"提示"
                                     tag:0
                                 message:@"筛选信息不完整"
                                delegate:self
                       otherButtonTitles:@"确定",nil];
                return;
            }
            
            
            NSString *path = @"";
            if (recordLongPressBtn.isRecord)
            {
                path = [self getRecordURL];
                //获得时间戳
                NSDate *dateNow  = [NSDate date];
                NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[dateNow timeIntervalSince1970]];
                
                NSString *ssid = [[NSUserDefaults standardUserDefaults] objectForKey:SSID];
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
                NSData *resVal = [request requestSyncWith:kServerPostRequest
                                                 paramDic:pDic
                                                   urlStr:url];
                assert(resVal);
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

            //封装所选条件
            NSString *sub = [Student searchSubjectID:subValLab.text];
            CLog(@"salaryDic:%@", salaryDic);
            NSDictionary *valueDic = [NSDictionary dictionaryWithObjectsAndKeys:dateValLab.text,@"Date",sub,
                                      @"Subject",salaryDic,@"SalaryDic",[Student searchGenderID:sexValLab.text],@"Sex",timeValueLab.text,@"Time",posValLab.text,@"Pos",posDic,@"POSDIC",path,@"AudioPath",messageField.text,@"Message",nil];
            
            CLog(@"codition:%@", valueDic);
            
            //保存载入信息
            [[NSUserDefaults standardUserDefaults] setObject:valueDic
                                                      forKey:@"Condition"];
            
            
            //如果是搜索老师直接发送订单信息
            if (tObj)
            {
                CustomNavigationViewController *nav = [MainViewController getNavigationViewController];
                [MBProgressHUD showHUDAddedTo:nav.view animated:YES];
                [self uploadOrderToServer:valueDic];
            }
            else
            {            
                WaitConfirmViewController *wcVctr = [[WaitConfirmViewController alloc]init];
                if (tObj)
                    wcVctr.tObj     = tObj;
                wcVctr.valueDic     = [valueDic copy];
                [self.navigationController pushViewController:wcVctr
                                                     animated:YES];
                [wcVctr release];
            }
            break;
        }
        case 2:     //录音
        {
            recordBtn.hidden    = YES;
            messageField.hidden = YES;
            keyBoardBtn.hidden  = NO;
            recordLongPressBtn.hidden = NO;
            
            break;
        }
        case 3:     //键盘
        {
            recordBtn.hidden   = NO;
            keyBoardBtn.hidden = YES;
            messageField.hidden= NO;
            recordLongPressBtn.hidden = YES;
            recordSuccessBtn.hidden   = YES;
            break;
        }
        case 5:     //录音成功
        {
            //显示提示
            reCustomBtnView.hidden = NO;
            clrBtnView.hidden = NO;
            break;
        }
        default:
            break;
    }
}

- (void) uploadOrderToServer:(NSDictionary *) valueDic
{
    if (![AppDelegate isConnectionAvailable:YES withGesture:NO])
    {
        return;
    }
    
    //个人位置
    NSString *log   = [[NSUserDefaults standardUserDefaults] objectForKey:@"LONGITUDE"];
    NSString *la    = [[NSUserDefaults standardUserDefaults] objectForKey:@"LATITUDE"];
    
    //封装iaddress_data
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
    CLog(@"addValueArr:%@", addValueArr);
    NSDictionary *addressDic = [NSDictionary dictionaryWithObjects:addValueArr
                                                           forKeys:addParamArr];
    
    NSData *stuData  = [[NSUserDefaults standardUserDefaults] objectForKey:STUDENT];
    Student *student = [NSKeyedUnarchiver unarchiveObjectWithData:stuData];
    
    NSDate *dateNow  = [NSDate date];
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[dateNow timeIntervalSince1970]];
    
    //获得salary
    NSString *salary   = [salaryDic objectForKey:@"name"];
    
    //总金额
    int studyTimes     = ((NSString *)[valueDic objectForKey:@"Time"]).intValue;
    NSNumber *taMount  = [NSNumber numberWithInt:(salary.intValue*studyTimes)];
    NSArray *paramsArr = [NSArray arrayWithObjects:@"subjectIndex",@"subjectId",@"subjectText",@"kcbzIndex",
                                                  @"iaddress_data",@"teacher_phone",@"teacher_deviceId",
                                                  @"phone",@"pushcc",@"type", @"nickname",
                                                  @"grade",@"gender",@"subjectId",@"teacherGender",
                                                  @"tamount",@"yjfdnum",@"sd",@"iaddress",
                                                  @"longitude",@"latitude",@"otherText",
                                                  @"audio",@"deviceId", @"keyId", nil];
    NSArray *valueArr = [NSArray arrayWithObjects:[valueDic objectForKey:@"Subject"],[valueDic objectForKey:@"Subject"],[Student searchSubjectName:[valueDic objectForKey:@"Subject"]],salary,addressDic,tObj.phoneNums,tObj.deviceId,student.phoneNumber,@"0",[NSNumber numberWithInt:PUSH_TYPE_PUSH], student.nickName, [Student searchGradeName:student.grade], [Student searchGenderID:student.gender],[valueDic objectForKey:@"Subject"],[Student searchGenderID:[valueDic objectForKey:@"Sex"]],taMount,[valueDic objectForKey:@"Time"],[valueDic objectForKey:@"Date"],[valueDic objectForKey:@"Pos"],log,la,@"",@"",[SingleMQTT getCurrentDevTopic], timeSp, nil];
    CLog(@"valueArr:%@", valueArr);
    NSDictionary *orderDic  = [NSDictionary dictionaryWithObjects:valueArr
                                                          forKeys:paramsArr];
    NSString *jsonOrder = [orderDic JSONFragment];
    NSString *ssid = [[NSUserDefaults standardUserDefaults] objectForKey:SSID];
    NSArray *pArr = [NSArray arrayWithObjects:@"action",@"orderInfo",@"sessid", nil];
    NSArray *vArr = [NSArray arrayWithObjects:@"submitOrder",jsonOrder,ssid, nil];
    NSDictionary *pDic = [NSDictionary dictionaryWithObjects:vArr
                                                     forKeys:pArr];
    ServerRequest *serverReq = [ServerRequest sharedServerRequest];
    serverReq.delegate = self;
    NSString *webAddress = [[NSUserDefaults standardUserDefaults] valueForKey:WEBADDRESS];
    NSString *url = [NSString stringWithFormat:@"%@%@/", webAddress,STUDENT];
    [serverReq requestASyncWith:kServerPostRequest
                       paramDic:pDic
                         urlStr:url];
}

#pragma mark -
#pragma mark - Notice
- (void) setPosNotice:(NSNotification *) notice
{
    posDic = [notice.userInfo copy];
    
    NSString *provice = [notice.userInfo objectForKey:@"PROVICE"];
    NSString *city    = [notice.userInfo objectForKey:@"CITY"];
    NSString *dist    = [notice.userInfo objectForKey:@"DIST"];
    posValLab.text    = [notice.userInfo objectForKey:@"ADDRESS"];
    
    [self checkConditionIsFinish];
}

- (void) setSalaryFromNotice:(NSNotification *) notice
{
    NSString *salary  = @"";
    
    if ([[notice.userInfo objectForKey:@"name"] isEqualToString:@"0"])
        salary = @"师生协商";
    else
        salary = [notice.userInfo objectForKey:@"name"];
    
    salaryValLab.text = salary;
    salaryDic = [notice.userInfo copy];
    
    [self checkConditionIsFinish];
}

- (void) setSexFromNotice:(NSNotification *) notice
{
    int tag   = ((NSNumber *)[notice.userInfo objectForKey:@"TAG"]).intValue;
    int index = ((NSNumber *)[notice.userInfo objectForKey:@"Index"]).intValue;
    
    if (tag==0)  //确定
    {
        switch (index)
        {
            case 1:
            {
                sexValLab.text = @"男";
                break;
            }
            case 2:
            {
                sexValLab.text = @"女";
                break;
            }
            case 3:
            {
                sexValLab.text = @"不限";
                break;
            }
            default:
                break;
        }
    }
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
    
    [self checkConditionIsFinish];
}

- (void) setDateFromNotice:(NSNotification *) notice
{
    int tag = ((NSNumber *)[notice.userInfo objectForKey:@"TAG"]).intValue;
    if (tag==0)
    {
        NSString *dateString = [notice.userInfo objectForKey:@"SetDate"];
        dateValLab.text = dateString;
    }
    
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
    
    [self checkConditionIsFinish];
}

- (void) setTimesFromNotice:(NSNotification *)notice
{
    int tag = ((NSNumber *)[notice.userInfo objectForKey:@"TAG"]).intValue;
    if (tag==0)
    {
        timeValueLab.text = [notice.userInfo objectForKey:@"Time"];
    }
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
    
    [self checkConditionIsFinish];
}

- (void) setSubjectFromNotice:(NSNotification *)notice
{
    NSNumber *tag  = (NSNumber *)[notice.userInfo objectForKey:@"TAG"];
    CLog(@"tag:%d", tag.intValue);
    if (tag.intValue==0)
    {
        NSDictionary *subDic = [notice.userInfo objectForKey:@"subDic"];
        subValLab.text = [subDic objectForKey:@"name"];
        [self checkConditionIsFinish];
    }
    
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
}

#pragma mark -
#pragma mark - CustomButtomViewDelegate
- (void) view:(CustomButtonView *)view index:(int)index
{
    switch (index)
    {
        case 0:      //重听一遍
        {
            //写入amr数据文件
            NSString *path   = [self getRecordURL];
            NSData *curAudio = [NSData dataWithContentsOfFile:path];
            [recordAudio play:curAudio];
            break;
        }
        case 1:      //清除录音
        {
            recordSuccessBtn.hidden     = YES;
            recordLongPressBtn.hidden   = NO;
            recordLongPressBtn.isRecord = NO;
            break;
        }
        default:
            break;
    }
    
    //隐藏操作图层
    reCustomBtnView.hidden = YES;
    clrBtnView.hidden = YES;
}

#pragma mark -
#pragma mark - UITableViewDelegate and UITableViewDataSource
- (int) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (int) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 7;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *idString    = @"idString";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:idString];
    NSDictionary *userDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"Condition"];
    [self checkConditionIsFinish];
    if (!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault
                                     reuseIdentifier:idString];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        switch (indexPath.row)
        {
            case 0:
            {
                UILabel *startDate = [[UILabel alloc]init];
                startDate.text = @"开始日期";
                startDate.backgroundColor = [UIColor clearColor];
                startDate.frame = [UIView fitCGRect:CGRectMake(2, 4.5, 80, 42)
                                         isBackView:NO];
                [cell addSubview:startDate];
                [startDate release];
                
                dateValLab = [[UILabel alloc]init];
                if ([userDic objectForKey:@"Date"])
                    dateValLab.text = [userDic objectForKey:@"Date"];
                else
                    dateValLab.text = @"";
                dateValLab.textAlignment   = NSTextAlignmentCenter;
                dateValLab.backgroundColor = [UIColor clearColor];
                dateValLab.frame = CGRectMake(80, 4.5, 170, 35);
                [cell addSubview:dateValLab];
                
                cell.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"sd_cell_normal_bg"]
                                                       highlightedImage:[UIImage imageNamed:@"sd_cell_hlight_bg"]];
                break;
            }
            case 1:
            {
                UILabel *subLab = [[UILabel alloc]init];
                subLab.text = [NSString stringWithFormat:@"辅导科目"];
                subLab.backgroundColor = [UIColor clearColor];
                subLab.frame = CGRectMake(2, 4.5, 140, 35);
                [cell addSubview:subLab];
                [subLab release];
                
                subValLab  = [[UILabel alloc]init];
                subValLab.frame = CGRectMake(140, 4.5, 120, 35);
                if (tObj)
                {
                    subValLab.text = tObj.pf;
                }
                else
                {
                    if ([userDic objectForKey:@"Subject"])
                        subValLab.text = [Student searchSubjectName:[userDic objectForKey:@"Subject"]];
                    else
                        subValLab.text = @"";
                }
                [cell addSubview:subValLab];
                
                cell.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"sd_cell_normal_bg"]
                                                       highlightedImage:[UIImage imageNamed:@"sd_cell_hlight_bg"]];
                break;
            }
            case 2:
            {
                UILabel *sexLab = [[UILabel alloc]init];
                sexLab.text = @"老师性别 ";
                sexLab.backgroundColor = [UIColor clearColor];
                sexLab.frame = CGRectMake(2, 4.5, 140, 35);
                [cell addSubview:sexLab];
                [sexLab release];
                
                sexValLab = [[UILabel alloc]init];
                sexValLab.frame = CGRectMake(140, 4.5, 120, 35);
                
                if (tObj)
                {
                    if (tObj.sex == 1)
                    {
                        sexValLab.text = @"男";
                    }
                    else
                    {
                        sexValLab.text = @"女";
                    }
                }
                else
                {
                    if ([userDic objectForKey:@"Sex"])
                    {
                        NSString *sex = [[userDic objectForKey:@"Sex"] copy];
                        if (sex.intValue == 1)
                        {
                            sexValLab.text = @"男";
                        }
                        else
                        {
                            sexValLab.text = @"女";
                        }
                    }
                    else
                        sexValLab.text = @"";
                }
                [cell addSubview:sexValLab];
                
                cell.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"sd_cell_normal_bg"]
                                                       highlightedImage:[UIImage imageNamed:@"sd_cell_hlight_bg"]];
                break;
            }
            case 3:
            {
                UILabel *salaryLab = [[UILabel alloc]init];
                salaryLab.text = @"每小时课酬标准";
                salaryLab.backgroundColor = [UIColor clearColor];
                salaryLab.frame = [UIView fitCGRect:CGRectMake(2, 4.5, 140, 35)
                                         isBackView:NO];
                [cell addSubview:salaryLab];
                [salaryLab release];
                
                salaryDic = [[userDic objectForKey:@"SalaryDic"] copy];
                NSString *salary = @"";
                if (tObj)
                {
                    //封装SalaryDic
                    NSString *expense = [NSString stringWithFormat:@"%d",tObj.expense];
                    salaryDic = [[NSDictionary dictionaryWithObjectsAndKeys:expense,@"id",
                                 [Student searchSalaryName:expense],@"name", nil] copy];
                    CLog(@"salaryDic:%@", salaryDic);
                    salary = [Student searchSalaryName:[NSString stringWithFormat:@"%d",tObj.expense]];
                }
                else
                {
                    salary = [salaryDic objectForKey:@"name"];
                    if (salary)
                    {
                        if ([salary isEqualToString:@"0"])
                            salary = @"师生协商";
                        else
                            salary = [salaryDic objectForKey:@"name"];
                    }
                    else
                    {
                        salary = @"";
                    }
                }
                salaryValLab  = [[UILabel alloc]init];
                salaryValLab.text = salary;
                salaryValLab.backgroundColor = [UIColor clearColor];
                salaryValLab.frame = CGRectMake(140, 4.5, 140, 35);
                [cell addSubview:salaryValLab];
                
                cell.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"sd_cell_normal_bg"]
                                                       highlightedImage:[UIImage imageNamed:@"sd_cell_hlight_bg"]];
                break;
            }
            case 4:
            {
                UILabel *timesLab = [[UILabel alloc]init];
                timesLab.text = @"预计辅导小时数";
                timesLab.backgroundColor = [UIColor clearColor];
                timesLab.frame = [UIView fitCGRect:CGRectMake(2, 4.5, 140, 35)
                                         isBackView:NO];
                [cell addSubview:timesLab];
                [timesLab release];
                
                NSString *times = [[userDic objectForKey:@"Time"] copy];
                if (times)
                    timeValueLab.text = times;
                else
                    timeValueLab.text = @"";
                
                timeValueLab = [[UILabel alloc]init];
                timeValueLab.text = times;
                timeValueLab.backgroundColor = [UIColor clearColor];
                timeValueLab.frame = CGRectMake(140, 4.5, 140, 35);
                [cell addSubview:timeValueLab];
                
                cell.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"sd_cell_normal_bg"]
                                                       highlightedImage:[UIImage imageNamed:@"sd_cell_hlight_bg"]];
                break;
            }
            case 5:
            {
                UILabel *posLab = [[UILabel alloc]init];
                posLab.text = @"授课地点";
                posLab.backgroundColor = [UIColor clearColor];
                posLab.frame = [UIView fitCGRect:CGRectMake(2, 4.5, 140, 35)
                                      isBackView:NO];
                [cell addSubview:posLab];
                [posLab release];
                
                posValLab = [[UILabel alloc]init];
                NSString *pos = [[userDic objectForKey:@"Pos"] copy];
                if (pos) {
                    posValLab.text = pos;
                }
                else
                    posValLab.text = @"";
                posValLab.backgroundColor = [UIColor clearColor];
                posValLab.frame = CGRectMake(140, 4.5, 130, 35);
                posValLab.font  = [UIFont systemFontOfSize:12.f];
                [cell addSubview:posValLab];
                
                cell.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"sd_cell_normal_bg"]
                                                       highlightedImage:[UIImage imageNamed:@"sd_cell_hlight_bg"]];
                break;
            }
            case 6:
            {
                UIImage *recordImg = [UIImage imageNamed:@"sd_record_btn"];
                
                recordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                recordBtn.tag    = 2;
                recordBtn.hidden = NO;
                [recordBtn setImage:recordImg
                           forState:UIControlStateNormal];
                recordBtn.frame  = CGRectMake(0, 17.5, 40, 30);
                [recordBtn addTarget:self
                              action:@selector(doButtonClicked:)
                    forControlEvents:UIControlEventTouchUpInside];
                [cell addSubview:recordBtn];
                
                keyBoardBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                keyBoardBtn.tag     = 3;
                keyBoardBtn.hidden  = YES;
                [keyBoardBtn setImage:[UIImage imageNamed:@"sd_input_btn"]
                             forState:UIControlStateNormal];
                keyBoardBtn.frame   = CGRectMake(0, 17.5, 40, 30);
                [keyBoardBtn addTarget:self
                                action:@selector(doButtonClicked:)
                      forControlEvents:UIControlEventTouchUpInside];
                [cell addSubview:keyBoardBtn];
                
                UIImage *normalImg = [UIImage imageNamed:@"normal_fld"];
                UIImageView *emailImgView = [[UIImageView alloc]initWithImage:normalImg];
                messageField  = [[UITextField alloc]init];
                messageField.delegate    = self;
                messageField.borderStyle = UITextBorderStyleNone;
                messageField.frame = CGRectMake(40+5,20,normalImg.size.width-5,
                                                        normalImg.size.height);
                emailImgView.frame = CGRectMake(40,15,normalImg.size.width,
                                                normalImg.size.height+10);
                [cell addSubview:emailImgView];
                [cell addSubview:messageField];
                                
                recordLongPressBtn = [[UILongPressButton alloc]initWithFrame:CGRectMake(40, 7, 230, 37.5)];
                recordLongPressBtn.tag      = 4;
                recordLongPressBtn.delegate = self;
                recordLongPressBtn.frame    = CGRectMake(40, 15, 230, 37.5);
                recordLongPressBtn.hidden   = YES;
                [cell addSubview:recordLongPressBtn];
                
                UIImage *btnImg   = [UIImage imageNamed:@"normal_btn"];
                recordSuccessBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                recordSuccessBtn.hidden= YES;
                recordSuccessBtn.tag   = 5;
                recordSuccessBtn.frame = CGRectMake(40, 15,
                                                    btnImg.size.width,
                                                    btnImg.size.height);
                [recordSuccessBtn setBackgroundImage:btnImg
                                            forState:UIControlStateNormal];
                recordSuccessBtn.titleLabel.font = [UIFont systemFontOfSize:14.f];
                [recordSuccessBtn setTitleColor:[UIColor blackColor]
                                       forState:UIControlStateNormal];
                [recordSuccessBtn setTitle:@"录音成功"
                                  forState:UIControlStateNormal];
                [recordSuccessBtn addTarget:self
                                     action:@selector(doButtonClicked:)
                             forControlEvents:UIControlEventTouchUpInside];
                [cell addSubview:recordSuccessBtn];
                
                reCustomBtnView = [[CustomButtonView alloc]initWithFrame:CGRectMake(60, 120, 80, 80)];
                reCustomBtnView.tag      = 0;
                reCustomBtnView.hidden   = YES;
                reCustomBtnView.delegate = self;
                reCustomBtnView.imageView.image = [UIImage imageNamed:@"re_hearing.png"];
                reCustomBtnView.contentLab.text = @"重听一遍";
                [self.view addSubview:reCustomBtnView];
                
                clrBtnView = [[CustomButtonView alloc]initWithFrame:CGRectMake(180, 120, 80, 80)];
                clrBtnView.tag    = 1;
                clrBtnView.hidden = YES;
                clrBtnView.delegate = self;
                clrBtnView.imageView.image = [UIImage imageNamed:@"cls_record.png"];
                clrBtnView.contentLab.text = @"清除录音";
                [self.view addSubview:clrBtnView];
                
                soundImageView = [[UIImageView alloc]initWithFrame:CGRectMake(100, -10, 20, 20)];
                soundImageView.image  = [UIImage imageNamed:@"quanquan.png"];
                
                UIImageView *labaView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 10, 10)];
                labaView.image = [UIImage imageNamed:@"laba.png"];
                [soundImageView addSubview:labaView];
                [recordSuccessBtn addSubview:soundImageView];
                break;
            }
            default:
                break;
        }
    }
    
    return cell;
}

- (float) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 6)
    {
        return 60;
    }
    
    return 44;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.row)
    {
        case 0:         //选择时间
        {
            SelectDateViewController *sdVctr = [[SelectDateViewController alloc]init];
            sdVctr.curValue = dateValLab.text;
            [self presentPopupViewController:sdVctr
                               animationType:MJPopupViewAnimationFade];
            break;
        }
        case 1:
        {
            if (tObj)
            {
                //不可修改
            }
            else
            {
                SelectSubjectViewController *ssVctr = [[SelectSubjectViewController alloc]init];
                ssVctr.subName = subValLab.text;
                [self presentPopupViewController:ssVctr
                                   animationType:MJPopupViewAnimationFade];
            }
            break;
        }
        case 2:
        {
            if (tObj)
            {
                //不可修改
            }
            else
            {
                SelectSexViewController *ssVctr = [[SelectSexViewController alloc]init];
                if (sexValLab.text.length==0)
                    ssVctr.sexName = @"男";
                else
                    ssVctr.sexName = sexValLab.text;
                [self presentPopupViewController:ssVctr
                                   animationType:MJPopupViewAnimationFade];
            }
            break;
        }
        case 3:
        {
            SelectSalaryViewController *ssVctr = [[SelectSalaryViewController alloc]init];
            if (salaryValLab.text.length==0)
                ssVctr.money = @"180";
            else
                ssVctr.money = salaryValLab.text;
            [self.navigationController pushViewController:ssVctr
                                                 animated:YES];
            [ssVctr release];
            break;
        }
        case 4:
        {
            SelectTimesViewController *stVctr = [[SelectTimesViewController alloc]init];
            if (timeValueLab.text.length == 0)
                stVctr.curValue = @"200";
            else
                stVctr.curValue = timeValueLab.text;
            [self presentPopupViewController:stVctr
                               animationType:MJPopupViewAnimationFade];
            break;
        }
        case 5:
        {
            SelectPosViewController *spVctr = [[SelectPosViewController alloc]init];
            [self.navigationController pushViewController:spVctr animated:YES];
            [spVctr release];
            break;
        }
        case 6:
        {
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
    [self showAlertWithTitle:@"提示"
                         tag:1
                     message:@"网络繁忙"
                    delegate:self
           otherButtonTitles:@"确定",nil];
    
    CLog(@"***********Result****************");
    CLog(@"ERROR");
    CLog(@"***********Result****************");
    
    CustomNavigationViewController *nav = [MainViewController getNavigationViewController];
    [MBProgressHUD hideHUDForView:nav.view animated:YES];
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
        NSString *action = [resDic objectForKey:@"action"];
        if ([action isEqualToString:@"submitOrder"])
        {
            if (![AppDelegate isConnectionAvailable:YES withGesture:NO])
            {
                return;
            }
            
            //获取订单
            curOrder = [Order setOrderProperty:[resDic objectForKey:@"order"]];
            curOrder.teacher = tObj;
            
            //封装订单信息
            NSArray *paramsArr = [NSArray arrayWithObjects:@"order_sd",@"order_kcbz",@"order_jyfdnum",
                                  @"order_iaddress",@"order_iaddress_data", nil];
            NSArray *valueArr  = [NSArray arrayWithObjects:curOrder.orderAddTimes,curOrder.everyTimesMoney,
                                 curOrder.orderStudyTimes,curOrder.orderStudyPos,curOrder.addressDataDic, nil];
            NSDictionary *orderDic = [NSDictionary dictionaryWithObjects:valueArr
                                                                 forKeys:paramsArr];
            NSString *jsonOrder = [orderDic JSONFragment];
            CLog(@"jsonOrder:%@", jsonOrder);
            
            //封装修改订单提交字段
            NSString *ssid = [[NSUserDefaults standardUserDefaults] objectForKey:SSID];
            NSArray *pArr  = [NSArray arrayWithObjects:@"action",@"orderInfo",@"oid",@"sessid", nil];
            NSArray *vArr  = [NSArray arrayWithObjects:@"editOrder",jsonOrder,curOrder.orderId,ssid, nil];
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
        else if ([action isEqualToString:@"editOrder"])//修改订单
        {
            NSData *stuData    = [[NSUserDefaults standardUserDefaults] valueForKey:STUDENT];
            Student *student   = [NSKeyedUnarchiver unarchiveObjectWithData:stuData];
            
            //发送聘请消息
            NSArray *paramsArr = [NSArray arrayWithObjects:@"type",@"phone",@"nickname",@"orderid",@"taPhone",@"deviceId", nil];
            NSArray *valuesArr = [NSArray arrayWithObjects:[NSNumber numberWithInt:PUSH_TYPE_ORDER_EDIT],student.phoneNumber,
                                  curOrder.teacher.name,curOrder.orderId,curOrder.teacher.phoneNums,
                                  [SingleMQTT getCurrentDevTopic], nil];
            CLog(@"valArr:%@", valuesArr);
            NSDictionary *pDic = [NSDictionary dictionaryWithObjects:valuesArr
                                                             forKeys:paramsArr];
            //发送消息
            NSString *json = [pDic JSONFragment];
            CLog(@"update Order Msg:%@,%@", json, curOrder.teacher.deviceId);
            NSData *data   = [json dataUsingEncoding:NSUTF8StringEncoding];
            SingleMQTT *session = [SingleMQTT shareInstance];
            
            [session.session publishData:data
                                 onTopic:curOrder.teacher.deviceId];
            
            CustomNavigationViewController *nav = [MainViewController getNavigationViewController];
            [MBProgressHUD hideHUDForView:nav.view animated:YES];
            
            //跳转到沟通页
            ChatViewController *cVctr = [[ChatViewController alloc]init];
            cVctr.tObj  = tObj;
            cVctr.order = curOrder;
            cVctr.order.teacher = tObj;
            [nav pushViewController:cVctr animated:YES];
            [cVctr release];
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
        
        CustomNavigationViewController *nav = [MainViewController getNavigationViewController];
        [MBProgressHUD hideHUDForView:nav.view animated:YES];
    }
}

@end
