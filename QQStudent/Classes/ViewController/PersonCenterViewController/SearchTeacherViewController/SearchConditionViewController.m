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
@synthesize tObj;
@synthesize teacherArray;
@synthesize posDic;

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

- (void) viewDidUnload
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [teacherArray removeAllObjects];
    [super viewDidUnload];
}

- (void) dealloc
{
    [subValLab    release];
    [dateValLab   release];
    [teacherArray release];
    [timeValueLab release];
    [super dealloc];
}

#pragma mark -
#pragma mark - Custom Action
- (void) initUI
{
    orderTab = [[UITableView alloc]init];
    orderTab.delegate = self;
    orderTab.dataSource = self;
    orderTab.frame = [UIView fitCGRect:CGRectMake(20, 40, 280, 300)
                            isBackView:NO];
    [self.view addSubview:orderTab];
    
    UIButton *orderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    orderBtn.tag   = 1;
    UIImage *img   = [UIImage imageNamed:@"mainmap_bottom_button_2_hover"];
    orderBtn.frame = [UIView fitCGRect:CGRectMake(160-img.size.width/4,
                                                  460-54-img.size.height/2,
                                                  img.size.width/2,
                                                  img.size.height/2)
                            isBackView:NO];
    [orderBtn setImage:img
              forState:UIControlStateNormal];
    [orderBtn addTarget:self
                 action:@selector(doBackBtnClicked:)
       forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:orderBtn];
    
    //注册设置性别消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(setSexFromNotice:)
                                                 name:@"setSexNotice"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(setSalaryFromNotice:)
                                                 name:@"setSalaryNotice"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(setDateFromNotice:)
                                                 name:@"setDateNotice"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(setTimesFromNotice:)
                                                 name:@"setTimesNotice"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(setSubjectFromNotice:) name:@"setSubjectNotice"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(setPosNotice:) name:@"setPosNotice"
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
        case 1: //邀请
        {
            if (dateValLab.text.length==0||subValLab.text.length==0||salaryValLab.text.length==0||sexValLab.text.length==0||timeValueLab.text.length==0||posValLab.text.length==0)
            {
                [self showAlertWithTitle:@"提示"
                                     tag:0
                                 message:@"筛选信息不完整"
                                delegate:self
                       otherButtonTitles:@"确定",nil];
                return;
            }
            
            //封装所选条件
            NSDictionary *valueDic = [NSDictionary dictionaryWithObjectsAndKeys:dateValLab.text,@"Date",[Order searchSubjectID:subValLab.text],@"Subject",salaryDic,@"SalaryDic",[Student searchGenderID:sexValLab.text],@"Sex",timeValueLab.text,@"Time",posValLab.text,@"Pos",posDic,@"POSDIC",nil];
            
            CLog(@"codition:%@", valueDic);
            
            WaitConfirmViewController *wcVctr = [[WaitConfirmViewController alloc]init];
            wcVctr.valueDic = valueDic;
            wcVctr.tObj     = tObj;
            wcVctr.teacherArray = teacherArray;
            [self.navigationController pushViewController:wcVctr
                                                 animated:YES];
            [wcVctr release];
            break;
        }
        default:
            break;
    }
}

#pragma mark -
#pragma mark - Notice
- (void) setPosNotice:(NSNotification *) notice
{
    posDic = [notice.userInfo copy];
    
    NSString *provice = [notice.userInfo objectForKey:@"PROVICE"];
    NSString *city    = [notice.userInfo objectForKey:@"CITY"];
    NSString *dist    = [notice.userInfo objectForKey:@"DIST"];
    posValLab.text    = [notice.userInfo objectForKey:@"ADDRESS"];
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
}

- (void) setSalaryFromNotice:(NSNotification *) notice
{
    NSString *salary  = @"";
    
    if ([[notice.userInfo objectForKey:@"name"] isEqualToString:@"0"])
        salary = @"师生协商";
    else
        salary = [notice.userInfo objectForKey:@"name"];
    
    salaryValLab.text = salary;
    salaryDic = [notice.userInfo copy];
}

