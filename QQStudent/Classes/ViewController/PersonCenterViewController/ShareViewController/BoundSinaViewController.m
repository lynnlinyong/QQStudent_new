//
//  BoundSinaViewController.m
//  QQStudent
//
//  Created by lynn on 14-2-17.
//  Copyright (c) 2014年 lynn. All rights reserved.
//

#import "BoundSinaViewController.h"

@interface BoundSinaViewController ()

@end

@implementation BoundSinaViewController

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

#pragma mark -
#pragma mark - Custom Action
- (void) initUI
{
    UILabel *infoLab = [[UILabel alloc]init];
    infoLab.text = @"绑定Sina微博,分享更多人!";
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

- (void) doButtonClicked:(id)sender
{
    SignalSinaWeibo *sgWb = [SignalSinaWeibo shareInstance:self];
    [sgWb.sinaWeibo logIn];
}

- (void)sinaweiboDidLogIn:(SinaWeibo *)sinaweibo
{
    CLog(@"Login Success!");
    ShareSinaViewController *ssVctr = [[ShareSinaViewController alloc]init];
    [self.navigationController pushViewController:ssVctr
                                         animated:YES];
    [ssVctr release];
}

- (void)sinaweiboDidLogOut:(SinaWeibo *)sinaweibo
{
    
}

- (void)sinaweiboLogInDidCancel:(SinaWeibo *)sinaweibo
{
    CLog(@"Login Failed!");
}

- (void)sinaweibo:(SinaWeibo *)sinaweibo logInDidFailWithError:(NSError *)error
{
    
}

- (void)sinaweibo:(SinaWeibo *)sinaweibo accessTokenInvalidOrExpired:(NSError *)error
{
    
}

@end
