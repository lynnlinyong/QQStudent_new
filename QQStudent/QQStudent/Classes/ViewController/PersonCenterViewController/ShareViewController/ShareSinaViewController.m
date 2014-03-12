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

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [MainViewController setNavTitle:@"分享到新浪微博"];
    
    
}

- (void) viewDidUnload
{

    [super viewDidUnload];
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
