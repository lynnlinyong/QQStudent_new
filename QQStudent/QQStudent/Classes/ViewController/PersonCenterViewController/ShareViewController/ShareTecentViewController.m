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
    
    [self initUI];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewDidUnload
{
//    CustomNavigationViewController *nav = (CustomNavigationViewController *) [MainViewController getNavigationViewController];
//    nav.dataSource = nil;
    [super viewDidUnload];
}

- (void) dealloc
{
    [shareImgView release];
    [super dealloc];
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
    
    [self.view addSubview:bgImgView];

    
    shareImgView = [[TTImageView alloc]init];
    [self.view addSubview:shareImgView];
    
    shareContentFld = [[UITextView alloc]init];
    shareContentFld.font        = [UIFont systemFontOfSize:12.f];
//    shareContentFld.delegate    = self;
//    shareContentFld.borderStyle = UITextBorderStyleLine;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7)
    {
        if (iPhone5)
        {
            //ios7 iphone5
            CLog(@"It's is iphone5 IOS7");
            shareContentFld.frame = [UIView fitCGRect:CGRectMake(70, 74, 230, 80)
                                           isBackView:NO];
            bgImgView.frame = [UIView fitCGRect:CGRectMake(10, 64, 300, 160)
                                     isBackView:NO];
            shareImgView.frame = [UIView fitCGRect:CGRectMake(20, 74, 50, 50)
                                        isBackView:NO];
        }
        else
        {
            CLog(@"It's is iphone4 IOS7");
            //ios 7 iphone 4
            shareContentFld.frame = [UIView fitCGRect:CGRectMake(70, 74, 230, 80)
                                           isBackView:NO];
            bgImgView.frame = [UIView fitCGRect:CGRectMake(10, 64, 300, 160)
                                     isBackView:NO];
            shareImgView.frame = [UIView fitCGRect:CGRectMake(20, 74, 50, 50)
                                        isBackView:NO];
        }
    }
    else
    {
        if (!iPhone5)
        {
            // ios 6 iphone4
            CLog(@"It's is iphone4 IOS6");
            shareContentFld.frame = [UIView fitCGRect:CGRectMake(70, 34, 230, 80)
                                           isBackView:NO];
            bgImgView.frame = [UIView fitCGRect:CGRectMake(10, 24, 300, 160)
                                     isBackView:NO];
            shareImgView.frame = [UIView fitCGRect:CGRectMake(20, 34, 50, 50)
                                        isBackView:NO];
            
        }
        else
        {
            //ios 6 iphone5
            CLog(@"It's is iphone5 IOS6");
            shareContentFld.frame = [UIView fitCGRect:CGRectMake(70, 74, 230, 80)
                                           isBackView:NO];
            bgImgView.frame = [UIView fitCGRect:CGRectMake(10, 64, 300, 160)
                                     isBackView:NO];
            shareImgView.frame = [UIView fitCGRect:CGRectMake(20, 74, 50, 50)
                                        isBackView:NO];
        }
    }
    [self.view addSubview:shareContentFld];
        [bgImgView release];
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
    
    CustomNavigationViewController *nav    = (CustomNavigationViewController *)[MainViewController getNavigationViewController];
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
