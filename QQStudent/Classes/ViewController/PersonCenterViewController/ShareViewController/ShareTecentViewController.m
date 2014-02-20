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
    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [shareBtn setTitle:@"分享" forState:UIControlStateNormal];
    shareBtn.frame = CGRectMake(0, 0, 40, 20);
    [shareBtn addTarget:self
                 action:@selector(doShareBtnClicked:)
       forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:shareBtn];
    
    shareImgView = [[UIImageView alloc]init];
    shareImgView.image = [UIImage imageNamed:@"shareIcon.jpg"];
    shareImgView.frame = [UIView fitCGRect:CGRectMake(20, 20, 50, 50) isBackView:NO];
    [self.view addSubview:shareImgView];
    
    shareContentFld = [[UITextField alloc]init];
    shareContentFld.font        = [UIFont systemFontOfSize:12.f];
    shareContentFld.text        = @"轻轻家教学生版,快快去下载哦!";
    shareContentFld.delegate    = self;
    shareContentFld.borderStyle = UITextBorderStyleLine;
    shareContentFld.frame = [UIView fitCGRect:CGRectMake(70, 20, 230, 80) isBackView:NO];
    [self.view addSubview:shareContentFld];
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
                                   shareImgView.image, @"pic",
                                   nil];
    CLog(@"params:%@", params);
    SingleTCWeibo *tcWbApi = [SingleTCWeibo shareInstance];
    [tcWbApi.tcWeiboApi requestWithParams:params
                                  apiName:@"t/add_pic"
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
    NSArray *ctrsArr = self.navigationController.viewControllers;
    for (UIViewController *ctr in ctrsArr)
    {
        if ([ctr isKindOfClass:[PersonCenterViewController class]])
        {
            [self.navigationController popToViewController:ctr
                                                  animated:NO];
        }
    }
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
