//
//  SetNickNameViewController.m
//  QQStudent
//
//  Created by lynn on 14-2-4.
//  Copyright (c) 2014年 lynn. All rights reserved.
//

#import "SetNickNameViewController.h"

@interface SetNickNameViewController ()

@end

@implementation SetNickNameViewController

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
    
    //
    [self initUI];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewDidUnload
{
    nickNameFld.delegate = nil;
    [super viewDidUnload];
}

- (void) dealloc
{
    [nickNameFld release];
    [super dealloc];
}

#pragma mark -
#pragma mark - Custom Action
- (void) initUI
{
    UIImage *bottomImg= [UIImage imageNamed:@"dialog_bottom"];
    UIImage *titleImg         = [UIImage imageNamed:@"dialog_title"];
    self.view.frame = CGRectMake(0, 0,
                                 titleImg.size.width,150+bottomImg.size.height);
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    UIImageView *titleImgView = [[UIImageView alloc]init];
    titleImgView.frame = CGRectMake(-2, -titleImg.size.height,
                                    self.view.frame.size.width+5,
                                    titleImg.size.height);
    titleImgView.image = titleImg;
    [self.view addSubview:titleImgView];
    [titleImgView release];
    
    UILabel *titleLab = [[UILabel alloc]init];
    titleLab.text     = @"昵称";
    titleLab.textColor= [UIColor whiteColor];
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.frame= [UIView fitCGRect:CGRectMake(0, -titleImg.size.height+3,
                                                 self.view.frame.size.width+5, titleImg.size.height)
                           isBackView:NO];
    titleLab.backgroundColor = [UIColor clearColor];
    [self.view addSubview:titleLab];
    [titleLab release];
    
    UILabel *infoLab = [[UILabel alloc]init];
    infoLab.text     = @"昵称";
    infoLab.font     = [UIFont systemFontOfSize:15.f];
    infoLab.textColor= [UIColor colorWithHexString:@"#ff6600"];
    infoLab.textAlignment = NSTextAlignmentLeft;
    infoLab.frame = [UIView fitCGRect:CGRectMake(10,
                                                 30,
                                                 self.view.frame.size.width+5, 20)
                           isBackView:NO];
    infoLab.backgroundColor = [UIColor clearColor];
    [self.view addSubview:infoLab];
    [infoLab release];
    
    UIImage *normalImg = [UIImage imageNamed:@"hight_fld"];
    nickNameFld = [[UITextField alloc]init];
    UIImageView *phoneImgView  = [[UIImageView alloc]initWithImage:normalImg];
    nickNameFld.delegate = self;
    nickNameFld.text     = @"";
    nickNameFld.borderStyle = UITextBorderStyleNone;
    nickNameFld.placeholder = @"输入昵称";
    nickNameFld.frame = [UIView fitCGRect:CGRectMake(10+5,
                                                50+10,
                                                normalImg.size.width-5,
                                                normalImg.size.height)
                          isBackView:NO];
    phoneImgView.frame = [UIView fitCGRect:CGRectMake(10,
                                                      50+5,
                                                      normalImg.size.width,
                                                      normalImg.size.height+10)
                                isBackView:NO];
    [self.view addSubview:phoneImgView];
    [self.view addSubview:nickNameFld];
    [phoneImgView release];
    
    
    UIImageView *bottomImgView = [[UIImageView alloc]init];
    bottomImgView.image = bottomImg;
    bottomImgView.frame = CGRectMake(-2,
                                     self.view.frame.size.height-bottomImg.size.height,
                                     self.view.frame.size.width+4, bottomImg.size.height);
    [self.view addSubview:bottomImgView];
    [bottomImgView release];
    
    UIImage *okBtnImg = [UIImage imageNamed:@"dialog_ok_normal_btn"];
    UIButton *okBtn   = [UIButton buttonWithType:UIButtonTypeCustom];
    okBtn.tag   = 0;
    [okBtn setTitleColor:[UIColor blackColor]
                forState:UIControlStateNormal];
    okBtn.titleLabel.font = [UIFont systemFontOfSize:13.f];
    okBtn.frame = CGRectMake(self.view.frame.size.width/2-okBtnImg.size.width-10,
                             self.view.frame.size.height-bottomImg.size.height+6,
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
                                 self.view.frame.size.height-bottomImg.size.height+6,
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
    UIButton *button  = sender;
    NSDictionary *dic = nil;
    switch (button.tag)
    {
        case 0:     //确定
        {
            dic = [NSDictionary dictionaryWithObjectsAndKeys:nickNameFld.text,
                                                           @"nickName", nil];
            break;
        }
        case 1:     //取消
        {
            break;
        }
        default:
            break;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"setNickNameNotice"
                                                        object:self
                                                      userInfo:dic];
}

#pragma mark -
#pragma mark - UITextFieldDelegate
- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return  YES;
}
@end
