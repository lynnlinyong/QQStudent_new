//
//  PersonCenterViewController.m
//  QQStudent
//
//  Created by lynn on 14-1-29.
//  Copyright (c) 2014年 lynn. All rights reserved.
//

#import "PersonCenterViewController.h"

@interface PersonCenterViewController ()

@end

@implementation PersonCenterViewController
@synthesize order;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [MainViewController setNavTitle:@"个人中心"];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [self checkSessidIsValid];
        dispatch_async(dispatch_get_main_queue(), ^{
            
        });
    });
}

- (void) viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) checkSessidIsValid
{
    if (![AppDelegate isConnectionAvailable:YES withGesture:NO])
    {
        return;
    }
    
    NSString *ssid = [[NSUserDefaults standardUserDefaults] objectForKey:SSID];
    NSArray *paramsArr = [NSArray arrayWithObjects:@"action",@"sessid", nil];
    NSArray *valuesArr = [NSArray arrayWithObjects:@"updatelogin",ssid, nil];
    NSDictionary *pDic = [NSDictionary dictionaryWithObjects:valuesArr
                                                     forKeys:paramsArr];
    
    NSString *webAdd   = [[NSUserDefaults standardUserDefaults] objectForKey:WEBADDRESS];
    if (!webAdd)
    {
        CustomNavigationViewController *nav = [MainViewController getNavigationViewController];
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:nav.view
                                                  withText:@"服务器地址不可用"
                                                  animated:YES
                                                  delegate:NULL];
        [hud hide:YES afterDelay:3];
        return;
    }
    NSString *url      = [NSString stringWithFormat:@"%@%@", webAdd, STUDENT];
    ServerRequest *serverReq = [ServerRequest sharedServerRequest];
    NSData *resVal     = [serverReq requestSyncWith:kServerPostRequest
                                           paramDic:pDic
                                             urlStr:url];
    NSString *resStr = [[[NSString alloc]initWithData:resVal
                                             encoding:NSUTF8StringEncoding]autorelease];
    NSDictionary *resDic  = [[resStr JSONValue] retain];
    NSString *eerid = [[resDic objectForKey:@"errorid"] copy];
    if (resDic)
    {
        if (eerid.intValue==0)
        {
            //获得最新个人信息
            CLog(@"get New Info:%@", resDic);
            NSDictionary *stuDic = [[resDic objectForKey:@"studentInfo"] retain];
            
            //获得Student
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
            [student release];
            [stuData release];
        }
        else
        {
            NSString *errorMsg = [resDic objectForKey:@"message"];
            [self showAlertWithTitle:@"提示"
                                 tag:4
                             message:[NSString stringWithFormat:@"错误码%@,%@",eerid,errorMsg]
                            delegate:self
                   otherButtonTitles:@"确定",nil];
        }
    }
    else
    {
        [self showAlertWithTitle:@"提示"
                             tag:3
                         message:@"获取数据失败!"
                        delegate:self
               otherButtonTitles:@"确定",nil];
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

- (void) doBackBtnClicked:(id)sender
{
    //返回聊天界面
    CustomNavigationViewController *nav = [MainViewController getNavigationViewController];
    [nav popToRootViewControllerAnimated:NO];
    
    ChatViewController *cVctr = [[ChatViewController alloc]init];
    cVctr.tObj  = order.teacher;
    cVctr.order = order;
    [nav pushViewController:cVctr animated:YES];
    [cVctr release];
}
@end
