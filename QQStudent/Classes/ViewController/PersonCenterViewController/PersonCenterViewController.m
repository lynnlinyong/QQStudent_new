//
//  PersonCenterViewController.m
//  QQStudent
//
//  Created by lynn on 14-1-29.
//  Copyright (c) 2014年 lynn. All rights reserved.
//

#import "PersonCenterViewController.h"

@interface PersonCenterViewController ()

@end

@implementation PersonCenterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) viewDidLoad
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
    MyTeacherViewController *mVctr = [[MyTeacherViewController alloc]initWithNibName:nil
                                                                              bundle:nil];
    
    LatlyViewController *lVctr = [[LatlyViewController alloc]initWithNibName:nil
                                                                      bundle:nil];
    
    SearchTeacherViewController *sVctr = [[SearchTeacherViewController alloc]initWithNibName:nil
                                                                                      bundle:nil];
    ShareViewController *shareVctr = [[ShareViewController alloc]initWithNibName:nil
                                                                          bundle:nil];
    
    SettingViewController *setVctr = [[SettingViewController alloc]initWithNibName:nil
                                                                            bundle:nil];
    
    NSArray *arrays = [NSArray arrayWithObjects:mVctr,lVctr,sVctr,
                                                shareVctr,setVctr, nil];
    [self setViewControllers:arrays];
}

- (void) doBackBtnClicked:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
@end
