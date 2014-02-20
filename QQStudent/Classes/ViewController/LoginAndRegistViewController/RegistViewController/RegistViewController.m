//
//  RegistViewController.m
//  QQStudent
//
//  Created by lynn on 14-1-28.
//  Copyright (c) 2014年 lynn. All rights reserved.
//

#import "RegistViewController.h"

@interface RegistViewController ()

@end

@implementation RegistViewController

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
    
    //初始化UI
    [self initUI];
}

- (void) viewDidUnload
{
    userNameFld.delegate = nil;
    userNameFld = nil;
    
    phoneFld.delegate = nil;
    phoneFld = nil;
    
    [super viewDidUnload];
}

- (void) dealloc
{
    [phoneFld    release];
    [userNameFld release];
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
//    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    [backBtn setTitle:@"返回" forState:UIControlStateNormal];
//    backBtn.frame = CGRectMake(0, 0, 100, 40);
//    [backBtn addTarget:self
//                action:@selector(doBackBtnClicked:)
//      forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:backBtn];
    
    userNameFld = [[UITextField alloc]init];
    userNameFld.delegate = self;
    userNameFld.borderStyle = UITextBorderStyleLine;
    userNameFld.placeholder = @"输入注册邮箱";
    userNameFld.frame = [UIView fitCGRect:CGRectMake(60, 110, 200, 30)
                               isBackView:NO];
    [self.view addSubview:userNameFld];
    
    phoneFld = [[UITextField alloc]init];
    phoneFld.delegate = self;
    phoneFld.borderStyle = UITextBorderStyleLine;
    phoneFld.placeholder = @"输入手机号码";
    phoneFld.frame = [UIView fitCGRect:CGRectMake(60, 150, 200, 30)
                            isBackView:NO];
    [self.view addSubview:phoneFld];
    
    UIButton *registBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [registBtn setTitle:@"注册" forState:UIControlStateNormal];
    registBtn.frame = CGRectMake(110, 220, 100, 40);
    [registBtn addTarget:self
                  action:@selector(doRegistBtnClicked:)
        forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registBtn];
}

- (BOOL) checkInfo
{
    if (userNameFld.text.length == 0 || phoneFld.text.length == 0)
    {
        [self showAlertWithTitle:@"提示"
                             tag:1
                         message:@"注册信息不完整!"
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
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void) doRegistBtnClicked:(id)sender
{
    //注册完成,跳转完成个人信息
//    CompletePersonalInfoViewController *cpVctr = [[CompletePersonalInfoViewController alloc]init];
//    [self.navigationController pushViewController:cpVctr
//                                         animated:YES];
    
    if (![self checkInfo])
    {
        return;
    }
    
    NSString *idString    = [SingleMQTT getCurrentDevTopic];
    NSString *deviceToken = [[NSUserDefaults standardUserDefaults] objectForKey:QQ_STUDENT];
    
    NSArray *paramsArr  = [NSArray arrayWithObjects:@"action",@"phoneNumber",@"email",
                                                              @"deviceId",@"ios",@"deviceToken",nil];
    NSArray *valuesArr  = [NSArray arrayWithObjects:@"register", phoneFld.text,
                                                   userNameFld.text, idString, IOS,deviceToken,nil];
    NSDictionary *pDic  = [NSDictionary dictionaryWithObjects:valuesArr
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
#pragma mark - UITextFieldDelegate
- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark -
#pragma mark - UIAlertViewDelegate
- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    int tag = alertView.tag;
    switch (tag)
    {
        case 0:     //正确Alert提示
        {
            //注册完成,跳转完成个人信息
            CompletePersonalInfoViewController *cpVctr = [[CompletePersonalInfoViewController alloc]init];
            [self.navigationController pushViewController:cpVctr
                                                 animated:YES];
            [cpVctr release];
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
        [self showAlertWithTitle:@"提示"
                             tag:0
                         message:@"注册成功"
                        delegate:self
               otherButtonTitles:@"确定", nil];
        
        NSString *ssid = [resDic objectForKey:@"sessid"];
        [[NSUserDefaults standardUserDefaults] setObject:ssid
                                                  forKey:SSID];

        //获得Student
        NSDictionary *stuDic = [resDic objectForKey:@"studentInfo"];
        Student *student    = [[Student alloc]init];
        student.email       = [stuDic objectForKey:@"email"];
        student.gender      = [[stuDic objectForKey:@"gender"] copy];
        student.grade       = [[stuDic objectForKey:@"grade"]  copy];
        student.icon        = [[stuDic objectForKey:@"icon"]   copy];
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
