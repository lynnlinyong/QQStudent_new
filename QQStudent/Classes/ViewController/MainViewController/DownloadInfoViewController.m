//
//  DownloadInfoViewController.m
//  QQStudent
//
//  Created by lynn on 14-2-5.
//  Copyright (c) 2014年 lynn. All rights reserved.
//

#import "DownloadInfoViewController.h"

@interface DownloadInfoViewController ()

@end

@implementation DownloadInfoViewController

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
    self.view.frame = [UIView fitCGRect:CGRectMake(0, 0, 240, 100)
                             isBackView:NO];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UILabel *infoLab = [[UILabel alloc]init];
    infoLab.text  = @"检测到有新版本,马上去更新!";
    infoLab.textAlignment = NSTextAlignmentCenter;
    infoLab.frame = CGRectMake(0, 0, 220, 20);
    infoLab.backgroundColor = [UIColor clearColor];
    [self.view addSubview:infoLab];
    [infoLab release];
    
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
    UIButton *button = sender;
    switch (button.tag)
    {
        case 0:     //确定下载新版本
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"gotoDownLoad"
                                                                object:nil];
            break;
        }
        case 1:     //取消下载新版本
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"cancelDownLoad"
                                                                object:nil];
            break;
        }
        default:
            break;
    }
}
@end
