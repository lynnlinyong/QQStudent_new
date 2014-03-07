//
//  LoginViewController.m
//  QQStudent
//
//  Created by lynn on 14-1-28.
//  Copyright (c) 2014年 lynn. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

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
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [MainViewController setNavTitle:@"登陆中"];
    
    [self initUI];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewDidUnload
{
    phoneFld = nil;
    phoneFld.delegate = nil;
    
    userNameFld = nil;
    userNameFld.delegate = nil;
    [super viewDidUnload];
}

- (void) viewDidDisappear:(BOOL)animated
{
    [registBtn removeFromSuperview];
    registBtn = nil;
    [super viewDidDisappear:animated];
}

- (void) dealloc
{
    [phoneFld           release];
    [userNameFld        release];
    [emailImgView       release];
    [phoneImgView       release];
    [super dealloc];
}

#pragma mark -
#pragma mark - Custom Action

- (void) initUI
{    
    UIImage *registImg  = [UIImage imageNamed:@"nav_right_normal_btn@2x"];
    registBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [registBtn setBackgroundImage:registImg
                         forState:UIControlStateNormal];
    [registBtn setBackgroundImage:[UIImage imageNamed:@"nav_right_hlight_btn@2x"]
                         forState:UIControlStateHighlighted];
    registBtn.frame = CGRectMake(320-60, 2,
                                 50,
                                 45);
    [registBtn addTarget:self
                  action:@selector(doRegistBtnClicked:)
        forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *regTitleLab = [[UILabel alloc]init];
    regTitleLab.text     = @"注册";
    regTitleLab.textColor= [UIColor whiteColor];
    regTitleLab.font     = [UIFont systemFontOfSize:12.f];
    regTitleLab.textAlignment = NSTextAlignmentCenter;
    regTitleLab.frame = CGRectMake(0, -3,
                                50,
                                45);
    regTitleLab.backgroundColor = [UIColor clearColor];
    [registBtn addSubview:regTitleLab];
    [regTitleLab release];
    
    CustomNavigationViewController *nav = (CustomNavigationViewController *)[MainViewController getNavigationViewController];
    [nav.navigationBar addSubview:registBtn];
    
    NSData *stuData  = [[NSUserDefaults standardUserDefaults] objectForKey:STUDENT];
    Student *student = [NSKeyedUnarchiver unarchiveObjectWithData:stuData];
    
    UIImage *normalImg = [UIImage imageNamed:@"normal_fld"];
    emailImgView = [[UIImageView alloc]initWithImage:normalImg];
    userNameFld  = [[UITextField alloc]init];
    userNameFld.tag = 0;
    userNameFld.delegate    = self;
    [userNameFld addTarget:self
                    action:@selector(valueChanged:)
          forControlEvents:UIControlEventEditingChanged];
    userNameFld.text        = student.email;
    userNameFld.borderStyle = UITextBorderStyleNone;
    userNameFld.placeholder = @"输入注册邮箱";
    userNameFld.frame = [UIView fitCGRect:CGRectMake(160-normalImg.size.width/2+5,
                                                     70,
                                                     normalImg.size.width-5,
                                                     normalImg.size.height)
                               isBackView:NO];
    emailImgView.frame = [UIView fitCGRect:CGRectMake(160-normalImg.size.width/2,
                                                      65,
                                                      normalImg.size.width,
                                                      normalImg.size.height+10)
                                isBackView:NO];
    [self.view addSubview:emailImgView];
    [self.view addSubview:userNameFld];
    
    phoneFld = [[UITextField alloc]init];
    phoneFld.tag  = 1;
    phoneImgView  = [[UIImageView alloc]initWithImage:normalImg];
    [phoneFld addTarget:self
                    action:@selector(valueChanged:)
          forControlEvents:UIControlEventEditingChanged];
    phoneFld.delegate = self;
    phoneFld.text     = student.phoneNumber;
    phoneFld.borderStyle = UITextBorderStyleNone;
    phoneFld.placeholder = @"输入手机号码";
    phoneFld.frame = [UIView fitCGRect:CGRectMake(160-normalImg.size.width/2+5,
                                                  80+normalImg.size.height+10,
                                                  normalImg.size.width-5,
                                                  normalImg.size.height)
                            isBackView:NO];
    phoneImgView.frame = [UIView fitCGRect:CGRectMake(160-normalImg.size.width/2,
                                                      80+normalImg.size.height+5,
                                                      normalImg.size.width,
                                                      normalImg.size.height+10)
                                isBackView:NO];
    [self.view addSubview:phoneImgView];
    [self.view addSubview:phoneFld];
    
    UIImage *loginImg  = [UIImage imageNamed:@"normal_btn"];
    loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [loginBtn setTitle:@"登录"
              forState:UIControlStateNormal];
    [loginBtn setTitleColor:[UIColor colorWithHexString:@"#999999"]
                   forState:UIControlStateNormal];
    [loginBtn setTitleColor:[UIColor colorWithHexString:@"#ff6600"]
                   forState:UIControlStateHighlighted];
    [loginBtn setBackgroundImage:loginImg
                        forState:UIControlStateNormal];
    [loginBtn setBackgroundImage:[UIImage imageNamed:@"hight_btn"]
                        forState:UIControlStateHighlighted];
    loginBtn.frame = [UIView fitCGRect:CGRectMake(160-loginImg.size.width/2,
                                                  80+normalImg.size.height*2+30,
                                                  loginImg.size.width,
                                                  loginImg.size.height)
                            isBackView:NO];
    [loginBtn addTarget:self
                 action:@selector(doLoginBtnClicked:)
       forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginBtn];
    
    UILabel *infoLab = [[UILabel alloc]init];
    infoLab.text = @"请务必保密您的邮箱及手机号码组合,并可随时使用\"设置\"功能进行修订,以确保您的权利";
    infoLab.frame= [UIView fitCGRect:CGRectMake(160-loginImg.size.width/2,
                                                80+normalImg.size.height*3+40,
                                                loginImg.size.width,
                                                loginImg.size.height*3)
                          isBackView:NO];
    infoLab.font = [UIFont systemFontOfSize:13.f];
    infoLab.backgroundColor = [UIColor clearColor];
    infoLab.lineBreakMode   = NSLineBreakByWordWrapping;
    infoLab.numberOfLines   = 0;
    infoLab.textColor = [UIColor colorWithHexString:@"#ff6600"];
    [self.view addSubview:infoLab];
    [infoLab release];
    
    UIImage *hpImg  = [UIImage imageNamed:@"login_help_phone_btn"];
    UIButton *hpBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [hpBtn setTitle:@"帮助"
           forState:UIControlStateNormal];
    [hpBtn setImage:hpImg
           forState:UIControlStateNormal];
    hpBtn.frame = [UIView fitCGRect:CGRectMake(237, 460-hpImg.size.height-44-15,
                                               hpImg.size.width,
                                               hpImg.size.height)
                         isBackView:NO];
    [hpBtn addTarget:self
              action:@selector(doHpBtnClicked:)
    forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:hpBtn];
    
    UILabel *helpLab = [[UILabel alloc]init];
    helpLab.text = @"忘记了吗?一键帮助";
    helpLab.textAlignment = NSTextAlignmentLeft;
    helpLab.frame= [UIView fitCGRect:CGRectMake(160-loginImg.size.width/2, 460-hpImg.size.height-44-15,
                                                loginImg.size.width,
                                                hpImg.size.height)
                          isBackView:NO];
    helpLab.backgroundColor = [UIColor clearColor];
    helpLab.font = [UIFont systemFontOfSize:18.f];
    helpLab.textColor = [UIColor colorWithHexString:@"#00947d"];
    [self.view addSubview:helpLab];
    [helpLab release];
}

- (BOOL) checkInfo
{
    if (userNameFld.text.length == 0 || phoneFld.text.length == 0)
    {   
        return NO;
    }
    
    BOOL isEmailType = [userNameFld.text isMatchedByRegex:@"\\b([a-zA-Z0-9%_.+\\-]+)@([a-zA-Z0-9.\\-]+?\\.[a-zA-Z]{2,6})\\b"];
    if (!isEmailType)
    {
        return NO;
    }
    
    BOOL isPhone = [phoneFld.text isMatchedByRegex:@"^(13[0-9]|15[0-9]|18[0-9])\\d{8}$"];
    if (!isPhone)
    {
        return NO;
    }
    
    return YES;
}

- (void) doRegistBtnClicked:(id)sender
{
    RegistViewController *rVctr = [[RegistViewController alloc]init];
    [self.navigationController pushViewController:rVctr animated:YES];
    [rVctr release];
}

- (void) valueChanged:(id)sender
{
    if (![self checkInfo])
    {
        [loginBtn setTitleColor:[UIColor colorWithHexString:@"#999999"]
                       forState:UIControlStateNormal];
    }
    else
    {
        [loginBtn setTitleColor:[UIColor colorWithHexString:@"#ff6600"]
                       forState:UIControlStateNormal];
    }
}

- (void) doLoginBtnClicked:(id)sender
{
    if (![AppDelegate isConnectionAvailable:YES withGesture:NO])
    {
        return;
    }
    
    if (![self checkInfo])
    {
        [self showAlertWithTitle:@"提示"
                             tag:0
                         message:@"请输入邮箱和手机号!"
                        delegate:self
               otherButtonTitles:@"确定",nil];
    }
    
    //恢复视图
    [self repickView:self.view];
    
    
    CustomNavigationViewController *nav = [MainViewController getNavigationViewController];
    [MBProgressHUD showHUDAddedTo:nav.view animated:YES];
    
    NSString *idString    = [SingleMQTT getCurrentDevTopic];
    NSString *deviceToken = [[NSUserDefaults standardUserDefaults] objectForKey:QQ_STUDENT];
    NSArray *paramsArr = [NSArray arrayWithObjects:@"action",@"phoneNumber",@"email",
                                                   @"deviceId",@"ios",@"deviceToken", nil];
    NSArray *valuesArr = [NSArray arrayWithObjects:@"login", phoneFld.text, userNameFld.text,
                                                   idString, IOS,deviceToken, nil];
    NSDictionary *pDic = [NSDictionary dictionaryWithObjects:valuesArr
                                                     forKeys:paramsArr];
    CLog(@"LoginPic:%@", pDic);
    ServerRequest *serverReq = [ServerRequest sharedServerRequest];
    serverReq.delegate = self;
    NSString *webAddress = [[NSUserDefaults standardUserDefaults] valueForKey:WEBADDRESS];
    NSString *url = [NSString stringWithFormat:@"%@%@/", webAddress,STUDENT];
    [serverReq requestASyncWith:kServerPostRequest
                       paramDic:pDic
                         urlStr:url];
}

- (void) doHpBtnClicked:(id)sender
{
    NSString *helpPhone = [[NSUserDefaults standardUserDefaults] objectForKey:HELP_PHONE];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", helpPhone]]];
}

#pragma mark -
#pragma mark MBProgressHUDDelegate methods

#pragma mark -
#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self repickView:self.view];
    [textField resignFirstResponder];
    return YES;
}



