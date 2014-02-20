//
//  ShareViewController.m
//  QQStudent
//
//  Created by lynn on 14-1-29.
//  Copyright (c) 2014年 lynn. All rights reserved.
//

#import "ShareViewController.h"

@interface ShareViewController ()

@end

@implementation ShareViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.tabBarItem.title = @"分享";
        self.tabBarItem.image = [UIImage imageNamed:@"user_3_1"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initUI];
}

- (void) viewDidAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(getDismissView:)
                                                 name:@"dismissView"
                                               object:nil];
    [super viewDidAppear:animated];
}

- (void) viewDidUnload
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
    UIButton *shareFrdBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [shareFrdBtn setTitle:@"分享通讯录"
                 forState:UIControlStateNormal];
    shareFrdBtn.frame = [UIView fitCGRect:CGRectMake(85, 80, 150, 30)
                               isBackView:NO];
    [shareFrdBtn addTarget:self
                    action:@selector(doShareFrdBtnClicked:)
          forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:shareFrdBtn];
    
    UIButton *shareWicoBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [shareWicoBtn setTitle:@"分享到微信"
                  forState:UIControlStateNormal];
    shareWicoBtn.frame = [UIView fitCGRect:CGRectMake(85, 120, 150, 30)
                                isBackView:NO];
    [shareWicoBtn addTarget:self
                     action:@selector(doShareWicoBtnClicked:)
           forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:shareWicoBtn];
    
    UIButton *shareSinaBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [shareSinaBtn setTitle:@"分享到新浪微博"
                  forState:UIControlStateNormal];
    shareSinaBtn.frame = [UIView fitCGRect:CGRectMake(85, 160, 150, 30)
                                isBackView:NO];
    [shareSinaBtn addTarget:self
                     action:@selector(doShareSinaBtnClicked:)
           forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:shareSinaBtn];
    
    UIButton *shareTecentBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [shareTecentBtn setTitle:@"分享到腾讯微博"
                    forState:UIControlStateNormal];
    shareTecentBtn.frame = [UIView fitCGRect:CGRectMake(85, 200, 150, 30)
                                  isBackView:NO];
    [shareTecentBtn addTarget:self
                       action:@selector(doShareTecentBtnClicked:)
             forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:shareTecentBtn];
}

- (void) doShareFrdBtnClicked:(id)sender
{
    ShareAddressBookViewController *shareBook = [[ShareAddressBookViewController alloc]init];
    [self.navigationController pushViewController:shareBook
                                         animated:YES];
    [shareBook release];
}

- (void) doShareWicoBtnClicked:(id)sender
{
    //检测是否安装微信,没有安装,提示安装
    if (![WXApi isWXAppInstalled])
    {
        CLog(@"NO Installed");
        [self showAlertWithTitle:@"提示"
                             tag:0
                         message:@"您尚未安装微信,马上去安装它!"
                        delegate:self
               otherButtonTitles:@"马上去",@"取消",nil];
    }
    else
    {
        CLog(@"YES Installed");
        ShareWeixinViewController *swVctr = [[ShareWeixinViewController alloc]init];
        [self presentPopupViewController:swVctr
                           animationType:MJPopupViewAnimationFade];
    }
}

- (void) doShareSinaBtnClicked:(id)sender
{
    SignalSinaWeibo *sgWeibo = [SignalSinaWeibo shareInstance:self];
    if (![sgWeibo.sinaWeibo isAuthValid])
    {
        BoundSinaViewController *bsVctr = [[BoundSinaViewController alloc]init];
        [self.navigationController pushViewController:bsVctr
                                             animated:YES];
        [bsVctr release];
    }
    else
    {
        ShareSinaViewController *sVctr = [[ShareSinaViewController alloc]init];
        [self.navigationController pushViewController:sVctr
                                             animated:YES];
        [sVctr release];
    }
}

- (void) doShareTecentBtnClicked:(id)sender
{
    SingleTCWeibo *tcWeibo = [SingleTCWeibo shareInstance];
    if (![tcWeibo.tcWeiboApi isAuthValid])
    {
        BoundTecentViewController *btVctr = [[BoundTecentViewController alloc]init];
        [self.navigationController pushViewController:btVctr
                                             animated:YES];
        [btVctr release];
    }
    else
    {
        ShareTecentViewController *stVctr = [[ShareTecentViewController alloc]init];
        [self.navigationController pushViewController:stVctr
                                             animated:YES];
        [stVctr release];
    }
}

#pragma mark -
#pragma mark - UIAlertViewDelegate
- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex)
    {
        case 0:    //马上去
        {
            NSString *url = [WXApi getWXAppInstallUrl];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
            break;
        }
        case 1:    //取消
        {
            break;
        }
        default:
            break;
    }
}

#pragma mark - 
#pragma mark - Notice
- (void) getDismissView:(NSNotification *) notice
{
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
}
@end
