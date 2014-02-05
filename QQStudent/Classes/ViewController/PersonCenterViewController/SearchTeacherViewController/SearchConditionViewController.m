//
//  SearchConditionViewController.m
//  QQStudent
//
//  Created by lynn on 14-1-30.
//  Copyright (c) 2014年 lynn. All rights reserved.
//

#import "SearchConditionViewController.h"

@interface SearchConditionViewController ()

@end

@implementation SearchConditionViewController
@synthesize teacherItem;

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
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super viewDidUnload];
}

- (void) dealloc
{
    [timeValueLab release];
    [super dealloc];
}

#pragma mark -
#pragma mark - Custom Action
- (void) initUI
{
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    backBtn.tag = 0;
    [backBtn setTitle:@"返回" forState:UIControlStateNormal];
    [backBtn addTarget:self
                action:@selector(doBackBtnClicked:)
      forControlEvents:UIControlEventTouchUpInside];
    backBtn.frame = CGRectMake(0, 0, 40, 30);
    [self.view addSubview:backBtn];
    
    orderTab = [[UITableView alloc]init];
    orderTab.delegate = self;
    orderTab.dataSource = self;
    orderTab.frame = [UIView fitCGRect:CGRectMake(20, 50, 280, 350)
                            isBackView:NO];
    [self.view addSubview:orderTab];
    
    UIButton *orderBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    orderBtn.tag   = 1;
    orderBtn.frame = [UIView fitCGRect:CGRectMake(80, 420, 160, 40)
                            isBackView:NO];
    [orderBtn setTitle:@"确认,开始邀请"
              forState:UIControlStateNormal];
    [orderBtn addTarget:self
                 action:@selector(doBackBtnClicked:)
       forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:orderBtn];
    
    //注册设置性别消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(setSexFromNotice:) name:@"setSexNotice"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(setDateFromNotice:) name:@"setDateNotice"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(setTimesFromNotice:) name:@"setTimesNotice"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(setSubjectFromNotice:) name:@"setSubjectNotice"
                                               object:nil];
}

- (void) doBackBtnClicked:(id)sender
{
    UIButton *button = sender;
    switch (button.tag)
    {
        case 0: //返回
        {
            [self.navigationController popViewControllerAnimated:YES];
            break;
        }
        case 1:
        {
            break;
        }
        default:
            break;
    }
}

#pragma mark -
#pragma mark - Notice
- (void) setSexFromNotice:(NSNotification *) notice
{
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
}

- (void) setDateFromNotice:(NSNotification *) notice
{
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
}

- (void) setTimesFromNotice:(NSNotification *)notice
{
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
}

- (void) setSubjectFromNotice:(NSNotification *)notice
{
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
}

