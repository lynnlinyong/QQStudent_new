//
//  TeacherDetailViewController.m
//  QQStudent
//
//  Created by lynn on 14-1-31.
//  Copyright (c) 2014年 lynn. All rights reserved.
//

#import "TeacherDetailViewController.h"

@interface TeacherDetailViewController ()

@end

@implementation TeacherDetailViewController

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

#pragma mark -
#pragma mark - Custom Action
- (void) initView
{
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [backBtn setTitle:@"返回" forState:UIControlStateNormal];
    backBtn.frame = [UIView fitCGRect:CGRectMake(0, 0, 60, 30)
                           isBackView:NO];
    [backBtn addTarget:self
                action:@selector(doBackBtnClicked:)
      forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
}

- (void) doBackBtnClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
