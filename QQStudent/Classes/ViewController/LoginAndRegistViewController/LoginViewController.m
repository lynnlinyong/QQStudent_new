//
//  LoginViewController.m
//  QQStudent
//
//  Created by lynn on 14-1-28.
//  Copyright (c) 2014年 lynn. All rights reserved.
//

#import "LoginViewController.h"
#import "ViewControllerHeader.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

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
    
    [self initView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewDidUnload
{
    phoneFld = nil;
    phoneFld.delegate = nil;
    
    userNameFld = nil;
    userNameFld.delegate = nil;
    [super viewDidUnload];
}

- (void) dealloc
{
    [phoneFld release];
    [userNameFld release];
    
    [super dealloc];
}

#pragma mark -
#pragma mark - Custom Action
- (void) initView
{
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [backBtn setTitle:@"返回" forState:UIControlStateNormal];
    backBtn.frame = CGRectMake(0, 0, 100, 40);
    [backBtn addTarget:self
                action:@selector(doBackBtnClicked:)
      forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    
    UIButton *registBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [registBtn setTitle:@"注册" forState:UIControlStateNormal];
    registBtn.frame = CGRectMake(320-100, 0, 100, 40);
    [registBtn addTarget:self
                  action:@selector(doRegistBtnClicked:)
        forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registBtn];
    
    userNameFld = [[UITextField alloc]init];
    userNameFld.delegate = self;
    userNameFld.borderStyle = UITextBorderStyleLine;
    userNameFld.placeholder = @"输入注册邮箱";
    userNameFld.frame = [UIView fitCGRect:CGRectMake(60, 110, 200, 30)
                               isBackView:NO];
    [self.view addSubview:userNameFld];
    
    phoneFld = [[UITextField alloc]init];
    phoneFld.delegate = self;
    phoneFld.borderStyle = UITextBorderStyleLine;
    phoneFld.placeholder = @"输入手机号码";
    phoneFld.frame = [UIView fitCGRect:CGRectMake(60, 150, 200, 30)
                          isBackView:NO];
    [self.view addSubview:phoneFld];
    
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [loginBtn setTitle:@"登录"
              forState:UIControlStateNormal];
    loginBtn.frame = [UIView fitCGRect:CGRectMake(110, 240, 100, 40)
                            isBackView:NO];
    [loginBtn addTarget:self
                 action:@selector(doLoginBtnClicked:)
       forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginBtn];
    
    UIButton *hpBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [hpBtn setTitle:@"帮助" forState:UIControlStateNormal];
    hpBtn.frame = [UIView fitCGRect:CGRectMake(110, 300, 100, 40)
                         isBackView:NO];
    [hpBtn addTarget:self
              action:@selector(doHpBtnClicked:)
    forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:hpBtn];
    
}

- (void) doBackBtnClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) doRegistBtnClicked:(id)sender
{
    RegistViewController *rVctr = [[RegistViewController alloc]init];
    [self.navigationController pushViewController:rVctr animated:YES];
    [rVctr release];
}

- (void) doLoginBtnClicked:(id)sender
{
    PersonCenterViewController *pcVctr = [[PersonCenterViewController alloc]init];
    [self.navigationController pushViewController:pcVctr
                                         animated:YES];
    [pcVctr release];
}

- (void) doHpBtnClicked:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://4008005430"]];
}

#pragma mark -
#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}
@end
