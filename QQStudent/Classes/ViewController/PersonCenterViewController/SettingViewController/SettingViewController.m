//
//  SettingViewController.m
//  QQStudent
//
//  Created by lynn on 14-1-29.
//  Copyright (c) 2014年 lynn. All rights reserved.
//

#import "SettingViewController.h"
#import "AboutSoftwareViewController.h"

@interface SettingViewController ()

@end

@implementation SettingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.tabBarItem.title = @"设置";
        [self.tabBarItem setImage:[UIImage imageNamed:@"user_4_2"]];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //初始化UI
    [self initUI];
    
//    [self checkInfoComplete];
}

- (void) viewDidAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateEmailInfoNotice:) name:@"updateEmailInfoNotice"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateEmailNotice:) name:@"updateEmailNotice"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updatePhoneInfoNotice:) name:@"updatePhoneInfoNotice"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updatePhoneNotice:) name:@"updatePhoneNotice"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(suggestNotice:) name:@"suggestNotice"
                                               object:nil];
    
    //注册选择年级消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(setGradeFromNotice:) name:@"setGradeNotice"
                                               object:nil];
    [super viewDidAppear:animated];
}

- (void) viewDidDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void) dealloc
{
    [student release];
    [phoneSw release];
    [locSw   release];
    [super dealloc];
}

#pragma mark -
#pragma mark - Custom Action
- (void) initUI
{
    UILabel *title        = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    title.textColor       = [UIColor colorWithHexString:@"#009f66"];
    title.backgroundColor = [UIColor clearColor];
    title.textAlignment = UITextAlignmentCenter;
    title.text = @"个人中心";
    self.navigationItem.titleView = title;
    [title release];
    
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
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    
    NSData *stuData  = [[NSUserDefaults standardUserDefaults] valueForKey:STUDENT];
    student = [[NSKeyedUnarchiver unarchiveObjectWithData:stuData] copy];
    
    setTab = [[UITableView alloc]initWithFrame:[UIView fitCGRect:CGRectMake(0, 0, 320, 420)
                                                      isBackView:NO]
                                         style:UITableViewStyleGrouped];
    setTab.delegate   = self;
    setTab.dataSource = self;
    [self.view addSubview:setTab];
}

- (void) updateStudentInfo
{
    //更新本地个人信息
    NSData *stuData = [NSKeyedArchiver archivedDataWithRootObject:student];
    [[NSUserDefaults standardUserDefaults] setObject:stuData
                                              forKey:STUDENT];
    
    //更新个人资料
    NSString *ssid   = [[NSUserDefaults standardUserDefaults] objectForKey:SSID];
    NSArray *paramsArr = [NSArray arrayWithObjects:@"action",@"phone",@"email", @"grade",@"gender",@"nick",@"phone_stars",@"location_stars",@"sessid",nil];
    NSArray *valuesArr = [NSArray arrayWithObjects:@"upinfo",student.phoneNumber,student.email,student.grade,student.gender,student.nickName,student.phoneStars, student.locStars, ssid, nil];
    NSDictionary *pDic = [NSDictionary dictionaryWithObjects:valuesArr
                                                     forKeys:paramsArr];
    CLog(@"Dic:%@", pDic);
    
    ServerRequest *serverReq = [ServerRequest sharedServerRequest];
    serverReq.delegate   = self;
    NSString *webAddress = [[NSUserDefaults standardUserDefaults] valueForKey:WEBADDRESS];
    NSString *url = [NSString stringWithFormat:@"%@%@/", webAddress,STUDENT];
    [serverReq requestASyncWith:kServerPostRequest
                       paramDic:pDic
                         urlStr:url];
}

- (void) uploadSuggest:(NSString *) content
{
    NSString *ssid   = [[NSUserDefaults standardUserDefaults] objectForKey:SSID];
    NSArray *paramsArr = [NSArray arrayWithObjects:@"action",@"text",@"sessid",nil];
    NSArray *valuesArr = [NSArray arrayWithObjects:@"submitProposal",content,ssid, nil];
    
    NSDictionary *pDic = [NSDictionary dictionaryWithObjects:valuesArr
                                                     forKeys:paramsArr];
    ServerRequest *serverReq = [ServerRequest sharedServerRequest];
    serverReq.delegate   = self;
    NSString *webAddress = [[NSUserDefaults standardUserDefaults] valueForKey:WEBADDRESS];
    NSString *url = [NSString stringWithFormat:@"%@%@/", webAddress,STUDENT];
    [serverReq requestASyncWith:kServerPostRequest
                       paramDic:pDic
                         urlStr:url];
}