- (void) setSexFromNotice:(NSNotification *) notice
{
    int tag   = ((NSNumber *)[notice.userInfo objectForKey:@"TAG"]).intValue;
    int index = ((NSNumber *)[notice.userInfo objectForKey:@"Index"]).intValue;
    
    if (tag==0)  //确定
    {
        switch (index)
        {
            case 1:
            {
                sexValLab.text = @"男";
                break;
            }
            case 2:
            {
                sexValLab.text = @"女";
                break;
            }
            case 3:
            {
                sexValLab.text = @"不限";
                break;
            }
            default:
                break;
        }
    }
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
}

- (void) setDateFromNotice:(NSNotification *) notice
{
    NSString *dateString = [notice.userInfo objectForKey:@"SetDate"];
    dateValLab.text = dateString;
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
}

- (void) setTimesFromNotice:(NSNotification *)notice
{
    timeValueLab.text = [notice.userInfo objectForKey:@"Time"];
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
}

- (void) setSubjectFromNotice:(NSNotification *)notice
{
    subValLab.text = [notice.userInfo objectForKey:@"name"];
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
                startDate.frame = [UIView fitCGRect:CGRectMake(0, 0, 80, 44)
                                         isBackView:NO];
                [cell addSubview:startDate];
                [startDate release];
                
                dateValLab = [[UILabel alloc]init];
                dateValLab.text = @"";
                dateValLab.textAlignment   = NSTextAlignmentCenter;
                dateValLab.backgroundColor = [UIColor clearColor];
                dateValLab.frame = CGRectMake(80, 0, 170, 44);
                [cell addSubview:dateValLab];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                break;
            }
            case 1:
            {
                UILabel *subLab = [[UILabel alloc]init];
                subLab.text = [NSString stringWithFormat:@"辅导科目"];
                subLab.backgroundColor = [UIColor clearColor];
                subLab.frame = CGRectMake(0, 0, 140, 44);
                [cell addSubview:subLab];
                [subLab release];
                
                subValLab  = [[UILabel alloc]init];
                subValLab.text      = tObj.pf;
                subValLab.textColor = [UIColor lightGrayColor];
                subValLab.frame = CGRectMake(140, 0, 140, 44);
                [cell addSubview:subValLab];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
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
                
                sexValLab = [[UILabel alloc]init];
                if (tObj.sex == 1)
                {
                    sexValLab.text = @"男";
                }
                else
                {
                    sexValLab.text = @"女";
                }
                sexValLab.textColor = [UIColor lightGrayColor];
                sexValLab.frame = CGRectMake(140, 0, 140, 44);
                [cell addSubview:sexValLab];
                [sexValLab release];
                
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
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
                
                salaryValLab  = [[UILabel alloc]init];
                salaryValLab.text      = @"";
                salaryValLab.backgroundColor = [UIColor clearColor];
                salaryValLab.frame = CGRectMake(140, 0, 140, 44);
                [cell addSubview:salaryValLab];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
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
                timeValueLab.text  = @"20";
                timeValueLab.backgroundColor = [UIColor clearColor];
                timeValueLab.frame = CGRectMake(140, 0, 140, 44);
                [cell addSubview:timeValueLab];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
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
                
                posValLab = [[UILabel alloc]init];
                posValLab.text  = @"";
                posValLab.backgroundColor = [UIColor clearColor];
                posValLab.frame = CGRectMake(140, 0, 130, 44);
                posValLab.font  = [UIFont systemFontOfSize:12.f];
                [cell addSubview:posValLab];
                
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
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
            [self.navigationController pushViewController:ssVctr
                                                 animated:YES];
            [ssVctr release];
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
            [self.navigationController pushViewController:spVctr animated:YES];
            [spVctr release];
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
