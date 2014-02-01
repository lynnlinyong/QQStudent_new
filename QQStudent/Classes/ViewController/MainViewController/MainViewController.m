//
//  MainViewController.m
//  QQStudent
//
//  Created by lynn on 14-1-28.
//  Copyright (c) 2014年 lynn. All rights reserved.
//

#import "MainViewController.h"
#import "ViewControllerHeader.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIButton *gotoBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [gotoBtn setTitle:@"跳转"
             forState:UIControlStateNormal];
    gotoBtn.frame = CGRectMake(110, 100, 100, 40);
    [gotoBtn addTarget:self
                action:@selector(doGotoBtnClicked:)
      forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *searchTeacherBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [searchTeacherBtn setTitle:@"我要找家教"
                      forState:UIControlStateNormal];
    searchTeacherBtn.frame = CGRectMake(110, 160, 100, 40);
    [searchTeacherBtn addTarget:self
                         action:@selector(doSearchBtnClicked:)
               forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:gotoBtn];
    [self.view addSubview:searchTeacherBtn];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark - Custom Action
- (void) doGotoBtnClicked:(id)sender
{
    LoginViewController *loginVctr = [[LoginViewController alloc]init];
    [self.navigationController pushViewController:loginVctr animated:YES];
    [loginVctr release];
}

- (void) doSearchBtnClicked:(id)sender
{
    SearchConditionViewController *scVctr = [[SearchConditionViewController alloc]init];
    [self.navigationController pushViewController:scVctr animated:YES];
    [scVctr release];
}
@end