#pragma mark -
#pragma mark - Notice Event
- (void) setGradeFromNotice:(NSNotification *) notice
{
    NSDictionary *userInfoDic = [notice.userInfo objectForKey:@"UserInfo"];
    int tag = ((NSNumber *)[userInfoDic objectForKey:@"TAG"]).intValue;
    if (tag == 0)
    {
        gradeValLab.text = [userInfoDic objectForKey:@"name"];
        student.grade    = [[userInfoDic objectForKey:@"id"] copy];
        
        //更新个人信息
        [self updateStudentInfo];
    }
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
}

- (void) updateEmailInfoNotice:(NSNotification *) notice
{
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
    int tag = ((NSNumber *)[notice.userInfo objectForKey:@"TAG"]).intValue;
    switch (tag)
    {
        case 0:
        {
            UpdateEmailViewController *ueVctr = [[UpdateEmailViewController alloc]init];
            [self presentPopupViewController:ueVctr
                               animationType:MJPopupViewAnimationFade];
            break;
        }
        default:
            break;
    }
}

- (void) updateEmailNotice:(NSNotification *) notice
{
    int tag = ((NSNumber *)[notice.userInfo objectForKey:@"TAG"]).intValue;
    if (tag == 0)
    {
        emailValLab.text = [notice.userInfo objectForKey:@"CONTENT"];
        student.email = [notice.userInfo objectForKey:@"CONTENT"];
        
        //更新个人信息
        [self updateStudentInfo];
    }
    
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
}

- (void) updatePhoneNotice:(NSNotification *) notice
{
    int tag = ((NSNumber *)[notice.userInfo objectForKey:@"TAG"]).intValue;
    if (tag == 0)
    {
        phoneValLab.text    = [notice.userInfo objectForKey:@"CONTENT"];
        student.phoneNumber = [notice.userInfo objectForKey:@"CONTENT"];
        
        //更新个人信息
        [self updateStudentInfo];
    }
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
}

- (void) suggestNotice:(NSNotification *) notice
{
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
    int tag = ((NSNumber *)[notice.userInfo objectForKey:@"TAG"]).intValue;
    switch (tag)
    {
        case 0:     //确定
        {
            //上传建议
            [self uploadSuggest:[notice.userInfo objectForKey:@"CONTENT"]];
            break;
        }
        default:
            break;
    }
}

- (void) updatePhoneInfoNotice:(NSNotification *) notice
{
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
    
    int tag = ((NSNumber *)[notice.userInfo objectForKey:@"TAG"]).intValue;
    switch (tag)
    {
        case 0:
        {
            UpdatePhoneViewController *ueVctr = [[UpdatePhoneViewController alloc]init];
            [self presentPopupViewController:ueVctr
                               animationType:MJPopupViewAnimationFade];
            break;
        }
        default:
            break;
    }
}

#pragma mark -
#pragma mark - Controller Event
- (void) doBackBtnClicked:(id)sender
{
    MainViewController *mVctr   = [[MainViewController alloc]init];
    UINavigationController *nvc = [[UINavigationController alloc]initWithRootViewController:mVctr];
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    app.window.rootViewController = nvc;
    [mVctr release];
}

- (void) doValueChanged:(id)sender
{
    UISwitch *sw = sender;
    switch (sw.tag)
    {
        case 0:        //电话修改
        {
            if (phoneSw.on)
                student.phoneStars = @"1";
            else
                student.phoneStars = @"0";
            break;
        }
        case 1:        //定位修改
        {
            if (locSw.on)
                student.locStars = @"1";
            else
                student.locStars = @"0";
            break;
        }
        default:
            break;
    }

    //更新个人信息
    [self updateStudentInfo];
}

