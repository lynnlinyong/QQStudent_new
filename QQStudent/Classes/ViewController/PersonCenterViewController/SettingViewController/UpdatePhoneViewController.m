//
//  UpdatePhoneViewController.m
//  QQStudent
//
//  Created by lynn on 14-2-16.
//  Copyright (c) 2014年 lynn. All rights reserved.
//

#import "UpdatePhoneViewController.h"

@interface UpdatePhoneViewController ()

@end

@implementation UpdatePhoneViewController
@synthesize phone;

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
    
    //初始化UI
    [self initUI];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) dealloc
{
    [txtFld release];
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
    titleLab.text     = @"手机号码";
    titleLab.textColor= [UIColor whiteColor];
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.frame= [UIView fitCGRect:CGRectMake(0, -titleImg.size.height+3,
                                                 self.view.frame.size.width+5, titleImg.size.height)
                           isBackView:NO];
    titleLab.backgroundColor = [UIColor clearColor];
    [self.view addSubview:titleLab];
    [titleLab release];
    
    UILabel *infoLab = [[UILabel alloc]init];
    infoLab.text     = @"手机号码";
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
    txtFld = [[UITextField alloc]init];
    UIImageView *phoneImgView  = [[UIImageView alloc]initWithImage:normalImg];
    txtFld.delegate = self;
    txtFld.text     = phone;
    txtFld.borderStyle = UITextBorderStyleNone;
    txtFld.placeholder = @"输入邮箱地址";
    txtFld.frame = CGRectMake(10+5,
                                                50+10,
                                                normalImg.size.width-5,
                                                normalImg.size.height);
    phoneImgView.frame = CGRectMake(10,
                                                      50+5,
                                                      normalImg.size.width,
                                                      normalImg.size.height+10);
    [self.view addSubview:phoneImgView];
    [self.view addSubview:txtFld];
    [phoneImgView release];
    
    
    UIImageView *bottomImgView = [[UIImageView alloc]init];
    bottomImgView.image = bottomImg;
    bottomImgView.frame = CGRectMake(-2,
                                     self.view.frame.size.height-bottomImg.size.height,
                                     self.view.frame.size.width+4, bottomImg.size.height);
    [self.view addSubview:bottomImgView];
    [bottomImgView release];
    
    UIImage *okBtnImg = [UIImage imageNamed:@"dialog_ok_normal_btn"];
    okBtn       = [UIButton buttonWithType:UIButtonTypeCustom];
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

#pragma mark -
#pragma mark - Control Event
- (void) doButtonClicked:(id)sender
{
    UIButton *btn      = sender;
    NSNumber *tagNum   = [NSNumber numberWithInt:btn.tag];
    if (tagNum.intValue== 0)
    {
        //检查格式
        if (![self checkInfo])
        {
            return;
        }
    }
    NSDictionary *pDic = [NSDictionary dictionaryWithObjectsAndKeys:tagNum,@"TAG",
                                                      txtFld.text,@"CONTENT",nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"updatePhoneNotice"
                                                        object:nil
                                                      userInfo:pDic];
    [self repickView:self.view];
}

- (BOOL) checkInfo
{
    if (txtFld.text.length == 0)
    {
        [self showAlertWithTitle:@"提示"
                             tag:1
                         message:@"登录信息不完整!"
                        delegate:self
               otherButtonTitles:@"确定", nil];
        
        return NO;
    }
    
    BOOL isPhone = [txtFld.text isMatchedByRegex:@"^(13[0-9]|15[0-9]|18[0-9])\\d{8}$"];
    if (!isPhone)
    {
        [self showAlertWithTitle:@"提示"
                             tag:1
                         message:@"手机号格式不正确"
                        delegate:self
               otherButtonTitles:@"确定",nil];
        return NO;
    }
    
    return YES;
}

#pragma mark -
#pragma mark - UIViewController Custom Methods
- (void) repickView:(UIView *)parent
{
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    
    [UIView setAnimationDuration:animationDuration];
    CGRect rect  = CGRectMake(parent.frame.origin.x,
                              parent.frame.origin.y+50,
                              parent.frame.size.width,
                              parent.frame.size.height);
    parent.frame = rect;
    
    [UIView commitAnimations];
}

- (void) moveViewWhenViewHidden:(UIView *)view parent:(UIView *) parentView
{
    //键盘高度216
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyBoard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    int width  = parentView.frame.size.width;
    int height = parentView.frame.size.height;
    CGRect rect= CGRectMake(parentView.frame.origin.x,
                            parentView.frame.origin.y-50,width, height);
    parentView.frame = rect;
    [UIView commitAnimations];
}

#pragma mark -
#pragma mark - UITextFieldDelegate
- (void) textFieldDidBeginEditing:(UITextField *)textField
{    
    [self moveViewWhenViewHidden:okBtn
                          parent:self.view];
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [self repickView:self.view];
    [textField resignFirstResponder];
    return YES;
}
@end
