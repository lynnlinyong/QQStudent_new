//
//  NoticeWallViewController.m
//  QQStudent
//
//  Created by lynn on 14-3-4.
//  Copyright (c) 2014年 lynn. All rights reserved.
//

#import "NoticeWallViewController.h"

@interface NoticeWallViewController ()

@end

@implementation NoticeWallViewController
@synthesize title;
@synthesize content;

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
    UIImage *bottomImg= [UIImage imageNamed:@"dialog_bottom"];
    UIImage *titleImg         = [UIImage imageNamed:@"dialog_title"];
    self.view.frame = CGRectMake(0, 0,
                                 titleImg.size.width,90+bottomImg.size.height);
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    UIImageView *titleImgView = [[UIImageView alloc]init];
    titleImgView.frame = CGRectMake(-2, -titleImg.size.height,
                                    self.view.frame.size.width+5,
                                    titleImg.size.height);
    titleImgView.image = titleImg;
    [self.view addSubview:titleImgView];
    [titleImgView release];
    
    UILabel *titleLab = [[UILabel alloc]init];
    titleLab.text     = title;
    titleLab.textColor= [UIColor whiteColor];
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.frame= [UIView fitCGRect:CGRectMake(0, -titleImg.size.height+1,
                                                 self.view.frame.size.width+5, titleImg.size.height)
                           isBackView:NO];
    titleLab.backgroundColor = [UIColor clearColor];
    [self.view addSubview:titleLab];
    [titleLab release];
    
    UILabel *infoLab = [[UILabel alloc]init];
    infoLab.text     = content;
    infoLab.font     = [UIFont systemFontOfSize:13.f];
    infoLab.textColor= [UIColor colorWithHexString:@"#ff6600"];
    infoLab.textAlignment = NSTextAlignmentCenter;
    infoLab.numberOfLines = 0;
    infoLab.lineBreakMode = NSLineBreakByWordWrapping;
    infoLab.frame = [UIView fitCGRect:CGRectMake(0,
                                                 (self.view.frame.size.height-bottomImg.size.height)/2-30,
                                                 self.view.frame.size.width, 60)
                           isBackView:NO];
    infoLab.backgroundColor = [UIColor clearColor];
    [self.view addSubview:infoLab];
    [infoLab release];
    
    
    UIImageView *bottomImgView = [[UIImageView alloc]init];
    bottomImgView.image = bottomImg;
    bottomImgView.frame = CGRectMake(-2,
                                     self.view.frame.size.height-bottomImg.size.height+5,
                                     self.view.frame.size.width+4, bottomImg.size.height);
    [self.view addSubview:bottomImgView];
    [bottomImgView release];
    
    UIImage *okBtnImg = [UIImage imageNamed:@"dialog_ok_normal_btn"];
    UIButton *okBtn   = [UIButton buttonWithType:UIButtonTypeCustom];
    okBtn.tag   = 0;
    [okBtn setTitleColor:[UIColor blackColor]
                forState:UIControlStateNormal];
    okBtn.titleLabel.font = [UIFont systemFontOfSize:13.f];
    okBtn.frame = CGRectMake(self.view.frame.size.width/2-okBtnImg.size.width/2,
                             self.view.frame.size.height-bottomImg.size.height+11,
                             okBtnImg.size.width,
                             okBtnImg.size.height);
    [okBtn setTitle:@"知道了"
           forState:UIControlStateNormal];
    [okBtn setBackgroundImage:[UIImage imageNamed:@"dialog_ok_normal_btn"]
                     forState:UIControlStateNormal];
    [okBtn setBackgroundImage:[UIImage imageNamed:@"dialog_ok_hlight_btn"]
                     forState:UIControlStateHighlighted];
    [okBtn addTarget:self
              action:@selector(doButtonClicked:)
    forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:okBtn];
}

- (void) doButtonClicked:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"closeNoticeWall"
                                                        object:nil];
}
@end
