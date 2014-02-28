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
    self.navigationController.navigationBarHidden = YES;
    
    [MainViewController setNavTitle:@"个人中心"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateEmailInfoNotice:) name:@"updateEmailInfoNotice"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateEmailNotice:)
                                                 name:@"updateEmailNotice"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updatePhoneInfoNotice:) name:@"updatePhoneInfoNotice"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updatePhoneNotice:)
                                                 name:@"updatePhoneNotice"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(suggestNotice:)
                                                 name:@"suggestNotice"
                                               object:nil];
    
    //注册选择年级消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(setGradeFromNotice:)
                                                 name:@"setGradeNotice"
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
    NSData *stuData  = [[NSUserDefaults standardUserDefaults] valueForKey:STUDENT];
    student = [[NSKeyedUnarchiver unarchiveObjectWithData:stuData] copy];
    
    setTab = [[UITableView alloc]initWithFrame:[UIView fitCGRect:CGRectMake(0, 0, 320, 398)
                                                      isBackView:YES]
                                         style:UITableViewStyleGrouped];
    setTab.delegate   = self;
    setTab.dataSource = self;
    [self.view addSubview:setTab];
    
    updateType = OtherUpdate;
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
    NSArray *valuesArr = [NSArray arrayWithObjects:@"upinfo",phoneValLab.text,emailValLab.text,[Student searchGradeID:gradeValLab.text],student.gender,student.nickName,student.phoneStars, student.locStars, ssid, nil];
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
        
        //更新个人信息
        [self updateStudentInfo];
    }
    
    CustomNavigationViewController *nav = (CustomNavigationViewController *)[MainViewController getNavigationViewController];
    [nav dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
}

