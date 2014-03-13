//
//  BoundTecentViewController.m
//  QQStudent
//
//  Created by lynn on 14-2-17.
//  Copyright (c) 2014年 lynn. All rights reserved.
//

#import "BoundTecentViewController.h"

@interface BoundTecentViewController ()

@end

@implementation BoundTecentViewController

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
    [MainViewController setNavTitle:@"分享到腾讯微博"];
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

- (void) viewDidDisappear:(BOOL)animated
{
    CustomNavigationViewController *nav = (CustomNavigationViewController *) [MainViewController getNavigationViewController];
    nav.dataSource = nil;
    [super viewDidDisappear:animated];
}

- (void) viewDidUnload
{
    [super viewDidUnload];
}

- (void) dealloc
{
    [super dealloc];
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
    infoLab.text = @"绑定腾讯微博,分享给更多人!";
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

#pragma mark -
#pragma mark - Control Event
- (void) doButtonClicked:(id)sender
{
    SingleTCWeibo *tcWeibo = [SingleTCWeibo shareInstance];
    [tcWeibo.tcWeiboApi loginWithDelegate:self
                        andRootController:self];
}

- (void) doBackBtnClicked:(id)sender
{
    //返回分享页面
    CustomNavigationViewController *nav = [MainViewController getNavigationViewController];
    [nav popViewControllerAnimated:NO];
    [nav popViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark - WeiboAuthDelegate
/**
 * @brief   重刷授权成功后的回调
 * @param   INPUT   wbapi 成功后返回的WeiboApi对象，accesstoken,openid,refreshtoken,expires 等授权信息都在此处返回
 * @return  无返回
 */
- (void)DidAuthRefreshed:(WeiboApi *)wbapi_
{
    NSString *str = [[NSString alloc]initWithFormat:@"accesstoken = %@\r openid = %@\r appkey=%@ \r appsecret=%@\r", wbapi_.accessToken, wbapi_.openid, wbapi_.appKey, wbapi_.appSecret];
    CLog(@"result = %@",str);
    [str release];
}

/**
 * @brief   重刷授权失败后的回调
 * @param   INPUT   error   标准出错信息
 * @return  无返回
 */
- (void)DidAuthRefreshFail:(NSError *)error
{
    NSString *str = [[NSString alloc] initWithFormat:@"refresh token error, errcode = %@",error.userInfo];
    CLog(@"Result:%@", str);
    [str release];
}

/**
 * @brief   授权成功后的回调
 * @param   INPUT   wbapi 成功后返回的WeiboApi对象，accesstoken,openid,refreshtoken,expires 等授权信息都在此处返回
 * @return  无返回
 */
- (void)DidAuthFinished:(WeiboApi *)wbapi_
{
    NSString *str = [[NSString alloc]initWithFormat:@"accesstoken = %@\r openid = %@\r appkey=%@ \r appsecret=%@\r", wbapi_.accessToken, wbapi_.openid, wbapi_.appKey, wbapi_.appSecret];
    CLog(@"result = %@",str);
    
    CustomNavigationViewController *nav     = [MainViewController getNavigationViewController];
    ShareTecentViewController *stVctr = [[ShareTecentViewController alloc]init];
    [nav pushViewController:stVctr
                   animated:YES];
    [stVctr release];
    [str release];
}

/**
 * @brief   授权成功后的回调
 * @param   INPUT   wbapi   weiboapi 对象，取消授权后，授权信息会被清空
 * @return  无返回
 */
- (void)DidAuthCanceled:(WeiboApi *)wbapi_
{
    
}

/**
 * @brief   授权成功后的回调
 * @param   INPUT   error   标准出错信息
 * @return  无返回
 */
- (void)DidAuthFailWithError:(NSError *)error
{
    NSString *str = [[NSString alloc] initWithFormat:@"refresh token error, errcode = %@",error.userInfo];
    CLog(@"Result:%@", str);
    [str release];
}
@end
