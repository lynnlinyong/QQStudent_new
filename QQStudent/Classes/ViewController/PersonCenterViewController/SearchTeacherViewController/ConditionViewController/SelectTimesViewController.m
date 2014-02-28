//
//  SelectTimesViewController.m
//  QQStudent
//
//  Created by lynn on 14-2-5.
//  Copyright (c) 2014年 lynn. All rights reserved.
//

#import "SelectTimesViewController.h"

@interface SelectTimesViewController ()

@end

@implementation SelectTimesViewController
@synthesize curValue;

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

- (void) viewDidUnload
{
    timePickerView.delegate = nil;
    timePickerView.dataSource = nil;
    
    timePickerView = nil;
    [super viewDidUnload];
}

- (void) dealloc
{
    [infoLab release];
    [timePickerView release];
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
    
    infoLab = [[UILabel alloc]init];
    infoLab.text  = [NSString stringWithFormat:@"选择预计辅导 %@ 小时", curValue];
    infoLab.textColor = [UIColor whiteColor];
    infoLab.textAlignment = NSTextAlignmentCenter;
    infoLab.frame= CGRectMake(-2, -titleImg.size.height,
                                   self.view.frame.size.width+5, titleImg.size.height);
    infoLab.backgroundColor = [UIColor clearColor];
    infoLab.textAlignment   = NSTextAlignmentCenter;
    [self.view addSubview:infoLab];
    
    int intValue = curValue.integerValue;
    int i = intValue / 100;
    int j = (intValue%100)/10;
    int k = (intValue%100)%10;
    
    timePickerView = [[UIPickerView alloc]init];
    timePickerView.delegate   = self;
    timePickerView.dataSource = self;
    [timePickerView setShowsSelectionIndicator:YES];
    [timePickerView selectRow:i inComponent:0 animated:NO];
    [timePickerView selectRow:j inComponent:1 animated:NO];
    [timePickerView selectRow:k inComponent:2 animated:NO];
    timePickerView.frame = CGRectMake(titleImg.size.width/2-120, 0, 240, 162);
    [self.view addSubview:timePickerView];

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
    UIButton *btn = sender;
    NSDictionary *msgDic = [NSDictionary dictionaryWithObjectsAndKeys:curValue,@"Time", [NSNumber numberWithInt:btn.tag], @"TAG",nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"setTimesNotice"
                                                        object:nil
                                                      userInfo:msgDic];
}

#pragma mark -
#pragma mark - UIPickerViewDelegate and UIPickerViewDataSource
- (int) numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

- (int) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 10;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [NSString stringWithFormat:@"%d", row];
}

- (void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    int intValue = curValue.integerValue;
    int i = intValue / 100;
    int j = (intValue%100)/10;
    int k = (intValue%100)%10;
    
    switch (component)
    {
        case 0:
        {
            intValue = row*100 + j*10 + k;
            break;
        }
        case 1:
        {
            intValue = i*100 + row*10 + k;
            break;
        }
        case 2:
        {
            intValue = i*100 + j*10 + row;
            break;
        }
        default:
            break;
    }
    
    curValue = [[NSString stringWithFormat:@"%d", intValue] retain];
    infoLab.text = [NSString stringWithFormat:@"选择预计辅导 %@ 小时", curValue];
}
@end
