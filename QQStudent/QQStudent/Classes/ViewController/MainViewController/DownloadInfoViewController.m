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
    UIImage *titleImg         = [UIImage imageNamed:@"dialog_title"];
    self.view.frame = [UIView fitCGRect:CGRectMake(0, 0,
                                                   titleImg.size.width,
                                                   150)
                             isBackView:NO];
    self.view.backgroundColor = [UIColor whiteColor];
    
    LBorderView *groupView = [[LBorderView alloc]initWithFrame:CGRectMake(-10, -5,
                                                                          self.view.frame.size.width+20,
                                                                          self.view.frame.size.height+10)];
    groupView.borderType   = BorderTypeSolid;
    groupView.dashPattern  = 8;
    groupView.spacePattern = 8;
    groupView.borderWidth  = 1;
    groupView.cornerRadius = 5;
    groupView.borderColor  = [UIColor whiteColor];
    groupView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:groupView];

    UIImageView *titleImgView = [[UIImageView alloc]init];
    titleImgView.frame = [UIView fitCGRect:CGRectMake(-2.5, -2,
                                                      groupView.frame.size.width+5, titleImg.size.height)
                                isBackView:NO];
    titleImgView.image = titleImg;
    [groupView addSubview:titleImgView];
    [titleImgView release];
    
    UILabel *titleLab = [[UILabel alloc]init];
    titleLab.text     = @"升级提示";
    titleLab.textColor= [UIColor whiteColor];
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.frame= [UIView fitCGRect:CGRectMake(-2.5, -2,
                                                 groupView.frame.size.width+5, titleImg.size.height)
                           isBackView:NO];
    titleLab.backgroundColor = [UIColor clearColor];
    [groupView addSubview:titleLab];
    [titleLab release];
    
    UILabel *infoLab = [[UILabel alloc]init];
    infoLab.text     = @"轻轻家教有更新,便于您使用体验,请升级";
    infoLab.font     = [UIFont systemFontOfSize:13.f];
    infoLab.textColor= [UIColor colorWithHexString:@"#ff6600"];
    infoLab.textAlignment = NSTextAlignmentCenter;
    infoLab.frame = [UIView fitCGRect:CGRectMake(0,
                                                 self.view.frame.size.height/2-20,
                                                 self.view.frame.size.width, 20)
                           isBackView:NO];
    infoLab.backgroundColor = [UIColor clearColor];
    [self.view addSubview:infoLab];
    [infoLab release];
    
    UIImage *bottomImg= [UIImage imageNamed:@"dialog_bottom"];
    UIImageView *bottomImgView = [[UIImageView alloc]init];
    bottomImgView.image = bottomImg;
    bottomImgView.frame = [UIView fitCGRect:CGRectMake(-11,
                                                       self.view.frame.size.height-bottomImg.size.height+5,
                                                       self.view.frame.size.width+23, bottomImg.size.height)
                                 isBackView:NO];
    [self.view addSubview:bottomImgView];
    [bottomImgView release];
    
    UIImage *okBtnImg = [UIImage imageNamed:@"dialog_ok_normal_btn"];
    UIButton *okBtn   = [UIButton buttonWithType:UIButtonTypeCustom];
    okBtn.tag   = 0;
    [okBtn setTitleColor:[UIColor blackColor]
                forState:UIControlStateNormal];
    okBtn.titleLabel.font = [UIFont systemFontOfSize:13.f];
    okBtn.frame = CGRectMake(self.view.frame.size.width/2-okBtnImg.size.width-10,
                             self.view.frame.size.height-okBtnImg.size.height-3,
                             okBtnImg.size.width,
                             okBtnImg.size.height);
    [okBtn setTitle:@"确定"
           forState:UIControlStateNormal];
    [okBtn setBackgroundImage:[UIImage imageNamed:@"dialog_ok_normal_btn"]
                     forState:UIControlStateNormal];
    [okBtn setBackgroundImage:[UIImage imageNamed:@"dialog_ok_hlight_btn"]
                     forState:UIControlStateHighlighted];
    [okBtn addTarget:self
              action:@selector(doButtonClicked:)
    forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:okBtn];
    
    UIImage *cancelImg  = [UIImage imageNamed:@"dialog_cancel_normal_btn"];
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.tag = 1;
    [cancelBtn setTitleColor:[UIColor blackColor]
                    forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:13.f];
    cancelBtn.frame = CGRectMake(self.view.frame.size.width/2+10,
                                 self.view.frame.size.height-cancelImg.size.height-3,
                                 cancelImg.size.width,
                                 cancelImg.size.height);
    [cancelBtn setTitle:@"取消"
               forState:UIControlStateNormal];
    [cancelBtn setBackgroundImage:[UIImage imageNamed:@"dialog_cancel_normal_btn"]
                         forState:UIControlStateNormal];
    [cancelBtn setBackgroundImage:[UIImage imageNamed:@"dialog_cancel_hlight_btn"]
                         forState:UIControlStateHighlighted];
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
