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

- (void) dealloc
{
    [super dealloc];
}

#pragma mark -
#pragma mark - Custom Action
- (void) initUI
{
    UILabel *infoLab = [[UILabel alloc]init];
    infoLab.text = @"绑定腾讯微博,分享更多人!";
    infoLab.backgroundColor = [UIColor clearColor];
    infoLab.frame = [UIView fitCGRect:CGRectMake(60, 200, 200, 20)
                           isBackView:NO];
    [self.view addSubview:infoLab];
    [infoLab release];
    
    UIButton *boundBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [boundBtn setTitle:@"立即绑定"
              forState:UIControlStateNormal];
    [boundBtn addTarget:self
                 action:@selector(doButtonClicked:)
       forControlEvents:UIControlEventTouchUpInside];
    boundBtn.frame = [UIView fitCGRect:CGRectMake(120, 230, 80, 30)
                            isBackView:NO];
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
    
    ShareTecentViewController *stVctr = [[ShareTecentViewController alloc]init];
    [self.navigationController pushViewController:stVctr
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
