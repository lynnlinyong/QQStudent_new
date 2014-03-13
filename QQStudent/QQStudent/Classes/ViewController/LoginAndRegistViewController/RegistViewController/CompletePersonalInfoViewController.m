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

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
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
    upTab = [[UITableView alloc]init];
    upTab.delegate     = self;
    upTab.dataSource   = self;
    upTab.frame = [UIView fitCGRect:CGRectMake(0, 44, 320, 480)
                         isBackView:YES];
    upTab.scrollEnabled  = NO;
    upTab.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:upTab];
    
    upTab.backgroundColor     = [UIColor colorWithHexString:@"E1E0DE"];
    self.view.backgroundColor = [UIColor colorWithHexString:@"E1E0DE"];

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
    if ((nameValLab.text.length!=0) && (classValLab.text.length!=0)
                                    && (sexValLab.text.length!=0))
    {
        finishBtn.enabled = YES;
        
        [finishBtn setTitleColor:[UIColor colorWithHexString:@"#ff6600"]
                        forState:UIControlStateNormal];
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
    NSData *stuData  = [[NSUserDefaults standardUserDefaults] dataForKey:STUDENT];
    Student *student = [NSKeyedUnarchiver unarchiveObjectWithData:stuData];
    
    NSDictionary *userInfoDic = [sender.userInfo objectForKey:@"UserInfo"];
    int tag = ((NSNumber *)[userInfoDic objectForKey:@"TAG"]).intValue;
    if (tag == 0)  //确定
    {
        classValLab.text = [userInfoDic objectForKey:@"name"];
        student.grade    = [userInfoDic objectForKey:@"id"];
    }
    
    stuData = [NSKeyedArchiver archivedDataWithRootObject:student];
    [[NSUserDefaults standardUserDefaults] setObject:stuData forKey:STUDENT];

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
        int index = ((NSNumber *)[userInfoDic objectForKey:@"Index"]).intValue;
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
            default:
                break;
        }
        
        student.gender = [NSString stringWithFormat:@"%d", index];
    }
    
    stuData = [NSKeyedArchiver archivedDataWithRootObject:student];
    [[NSUserDefaults standardUserDefaults] setObject:stuData forKey:STUDENT];
    
    [self checkInfoComplete];
    
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
}

- (void) doButtonClicked:(id)sender
{
    if (![AppDelegate isConnectionAvailable:YES withGesture:NO])
    {
        return;
    }
    
    NSData *stuData  = [[NSUserDefaults standardUserDefaults] dataForKey:STUDENT];
    Student *student = [NSKeyedUnarchiver unarchiveObjectWithData:stuData];
    NSString *ssid   = [[NSUserDefaults standardUserDefaults] objectForKey:SSID];
    
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

#pragma mark -
#pragma mark - UITableViewDelegate and UITableViewDatasource
- (int) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (int) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}

