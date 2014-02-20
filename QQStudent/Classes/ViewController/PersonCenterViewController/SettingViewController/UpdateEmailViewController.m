//
//  UpdateEmailViewController.m
//  QQStudent
//
//  Created by lynn on 14-2-16.
//  Copyright (c) 2014年 lynn. All rights reserved.
//

#import "UpdateEmailViewController.h"

@interface UpdateEmailViewController ()

@end

@implementation UpdateEmailViewController

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

- (void) dealloc
{
    [txtFld release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark -  Custom Action
- (void) initUI
{
    self.view.frame = [UIView fitCGRect:CGRectMake(0, 0, 240, 120)
                             isBackView:NO];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UILabel *titleLab = [[UILabel alloc]init];
    titleLab.text = @"邮箱";
    titleLab.textAlignment   = NSTextAlignmentCenter;
    titleLab.backgroundColor = [UIColor clearColor];
    titleLab.frame = CGRectMake(20, 0, 200, 20);
    [self.view addSubview:titleLab];
    [titleLab release];
    
    UILabel *contentLab = [[UILabel alloc]init];
    contentLab.text = @"邮箱";
    contentLab.backgroundColor = [UIColor clearColor];
    contentLab.frame = CGRectMake(20, 20, 200, 20);
    contentLab.numberOfLines = 0;
    contentLab.lineBreakMode = NSLineBreakByWordWrapping;
    [self.view addSubview:contentLab];
    [contentLab release];
    
    txtFld = [[UITextField alloc]init];
    txtFld.delegate    = self;
    txtFld.borderStyle = UITextBorderStyleLine;
    txtFld.frame       = CGRectMake(20, 50, 200, 20);
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

- (void) doButtonClicked:(id)sender
{
    UIButton *btn      = sender;
    NSNumber *tagNum   = [NSNumber numberWithInt:btn.tag];
    NSDictionary *pDic = [NSDictionary dictionaryWithObjectsAndKeys:tagNum,@"TAG", txtFld.text,@"CONTENT",nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateEmailNotice"
                                                        object:nil
                                                      userInfo:pDic];
}

#pragma mark -
#pragma mark - UITextFieldDelegate
- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
@end
