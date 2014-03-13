//
//  BoundSinaViewController.m
//  QQStudent
//
//  Created by lynn on 14-2-17.
//  Copyright (c) 2014年 lynn. All rights reserved.
//

#import "BoundSinaViewController.h"

@interface BoundSinaViewController ()

@end

@implementation BoundSinaViewController

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
    [MainViewController setNavTitle:@"分享到新浪微博"];
    [self initBackBarItem];
    [super viewDidAppear:animated];
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
    [super viewDidUnload];
}

- (void) viewDidDisappear:(BOOL)animated
{
    CustomNavigationViewController *nav = (CustomNavigationViewController *) [MainViewController getNavigationViewController];
    nav.dataSource = nil;
    [super viewDidDisappear:animated];
}

#pragma mark -
#pragma mark - Custom Action
#pragma mark -
#pragma mark - CustomNavigationDataSource
- (UIBarButtonItem *) backBarButtomItem
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

- (void) initBackBarItem
{
    CustomNavigationViewController *nav = [MainViewController getNavigationViewController];
    nav.dataSource = self;
}

- (void) initUI
{
    UILabel *infoLab = [[UILabel alloc]init];
    infoLab.text = @"绑定Sina微博,分享给更多人!";
    infoLab.backgroundColor = [UIColor clearColor];
    infoLab.frame = [UIView fitCGRect:CGRectMake(50, 180, 220, 20)
                           isBackView:NO];
    [self.view addSubview:infoLab];
    [infoLab release];
    
    UIImage *boundImg  = [UIImage imageNamed:@"normal_btn"];
    UIButton *boundBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [boundBtn setTitle:@"立即绑定"
              forState:UIControlStateNormal];
    [boundBtn setTitleColor:[UIColor colorWithHexString:@"#ff6600"]
                   forState:UIControlStateNormal];
    [boundBtn setTitleColor:[UIColor colorWithHexString:@"#ff6600"]
                   forState:UIControlStateHighlighted];
    [boundBtn setBackgroundImage:boundImg
                        forState:UIControlStateNormal];
    [boundBtn setBackgroundImage:[UIImage imageNamed:@"hight_btn"]
                        forState:UIControlStateHighlighted];
    boundBtn.frame = [UIView fitCGRect:CGRectMake(160-boundImg.size.width/2,
                                                  230,
                                                  boundImg.size.width,
                                                  boundImg.size.height)
                            isBackView:NO];
    [boundBtn addTarget:self
                 action:@selector(doButtonClicked:)
       forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:boundBtn];
}

- (void) doButtonClicked:(id)sender
{
    SignalSinaWeibo *sgWb = [SignalSinaWeibo shareInstance:self];
    [sgWb.sinaWeibo logIn];
}

- (void) doBackBtnClicked:(id)sender
{
    //返回分享页面
    CustomNavigationViewController *nav = [MainViewController getNavigationViewController];
    [nav popViewControllerAnimated:NO];
    [nav popViewControllerAnimated:YES];
}

- (void)sinaweiboDidLogIn:(SinaWeibo *)sinaweibo
{
    CLog(@"Login Success!");
    ShareSinaViewController *ssVctr = [[ShareSinaViewController alloc]init];
    [self.navigationController pushViewController:ssVctr
                                         animated:YES];
    [ssVctr release];
}

- (void)sinaweiboDidLogOut:(SinaWeibo *)sinaweibo
{
    
}

- (void)sinaweiboLogInDidCancel:(SinaWeibo *)sinaweibo
{
    CLog(@"Login Failed!");
}

- (void)sinaweibo:(SinaWeibo *)sinaweibo logInDidFailWithError:(NSError *)error
{
    
}

- (void)sinaweibo:(SinaWeibo *)sinaweibo accessTokenInvalidOrExpired:(NSError *)error
{
    
}

@end