- (float) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 5)
    {
        return 80;
    }
    
    return 44;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *idString = @"idString";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:idString];
    if (!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault
                                     reuseIdentifier:idString];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    //获得Student
    NSData *stuData  = [[NSUserDefaults standardUserDefaults] valueForKey:STUDENT];
    Student *student = [NSKeyedUnarchiver unarchiveObjectWithData:stuData];
    switch (indexPath.row)
    {
        case 0:
        {
            cell.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"sp_content_hlight_cell"]];
            
            UILabel *infoLab = [[UILabel alloc]init];
            infoLab.backgroundColor = [UIColor clearColor];
            infoLab.text  = @"邮箱";
            infoLab.frame = CGRectMake(10, 12, 40, 20);
            [cell addSubview:infoLab];
            [infoLab release];
            
            UILabel *emailValLab = [[UILabel alloc]init];
            emailValLab.text = student.email;
            emailValLab.textAlignment   = NSTextAlignmentCenter;
            emailValLab.backgroundColor = [UIColor clearColor];
            emailValLab.frame = CGRectMake(75, 12, 170, 20);
            [cell addSubview:emailValLab];
            
            break;
        }
        case 1:
        {
            cell.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"sp_content_hlight_cell"]];
            
            UILabel *infoLab = [[UILabel alloc]init];
            infoLab.backgroundColor = [UIColor clearColor];
            infoLab.text = @"手机";
            infoLab.frame = CGRectMake(10, 12, 40, 20);
            [cell addSubview:infoLab];
            [infoLab release];
            
            UILabel *phoneValLab = [[UILabel alloc]init];
            phoneValLab.text  = student.phoneNumber;
            phoneValLab.frame = CGRectMake(75, 12, 170, 20);
            phoneValLab.backgroundColor = [UIColor clearColor];
            phoneValLab.textAlignment   = NSTextAlignmentCenter;
            [cell addSubview:phoneValLab];
            [phoneValLab release];
            break;
        }
        case 2:
        {
            cell.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"sp_content_normal_cell"] highlightedImage:[UIImage imageNamed:@"sp_content_hlight_cell"]];
            
            UILabel *infoLab = [[UILabel alloc]init];
            infoLab.backgroundColor = [UIColor clearColor];
            infoLab.text = @"昵称";
            infoLab.frame = CGRectMake(10, 12, 40, 20);
            [cell addSubview:infoLab];
            [infoLab release];
            
            nameValLab = [[UILabel alloc]init];
            nameValLab.text = @"";
            nameValLab.frame = CGRectMake(75, 12, 170, 20);
            nameValLab.backgroundColor = [UIColor clearColor];
            nameValLab.textAlignment   = NSTextAlignmentCenter;
            [cell addSubview:nameValLab];
            
            
            break;
        }
        case 3:
        {
            cell.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"sp_content_normal_cell"] highlightedImage:[UIImage imageNamed:@"sp_content_hlight_cell"]];
            
            UILabel *infoLab = [[UILabel alloc]init];
            infoLab.backgroundColor = [UIColor clearColor];
            infoLab.text = @"年级";
            infoLab.frame = CGRectMake(10, 12, 40, 20);
            [cell addSubview:infoLab];
            [infoLab release];
            
            classValLab = [[UILabel alloc]init];
            classValLab.text = @"";
            classValLab.frame = CGRectMake(75, 12, 170,
                                           20);
            classValLab.backgroundColor = [UIColor clearColor];
            classValLab.textAlignment   = NSTextAlignmentCenter;
            [cell addSubview:classValLab];
            
            break;
        }
        case 4:
        {
            cell.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"sp_content_normal_cell"] highlightedImage:[UIImage imageNamed:@"sp_content_hlight_cell"]];
            
            UILabel *infoLab = [[UILabel alloc]init];
            infoLab.backgroundColor = [UIColor clearColor];
            infoLab.text = @"性别";
            infoLab.frame = CGRectMake(10, 12, 40, 20);
            [cell addSubview:infoLab];
            [infoLab release];
            
            sexValLab = [[UILabel alloc]init];
            sexValLab.text  = @"";
            sexValLab.textAlignment = NSTextAlignmentCenter;
            sexValLab.frame = CGRectMake(75, 12, 170, 20);
            sexValLab.backgroundColor = [UIColor clearColor];
            [cell addSubview:sexValLab];
            
            break;
        }
        case 5:
        {
            UIImage *loginImg  = [UIImage imageNamed:@"normal_btn"];
            finishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            finishBtn.enabled = NO;
            [finishBtn setTitle:@"完成"
                       forState:UIControlStateNormal];
            [finishBtn setTitleColor:[UIColor colorWithHexString:@"#999999"]
                            forState:UIControlStateNormal];
            [finishBtn setTitleColor:[UIColor colorWithHexString:@"#ff6600"]
                            forState:UIControlStateHighlighted];
            [finishBtn setBackgroundImage:loginImg
                                 forState:UIControlStateNormal];
            finishBtn.frame = CGRectMake(5,
                                         30,
                                         cell.frame.size.width-10,
                                         cell.frame.size.height);
            [finishBtn addTarget:self
                          action:@selector(doButtonClicked:)
                forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:finishBtn];
            cell.backgroundColor = [UIColor colorWithHexString:@"E1E0DE"];
            break;
        }
        default:
            break;
    }
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath
                             animated:YES];
    CustomNavigationViewController *nav = (CustomNavigationViewController *)[MainViewController getNavigationViewController];
   
    switch (indexPath.row)
    {
        case 2:
        {
            SetNickNameViewController *snVc = [[SetNickNameViewController alloc]init];
            [nav presentPopupViewController:snVc
                              animationType:MJPopupViewAnimationFade];
            break;
        }
        case 3:
        {
            SetGradeViewController *sgVctr = [[SetGradeViewController alloc]init];
            sgVctr.gradeName = classValLab.text;
            [nav presentPopupViewController:sgVctr
                               animationType:MJPopupViewAnimationFade];
            break;
        }
        case 4:
        {
            SelectSexViewController *ssVctr = [[SelectSexViewController alloc]init];
            ssVctr.isSetSex = YES;
            if (sexValLab.text.length==0)
                ssVctr.sexName = @"男";
            else
                ssVctr.sexName = sexValLab.text;
            [nav presentPopupViewController:ssVctr
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
//        [self showAlertWithTitle:@"提示"
//                             tag:0
//                         message:@"更新成功"
//                        delegate:self
//               otherButtonTitles:@"确定", nil];
        NSDictionary *stuDic = [resDic objectForKey:@"studentInfo"];
        
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
