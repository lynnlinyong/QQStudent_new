//
//  ShareSinaViewController.m
//  QQStudent
//
//  Created by lynn on 14-2-17.
//  Copyright (c) 2014年 lynn. All rights reserved.
//

#import "ShareSinaViewController.h"

@interface ShareSinaViewController ()

@end

@implementation ShareSinaViewController

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
    
    //初始化UI
    [self initUI];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark - Custom Action
- (void) initUI
{
    UILabel *title        = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    title.textColor       = [UIColor colorWithHexString:@"#009f66"];
    title.backgroundColor = [UIColor clearColor];
    title.textAlignment = UITextAlignmentCenter;
    title.text = @"分享到新浪微博";
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
#pragma mark - Control Event
- (void) doBackBtnClicked:(id)sender
{
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UINavigationController *nav    = (UINavigationController *)app.window.rootViewController;
    [nav popToRootViewControllerAnimated:YES];
}

- (void) doShareBtnClicked:(id)sender
{
    SignalSinaWeibo *sgWeibo = [SignalSinaWeibo shareInstance:self];
    [sgWeibo.sinaWeibo requestWithURL:@"statuses/upload_url_text.json"
                               params:[NSMutableDictionary
                                       dictionaryWithObjectsAndKeys:@"Test",@"status",shareImgView.URL,@"url",nil]
                           httpMethod:@"POST"
                             delegate:self];
}

#pragma mark -
#pragma mark - SinaWeiboRequestDelegate

- (void)request:(SinaWeiboRequest *)request didReceiveResponse:(NSURLResponse *)response
{
    
}

- (void)request:(SinaWeiboRequest *)request didReceiveRawData:(NSData *)data
{
    
}

- (void)request:(SinaWeiboRequest *)request didFailWithError:(NSError *)error
{
    
}

- (void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result
{
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UINavigationController *nav    = (UINavigationController *)app.window.rootViewController;
    [nav popToRootViewControllerAnimated:YES];
    
    CLog(@"Send Message Success!");
}
@end
