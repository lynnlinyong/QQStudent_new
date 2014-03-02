//
//  OrderEditConfirmViewController.m
//  QQStudent
//
//  Created by lynn on 14-2-28.
//  Copyright (c) 2014年 lynn. All rights reserved.
//

#import "OrderEditConfirmViewController.h"

@interface OrderEditConfirmViewController ()

@end

@implementation OrderEditConfirmViewController

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
    UIImage *bgImg = [UIImage imageNamed:@"order_confirm_bg"];
    self.view.frame = CGRectMake(0, 0,
                                 bgImg.size.width,
                                 bgImg.size.height);
    
    
    UIImageView *bgImageView = [[UIImageView alloc]initWithImage:bgImg];
    bgImageView.frame = CGRectMake(0, 0,
                                   bgImg.size.width,
                                   bgImg.size.height);
    [self.view addSubview:bgImageView];
    [bgImageView release];
    
    UILabel *titleLab = [[UILabel alloc]init];
    titleLab.text = @"提示";
    titleLab.backgroundColor = [UIColor clearColor];
    titleLab.textColor = [UIColor whiteColor];
    titleLab.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleLab];
    [titleLab release];
    
    UILabel *contentLab = [[UILabel alloc]init];
    contentLab.text = @"老师已经确认了您的订单修改!";
    contentLab.numberOfLines = 0;
    contentLab.lineBreakMode = NSLineBreakByWordWrapping;
    [self.view addSubview:contentLab];
    [contentLab release];
    
    UIImage *btnImg = [UIImage imageNamed:@""];
    UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [confirmBtn setTitle:@"确定"
                forState:UIControlStateNormal];
    
    
}
@end
