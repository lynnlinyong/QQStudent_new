//
//  SelectDateViewController.m
//  QQStudent
//
//  Created by lynn on 14-2-5.
//  Copyright (c) 2014年 lynn. All rights reserved.
//

#import "SelectDateViewController.h"

@interface SelectDateViewController ()

@end

@implementation SelectDateViewController

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

- (void) dealloc
{
    [datePicker release];
    [super dealloc];
}

#pragma mark -
#pragma mark - Custom Action
- (void) initUI
{
    UIImage *titleImg         = [UIImage imageNamed:@"dialog_title"];
    self.view.frame = [UIView fitCGRect:CGRectMake(0, 0,
                                                   titleImg.size.width,
                                                   210)
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
    titleLab.text  = @"设置开始日期";
    titleLab.textColor = [UIColor whiteColor];
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.frame= [UIView fitCGRect:CGRectMake(-2.5, -2,
                                                 groupView.frame.size.width+5, titleImg.size.height)
                           isBackView:NO];
    titleLab.backgroundColor = [UIColor clearColor];
    titleLab.textAlignment   = NSTextAlignmentCenter;
    [groupView addSubview:titleLab];
    [titleLab release];
    
    datePicker = [[UIDatePicker alloc]init];
    datePicker.frame = CGRectMake(titleImg.size.width/2-120, 20, 240, 80);
    [datePicker setDatePickerMode:UIDatePickerModeDate];
    [datePicker addTarget:self
                   action:@selector(dateChanged:)
         forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:datePicker];
    
    UIImage *bottomImg= [UIImage imageNamed:@"dialog_bottom"];
    UIImageView *bottomImgView = [[UIImageView alloc]init];
    bottomImgView.image = bottomImg;
    bottomImgView.frame = [UIView fitCGRect:CGRectMake(-11,
                                                       self.view.frame.size.height-bottomImg.size.height+6,
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
                             self.view.frame.size.height-okBtnImg.size.height+3,
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
                                 self.view.frame.size.height-cancelImg.size.height+3,
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

-(void) doButtonClicked:(id)sender
{
    UIButton *button = sender;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSTimeZone *timeZone = [NSTimeZone localTimeZone];
    [formatter setTimeZone:timeZone];
    [formatter setDateFormat : @"yyyy/M/d"];
    
    NSString *dateString    = [formatter stringFromDate:datePicker.date];
    NSDictionary *noticeDic = [NSDictionary dictionaryWithObjectsAndKeys:dateString,@"SetDate", [NSNumber numberWithInt:button.tag],@"TAG",nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"setDateNotice"
                                                        object:nil
                                                      userInfo:noticeDic];
}

-(void) dateChanged:(id)sender
{
    
}
@end