- (void) doLogoutBtnClicked:(id)sender
{
    //写入登录成功标识
    [[NSUserDefaults standardUserDefaults] setBool:NO
                                            forKey:LOGINE_SUCCESS];
    
    //显示登录页面
    MainViewController *mVc     = [[MainViewController alloc]init];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:mVc];
    [mVc release];
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    app.window.rootViewController = nav;
}

#pragma mark -
#pragma mark - UITableViewDelegate and UITableViewDataSource
- (int) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (int) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section)
    {
        case 0:
        {
            return 2;
            break;
        }
        case 1:
        {
            return 6;
            break;
        }
        case 2:
        {
            return 4;
            break;
        }
        default:
            break;
    }
    
    return 1;
}

- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section)
    {
        case 0:
        {
            return @"开关设置";
            break;
        }
        case 1:
        {
            return @"个人信息设置";
            break;
        }
        case 2:
        {
            return @"其他设置";
            break;
        }
        default:
            break;
    }
    
    return @"";
}

- (float) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (UITableViewCell *) tableView:(UITableView *)tableView
          cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *idString = @"idString";
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault
                                                  reuseIdentifier:idString];
    switch (indexPath.section)
    {
        case 0:
        {
            switch (indexPath.row)
            {
                case 0:         //电话接听
                {                    
                    UILabel *phoneLab = [[UILabel alloc]init];
                    phoneLab.text  = @"电话接听";
                    phoneLab.frame = CGRectMake(10, 12, 80, 20);
                    phoneLab.backgroundColor = [UIColor clearColor];
                    [cell addSubview:phoneLab];
                    [phoneLab release];
                    
                    phoneSw  = [[UISwitch alloc]init];
                    phoneSw.tag   = 0;
                    phoneSw.frame = CGRectMake(230, 4, 80, 20);
                    [cell addSubview:phoneSw];
                    if (student.phoneStars.intValue == 1)
                        phoneSw.on = YES;
                    else
                        phoneSw.on = NO;
                    [phoneSw addTarget:self
                                action:@selector(doValueChanged:)
                      forControlEvents:UIControlEventValueChanged];
                    break;
                }
                case 1:         //定位
                {
                    UILabel *locLab = [[UILabel alloc]init];
                    locLab.text  = @"定位";
                    locLab.frame = CGRectMake(10, 12, 80, 20);
                    locLab.backgroundColor = [UIColor clearColor];
                    [cell addSubview:locLab];
                    [locLab release];
                    
                    locSw = [[UISwitch alloc]init];
                    locSw.tag   = 1;
                    locSw.frame = CGRectMake(230, 4, 80, 20);
                    [cell addSubview:locSw];
                    if (student.locStars.intValue == 1)
                        locSw.on = YES;
                    else
                        locSw.on = NO;
                    [locSw addTarget:self
                              action:@selector(doValueChanged:)
                    forControlEvents:UIControlEventValueChanged];
                    break;
                }
                default:
                    break;
            }
            break;
        }
        case 1:
        {
            switch (indexPath.row)
            {
                case 0:
                {
                    UILabel *emailLab = [[UILabel alloc]init];
                    emailLab.text  = @"邮箱";
                    emailLab.frame = CGRectMake(10, 12, 80, 20);
                    emailLab.backgroundColor = [UIColor clearColor];
                    [cell addSubview:emailLab];
                    [emailLab release];
                    
                    emailValLab = [[UILabel alloc]init];
                    emailValLab.text   = student.email;
                    emailValLab.textAlignment   = NSTextAlignmentRight;
                    emailValLab.backgroundColor = [UIColor clearColor];
                    emailValLab.frame  = CGRectMake(320-30-200, 12, 200, 20);
                    [cell addSubview:emailValLab];
                    
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    break;
                }
                case 1:
                {
                    UILabel *phoneLab = [[UILabel alloc]init];
                    phoneLab.text  = @"手机";
                    phoneLab.frame = CGRectMake(10, 12, 80, 20);
                    phoneLab.backgroundColor = [UIColor clearColor];
                    [cell addSubview:phoneLab];
                    [phoneLab release];
                    
                    phoneValLab = [[UILabel alloc]init];
                    phoneValLab.text   = student.phoneNumber;
                    phoneValLab.textAlignment   = NSTextAlignmentRight;
                    phoneValLab.backgroundColor = [UIColor clearColor];
                    phoneValLab.frame  = CGRectMake(320-30-200, 12, 200, 20);
                    [cell addSubview:phoneValLab];
                    
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    break;
                }
                case 2:
                {
                    UILabel *classLab = [[UILabel alloc]init];
                    classLab.text  = @"年级";
                    classLab.frame = CGRectMake(10, 12, 80, 20);
                    classLab.backgroundColor = [UIColor clearColor];
                    [cell addSubview:classLab];
                    [classLab release];
                    
                    gradeValLab = [[UILabel alloc]init];
                    gradeValLab.text   = [Student searchGradeName:student.grade];
                    gradeValLab.textAlignment   = NSTextAlignmentRight;
                    gradeValLab.backgroundColor = [UIColor clearColor];
                    gradeValLab.frame  = CGRectMake(320-30-200, 12, 200, 20);
                    [cell addSubview:gradeValLab];
                    
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    break;
                }
                case 3:
                {
                    UILabel *sexLab = [[UILabel alloc]init];
                    sexLab.text  = @"性别";
                    sexLab.frame = CGRectMake(10, 12, 80, 20);
                    sexLab.backgroundColor = [UIColor clearColor];
                    [cell addSubview:sexLab];
                    [sexLab release];
                    
                    NSString *gender = @"";
                    if (student.gender.intValue==1)
                        gender = @"男";
                    else
                        gender = @"女";
                    
                    UILabel *sexValLab = [[UILabel alloc]init];
                    sexValLab.text     = gender;
                    sexValLab.textAlignment   = NSTextAlignmentRight;
                    sexValLab.backgroundColor = [UIColor clearColor];
                    sexValLab.frame  = CGRectMake(320-30-200, 12, 200, 20);
                    [cell addSubview:sexValLab];
                    [sexValLab release];
                    
                    break;
                }
                case 4:
                {
                    UILabel *nameLab = [[UILabel alloc]init];
                    nameLab.text  = @"昵称";
                    nameLab.frame = CGRectMake(10, 12, 80, 20);
                    nameLab.backgroundColor = [UIColor clearColor];
                    [cell addSubview:nameLab];
                    [nameLab release];
                    
                    UILabel *nameValLab = [[UILabel alloc]init];
                    nameValLab.text     = student.nickName;
                    nameValLab.textAlignment   = NSTextAlignmentRight;
                    nameValLab.backgroundColor = [UIColor clearColor];
                    nameValLab.frame  = CGRectMake(320-30-200, 12, 200, 20);
                    [cell addSubview:nameValLab];
                    [nameValLab release];
                    break;
                }
                case 5:
                {
                    UILabel *numberLab = [[UILabel alloc]init];
                    numberLab.text  = @"绑定账号";
                    numberLab.frame = CGRectMake(10, 12, 80, 20);
                    numberLab.backgroundColor = [UIColor clearColor];
                    [cell addSubview:numberLab];
                    [numberLab release];
                    
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    break;
                }
                default:
                    break;
            }
            break;
        }
        case 2:
        {
            switch (indexPath.row)
            {
                case 0:
                {
                    UILabel *adviseLab = [[UILabel alloc]init];
                    adviseLab.text  = @"建议反馈";
                    adviseLab.frame = CGRectMake(10, 12, 80, 20);
                    adviseLab.backgroundColor = [UIColor clearColor];
                    [cell addSubview:adviseLab];
                    [adviseLab release];
                    
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    break;
                }
                case 1:
                {
                    UILabel *aboutLab = [[UILabel alloc]init];
                    aboutLab.text  = @"关于轻轻";
                    aboutLab.frame = CGRectMake(10, 12, 80, 20);
                    aboutLab.backgroundColor = [UIColor clearColor];
                    [cell addSubview:aboutLab];
                    [aboutLab release];
                    
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    break;
                }
                case 2:
                {
                    UILabel *versionLab = [[UILabel alloc]init];
                    versionLab.text  = @"版本检查";
                    versionLab.frame = CGRectMake(10, 12, 80, 20);
                    versionLab.backgroundColor = [UIColor clearColor];
                    [cell addSubview:versionLab];
                    [versionLab release];
                    
                    UILabel *versionValLab = [[UILabel alloc]init];
                    versionValLab.text     = student.nickName;
                    versionValLab.textAlignment   = NSTextAlignmentRight;
                    versionValLab.backgroundColor = [UIColor clearColor];
                    versionValLab.frame  = CGRectMake(320-30-200, 12, 200, 20);
                    [cell addSubview:versionValLab];
                    
                    //对比版本号
                    NSDictionary *newDic =  [[NSUserDefaults standardUserDefaults] objectForKey:APP_VERSION];
                    NSString *newVersion = [newDic objectForKey:@"Version"];
                    
                    //当前版本
                    NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
                    NSString *oldVersion   = [infoDict objectForKey:@"CFBundleVersion"];
                    if (newVersion.intValue>oldVersion.intValue)
                    {
                        versionValLab.text = [NSString stringWithFormat:@"有新版本v%@,点击更新", newVersion];
                        cell.userInteractionEnabled = YES;
                        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    }
                    else
                    {
                        versionValLab.text = @"最新版本";
                        cell.userInteractionEnabled = NO;
                    }
                    [versionValLab release];
                    break;
                }
                case 3:
                {
                    UIButton *logoutBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                    [logoutBtn setTitle:@"退出当前账号" forState:UIControlStateNormal];
                    logoutBtn.frame = CGRectMake(20, 20, 280, 40);
                    [logoutBtn addTarget:self
                                  action:@selector(doLogoutBtnClicked:)
                        forControlEvents:UIControlEventTouchUpInside];
                    [cell addSubview:logoutBtn];
                }
                default:
                    break;
            }
            break;
        }
        default:
            break;
    }
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section)
    {
        case 0:      //开关设置
        {
            break;
        }
        case 1:      //个人信息设置
        {
            switch (indexPath.row)
            {
                case 0:        //邮箱
                {
                    UpdateEmailInfoViewController *uiVctr = [[UpdateEmailInfoViewController alloc]init];
                    [self presentPopupViewController:uiVctr
                                       animationType:MJPopupViewAnimationFade];
                    break;
                }
                case 1:        //电话
                {
                    UpdatePhoneInfoViewController *upVctr = [[UpdatePhoneInfoViewController alloc]init];
                    [self presentPopupViewController:upVctr
                                       animationType:MJPopupViewAnimationFade];

                    break;
                }
                case 2:        //年级
                {
                    SetGradeViewController *sgVctr = [[SetGradeViewController alloc]init];
                    [self presentPopupViewController:sgVctr
                                       animationType:MJPopupViewAnimationFade];
                    break;
                }
                case 3:
                {
                    break;
                }
                case 4:
                {
                    break;
                }
                case 5:        //绑定账号
                {
                    break;
                }
                default:
                    break;
            }
            break;
        }
        case 2:      //其他设置
        {
            switch (indexPath.row)
            {
                case 0:          //建议反馈
                {
                    SuggestViewController *sVctr = [[SuggestViewController alloc]init];
                    [self presentPopupViewController:sVctr
                                       animationType:MJPopupViewAnimationFade];
                    break;
                }
                case 1:          //关于轻轻
                {
                    AboutSoftwareViewController *aboutVctr = [[AboutSoftwareViewController alloc]init];
                    [self.navigationController pushViewController:aboutVctr
                                                         animated:YES];
                    [aboutVctr release];
                    break;
                }
                case 2:          //版本检查
                {
                    NSDictionary *newDic =  [[NSUserDefaults standardUserDefaults] objectForKey:APP_VERSION];
                    NSString *appUrl = [newDic objectForKey:@"AppURL"];
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:appUrl]];
                    break;
                }
                default:
                    break;
            }
            break;
        }
        default:
            break;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
        NSString *action = [resDic objectForKey:@"action"];
        if ([action isEqualToString:@"submitProposal"])
        {
            CLog(@"upload suggest success!");
        }
        else if ([action isEqualToString:@"upinfo"])
        {
            CLog(@"update infomation success!");
            [setTab reloadData];
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
@end