- (void) updateEmailInfoNotice:(NSNotification *) notice
{
    CustomNavigationViewController *nav = (CustomNavigationViewController *)[MainViewController getNavigationViewController];
    int tag = ((NSNumber *)[notice.userInfo objectForKey:@"TAG"]).intValue;
    switch (tag)
    {
        case 0:
        {
            UpdateEmailViewController *ueVctr = [[UpdateEmailViewController alloc]init];
            ueVctr.email = student.email;
            [nav presentPopupViewController:ueVctr
                              animationType:MJPopupViewAnimationFade];
            break;
        }
        default:
            break;
    }
    [nav dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
}

- (void) updateEmailNotice:(NSNotification *) notice
{
    int tag = ((NSNumber *)[notice.userInfo objectForKey:@"TAG"]).intValue;
    if (tag == 0)
    {
        emailValLab.text = [notice.userInfo objectForKey:@"CONTENT"];
        updateType = EmailUpdate;
        
        //更新个人信息
        [self updateStudentInfo];
    }
    
    CustomNavigationViewController *nav = (CustomNavigationViewController *)[MainViewController getNavigationViewController];
    [nav dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
}

- (void) updatePhoneNotice:(NSNotification *) notice
{
    int tag = ((NSNumber *)[notice.userInfo objectForKey:@"TAG"]).intValue;
    if (tag == 0)
    {
        phoneValLab.text    = [notice.userInfo objectForKey:@"CONTENT"];
        updateType = PhoneUpdate;
        
        //更新个人信息
        [self updateStudentInfo];
    }
    CustomNavigationViewController *nav = (CustomNavigationViewController *)[MainViewController getNavigationViewController];
    [nav dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
}

- (void) suggestNotice:(NSNotification *) notice
{
    CustomNavigationViewController *nav = (CustomNavigationViewController *)[MainViewController getNavigationViewController];
    [nav dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
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
    CustomNavigationViewController *nav = (CustomNavigationViewController *)[MainViewController getNavigationViewController];
    [nav dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
    int tag = ((NSNumber *)[notice.userInfo objectForKey:@"TAG"]).intValue;
    switch (tag)
    {
        case 0:
        {
            UpdatePhoneViewController *ueVctr = [[UpdatePhoneViewController alloc]init];
            ueVctr.phone = student.phoneNumber;
            [nav presentPopupViewController:ueVctr
                               animationType:MJPopupViewAnimationFade];
            break;
        }
        default:
            break;
    }
}

#pragma mark -
#pragma mark - Controller Event
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
    CustomNavigationViewController *nav = [[CustomNavigationViewController alloc]initWithRootViewController:mVc];
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    app.window.rootViewController = nav;
    
    LoginViewController *lVctr  = [[LoginViewController alloc]init];
    [nav pushViewController:lVctr
                   animated:YES];
    [mVc release];
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
    return 50;
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
                    phoneLab.text     = @"电话接听";
                    phoneLab.frame    = CGRectMake(20, 16, 80, 20);
                    phoneLab.backgroundColor = [UIColor clearColor];
                    [cell addSubview:phoneLab];
                    [phoneLab release];
                    
                    phoneSw  = [[UISwitch alloc]init];
                    phoneSw.tag   = 0;
                    phoneSw.frame = CGRectMake(215, 12, 80, 20);
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
                    locLab.frame = CGRectMake(20, 16, 80, 20);
                    locLab.backgroundColor = [UIColor clearColor];
                    [cell addSubview:locLab];
                    [locLab release];
                    
                    locSw = [[UISwitch alloc]init];
                    locSw.tag   = 1;
                    locSw.frame = CGRectMake(215, 12, 80, 20);
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
                    emailLab.frame = CGRectMake(20, 16, 80, 20);
                    emailLab.backgroundColor = [UIColor clearColor];
                    [cell addSubview:emailLab];
                    [emailLab release];
                    
                    emailValLab = [[UILabel alloc]init];
                    emailValLab.text   = student.email;
                    emailValLab.textAlignment   = NSTextAlignmentRight;
                    emailValLab.backgroundColor = [UIColor clearColor];
                    emailValLab.frame  = CGRectMake(87, 16, 200, 20);
                    [cell addSubview:emailValLab];
                    
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    break;
                }
                case 1:
                {
                    UILabel *phoneLab = [[UILabel alloc]init];
                    phoneLab.text  = @"手机";
                    phoneLab.frame = CGRectMake(20, 16, 80, 20);
                    phoneLab.backgroundColor = [UIColor clearColor];
                    [cell addSubview:phoneLab];
                    [phoneLab release];
                    
                    phoneValLab = [[UILabel alloc]init];
                    phoneValLab.text   = student.phoneNumber;
                    phoneValLab.textAlignment   = NSTextAlignmentRight;
                    phoneValLab.backgroundColor = [UIColor clearColor];
                    phoneValLab.frame  = CGRectMake(87, 16, 200, 20);
                    [cell addSubview:phoneValLab];
                    
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    break;
                }
                case 2:
                {
                    UILabel *classLab = [[UILabel alloc]init];
                    classLab.text  = @"年级";
                    classLab.frame = CGRectMake(20, 16, 80, 20);
                    classLab.backgroundColor = [UIColor clearColor];
                    [cell addSubview:classLab];
                    [classLab release];
                    
                    gradeValLab = [[UILabel alloc]init];
                    gradeValLab.text   = [Student searchGradeName:student.grade];
                    gradeValLab.textAlignment   = NSTextAlignmentRight;
                    gradeValLab.backgroundColor = [UIColor clearColor];
                    gradeValLab.frame  = CGRectMake(87, 16, 200, 20);
                    [cell addSubview:gradeValLab];
                    
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    break;
                }
                case 3:
                {
                    UILabel *sexLab = [[UILabel alloc]init];
                    sexLab.text  = @"性别";
                    sexLab.frame = CGRectMake(20, 16, 80, 20);
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
                    sexValLab.frame  = CGRectMake(87, 16, 200, 20);
                    [cell addSubview:sexValLab];
                    [sexValLab release];
                    
                    break;
                }
                case 4:
                {
                    UILabel *nameLab = [[UILabel alloc]init];
                    nameLab.text  = @"昵称";
                    nameLab.frame = CGRectMake(20, 16, 80, 20);
                    nameLab.backgroundColor = [UIColor clearColor];
                    [cell addSubview:nameLab];
                    [nameLab release];
                    
                    UILabel *nameValLab = [[UILabel alloc]init];
                    nameValLab.text     = student.nickName;
                    nameValLab.textAlignment   = NSTextAlignmentRight;
                    nameValLab.backgroundColor = [UIColor clearColor];
                    nameValLab.frame  = CGRectMake(87, 16, 200, 20);
                    [cell addSubview:nameValLab];
                    [nameValLab release];
                    break;
                }
                case 5:
                {
                    UILabel *numberLab = [[UILabel alloc]init];
                    numberLab.text  = @"绑定账号";
                    numberLab.frame = CGRectMake(20, 16, 80, 20);
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
                    adviseLab.frame = CGRectMake(20, 16, 80, 20);
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
                    aboutLab.frame = CGRectMake(20, 16, 80, 20);
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
                    versionLab.frame = CGRectMake(20, 16, 80, 20);
                    versionLab.backgroundColor = [UIColor clearColor];
                    [cell addSubview:versionLab];
                    [versionLab release];
                    
                    UILabel *versionValLab = [[UILabel alloc]init];
                    versionValLab.textAlignment   = NSTextAlignmentRight;
                    versionValLab.backgroundColor = [UIColor clearColor];
                    versionValLab.frame    = CGRectMake(87, 16, 200, 20);
                    [cell addSubview:versionValLab];

                    //当前版本
                    NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
                    NSString *oldVersion   = [infoDict objectForKey:@"CFBundleVersion"];
                    
//                    NSString *Dic =  [[NSUserDefaults standardUserDefaults]
//                                                                        objectForKey:APP_VERSION];
//                    NSString *newVersion = [newDic objectForKey:@"Version"];
                    versionValLab.text   = [NSString stringWithFormat:@"当前版本:V%@", oldVersion];
                    cell.userInteractionEnabled = NO;
                    [versionValLab release];
                    break;
                }
                case 3:
                {
                    UIImage *loginImg   = [UIImage imageNamed:@"normal_btn"];
                    UIButton *logoutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                    [logoutBtn setTitle:@"退出当前账号"
                              forState:UIControlStateNormal];
                    [logoutBtn setTitleColor:[UIColor colorWithHexString:@"#999999"]
                                   forState:UIControlStateNormal];
                    [logoutBtn setTitleColor:[UIColor colorWithHexString:@"#ff6600"]
                                   forState:UIControlStateHighlighted];
                    [logoutBtn setBackgroundImage:loginImg
                                        forState:UIControlStateNormal];
                    [logoutBtn setBackgroundImage:[UIImage imageNamed:@"hight_btn"]
                                        forState:UIControlStateHighlighted];
                    logoutBtn.frame = CGRectMake(20, 5, 280, 40);
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
    CustomNavigationViewController *nav = (CustomNavigationViewController *)[MainViewController getNavigationViewController];
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
                    [nav presentPopupViewController:uiVctr
                                      animationType:MJPopupViewAnimationFade];
                    break;
                }
                case 1:        //电话
                {
                    UpdatePhoneInfoViewController *upVctr = [[UpdatePhoneInfoViewController alloc]init];
                    [nav presentPopupViewController:upVctr
                                       animationType:MJPopupViewAnimationFade];

                    break;
                }
                case 2:        //年级
                {
                    SetGradeViewController *sgVctr = [[SetGradeViewController alloc]init];
                    [nav presentPopupViewController:sgVctr
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
                    //跳转分享页面
                    for (UIViewController *vtr in nav.viewControllers)
                    {
                        if ([vtr isKindOfClass:[LeveyTabBarController class]])
                        {
                            [((LeveyTabBarController *)vtr) setSelectedIndex:3];
                        }
                    }
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
                    [nav presentPopupViewController:sVctr
                                       animationType:MJPopupViewAnimationFade];
                    break;
                }
                case 1:          //关于轻轻
                {
                    AboutSoftwareViewController *aboutVctr = [[AboutSoftwareViewController alloc]init];
                    [nav pushViewController:aboutVctr animated:YES];
                    [aboutVctr release];
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
            student.email = emailValLab.text;
            student.phoneNumber = phoneValLab.text;
            student.grade = [Student searchGradeID:gradeValLab.text];
            
            //写入保存
            NSData *stuData = [NSKeyedArchiver archivedDataWithRootObject:student];
            [[NSUserDefaults standardUserDefaults] setObject:stuData
                                                      forKey:STUDENT];
            
            if ((updateType==EmailUpdate) || (updateType==PhoneUpdate))
            {
                //退出回到登录页面
                [self doLogoutBtnClicked:nil];
            }
            
            [setTab reloadData];
        }
    }
    else
    {
        emailValLab.text = student.email;
        phoneValLab.text = student.phoneNumber;
        gradeValLab.text = [Student searchGenderName:student.grade];
        
        NSString *errorMsg = [resDic objectForKey:@"message"];
        [self showAlertWithTitle:@"提示"
                             tag:0
                         message:[NSString stringWithFormat:@"错误码%@,%@",errorid,errorMsg]
                        delegate:self
               otherButtonTitles:@"确定",nil];
    }
}
@end
