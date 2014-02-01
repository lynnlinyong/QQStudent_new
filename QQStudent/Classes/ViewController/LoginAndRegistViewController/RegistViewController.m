//
//  RegistViewController.m
//  QQStudent
//
//  Created by lynn on 14-1-28.
//  Copyright (c) 2014年 lynn. All rights reserved.
//

#import "RegistViewController.h"

@interface RegistViewController ()

@end

@implementation RegistViewController

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

- (void) viewDidUnload
{
    userNameFld.delegate = nil;
    userNameFld = nil;
    
    phoneFld.delegate = nil;
    phoneFld = nil;
    
    [super viewDidUnload];
}

- (void) dealloc
{
    [phoneFld release];
    [userNameFld release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    UIButton *registBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [registBtn setTitle:@"注册" forState:UIControlStateNormal];
    registBtn.frame = CGRectMake(110, 220, 100, 40);
    [registBtn addTarget:self
                  action:@selector(doRegistBtnClicked:)
        forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registBtn];
}

- (void) doBackBtnClicked:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void) doRegistBtnClicked:(id)sender
{
    
}

#pragma mark -
#pragma mark - UITextFieldDelegate
- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
@end
