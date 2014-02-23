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

- (void) dealloc
{
    [phoneFld release];
    [userNameFld release];
    
    [super dealloc];
}

#pragma mark -
#pragma mark - Custom Action
- (void) initUI
{
    NSData *stuData  = [[NSUserDefaults standardUserDefaults] objectForKey:STUDENT];
    Student *student = [NSKeyedUnarchiver unarchiveObjectWithData:stuData];
    
//    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
////    [backBtn setTitle:@"返回" forState:UIControlStateNormal];
//    backBtn.frame = CGRectMake(0, 0, 100, 40);
//    [backBtn addTarget:self
//                action:@selector(doBackBtnClicked:)
//      forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:backBtn];
    
    UIButton *registBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [registBtn setTitle:@"注册" forState:UIControlStateNormal];
    registBtn.frame = CGRectMake(320-60, 7, 40, 30);
    [registBtn addTarget:self
                  action:@selector(doRegistBtnClicked:)
        forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:registBtn];
//  [self.view addSubview:registBtn];
    
    userNameFld = [[UITextField alloc]init];
    userNameFld.delegate    = self;
    userNameFld.text        = student.email;
    userNameFld.borderStyle = UITextBorderStyleLine;
    userNameFld.placeholder = @"输入注册邮箱";
    userNameFld.frame = [UIView fitCGRect:CGRectMake(60, 110, 200, 30)
                               isBackView:NO];
    [self.view addSubview:userNameFld];
    
    phoneFld = [[UITextField alloc]init];
    phoneFld.delegate = self;
    phoneFld.text     = student.phoneNumber;
    phoneFld.borderStyle = UITextBorderStyleLine;
    phoneFld.placeholder = @"输入手机号码";
    phoneFld.frame = [UIView fitCGRect:CGRectMake(60, 150, 200, 30)
                          isBackView:NO];
    [self.view addSubview:phoneFld];
    
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [loginBtn setTitle:@"登录"
              forState:UIControlStateNormal];
    loginBtn.frame = [UIView fitCGRect:CGRectMake(110, 240, 100, 40)
                            isBackView:NO];
    [loginBtn addTarget:self
                 action:@selector(doLoginBtnClicked:)
       forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginBtn];
    
    UIButton *hpBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [hpBtn setTitle:@"帮助" forState:UIControlStateNormal];
    hpBtn.frame = [UIView fitCGRect:CGRectMake(110, 300, 100, 40)
                         isBackView:NO];
    [hpBtn addTarget:self
              action:@selector(doHpBtnClicked:)
    forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:hpBtn];
}

- (BOOL) checkInfo
{
    if (userNameFld.text.length == 0 || phoneFld.text.length == 0)
    {
        [self showAlertWithTitle:@"提示"
                             tag:1
                         message:@"登录信息不完整!"
                        delegate:self
               otherButtonTitles:@"确定", nil];
        
        return NO;
    }
    
    BOOL isEmailType = [userNameFld.text isMatchedByRegex:@"\\b([a-zA-Z0-9%_.+\\-]+)@([a-zA-Z0-9.\\-]+?\\.[a-zA-Z]{2,6})\\b"];
    if (!isEmailType)
    {
        [self showAlertWithTitle:@"提示"
                             tag:1
                         message:@"邮箱格式不正确"
                        delegate:self
               otherButtonTitles:@"确定", nil];
        return NO;
    }
    
    BOOL isPhone = [phoneFld.text isMatchedByRegex:@"^(13[0-9]|15[0-9]|18[0-9])\\d{8}$"];
    if (!isPhone)
    {
        [self showAlertWithTitle:@"提示"
                             tag:1
                         message:@"手机号格式不正确"
                        delegate:self
               otherButtonTitles:@"确定",nil];
        return NO;
    }
    
    return YES;
}

- (void) doBackBtnClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) doRegistBtnClicked:(id)sender
{
    RegistViewController *rVctr = [[RegistViewController alloc]init];
    [self.navigationController pushViewController:rVctr animated:YES];
    [rVctr release];
}

- (void) doLoginBtnClicked:(id)sender
{
    if (![self checkInfo])
    {
        return;
    }
    
    NSString *idString    = [SingleMQTT getCurrentDevTopic];
    NSString *deviceToken = [[NSUserDefaults standardUserDefaults] objectForKey:QQ_STUDENT];
    NSArray *paramsArr = [NSArray arrayWithObjects:@"action",@"phoneNumber",@"email",
                                                   @"deviceId",@"ios",@"deviceToken", nil];
    NSArray *valuesArr = [NSArray arrayWithObjects:@"login", phoneFld.text, userNameFld.text,
                                                   idString, IOS,deviceToken, nil];
    NSDictionary *pDic = [NSDictionary dictionaryWithObjects:valuesArr
                                                     forKeys:paramsArr];
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
    NSString *helpPhone = [[NSUserDefaults standardUserDefaults] objectForKey:@""];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", helpPhone]]];
}

#pragma mark -
#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
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
        NSString *ssid = [resDic objectForKey:@"sessid"];
        [[NSUserDefaults standardUserDefaults] setObject:ssid forKey:SSID];
        CLog(@"ssid:%@", ssid);
        
        NSDictionary *stuDic = [resDic objectForKey:@"studentInfo"];
        
        //获得Student
        Student *student    = [[Student alloc]init];
        student.email       = [stuDic objectForKey:@"email"];
        student.gender      = [[stuDic objectForKey:@"gender"] copy];
        student.grade       = [[stuDic objectForKey:@"grade"]  copy];
        student.icon        = [stuDic objectForKey:@"icon"];
        student.latltude    = [stuDic objectForKey:@"latitude"];
        student.longltude   = [stuDic objectForKey:@"longitude"];
        student.lltime      = [stuDic objectForKey:@"lltime"];
        student.nickName    = [stuDic objectForKey:@"nickname"];
        student.phoneNumber = [stuDic objectForKey:@"phone"];
        student.status      = [[stuDic objectForKey:@"status"] copy];
        student.phoneStars  = [[stuDic objectForKey:@"phone_stars"] copy];
        student.locStars    = [[stuDic objectForKey:@"location_stars"] copy];
        
        NSData *stuData = [NSKeyedArchiver archivedDataWithRootObject:student];
        [[NSUserDefaults standardUserDefaults] setObject:stuData
                                                  forKey:STUDENT];
        [student release];
        
        //写入登录成功标识
        [[NSUserDefaults standardUserDefaults] setBool:YES
                                                forKey:LOGINE_SUCCESS];
        
        //跳转个人中心
        [self.navigationController popToRootViewControllerAnimated:NO];
        PersonCenterViewController *pcVctr = [[PersonCenterViewController alloc]init];
        [self.navigationController pushViewController:pcVctr
                                             animated:YES];
        [pcVctr release];
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
