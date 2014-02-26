//
//  ShareTecentViewController.m
//  QQStudent
//
//  Created by lynn on 14-2-17.
//  Copyright (c) 2014年 lynn. All rights reserved.
//

#import "ShareTecentViewController.h"

@interface ShareTecentViewController ()

@end

@implementation ShareTecentViewController

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
    
    [MainViewController setNavTitle:@"分享到腾讯微博"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initBackBarItem];
    
    [self initUI];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) dealloc
{
    [shareImgView release];
    [super dealloc];
}

#pragma mark -
#pragma mark - Custom Action
- (void) initBackBarItem
{
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    CustomNavigationViewController *nav = (CustomNavigationViewController *) app.window.rootViewController;
    nav.dataSource = self;
}

- (void) initUI
{
    self.view.backgroundColor = [UIColor colorWithHexString:@"#E1E0DE"];
    
    UIImage *shareImg  = [UIImage imageNamed:@"sp_share_btn_normal"];
    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [shareBtn setTitle:@"分享"
              forState:UIControlStateNormal];
    shareBtn.titleLabel.font = [UIFont systemFontOfSize:14.f];
    [shareBtn setBackgroundImage:shareImg
                        forState:UIControlStateNormal];
    [shareBtn setBackgroundImage:[UIImage imageNamed:@"sp_share_btn_hlight"]
                        forState:UIControlStateHighlighted];
    shareBtn.frame = CGRectMake(0, 0,
                                shareImg.size.width-10,
                                shareImg.size.height-5);
    [shareBtn addTarget:self
                 action:@selector(doShareBtnClicked:)
       forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:shareBtn];
    
    UIImageView *bgImgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"sp_share_content_bg"]];
    bgImgView.frame = [UIView fitCGRect:CGRectMake(10, 10, 300, 160)
                             isBackView:NO];
    
    [self.view addSubview:bgImgView];
    [bgImgView release];
    
    shareImgView = [[TTImageView alloc]init];
//    shareImgView.image = [UIImage imageNamed:@"shareIcon.jpg"];
    shareImgView.frame = [UIView fitCGRect:CGRectMake(20, 20, 50, 50)
                                isBackView:NO];
    [self.view addSubview:shareImgView];
    
    shareContentFld = [[UITextView alloc]init];
    shareContentFld.font        = [UIFont systemFontOfSize:12.f];
//    shareContentFld.delegate    = self;
//    shareContentFld.borderStyle = UITextBorderStyleLine;
    shareContentFld.frame = [UIView fitCGRect:CGRectMake(70, 20, 230, 80) isBackView:NO];
    [self.view addSubview:shareContentFld];
    
    NSDictionary *shareDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"ShareContent"];
    if (shareDic)
    {
        NSDictionary *studentDic = [shareDic objectForKey:@"student"];
        shareContentFld.text     = [studentDic objectForKey:@"text"];
        shareImgView.URL         = [studentDic objectForKey:@"image"];
        CLog(@"URL:%@", [studentDic objectForKey:@"image"]);
    }
}

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

#pragma mark -
#pragma mark - UITextFieldDelegate
- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark -
#pragma mark - Control Event
- (void) doShareBtnClicked:(id)sender
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc]initWithObjectsAndKeys:@"json",@"format",
                                   shareContentFld.text, @"content",
                                   shareImgView.URL,@"pic_url",
                                   nil];
    CLog(@"params:%@", params);
    SingleTCWeibo *tcWbApi = [SingleTCWeibo shareInstance];
    [tcWbApi.tcWeiboApi requestWithParams:params
                                  apiName:@"t/add_pic_url"
                               httpMethod:@"POST"
                                 delegate:self];
    [params release];
}

- (void) doBackBtnClicked:(id)sender
{
    //返回分享页面
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    CustomNavigationViewController *nav = (CustomNavigationViewController *)app.window.rootViewController;
    NSArray *vctrs = nav.viewControllers;
    for (UIViewController *vctr in vctrs)
    {
        if ([vctr isKindOfClass:[PersonCenterViewController class]])
        {
            [nav popToViewController:vctr animated:YES];
            return;
        }
    }
}

#pragma mark WeiboRequestDelegate

/**
 * @brief   接口调用成功后的回调
 * @param   INPUT   data    接口返回的数据
 * @param   INPUT   request 发起请求时的请求对象，可以用来管理异步请求
 * @return  无返回
 */
- (void)didReceiveRawData:(NSData *)data reqNo:(int)reqno
{
    NSString *strResult = [[NSString alloc] initWithBytes:[data bytes] length:[data length] encoding:NSUTF8StringEncoding];
    CLog(@"result = %@",strResult);
    
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UINavigationController *nav    = (UINavigationController *)app.window.rootViewController;
    [nav popToRootViewControllerAnimated:YES];
    
    [strResult release];
}

/**
 * @brief   接口调用失败后的回调
 * @param   INPUT   error   接口返回的错误信息
 * @param   INPUT   request 发起请求时的请求对象，可以用来管理异步请求
 * @return  无返回
 */
- (void)didFailWithError:(NSError *)error reqNo:(int)reqno
{
    NSString *str = [[NSString alloc] initWithFormat:@"refresh token error, errcode = %@",error.userInfo];
    CLog(@"result=%@", str);
    [str release];
}
@end