#pragma mark -
#pragma mark - UITableViewDelegate and UITableViewDataSource
- (int) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (int) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 7;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *idString = @"idString";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:idString];
    if (!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault
                                     reuseIdentifier:idString];
        switch (indexPath.row)
        {
            case 0:
            {
                UILabel *startDate = [[UILabel alloc]init];
                startDate.text = @"开始日期";
                startDate.backgroundColor = [UIColor clearColor];
                startDate.frame = [UIView fitCGRect:CGRectMake(0, 0, 140, 44)
                                         isBackView:NO];
                [cell addSubview:startDate];
                [startDate release];
                break;
            }
            case 1:
            {
//                NSData *stuData  = [[NSUserDefaults standardUserDefaults] objectForKey:STUDENT];
//                Student *student = [NSKeyedUnarchiver unarchiveObjectWithData:stuData];
//                CLog(@"grade:%@", student.grade);
                UILabel *subLab = [[UILabel alloc]init];
                subLab.text = [NSString stringWithFormat:@"辅导科目"];
                subLab.backgroundColor = [UIColor clearColor];
                subLab.frame = CGRectMake(0, 0, 140, 44);
                [cell addSubview:subLab];
                [subLab release];
                
                UILabel *subValLab = [[UILabel alloc]init];
                subValLab.text = [teacherItem objectForKey:@"subject"];
                subValLab.textColor = [UIColor lightGrayColor];
                subValLab.frame = CGRectMake(140, 0, 140, 44);
                [cell addSubview:subValLab];
                [subValLab release];
                break;
            }
            case 2:
            {
                UILabel *sexLab = [[UILabel alloc]init];
                sexLab.text = @"老师性别 ";
                sexLab.backgroundColor = [UIColor clearColor];
                sexLab.frame = CGRectMake(0, 0, 140, 44);
                [cell addSubview:sexLab];
                [sexLab release];
                
                UILabel *sexValLab = [[UILabel alloc]init];
                sexValLab.text = [teacherItem objectForKey:@"gender"];
                sexValLab.textColor = [UIColor lightGrayColor];
                sexValLab.frame = CGRectMake(140, 0, 140, 44);
                [cell addSubview:sexValLab];
                [sexValLab release];
                break;
            }
            case 3:
            {
                UILabel *salaryLab = [[UILabel alloc]init];
                salaryLab.text = @"每小时课酬标准";
                salaryLab.backgroundColor = [UIColor clearColor];
                salaryLab.frame = [UIView fitCGRect:CGRectMake(0, 0, 140, 44)
                                         isBackView:NO];
                [cell addSubview:salaryLab];
                [salaryLab release];
                break;
            }
            case 4:
            {
                UILabel *timesLab = [[UILabel alloc]init];
                timesLab.text = @"预计辅导小时数";
                timesLab.backgroundColor = [UIColor clearColor];
                timesLab.frame = [UIView fitCGRect:CGRectMake(0, 0, 140, 44)
                                         isBackView:NO];
                [cell addSubview:timesLab];
                [timesLab release];
                
                timeValueLab = [[UILabel alloc]init];
                timeValueLab.text = @"20";
                timeValueLab.backgroundColor = [UIColor clearColor];
                timeValueLab.frame = CGRectMake(140, 0, 140, 44);
                [cell addSubview:timeValueLab];
                break;
            }
            case 5:
            {
                UILabel *posLab = [[UILabel alloc]init];
                posLab.text = @"授课地点";
                posLab.backgroundColor = [UIColor clearColor];
                posLab.frame = [UIView fitCGRect:CGRectMake(0, 0, 140, 44)
                                      isBackView:NO];
                [cell addSubview:posLab];
                [posLab release];
                break;
            }
            case 6:
            {
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                break;
            }
            default:
                break;
        }
    }
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.row)
    {
        case 0:         //选择时间
        {
            SelectDateViewController *sdVctr = [[SelectDateViewController alloc]init];
            [self presentPopupViewController:sdVctr
                               animationType:MJPopupViewAnimationFade];
            break;
        }
        case 1:
        {
            SelectSubjectViewController *ssVctr = [[SelectSubjectViewController alloc]init];
            [self presentPopupViewController:ssVctr
                               animationType:MJPopupViewAnimationFade];
            break;
        }
        case 2:
        {
            SelectSexViewController *ssVctr = [[SelectSexViewController alloc]init];
            [self presentPopupViewController:ssVctr
                               animationType:MJPopupViewAnimationFade];
            break;
        }
        case 3:
        {
            SelectSalaryViewController *ssVctr = [[SelectSalaryViewController alloc]init];
            [self presentPopupViewController:ssVctr
                               animationType:MJPopupViewAnimationFade];
            break;
        }
        case 4:
        {
            SelectTimesViewController *stVctr = [[SelectTimesViewController alloc]init];
            stVctr.curValue = timeValueLab.text;
            [self presentPopupViewController:stVctr
                               animationType:MJPopupViewAnimationFade];
            break;
        }
        case 5:
        {
            SelectPosViewController *spVctr = [[SelectPosViewController alloc]init];
            [self presentPopupViewController:spVctr
                               animationType:MJPopupViewAnimationFade];
            break;
        }
        case 6:
        {
            break;
        }
        default:
            break;
    }
}

@end
