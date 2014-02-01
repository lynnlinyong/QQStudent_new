//
//  ShareViewController.m
//  QQStudent
//
//  Created by lynn on 14-1-29.
//  Copyright (c) 2014年 lynn. All rights reserved.
//

#import "ShareViewController.h"

@interface ShareViewController ()

@end

@implementation ShareViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.tabBarItem.title = @"分享";
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
    UIButton *shareFrdBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [shareFrdBtn setTitle:@"分享通讯录"
                 forState:UIControlStateNormal];
    shareFrdBtn.frame = [UIView fitCGRect:CGRectMake(85, 80, 150, 30)
                               isBackView:NO];
    [shareFrdBtn addTarget:self
                    action:@selector(doShareFrdBtnClicked:)
          forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:shareFrdBtn];
    
    UIButton *shareWicoBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [shareWicoBtn setTitle:@"分享到微信"
                  forState:UIControlStateNormal];
    shareWicoBtn.frame = [UIView fitCGRect:CGRectMake(85, 120, 150, 30)
                                isBackView:NO];
    [shareWicoBtn addTarget:self
                     action:@selector(doShareWicoBtnClicked:)
           forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:shareWicoBtn];
    
    UIButton *shareSinaBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [shareSinaBtn setTitle:@"分享到新浪微博"
                  forState:UIControlStateNormal];
    shareSinaBtn.frame = [UIView fitCGRect:CGRectMake(85, 160, 150, 30)
                                isBackView:NO];
    [shareSinaBtn addTarget:self
                     action:@selector(doShareSinaBtnClicked:)
           forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:shareSinaBtn];
    
    UIButton *shareTecentBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [shareTecentBtn setTitle:@"分享到腾讯微博"
                    forState:UIControlStateNormal];
    shareTecentBtn.frame = [UIView fitCGRect:CGRectMake(85, 200, 150, 30)
                                  isBackView:NO];
    [shareTecentBtn addTarget:self
                       action:@selector(doShareTecentBtnClicked:)
             forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:shareTecentBtn];
}

- (void) doShareFrdBtnClicked:(id)sender
{
    
}

- (void) doShareWicoBtnClicked:(id)sender
{
    
}

- (void) doShareSinaBtnClicked:(id)sender
{
    
}

- (void) doShareTecentBtnClicked:(id)sender
{
    
}

@end
