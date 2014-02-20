//
//  CompletePersonalInfoViewController.m
//  QQStudent
//
//  Created by lynn on 14-2-2.
//  Copyright (c) 2014年 lynn. All rights reserved.
//

#import "CompletePersonalInfoViewController.h"

@interface CompletePersonalInfoViewController ()

@end

@implementation CompletePersonalInfoViewController

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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void) viewDidUnload
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super viewDidUnload];
}

- (void)dealloc
{
    [classValLab release];
    [sexValLab   release];
    [nameValLab  release];
    [super dealloc];
}

#pragma mark -
#pragma mark - Custom Action
- (void) initUI
{
    //获得Student
    NSData *stuData  = [[NSUserDefaults standardUserDefaults] valueForKey:STUDENT];
    Student *student = [NSKeyedUnarchiver unarchiveObjectWithData:stuData];
    
    UIButton *emailBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    emailBtn.frame = [UIView fitCGRect:CGRectMake(30, 80, 260, 20)
                            isBackView:NO];
    UILabel *emailLab = [[UILabel alloc]init];
    emailLab.text  = @"邮箱";
    emailLab.frame = CGRectMake(0, 0, 40, 20);
    emailLab.backgroundColor = [UIColor clearColor];
    [emailBtn addSubview:emailLab];
    
    UILabel *emailValLab = [[UILabel alloc]init];
    emailValLab.text  = student.email;
    emailValLab.frame =CGRectMake(40, 0, 220, 20);
    emailValLab.backgroundColor = [UIColor clearColor];
    emailValLab.textAlignment   = NSTextAlignmentCenter;
    [emailBtn addSubview:emailValLab];
    [self.view addSubview:emailBtn];
    [emailLab release];
    [emailValLab release];
    
    UIButton *phoneBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    phoneBtn.frame = [UIView fitCGRect:CGRectMake(30, 110, 260, 20)
                            isBackView:NO];
    UILabel *phoneLab = [[UILabel alloc]init];
    phoneLab.text  = @"手机";
    phoneLab.frame = CGRectMake(0, 0, 40, 20);
    phoneLab.backgroundColor = [UIColor clearColor];
    [phoneBtn addSubview:phoneLab];
    
    UILabel *phoneValLab = [[UILabel alloc]init];
    phoneValLab.text  = student.phoneNumber;
    phoneValLab.frame =CGRectMake(40, 0, 220, 20);
    phoneValLab.backgroundColor = [UIColor clearColor];
    phoneValLab.textAlignment   = NSTextAlignmentCenter;
    [phoneBtn addSubview:phoneValLab];
    [self.view addSubview:phoneBtn];
    [phoneLab release];
    [phoneValLab release];
    
    UIButton *nameBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    nameBtn.tag   = 0;
    nameBtn.frame = [UIView fitCGRect:CGRectMake(30, 140, 260, 20)
                           isBackView:NO];
    [nameBtn addTarget:self
                action:@selector(doButtonClicked:)
      forControlEvents:UIControlEventTouchUpInside];
    UILabel *nameLab = [[UILabel alloc]init];
    nameLab.text  = @"昵称";
    nameLab.frame = CGRectMake(0, 0, 40, 20);
    nameLab.backgroundColor = [UIColor clearColor];
    [nameBtn addSubview:nameLab];
    
    nameValLab = [[UILabel alloc]init];
    nameValLab.text = student.nickName;
    nameValLab.frame = CGRectMake(40, 0, 220, 20);
    nameValLab.backgroundColor = [UIColor clearColor];
    nameValLab.textAlignment   = NSTextAlignmentCenter;
    [nameBtn addSubview:nameValLab];
    [self.view addSubview:nameBtn];
    [nameLab release];
    
    UIButton *classBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    classBtn.tag   = 1;
    classBtn.frame = [UIView fitCGRect:CGRectMake(30, 170, 260, 20)
                            isBackView:NO];
    [classBtn addTarget:self
                 action:@selector(doButtonClicked:)
       forControlEvents:UIControlEventTouchUpInside];
    UILabel *classLab = [[UILabel alloc]init];
    classLab.text  = @"年级";
    classLab.backgroundColor = [UIColor clearColor];
    classLab.frame = CGRectMake(0, 0, 40, 20);
    [classBtn addSubview:classLab];
    
    classValLab = [[UILabel alloc]init];
    classValLab.text = @"";
    classValLab.frame = CGRectMake(40, 0, 220, 20);
    classValLab.backgroundColor = [UIColor clearColor];
    classValLab.textAlignment   = NSTextAlignmentCenter;
    [classBtn addSubview:classValLab];
    [self.view addSubview:classBtn];
    [classLab release];
    
    UIButton *sexBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    sexBtn.tag   = 2;
    sexBtn.frame = [UIView fitCGRect:CGRectMake(30, 200, 260, 20)
                          isBackView:NO];
    [sexBtn addTarget:self
               action:@selector(doButtonClicked:)
     forControlEvents:UIControlEventTouchUpInside];
    UILabel *sexLab = [[UILabel alloc]init];
    sexLab.text     = @"性别";
    sexLab.backgroundColor = [UIColor clearColor];
    sexLab.frame = CGRectMake(0, 0, 40, 20);
    [sexBtn addSubview:sexLab];
    
    sexValLab = [[UILabel alloc]init];
    sexValLab.text  = @"";
    sexValLab.textAlignment = NSTextAlignmentCenter;
    sexValLab.frame = CGRectMake(40, 0, 220, 20);
    sexValLab.backgroundColor = [UIColor clearColor];
    [sexBtn addSubview:sexValLab];
    [self.view addSubview:sexBtn];
    [sexLab release];
    
    //注册设置名称昵称消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(setNickNameFromNotice:) name:@"setNickNameNotice"
                                               object:nil];
    
    //注册选择性别消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(setSexFromNotice:) name:@"setSexNotice"
                                               object:nil];
    
    //注册选择年级消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(setGradeFromNotice:) name:@"setGradeNotice"
                                               object:nil];
}

