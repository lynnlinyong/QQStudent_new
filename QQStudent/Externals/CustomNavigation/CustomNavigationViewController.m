//
//  CustomNavigationViewController.m
//  QQStudent
//
//  Created by lynn on 14-2-26.
//  Copyright (c) 2014年 lynn. All rights reserved.
//

#import "CustomNavigationViewController.h"

@interface CustomNavigationViewController ()

@end

@implementation CustomNavigationViewController
@synthesize dataSource;

-(void)doBackBtnClicked:(id)sender
{
    [self popViewControllerAnimated:YES];
}

-(UIBarButtonItem*) createBackButton
{
    if (dataSource)
    {
        if ([dataSource respondsToSelector:@selector(backBarButtomItem)])
        {
            return [dataSource backBarButtomItem];
        }
    }
    
    //设置返回按钮
    UIImage *backImg  = [UIImage imageNamed:@"nav_back_normal_btn@2x"];
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame     = CGRectMake(0, 0,
                                   50,
                                   30);
    [backBtn setBackgroundImage:backImg
                       forState:UIControlStateNormal];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"nav_back_hlight_btn@2x"]
                       forState:UIControlStateHighlighted];
    [backBtn addTarget:self
                action:@selector(doBackBtnClicked:)
      forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *titleLab = [[UILabel alloc]init];
    titleLab.text     = @"返回";
    titleLab.textColor= [UIColor whiteColor];
    titleLab.font     = [UIFont systemFontOfSize:12.f];
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.frame = CGRectMake(8, 0,
                                50,
                                30);
    titleLab.backgroundColor = [UIColor clearColor];
    [backBtn addSubview:titleLab];
    [titleLab release];

    return [[UIBarButtonItem alloc]
            initWithCustomView:backBtn];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated

{
    [super pushViewController:viewController animated:animated];

    if (viewController.navigationItem.leftBarButtonItem == nil && [self.viewControllers count] > 1) { 
 
        viewController.navigationItem.leftBarButtonItem = [self createBackButton];
    } 

} 


@end
