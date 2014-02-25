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
    [shareImgView release];
    [super dealloc];
}

#pragma mark -
#pragma mark - Custom Action
- (void) initUI
{
    UILabel *title        = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    title.textColor       = [UIColor colorWithHexString:@"#009f66"];
    title.backgroundColor = [UIColor clearColor];
    title.textAlignment = UITextAlignmentCenter;
    title.text = @"分享到腾讯微博";
    self.navigationItem.titleView = title;
    [title release];
    
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
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    
    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [shareBtn setTitle:@"分享" forState:UIControlStateNormal];
    shareBtn.frame = CGRectMake(0, 0, 40, 20);
    [shareBtn addTarget:self
                 action:@selector(doShareBtnClicked:)
       forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:shareBtn];
    
    shareImgView = [[TTImageView alloc]init];
    shareImgView.image = [UIImage imageNamed:@"shareIcon.jpg"];
    shareImgView.frame = [UIView fitCGRect:CGRectMake(20, 20, 50, 50)
                                isBackView:NO];
    [self.view addSubview:shareImgView];
    
    shareContentFld = [[UITextField alloc]init];
    shareContentFld.font        = [UIFont systemFontOfSize:12.f];
    shareContentFld.text        = @"轻轻家教学生版,快快去下载哦!";
    shareContentFld.delegate    = self;
    shareContentFld.borderStyle = UITextBorderStyleLine;
    shareContentFld.frame = [UIView fitCGRect:CGRectMake(70, 20, 230, 80) isBackView:NO];
    [self.view addSubview:shareContentFld];
    
    NSDictionary *shareDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"ShareContent"];
    if (shareDic)
    {
        NSDictionary *studentDic = [shareDic objectForKey:@"student"];
        shareContentFld.text = [studentDic objectForKey:@"text"];
        
        shareImgView.URL = [studentDic objectForKey:@"image"];
    }
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
- (void) doBackBtnClicked:(id)sender
{
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UINavigationController *nav    = (UINavigationController *)app.window.rootViewController;
    [nav popToRootViewControllerAnimated:YES];
}

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
