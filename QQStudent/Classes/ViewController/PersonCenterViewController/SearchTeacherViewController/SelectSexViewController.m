//
//  SelectSexViewController.m
//  QQStudent
//
//  Created by lynn on 14-2-5.
//  Copyright (c) 2014年 lynn. All rights reserved.
//

#import "SelectSexViewController.h"

@interface SelectSexViewController ()

@end

@implementation SelectSexViewController

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
}

#pragma mark -
#pragma mark - Custom Action
- (void) initUI
{
    self.view.frame = [UIView fitCGRect:CGRectMake(0, 0, 240, 160)
                             isBackView:NO];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UILabel *infoLab = [[UILabel alloc]init];
    infoLab.text  = @"选择性别";
    infoLab.frame = CGRectMake(45, 0, 150, 20);
    infoLab.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:infoLab];
    [infoLab release];
    
    gdView = [[UIGridView alloc]init];
    gdView.uiGridViewDelegate = self;
    gdView.frame = CGRectMake(0, 20, 240, 90);
    gdView.userInteractionEnabled = YES;
    [self.view addSubview:gdView];
    
    UIButton *okBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    okBtn.tag = 0;
    okBtn.frame = CGRectMake(60, 120, 40, 30);
    [okBtn setTitle:@"确定"
           forState:UIControlStateNormal];
    [okBtn addTarget:self
              action:@selector(doButtonClicked:)
    forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:okBtn];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    cancelBtn.tag   = 1;
    cancelBtn.frame = CGRectMake(160, 120, 40, 30);
    [cancelBtn setTitle:@"取消"
               forState:UIControlStateNormal];
    [cancelBtn addTarget:self
                  action:@selector(doButtonClicked:)
        forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancelBtn];
}

- (void) doButtonClicked:(id)sender
{
    UIButton *button = sender;
    NSDictionary *dic = nil;
    switch (button.tag)
    {
        case 0:
        {
            dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:selectRadioIndex], @"sexIndex", nil];
            break;
        }
        case 1:
        {
            break;
        }
        default:
            break;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"setSexNotice"
                                                        object:self
                                                      userInfo:dic];
}

#pragma mark -
#pragma mark - QRadioButtonDelegate
- (void) didSelectedRadioButton:(QRadioButton *)radio groupId:(NSString *)groupId
{
    selectRadioIndex = radio.tag;
}

#pragma mark -
#pragma mark - UIGridViewDelegate
- (void) gridView:(UIGridView *)grid didSelectRowAt:(int)rowIndex AndColumnAt:(int)columnIndex
{
    
}

- (CGFloat) gridView:(UIGridView *)grid widthForColumnAt:(int)columnIndex
{
    return 100;
}

- (CGFloat) gridView:(UIGridView *)grid heightForRowAt:(int)rowIndex
{
    return 30;
}

- (NSInteger) numberOfColumnsOfGridView:(UIGridView *) grid
{
    return 1;
}

- (NSInteger) numberOfCellsOfGridView:(UIGridView *) grid
{
    return 3;
}

- (UIGridViewCell *) gridView:(UIGridView *)grid cellForRowAt:(int)rowIndex AndColumnAt:(int)columnIndex
{
    NSString *idString   = @"idString";
    UIGridViewCell *cell = [grid dequeueReusableCellWithIdentifier:idString];
    if (!cell)
    {
        cell = [[[UIGridViewCell alloc]init]autorelease];
        switch (rowIndex)
        {
            case 0:
            {
                QRadioButton *qrBtn = [[QRadioButton alloc]initWithDelegate:self
                                                                    groupId:@"sex"];
                qrBtn.tag = 0;
                [qrBtn setTitle:@"男"
                       forState:UIControlStateNormal];
                [qrBtn setTitleColor:[UIColor grayColor]
                            forState:UIControlStateNormal];
                qrBtn.frame = CGRectMake(0, 0, 80, 30);
                [qrBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
                [qrBtn setChecked:YES];
                [cell addSubview:qrBtn];
                qrBtn.exclusiveTouch = YES;
                qrBtn.userInteractionEnabled = YES;
                [qrBtn release];
                break;
            }
            case 1:
            {
                QRadioButton *qrBtn = [[QRadioButton alloc]initWithDelegate:self
                                                                    groupId:@"sex"];
                qrBtn.tag = 1;
                [qrBtn setTitle:@"女"
                       forState:UIControlStateNormal];
                [qrBtn setTitleColor:[UIColor grayColor]
                            forState:UIControlStateNormal];
                qrBtn.frame = CGRectMake(0, 0, 80, 30);
                [qrBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
                [cell addSubview:qrBtn];
                qrBtn.exclusiveTouch = YES;
                qrBtn.userInteractionEnabled = YES;
                [qrBtn release];
                break;
            }
            case 2:
            {
                QRadioButton *qrBtn = [[QRadioButton alloc]initWithDelegate:self
                                                                    groupId:@"sex"];
                qrBtn.tag = 2;
                [qrBtn setTitle:@"不限"
                       forState:UIControlStateNormal];
                [qrBtn setTitleColor:[UIColor grayColor]
                            forState:UIControlStateNormal];
                qrBtn.frame = CGRectMake(0, 0, 80, 30);
                [qrBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
                [cell addSubview:qrBtn];
                qrBtn.exclusiveTouch = YES;
                qrBtn.userInteractionEnabled = YES;
                [qrBtn release];
                break;
            }
            default:
                break;
        }
    }
    
    return cell;
}
@end
