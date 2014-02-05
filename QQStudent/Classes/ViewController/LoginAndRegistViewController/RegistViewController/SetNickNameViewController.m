//
//  SetNickNameViewController.m
//  QQStudent
//
//  Created by lynn on 14-2-4.
//  Copyright (c) 2014年 lynn. All rights reserved.
//

#import "SetNickNameViewController.h"

@interface SetNickNameViewController ()

@end

@implementation SetNickNameViewController

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
    
    //
    [self initUI];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewDidUnload
{
    nickNameFld.delegate = nil;
    [super viewDidUnload];
}

- (void) dealloc
{
    [nickNameFld release];
    [super dealloc];
}

#pragma mark -
#pragma mark - Custom Action
- (void) initUI
{
    self.view.frame = [UIView fitCGRect:CGRectMake(0, 0, 240, 100)
                             isBackView:NO];
    self.view.backgroundColor = [UIColor whiteColor];
    
    nickNameFld = [[UITextField alloc]init];
    nickNameFld.delegate = self;
    nickNameFld.borderStyle = UITextBorderStyleLine;
    nickNameFld.frame = CGRectMake(30, 20, 180, 20);
    [self.view addSubview:nickNameFld];
    
    UIButton *okBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    okBtn.tag = 0;
    okBtn.frame = CGRectMake(60, 60, 40, 20);
    [okBtn setTitle:@"确定"
           forState:UIControlStateNormal];
    [okBtn addTarget:self
              action:@selector(doButtonClicked:)
    forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:okBtn];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    cancelBtn.tag = 1;
    cancelBtn.frame = CGRectMake(140, 60, 40, 20);
    [cancelBtn setTitle:@"取消"
               forState:UIControlStateNormal];
    [cancelBtn addTarget:self
                  action:@selector(doButtonClicked:)
        forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancelBtn];
}

- (void) doButtonClicked:(id)sender
{
    UIButton *button  = sender;
    NSDictionary *dic = nil;
    switch (button.tag)
    {
        case 0:     //确定
        {
            dic = [NSDictionary dictionaryWithObjectsAndKeys:nickNameFld.text,
                                                           @"nickName", nil];
            break;
        }
        case 1:     //取消
        {
            break;
        }
        default:
            break;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"setNickNameNotice"
                                                        object:self
                                                      userInfo:dic];
}

#pragma mark -
#pragma mark - UITextFieldDelegate
- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return  YES;
}
@end
