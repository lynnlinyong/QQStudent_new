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
    
    //初始化UI
    [self initUI];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

#pragma mark -
#pragma mark - Custom Action
- (void) initUI
{    
    MyTeacherViewController *mVctr = [[MyTeacherViewController alloc]initWithNibName:nil
                                                                              bundle:nil];
    UINavigationController *navMvctr = [[UINavigationController alloc]initWithRootViewController:mVctr];
    
    
    
    LatlyViewController *lVctr = [[LatlyViewController alloc]initWithNibName:nil
                                                                      bundle:nil];
    UINavigationController *navLVctr = [[UINavigationController alloc]initWithRootViewController:lVctr];
    
    SearchTeacherViewController *sVctr = [[SearchTeacherViewController alloc]initWithNibName:nil
                                                                                      bundle:nil];
    UINavigationController *navSVctr = [[UINavigationController alloc]initWithRootViewController:sVctr];
    
    ShareViewController *shareVctr = [[ShareViewController alloc]initWithNibName:nil
                                                                          bundle:nil];
    UINavigationController *navShareVctr = [[UINavigationController alloc]initWithRootViewController:shareVctr];
    
    SettingViewController *setVctr = [[SettingViewController alloc]initWithNibName:nil
                                                                            bundle:nil];
    UINavigationController *navSetVctr = [[UINavigationController alloc]initWithRootViewController:setVctr];
    [mVctr     release];
	[lVctr     release];
	[sVctr     release];
	[shareVctr release];
    [setVctr   release];
    
    NSMutableDictionary *imgDic = [NSMutableDictionary dictionaryWithCapacity:3];
	[imgDic setObject:[UIImage imageNamed:@"s_1_1"]
               forKey:@"Default"];
	[imgDic setObject:[UIImage imageNamed:@"s_1_2"]
               forKey:@"Highlighted"];
	[imgDic setObject:[UIImage imageNamed:@"s_1_2"]
               forKey:@"Seleted"];
	NSMutableDictionary *imgDic2 = [NSMutableDictionary dictionaryWithCapacity:3];
	[imgDic2 setObject:[UIImage imageNamed:@"s_2_1"]
                forKey:@"Default"];
	[imgDic2 setObject:[UIImage imageNamed:@"s_2_2"]
                forKey:@"Highlighted"];
	[imgDic2 setObject:[UIImage imageNamed:@"s_2_2"]
                forKey:@"Seleted"];
	NSMutableDictionary *imgDic3 = [NSMutableDictionary dictionaryWithCapacity:3];
	[imgDic3 setObject:[UIImage imageNamed:@"s_3_1"]
                forKey:@"Default"];
	[imgDic3 setObject:[UIImage imageNamed:@"s_3_2"]
                forKey:@"Highlighted"];
	[imgDic3 setObject:[UIImage imageNamed:@"s_3_2"]
                forKey:@"Seleted"];
	NSMutableDictionary *imgDic4 = [NSMutableDictionary dictionaryWithCapacity:3];
	[imgDic4 setObject:[UIImage imageNamed:@"s_4_1"]
                forKey:@"Default"];
	[imgDic4 setObject:[UIImage imageNamed:@"s_4_2"]
                forKey:@"Highlighted"];
	[imgDic4 setObject:[UIImage imageNamed:@"s_4_2"]
                forKey:@"Seleted"];
	NSMutableDictionary *imgDic5 = [NSMutableDictionary dictionaryWithCapacity:3];
	[imgDic5 setObject:[UIImage imageNamed:@"s_5_1"]
                forKey:@"Default"];
	[imgDic5 setObject:[UIImage imageNamed:@"s_5_2"]
                forKey:@"Highlighted"];
	[imgDic5 setObject:[UIImage imageNamed:@"s_5_2"]
                forKey:@"Seleted"];
	NSArray *ctrlArr = [NSArray arrayWithObjects:navMvctr,navLVctr,navSVctr,navShareVctr,navSetVctr,nil];

	NSArray *imgArr = [NSArray arrayWithObjects:imgDic,imgDic3,imgDic2,
                                                imgDic4,imgDic5,nil];
	
	LeveyTabBarController *leveyTabBarController = [[LeveyTabBarController alloc] initWithViewControllers:ctrlArr
                                                                                               imageArray:imgArr];
	[leveyTabBarController.tabBar setBackgroundImage:[UIImage imageNamed:@"c-2-1.png"]];
	[leveyTabBarController setTabBarTransparent:YES];
    
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    app.window.rootViewController = leveyTabBarController;
}

- (void) doBackBtnClicked:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
@end