- (void) checkInfoComplete
{
    NSData *stuData  = [[NSUserDefaults standardUserDefaults] dataForKey:STUDENT];
    Student *student = [NSKeyedUnarchiver unarchiveObjectWithData:stuData];
    NSString *ssid   = [[NSUserDefaults standardUserDefaults] objectForKey:SSID];
    if ((nameValLab.text.length!=0) && (classValLab.text.length!=0)
                                    && (sexValLab.text.length!=0))
    {
        NSString *valSex = nil;
        if ([sexValLab.text isEqualToString:@"男"])
            valSex = @"1";
        else
            valSex = @"2";
        
        //更新个人资料
        NSArray *paramsArr = [NSArray arrayWithObjects:@"action",@"phone",@"email", @"grade",@"gender",@"nick",@"phone_stars",@"location_stars",@"sessid",nil];
        NSArray *valuesArr = [NSArray arrayWithObjects:@"upinfo",student.phoneNumber,
                                                       student.email,student.grade,valSex,
                                                       nameValLab.text,@"1",
                                                       @"1",ssid,nil];
        NSDictionary *pDic = [NSDictionary dictionaryWithObjects:valuesArr
                                                         forKeys:paramsArr];
        CLog(@"updateInfo:%@", pDic);
        ServerRequest *serverReq = [ServerRequest sharedServerRequest];
        serverReq.delegate   = self;
        NSString *webAddress = [[NSUserDefaults standardUserDefaults] valueForKey:WEBADDRESS];
        NSString *url = [NSString stringWithFormat:@"%@%@/", webAddress,STUDENT];
        [serverReq requestASyncWith:kServerPostRequest
                           paramDic:pDic
                             urlStr:url];
    }
}

#pragma mark -
#pragma mark - Notice
- (void) setNickNameFromNotice:(NSNotification *)sender
{
    NSData *stuData  = [[NSUserDefaults standardUserDefaults] dataForKey:STUDENT];
    Student *student = [NSKeyedUnarchiver unarchiveObjectWithData:stuData];
    
    NSNotification *notice = sender;
    NSDictionary *userInfoDic = notice.userInfo;
    if (userInfoDic)
    {
        nameValLab.text  = [userInfoDic objectForKey:@"nickName"];
        student.nickName = [userInfoDic objectForKey:@"nickName"];
    }
    
    stuData = [NSKeyedArchiver archivedDataWithRootObject:student];
    [[NSUserDefaults standardUserDefaults] setObject:stuData forKey:STUDENT];
    
    [self checkInfoComplete];
    
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
}

