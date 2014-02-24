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
@synthesize teacherArray;
@synthesize posDic;

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
    
    [teacherArray removeAllObjects];
    [super viewDidUnload];
}

- (void) dealloc
{
    [recordAudio  release];
    [subValLab    release];
    [dateValLab   release];
    [teacherArray release];
    [timeValueLab release];
    [messageField release];
    [super dealloc];
}

#pragma mark -
#pragma mark - Custom Action
- (void) initUI
{
    UILabel *title        = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    title.textColor       = [UIColor colorWithHexString:@"#009f66"];
    title.backgroundColor = [UIColor clearColor];
    title.textAlignment   = UITextAlignmentCenter;
    title.text = @"轻轻家教";
    self.navigationItem.titleView = title;
    [title release];
    
    //设置返回按钮
    UIImage *backImg  = [UIImage imageNamed:@"nav_back_normal_btn@2x"];
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.tag       = 0;
    backBtn.frame     = CGRectMake(0, 0,
                                   50,
                                   30);
    [backBtn setBackgroundImage:backImg
                       forState:UIControlStateNormal];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"nav_back_hlight_btn@2x"]
                       forState:UIControlStateHighlighted];
    [backBtn addTarget:self
                action:@selector(doButtonClicked:)
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
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    
    orderTab = [[UITableView alloc]init];
    orderTab.delegate = self;
    orderTab.dataSource = self;
    orderTab.frame = [UIView fitCGRect:CGRectMake(20, 20, 280, 340)
                            isBackView:NO];
    [self.view addSubview:orderTab];
    
    UIButton *orderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    orderBtn.tag   = 1;
    UIImage *img   = [UIImage imageNamed:@"main_invit_normal_btn"];
    orderBtn.frame = [UIView fitCGRect:CGRectMake(160-img.size.width/2,
                                                  460-54-img.size.height,
                                                  img.size.width,
                                                  img.size.height)
                            isBackView:NO];
    [orderBtn setImage:img
              forState:UIControlStateNormal];
    [orderBtn setImage:[UIImage imageNamed:@"main_invit_hlight_btn"]
              forState:UIControlStateHighlighted];
    [orderBtn addTarget:self
                 action:@selector(doButtonClicked:)
       forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:orderBtn];
    
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
                                             selector:@selector(setSubjectFromNotice:) name:@"setSubjectNotice"
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
        CLog(@"播放完成");
    }
    else if(status==2)
    {
        //出错
        CLog(@"播放出错");
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
            break;
        }
        case LONG_PRESS_BUTTON_LONG:     //长按太长
        {
            [self showAlertWithTitle:@"提示"
                                 tag:0
                             message:@"录音时间太长"
                            delegate:self
                   otherButtonTitles:@"确定",nil];
            break;
        }
        case LONG_PRESS_BUTTON_UP:       //长按结束
        {
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

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
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
            NSDictionary *valueDic = [NSDictionary dictionaryWithObjectsAndKeys:dateValLab.text,@"Date",[Order searchSubjectID:subValLab.text],@"Subject",salaryDic,@"SalaryDic",[Student searchGenderID:sexValLab.text],@"Sex",timeValueLab.text,@"Time",posValLab.text,@"Pos",posDic,@"POSDIC",path,@"AudioPath",messageField.text,@"Message",nil];
            CLog(@"codition:%@", valueDic);
            
            WaitConfirmViewController *wcVctr = [[WaitConfirmViewController alloc]init];
            wcVctr.valueDic     = valueDic;
            wcVctr.tObj         = tObj;
            wcVctr.teacherArray = teacherArray;
            [self.navigationController pushViewController:wcVctr
                                                 animated:YES];
            [wcVctr release];
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

#pragma mark -
#pragma mark - Notice
- (void) setPosNotice:(NSNotification *) notice
{
    posDic = [notice.userInfo copy];
    
    NSString *provice = [notice.userInfo objectForKey:@"PROVICE"];
    NSString *city    = [notice.userInfo objectForKey:@"CITY"];
    NSString *dist    = [notice.userInfo objectForKey:@"DIST"];
    posValLab.text    = [notice.userInfo objectForKey:@"ADDRESS"];
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
}

- (void) setDateFromNotice:(NSNotification *) notice
{
    NSString *dateString = [notice.userInfo objectForKey:@"SetDate"];
    dateValLab.text = dateString;
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
}

- (void) setTimesFromNotice:(NSNotification *)notice
{
    timeValueLab.text = [notice.userInfo objectForKey:@"Time"];
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
}

- (void) setSubjectFromNotice:(NSNotification *)notice
{
    subValLab.text = [notice.userInfo objectForKey:@"name"];
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
    NSString *idString = @"idString";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:idString];
    if (!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault
                                     reuseIdentifier:idString];
        switch (indexPath.row)
        {
            case 0:
            {
                UILabel *startDate = [[UILabel alloc]init];
                startDate.text = @"开始日期";
                startDate.backgroundColor = [UIColor clearColor];
                startDate.frame = [UIView fitCGRect:CGRectMake(0, 0, 80, 44)
                                         isBackView:NO];
                [cell addSubview:startDate];
                [startDate release];
                
                dateValLab = [[UILabel alloc]init];
                dateValLab.text = @"";
                dateValLab.textAlignment   = NSTextAlignmentCenter;
                dateValLab.backgroundColor = [UIColor clearColor];
                dateValLab.frame = CGRectMake(80, 0, 170, 44);
                [cell addSubview:dateValLab];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                break;
            }
            case 1:
            {
                UILabel *subLab = [[UILabel alloc]init];
                subLab.text = [NSString stringWithFormat:@"辅导科目"];
                subLab.backgroundColor = [UIColor clearColor];
                subLab.frame = CGRectMake(0, 0, 140, 44);
                [cell addSubview:subLab];
                [subLab release];
                
                subValLab  = [[UILabel alloc]init];
                subValLab.text      = tObj.pf;
                subValLab.textColor = [UIColor lightGrayColor];
                subValLab.frame = CGRectMake(140, 0, 140, 44);
                [cell addSubview:subValLab];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                break;
            }
            case 2:
            {
                UILabel *sexLab = [[UILabel alloc]init];
                sexLab.text = @"老师性别 ";
                sexLab.backgroundColor = [UIColor clearColor];
                sexLab.frame = CGRectMake(0, 0, 140, 44);
                [cell addSubview:sexLab];
                [sexLab release];
                
                sexValLab = [[UILabel alloc]init];
                if (tObj.sex == 1)
                {
                    sexValLab.text = @"男";
                }
                else
                {
                    sexValLab.text = @"女";
                }
                sexValLab.textColor = [UIColor lightGrayColor];
                sexValLab.frame = CGRectMake(140, 0, 140, 44);
                [cell addSubview:sexValLab];
                [sexValLab release];
                
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                break;
            }
            case 3:
            {
                UILabel *salaryLab = [[UILabel alloc]init];
                salaryLab.text = @"每小时课酬标准";
                salaryLab.backgroundColor = [UIColor clearColor];
                salaryLab.frame = [UIView fitCGRect:CGRectMake(0, 0, 140, 44)
                                         isBackView:NO];
                [cell addSubview:salaryLab];
                [salaryLab release];
                
                salaryValLab  = [[UILabel alloc]init];
                salaryValLab.text      = @"";
                salaryValLab.backgroundColor = [UIColor clearColor];
                salaryValLab.frame = CGRectMake(140, 0, 140, 44);
                [cell addSubview:salaryValLab];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                break;
            }
            case 4:
            {
                UILabel *timesLab = [[UILabel alloc]init];
                timesLab.text = @"预计辅导小时数";
                timesLab.backgroundColor = [UIColor clearColor];
                timesLab.frame = [UIView fitCGRect:CGRectMake(0, 0, 140, 44)
                                         isBackView:NO];
                [cell addSubview:timesLab];
                [timesLab release];
                
                timeValueLab = [[UILabel alloc]init];
                timeValueLab.text  = @"20";
                timeValueLab.backgroundColor = [UIColor clearColor];
                timeValueLab.frame = CGRectMake(140, 0, 140, 44);
                [cell addSubview:timeValueLab];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                break;
            }
            case 5:
            {
                UILabel *posLab = [[UILabel alloc]init];
                posLab.text = @"授课地点";
                posLab.backgroundColor = [UIColor clearColor];
                posLab.frame = [UIView fitCGRect:CGRectMake(0, 0, 140, 44)
                                      isBackView:NO];
                [cell addSubview:posLab];
                [posLab release];
                
                posValLab = [[UILabel alloc]init];
                posValLab.text  = @"";
                posValLab.backgroundColor = [UIColor clearColor];
                posValLab.frame = CGRectMake(140, 0, 130, 44);
                posValLab.font  = [UIFont systemFontOfSize:12.f];
                [cell addSubview:posValLab];
                
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                break;
            }
            case 6:
            {
                recordBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                recordBtn.tag    = 2;
                recordBtn.hidden = NO;
                [recordBtn setTitle:@"录音"
                           forState:UIControlStateNormal];
                recordBtn.frame  = CGRectMake(30, 15, 40, 30);
                [recordBtn addTarget:self
                              action:@selector(doButtonClicked:)
                    forControlEvents:UIControlEventTouchUpInside];
                [cell addSubview:recordBtn];
                
                keyBoardBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                keyBoardBtn.tag     = 3;
                keyBoardBtn.hidden  = YES;
                [keyBoardBtn setTitle:@"键盘"
                             forState:UIControlStateNormal];
                keyBoardBtn.frame   = CGRectMake(30, 15, 40, 30);
                [keyBoardBtn addTarget:self
                                action:@selector(doButtonClicked:)
                      forControlEvents:UIControlEventTouchUpInside];
                [cell addSubview:keyBoardBtn];
                
                messageField = [[UITextField alloc]init];
                messageField.text     = @"";
                messageField.hidden   = NO;
                messageField.delegate = self;
                messageField.frame    = CGRectMake(70, 15, 160, 30);
                messageField.borderStyle = UITextBorderStyleLine;
                [cell addSubview:messageField];
                                
                recordLongPressBtn = [[UILongPressButton alloc]initWithFrame:CGRectMake(70, 7, 160, 30)];
                recordLongPressBtn.tag      = 4;
                recordLongPressBtn.delegate = self;
                recordLongPressBtn.frame    = CGRectMake(70, 15, 160, 30);
                recordLongPressBtn.hidden   = YES;
                [cell addSubview:recordLongPressBtn];
                
                recordSuccessBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                recordSuccessBtn.hidden= YES;
                recordSuccessBtn.tag   = 5;
                recordSuccessBtn.frame = CGRectMake(70, 15, 160, 30);
                [recordSuccessBtn setTitle:@"录音成功"
                                  forState:UIControlStateNormal];
                [recordSuccessBtn addTarget:self
                                     action:@selector(doButtonClicked:)
                             forControlEvents:UIControlEventTouchUpInside];
                [cell addSubview:recordSuccessBtn];
                
                reCustomBtnView = [[CustomButtonView alloc]initWithFrame:CGRectMake(70, 120, 80, 80)];
                reCustomBtnView.tag    = 0;
                reCustomBtnView.hidden = YES;
                reCustomBtnView.delegate = self;
                reCustomBtnView.imageView.image = [UIImage imageNamed:@"re_hearing.png"];
                reCustomBtnView.contentLab.text = @"重听一遍";
                [self.view addSubview:reCustomBtnView];
                
                clrBtnView = [[CustomButtonView alloc]initWithFrame:CGRectMake(170, 120, 80, 80)];
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
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
            [self presentPopupViewController:sdVctr
                               animationType:MJPopupViewAnimationFade];
            break;
        }
        case 1:
        {
            SelectSubjectViewController *ssVctr = [[SelectSubjectViewController alloc]init];
            [self presentPopupViewController:ssVctr
                               animationType:MJPopupViewAnimationFade];
            break;
        }
        case 2:
        {
            SelectSexViewController *ssVctr = [[SelectSexViewController alloc]init];
            [self presentPopupViewController:ssVctr
                               animationType:MJPopupViewAnimationFade];
            break;
        }
        case 3:
        {
            SelectSalaryViewController *ssVctr = [[SelectSalaryViewController alloc]init];
            [self.navigationController pushViewController:ssVctr
                                                 animated:YES];
            [ssVctr release];
            break;
        }
        case 4:
        {
            SelectTimesViewController *stVctr = [[SelectTimesViewController alloc]init];
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

@end
