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
    
    [self initBackBarItem];
    
    //初始化UI
    [self initUI];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [MainViewController setNavTitle:@"分享到新浪微博"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    shareImgView.frame = [UIView fitCGRect:CGRectMake(20, 20, 50, 50)
                                isBackView:NO];
    [self.view addSubview:shareImgView];
    
    shareContentFld = [[UITextView alloc]init];
    shareContentFld.font        = [UIFont systemFontOfSize:12.f];
//    shareContentFld.delegate    = self;
//    shareContentFld.borderStyle = UITextBorderStyleLine;
    shareContentFld.frame = [UIView fitCGRect:CGRectMake(70, 20, 230, 80)
                                   isBackView:NO];
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
#pragma mark - Control Event
- (void) doShareBtnClicked:(id)sender
{
    NSData *dataObj = UIImageJPEGRepresentation(shareImgView.image, 1.0);
    SignalSinaWeibo *sgWeibo = [SignalSinaWeibo shareInstance:self];
    [sgWeibo.sinaWeibo requestWithURL:@"statuses/upload.json"
                               params:[NSMutableDictionary
                                       dictionaryWithObjectsAndKeys:shareContentFld.text,@"status",dataObj,@"pic",nil]
                           httpMethod:@"POST"
                             delegate:self];
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

#pragma mark -
#pragma mark - SinaWeiboRequestDelegate

- (void)request:(SinaWeiboRequest *)request didReceiveResponse:(NSURLResponse *)response
{
    
}

- (void)request:(SinaWeiboRequest *)request didReceiveRawData:(NSData *)data
{
    NSString *resStr = [NSString stringWithCString:[data bytes] encoding:NSUTF8StringEncoding];
    CLog(@"resStr:%@", resStr);
}

- (void)request:(SinaWeiboRequest *)request didFailWithError:(NSError *)error
{
    
}

- (void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result
{
    CustomNavigationViewController *nav    = (CustomNavigationViewController *)[MainViewController getNavigationViewController];
    [nav popToRootViewControllerAnimated:YES];
    
    CLog(@"Send Message Success!");
}
@end
