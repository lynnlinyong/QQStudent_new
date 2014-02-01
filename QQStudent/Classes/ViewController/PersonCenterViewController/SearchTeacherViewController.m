//
//  SearchTeacherViewController.m
//  QQStudent
//
//  Created by lynn on 14-1-29.
//  Copyright (c) 2014年 lynn. All rights reserved.
//

#import "SearchTeacherViewController.h"

@interface SearchTeacherViewController ()

@end

@implementation SearchTeacherViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.tabBarItem.title = @"搜索";
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
    searchFld = nil;
    searchFld.delegate = nil;
    
    searchLab = nil;
    [super viewDidUnload];
}

- (void) dealloc
{
    [searchLab release];
    [searchFld release];
    [super dealloc];
}

#pragma mark -
#pragma mark - Custom Action
- (void) initView
{
    searchLab = [[UILabel alloc]init];
    searchLab.text  = @"搜索:";
    searchLab.frame = [UIView fitCGRect:CGRectMake(0, 385, 40, 20)
                             isBackView:NO];
    [self.view addSubview:searchLab];
    
    searchFld = [[UITextField alloc]init];
    searchFld.delegate = self;
    searchFld.font = [UIFont systemFontOfSize:12];
    searchFld.placeholder = @"输入手机号/前14位身份证号/9位搜索码";
    searchFld.borderStyle = UITextBorderStyleLine;
    searchFld.frame = [UIView fitCGRect:CGRectMake(40, 385, 240, 20)
                             isBackView:NO];
    [self.view addSubview:searchFld];
    
    UIButton *okBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [okBtn setTitle:@"确定"
           forState:UIControlStateNormal];
    okBtn.frame = [UIView fitCGRect:CGRectMake(280, 385, 40, 30)
                         isBackView:NO];
    [okBtn addTarget:self
              action:@selector(doOkBtnClicked:)
    forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:okBtn];
}

- (void) doOkBtnClicked:(id)sender
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
