//
//  SelectSubjectViewController.m
//  QQStudent
//
//  Created by lynn on 14-2-5.
//  Copyright (c) 2014年 lynn. All rights reserved.
//

#import "SelectSubjectViewController.h"

@interface SelectSubjectViewController ()

@end

@implementation SelectSubjectViewController

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
    self.view.frame = [UIView fitCGRect:CGRectMake(0, 0, 240, 260)
                             isBackView:NO];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UILabel *infoLab = [[UILabel alloc]init];
    infoLab.text  = @"选择年级";
    infoLab.frame = CGRectMake(45, 0, 150, 20);
    infoLab.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:infoLab];
    [infoLab release];
    
    gdView = [[UIGridView alloc]init];
    gdView.uiGridViewDelegate = self;
    gdView.frame = CGRectMake(0, 20, 240, 210);
    [self.view addSubview:gdView];
    
    UIButton *okBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    okBtn.tag = 0;
    okBtn.frame = CGRectMake(60, 230, 40, 30);
    [okBtn setTitle:@"确定"
           forState:UIControlStateNormal];
    [okBtn addTarget:self
              action:@selector(doButtonClicked:)
    forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:okBtn];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    cancelBtn.tag   = 1;
    cancelBtn.frame = CGRectMake(160, 230, 40, 30);
    [cancelBtn setTitle:@"取消"
               forState:UIControlStateNormal];
    [cancelBtn addTarget:self
                  action:@selector(doButtonClicked:)
        forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancelBtn];
}

- (void) doButtonClicked:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"setSubjectNotice"
                                                        object:nil];
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
    return 2;
}

- (NSInteger) numberOfCellsOfGridView:(UIGridView *) grid
{
    return 14;
}

- (UIGridViewCell *) gridView:(UIGridView *)grid cellForRowAt:(int)rowIndex AndColumnAt:(int)columnIndex
{
    NSString *idString = @"idString";
    UIGridViewCell *cell = [grid dequeueReusableCellWithIdentifier:idString];
    if (!cell)
    {
        cell = [[[UIGridViewCell alloc]init]autorelease];
        
        switch (rowIndex)
        {
            case 0:
            {
                switch (columnIndex)
                {
                    case 0:
                    {
                        QRadioButton *qrBtn = [[QRadioButton alloc]initWithDelegate:self
                                                                            groupId:@"grade"];
                        [qrBtn setTitle:@"数学"
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
                                                                            groupId:@"grade"];
                        [qrBtn setTitle:@"SAT"
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
                    default:
                        break;
                }
                break;
            }
            case 1:
            {
                switch (columnIndex)
                {
                    case 0:
                    {
                        QRadioButton *qrBtn = [[QRadioButton alloc]initWithDelegate:self
                                                                            groupId:@"grade"];
                        
                        [qrBtn setTitle:@"英语"
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
                                                                            groupId:@"grade"];
                        
                        [qrBtn setTitle:@"TOEFL"
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
                    default:
                        break;
                }
                break;
            }
            case 2:
            {
                switch (columnIndex)
                {
                    case 0:
                    {
                        QRadioButton *qrBtn = [[QRadioButton alloc]initWithDelegate:self
                                                                            groupId:@"grade"];
                        [qrBtn setTitle:@"物理"
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
                                                                            groupId:@"grade"];
                        [qrBtn setTitle:@"SSAT"
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
                    default:
                        break;
                }
                break;
            }
            case 3:
            {
                switch (columnIndex)
                {
                    case 0:
                    {
                        QRadioButton *qrBtn = [[QRadioButton alloc]initWithDelegate:self
                                                                            groupId:@"grade"];
                        [qrBtn setTitle:@"化学"
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
                                                                            groupId:@"grade"];
                        [qrBtn setTitle:@"IELTS"
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
                    default:
                        break;
                }
                break;
            }
            case 4:
            {
                switch (columnIndex)
                {
                    case 0:
                    {
                        QRadioButton *qrBtn = [[QRadioButton alloc]initWithDelegate:self
                                                                            groupId:@"grade"];
                        [qrBtn setTitle:@"语文"
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
                                                                            groupId:@"grade"];
                        [qrBtn setTitle:@"钢琴"
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
                    default:
                        break;
                }
            }
            case 5:
            {
                switch (columnIndex)
                {
                    case 0:
                    {
                        QRadioButton *qrBtn = [[QRadioButton alloc]initWithDelegate:self
                                                                            groupId:@"grade"];
                        [qrBtn setTitle:@"行测"
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
                                                                            groupId:@"grade"];
                        [qrBtn setTitle:@"申论"
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
                    default:
                        break;
                }
                break;
            }
            case 6:
            {
                switch (columnIndex)
                {
                    case 0:
                    {
                        QRadioButton *qrBtn = [[QRadioButton alloc]initWithDelegate:self
                                                                            groupId:@"grade"];
                        [qrBtn setTitle:@"面试"
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
                                                                            groupId:@"grade"];
                        [qrBtn setTitle:@"陪驾"
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
                    default:
                        break;
                }
                break;
            }
            default:
                break;
        }
    }
    
    return cell;
}

@end
