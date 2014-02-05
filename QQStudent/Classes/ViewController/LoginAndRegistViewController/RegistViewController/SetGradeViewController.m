//
//  SetGradeViewController.m
//  QQStudent
//
//  Created by lynn on 14-2-4.
//  Copyright (c) 2014年 lynn. All rights reserved.
//

#import "SetGradeViewController.h"

@interface SetGradeViewController ()

@end

@implementation SetGradeViewController

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

#pragma mark -
#pragma mark - Custom Action
- (void) initUI
{
    self.view.frame = [UIView fitCGRect:CGRectMake(0, 0, 240, 280)
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
    gdView.frame = CGRectMake(0, 20, 240, 220);
    [self.view addSubview:gdView];
    
    UIButton *okBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    okBtn.tag = 0;
    okBtn.frame = CGRectMake(60, 245, 40, 30);
    [okBtn setTitle:@"确定"
           forState:UIControlStateNormal];
    [okBtn addTarget:self
              action:@selector(doButtonClicked:)
    forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:okBtn];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    cancelBtn.tag   = 1;
    cancelBtn.frame = CGRectMake(160, 245, 40, 30);
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
            dic = [NSDictionary dictionaryWithObjectsAndKeys:radioTitle, @"gradeName", nil];
            break;
        }
        case 1:
        {
            break;
        }
        default:
            break;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"setGradeNotice"
                                                        object:self
                                                      userInfo:dic];
}

#pragma mark -
#pragma mark - QRadioButtonDelegate
- (void) didSelectedRadioButton:(QRadioButton *)radio groupId:(NSString *)groupId
{
    radioTitle = radio.titleLabel.text;
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
    return 44;
}

- (NSInteger) numberOfColumnsOfGridView:(UIGridView *) grid
{
    return 2;
}

- (NSInteger) numberOfCellsOfGridView:(UIGridView *) grid
{
    return 10;
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
                        [qrBtn setTitle:@"初一"
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
                        [qrBtn setTitle:@"初二"
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
                       
                        [qrBtn setTitle:@"初三"
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
                    
                        [qrBtn setTitle:@"高一"
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
                        [qrBtn setTitle:@"高二"
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
                        [qrBtn setTitle:@"高三"
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
                        [qrBtn setTitle:@"大一"
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
                        [qrBtn setTitle:@"大二"
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
                        [qrBtn setTitle:@"大三"
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
                        [qrBtn setTitle:@"大四"
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
