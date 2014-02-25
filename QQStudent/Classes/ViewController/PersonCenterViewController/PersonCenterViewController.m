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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    [self checkSessidIsValid];
    
    //初始化UI
    [self initUI];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

#pragma mark -
#pragma mark - Custom Action
- (void) checkSessidIsValid
{
    NSString *ssid = [[NSUserDefaults standardUserDefaults] objectForKey:SSID];
    NSArray *paramsArr = [NSArray arrayWithObjects:@"action",@"sessid", nil];
    NSArray *valuesArr = [NSArray arrayWithObjects:@"updatelogin",ssid, nil];
    NSDictionary *pDic = [NSDictionary dictionaryWithObjects:valuesArr
                                                     forKeys:paramsArr];
    
    NSString *webAdd   = [[NSUserDefaults standardUserDefaults] objectForKey:WEBADDRESS];
    NSString *url      = [NSString stringWithFormat:@"%@%@", webAdd, STUDENT];
    ServerRequest *serverReq = [ServerRequest sharedServerRequest];
    NSData *resVal     = [serverReq requestSyncWith:kServerPostRequest
                                           paramDic:pDic
                                             urlStr:url];
    NSString *resStr = [[[NSString alloc]initWithData:resVal
                                             encoding:NSUTF8StringEncoding]autorelease];
    NSDictionary *resDic  = [resStr JSONValue];
    NSString *eerid = [[resDic objectForKey:@"errorid"] copy];
    if (resDic)
    {
        if (eerid.intValue==0)
        {
            //获得最新个人信息
            CLog(@"get New Info:%@", resDic);
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

- (void) initUI
{    
    MyTeacherViewController *mVctr = [[MyTeacherViewController alloc]initWithNibName:nil
                                                                              bundle:nil];
    UINavigationController *navMvctr = [[UINavigationController alloc]initWithRootViewController:mVctr];
    
    LatlyViewController *lVctr = [[LatlyViewController alloc]initWithNibName:nil
                                                                      bundle:nil];
    UINavigationController *navLVctr = [[UINavigationController alloc]initWithRootViewController:lVctr];
    
    SearchTeacherViewController *sVctr = [[SearchTeacherViewController alloc]initWithNibName:nil
                                                                                      bundle:nil];
    UINavigationController *navSVctr = [[UINavigationController alloc]initWithRootViewController:sVctr];
    
    ShareViewController *shareVctr = [[ShareViewController alloc]initWithNibName:nil
                                                                          bundle:nil];
    UINavigationController *navShareVctr = [[UINavigationController alloc]initWithRootViewController:shareVctr];
    
    SettingViewController *setVctr = [[SettingViewController alloc]initWithNibName:nil
                                                                            bundle:nil];
    UINavigationController *navSetVctr = [[UINavigationController alloc]initWithRootViewController:setVctr];
    [mVctr     release];
	[lVctr     release];
	[sVctr     release];
	[shareVctr release];
    [setVctr   release];
    
    NSMutableDictionary *imgDic = [NSMutableDictionary dictionaryWithCapacity:3];
	[imgDic setObject:[UIImage imageNamed:@"s_1_1"]
               forKey:@"Default"];
	[imgDic setObject:[UIImage imageNamed:@"s_1_2"]
               forKey:@"Highlighted"];
	[imgDic setObject:[UIImage imageNamed:@"s_1_2"]
               forKey:@"Seleted"];
	NSMutableDictionary *imgDic2 = [NSMutableDictionary dictionaryWithCapacity:3];
	[imgDic2 setObject:[UIImage imageNamed:@"s_2_1"]
                forKey:@"Default"];
	[imgDic2 setObject:[UIImage imageNamed:@"s_2_2"]
                forKey:@"Highlighted"];
	[imgDic2 setObject:[UIImage imageNamed:@"s_2_2"]
                forKey:@"Seleted"];
	NSMutableDictionary *imgDic3 = [NSMutableDictionary dictionaryWithCapacity:3];
	[imgDic3 setObject:[UIImage imageNamed:@"s_3_1"]
                forKey:@"Default"];
	[imgDic3 setObject:[UIImage imageNamed:@"s_3_2"]
                forKey:@"Highlighted"];
	[imgDic3 setObject:[UIImage imageNamed:@"s_3_2"]
                forKey:@"Seleted"];
	NSMutableDictionary *imgDic4 = [NSMutableDictionary dictionaryWithCapacity:3];
	[imgDic4 setObject:[UIImage imageNamed:@"s_4_1"]
                forKey:@"Default"];
	[imgDic4 setObject:[UIImage imageNamed:@"s_4_2"]
                forKey:@"Highlighted"];
	[imgDic4 setObject:[UIImage imageNamed:@"s_4_2"]
                forKey:@"Seleted"];
	NSMutableDictionary *imgDic5 = [NSMutableDictionary dictionaryWithCapacity:3];
	[imgDic5 setObject:[UIImage imageNamed:@"s_5_1"]
                forKey:@"Default"];
	[imgDic5 setObject:[UIImage imageNamed:@"s_5_2"]
                forKey:@"Highlighted"];
	[imgDic5 setObject:[UIImage imageNamed:@"s_5_2"]
                forKey:@"Seleted"];
	NSArray *ctrlArr = [NSArray arrayWithObjects:navMvctr,navLVctr,navSVctr,navShareVctr,navSetVctr,nil];

	NSArray *imgArr = [NSArray arrayWithObjects:imgDic,imgDic3,imgDic2,
                                                imgDic4,imgDic5,nil];
	
	LeveyTabBarController *leveyTabBarController = [[LeveyTabBarController alloc] initWithViewControllers:ctrlArr
                                                                                               imageArray:imgArr];
	[leveyTabBarController.tabBar setBackgroundImage:[UIImage imageNamed:@"c-2-1.png"]];
	[leveyTabBarController setTabBarTransparent:YES];
    
    UINavigationController *nav   = [[UINavigationController alloc]init];
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    app.window.rootViewController = nav;
    [nav pushViewController:leveyTabBarController
                   animated:NO];
}

- (void) doBackBtnClicked:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
@end
