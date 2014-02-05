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
    self.view.frame = [UIView fitCGRect:CGRectMake(0, 0, 240, 220)
                             isBackView:NO];
    self.view.backgroundColor = [UIColor whiteColor];
    
    infoLab = [[UILabel alloc]init];
    infoLab.text  = [NSString stringWithFormat:@"选择预计辅导 %@ 小时", curValue];
    infoLab.frame = CGRectMake(0, 0, 240, 20);
    infoLab.textAlignment = NSTextAlignmentCenter;
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
    timePickerView.frame = CGRectMake(0, 20, 240, 162);
    [self.view addSubview:timePickerView];
    
    UIButton *okBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    okBtn.tag = 0;
    okBtn.frame = CGRectMake(60, 190, 40, 30);
    [okBtn setTitle:@"确定"
           forState:UIControlStateNormal];
    [okBtn addTarget:self
              action:@selector(doButtonClicked:)
    forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:okBtn];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    cancelBtn.tag   = 1;
    cancelBtn.frame = CGRectMake(160, 190, 40, 30);
    [cancelBtn setTitle:@"取消"
               forState:UIControlStateNormal];
    [cancelBtn addTarget:self
                  action:@selector(doButtonClicked:)
        forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancelBtn];
}

- (void) doButtonClicked:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"setTimesNotice"
                                                        object:nil];
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
    CLog(@"curValue:%@", curValue);
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
    CLog(@"newValue:%@", curValue);
    infoLab.text = [NSString stringWithFormat:@"选择预计辅导 %@ 小时", curValue];
}
@end