- (void) textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == userNameFld)
    {
        emailImgView.image    = [UIImage imageNamed:@"hight_fld"];
        phoneImgView.image    = [UIImage imageNamed:@"normal_fld"];
    }
    else
    {
        phoneImgView.image    = [UIImage imageNamed:@"hight_fld"];
        emailImgView.image    = [UIImage imageNamed:@"normal_fld"];
    }
    
    [self moveViewWhenViewHidden:loginBtn
                          parent:self.view];
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
    CustomNavigationViewController *nav = [MainViewController getNavigationViewController];
    [MBProgressHUD hideHUDForView:nav.view animated:YES];
    
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
    
    NSNumber *errorid = [[resDic objectForKey:@"errorid"] copy];
    if (errorid.intValue == 0)
    {        
        NSString *ssid = [[resDic objectForKey:@"sessid"] retain];
        if (ssid)
        {
            [[NSUserDefaults standardUserDefaults] setObject:ssid
                                                      forKey:SSID];
            CLog(@"ssid:%@", ssid);
            
            NSString *preCurDeviceId = [resDic objectForKey:@"fDeviceId"];
            NSString *curDeviceId = [SingleMQTT getCurrentDevTopic];
            if (![preCurDeviceId isEqualToString:curDeviceId])
            {
                //本次登录和上次登录手机不同,通知上次手机下线
                NSDictionary *offlineDic = [NSDictionary dictionaryWithObjectsAndKeys:@"9999",@"type", nil];
                NSString *jsonStr   = [offlineDic JSONFragment];
                NSData *data        = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
                SingleMQTT *session = [SingleMQTT shareInstance];
                [session.session publishData:data
                                     onTopic:preCurDeviceId];
            }
            
            //获得Student
            NSDictionary *stuDic = [resDic objectForKey:@"studentInfo"];
            Student *student    = [[Student alloc]init];
            student.email       = [stuDic objectForKey:@"email"];
            student.gender      = [[stuDic objectForKey:@"gender"] copy];
            student.grade       = [[stuDic objectForKey:@"grade"]  copy];
            student.icon        = [[stuDic objectForKey:@"icon"] copy];
            student.latltude    = [stuDic objectForKey:@"latitude"];
            student.longltude   = [stuDic objectForKey:@"longitude"];
            student.lltime      = [stuDic objectForKey:@"lltime"];
            student.nickName    = [stuDic objectForKey:@"nickname"];
            student.phoneNumber = [stuDic objectForKey:@"phone"];
            student.status      = [[stuDic objectForKey:@"status"] copy];
            student.phoneStars  = [[stuDic objectForKey:@"phone_stars"] copy];
            student.locStars    = [[stuDic objectForKey:@"location_stars"] copy];
            
            NSData *stuData = [[NSKeyedArchiver archivedDataWithRootObject:student] retain];
            [[NSUserDefaults standardUserDefaults] setObject:stuData
                                                      forKey:STUDENT];
            [stuData release];
            //判断用户是否完善个人资料
            if (student.status.intValue == 0)
            {
                //跳转到完善个人资料页
                CompletePersonalInfoViewController *cpVctr = [[[CompletePersonalInfoViewController alloc]init]autorelease];
                [self.navigationController pushViewController:cpVctr
                                                     animated:YES];
                [student release];
            }
            else
            {
                //写入登录成功标识
                [[NSUserDefaults standardUserDefaults] setBool:YES
                                                        forKey:LOGINE_SUCCESS];
                
                //跳转个人中心
                [self.navigationController popToRootViewControllerAnimated:NO];
                
                PersonCenterViewController *pcVctr = [[PersonCenterViewController alloc]init];
                [self.navigationController pushViewController:pcVctr
                                                     animated:YES];
                [pcVctr release];
                [student release];
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
