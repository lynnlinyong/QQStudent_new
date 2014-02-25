//
//  UpdatePhoneViewController.m
//  QQStudent
//
//  Created by lynn on 14-2-16.
//  Copyright (c) 2014年 lynn. All rights reserved.
//

#import "UpdatePhoneViewController.h"

@interface UpdatePhoneViewController ()

@end

@implementation UpdatePhoneViewController
@synthesize phone;

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

- (void) dealloc
{
    [txtFld release];
    [super dealloc];
}

#pragma mark - 
#pragma mark - Custom Action
- (void) initUI
{
    self.view.frame = [UIView fitCGRect:CGRectMake(0, 0, 240, 120)
                             isBackView:NO];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UILabel *titleLab = [[UILabel alloc]init];
    titleLab.text = @"手机号码";
    titleLab.textAlignment   = NSTextAlignmentCenter;
    titleLab.backgroundColor = [UIColor clearColor];
    titleLab.frame = CGRectMake(20, 0, 200, 20);
    [self.view addSubview:titleLab];
    [titleLab release];
    
    UILabel *contentLab = [[UILabel alloc]init];
    contentLab.text = @"手机号码";
    contentLab.backgroundColor = [UIColor clearColor];
    contentLab.frame = CGRectMake(20, 20, 200, 20);
    contentLab.numberOfLines = 0;
    contentLab.lineBreakMode = NSLineBreakByWordWrapping;
    [self.view addSubview:contentLab];
    [contentLab release];
    
    txtFld = [[UITextField alloc]init];
    txtFld.text = phone;
    txtFld.delegate = self;
    txtFld.borderStyle = UITextBorderStyleLine;
    txtFld.frame    = CGRectMake(20, 50, 200, 20);
    [self.view addSubview:txtFld];
    
    UIButton *okBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    okBtn.tag = 0;
    [okBtn setTitle:@"确定"
           forState:UIControlStateNormal];
    okBtn.frame = CGRectMake(70, 120-25, 40, 20);
    [okBtn addTarget:self
              action:@selector(doButtonClicked:)
    forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:okBtn];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    cancelBtn.tag = 1;
    [cancelBtn setTitle:@"取消"
               forState:UIControlStateNormal];
    cancelBtn.frame = CGRectMake(130, 120-25, 40, 20);
    [cancelBtn addTarget:self
                  action:@selector(doButtonClicked:)
        forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancelBtn];
}

#pragma mark -
#pragma mark - Control Event
- (void) doButtonClicked:(id)sender
{
    //检查格式
    if (![self checkInfo])
    {
        return;
    }
    
    UIButton *btn      = sender;
    NSNumber *tagNum   = [NSNumber numberWithInt:btn.tag];
    NSDictionary *pDic = [NSDictionary dictionaryWithObjectsAndKeys:tagNum,@"TAG", txtFld.text,@"CONTENT",nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"updatePhoneNotice"
                                                        object:nil
                                                      userInfo:pDic];
}

- (BOOL) checkInfo
{
    if (txtFld.text.length == 0)
    {
        [self showAlertWithTitle:@"提示"
                             tag:1
                         message:@"登录信息不完整!"
                        delegate:self
               otherButtonTitles:@"确定", nil];
        
        return NO;
    }
    
    BOOL isPhone = [txtFld.text isMatchedByRegex:@"^(13[0-9]|15[0-9]|18[0-9])\\d{8}$"];
    if (!isPhone)
    {
        [self showAlertWithTitle:@"提示"
                             tag:1
                         message:@"手机号格式不正确"
                        delegate:self
               otherButtonTitles:@"确定",nil];
        return NO;
    }
    
    return YES;
}

#pragma mark -
#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
@end