- (void) setGradeFromNotice:(NSNotification *) sender
{
    NSDictionary *userInfoDic = [sender.userInfo objectForKey:@"UserInfo"];
    int tag = ((NSNumber *)[userInfoDic objectForKey:@"TAG"]).intValue;
    if (tag == 0)
    {
        classValLab.text = [userInfoDic objectForKey:@"name"];
    }
    
    [self checkInfoComplete];
    
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
}

- (void) setSexFromNotice:(NSNotification *) sender
{
    NSNotification *notice = sender;
    NSDictionary *userInfoDic = notice.userInfo;

    NSData *stuData  = [[NSUserDefaults standardUserDefaults] dataForKey:STUDENT];
    Student *student = [NSKeyedUnarchiver unarchiveObjectWithData:stuData];
    if (userInfoDic)
    {
        NSNumber *index = [userInfoDic objectForKey:@"sexIndex"];
        switch (index.intValue)
        {
            case 0:
            {
                sexValLab.text = @"男";
                break;
            }
            case 1:
            {
                sexValLab.text = @"女";
                break;
            }
            default:
                break;
        }
        
        student.gender = [NSString stringWithFormat:@"%d", index.intValue];
    }
    
    stuData = [NSKeyedArchiver archivedDataWithRootObject:student];
    [[NSUserDefaults standardUserDefaults] setObject:stuData forKey:STUDENT];
    
    [self checkInfoComplete];
    
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
}

- (void) doButtonClicked:(id)sender
{
    UIButton *button = (UIButton *)sender;
    switch (button.tag)
    {
        case 0:         //昵称
        {
            SetNickNameViewController *snVc = [[SetNickNameViewController alloc]init];
            [self presentPopupViewController:snVc
                               animationType:MJPopupViewAnimationFade];
            break;
        }
        case 1:         //年级
        {
            SetGradeViewController *sgVctr = [[SetGradeViewController alloc]init];
            [self presentPopupViewController:sgVctr
                               animationType:MJPopupViewAnimationFade];
            break;
        }
        case 2:         //性别
        {
            SetSexViewController *ssVctr = [[SetSexViewController alloc]init];
            [self presentPopupViewController:ssVctr
                               animationType:MJPopupViewAnimationFade];
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
                         message:@"更新成功"
                        delegate:self
               otherButtonTitles:@"确定", nil];
        
        NSDictionary *stuDic = [resDic objectForKey:@"studentInfo"];
        CLog(@"Dictionary:%@", stuDic);
        
        //获得Student
        Student *student    = [[Student alloc]init];
        student.email       = [stuDic objectForKey:@"email"];
        student.gender      = [[NSNumber numberWithInt:(int)[stuDic objectForKey:@"gender"]] stringValue];
        student.grade       = [[NSNumber numberWithInt:(int)[stuDic objectForKey:@"grade"]] stringValue];
        student.icon        = [[NSNumber numberWithInt:(int)[stuDic objectForKey:@"icon"]] stringValue];
        student.latltude    = [stuDic objectForKey:@"latitude"];
        student.longltude   = [stuDic objectForKey:@"longitude"];
        student.lltime      = [stuDic objectForKey:@"lltime"];
        student.nickName    = [stuDic objectForKey:@"nickname"];
        student.phoneNumber = [stuDic objectForKey:@"phone"];
        student.status      = [[NSNumber numberWithInt:(int)[stuDic objectForKey:@"status"]] stringValue];
        student.phoneStars  = [[NSNumber numberWithInt:(int)[stuDic objectForKey:@"phone_stars"]] stringValue];
        student.locStars    = [[NSNumber numberWithInt:(int)[stuDic objectForKey:@"location_stars"]] stringValue];
        
        NSData *stuData = [NSKeyedArchiver archivedDataWithRootObject:student];
        [[NSUserDefaults standardUserDefaults] setObject:stuData
                                                  forKey:STUDENT];
        [student release];
        
        //返回登陆
        [self backLoginView];
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

- (void) backLoginView
{
    NSArray *ctrsArr = self.navigationController.viewControllers;
    for (UIViewController *vc in ctrsArr)
    {
        if ([vc isKindOfClass:[LoginViewController class]])
        {
            [self.navigationController popToViewController:vc animated:YES];
        }
    }
}
@end
