//
//  SettingViewController.m
//  QQStudent
//
//  Created by lynn on 14-1-29.
//  Copyright (c) 2014年 lynn. All rights reserved.
//

#import "SettingViewController.h"
#import "AboutSoftwareViewController.h"

@interface SettingViewController ()

@end

@implementation SettingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.tabBarItem.title = @"设置";
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
    setTab = [[UITableView alloc]initWithFrame:[UIView fitCGRect:CGRectMake(0, 0, 320, 420)
                                                      isBackView:NO]
                                         style:UITableViewStyleGrouped];
    setTab.delegate   = self;
    setTab.dataSource = self;
    [self.view addSubview:setTab];
}

- (void) doLogoutBtnClicked:(id)sender
{
    //写入登录成功标识
    [[NSUserDefaults standardUserDefaults] setBool:NO
                                            forKey:LOGINE_SUCCESS];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark - UITableViewDelegate and UITableViewDataSource
- (int) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (int) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section)
    {
        case 0:
        {
            return 2;
            break;
        }
        case 1:
        {
            return 6;
            break;
        }
        case 2:
        {
            return 4;
            break;
        }
        default:
            break;
    }
    
    return 1;
}

- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section)
    {
        case 0:
        {
            return @"开关设置";
            break;
        }
        case 1:
        {
            return @"个人信息设置";
            break;
        }
        case 2:
        {
            return @"其他设置";
            break;
        }
        default:
            break;
    }
    
    return @"";
}

- (float) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2)
    {
        if (indexPath.row == 3)
        {
            return 80;
        }
    }
    
    return 44;
}

- (UITableViewCell *) tableView:(UITableView *)tableView
          cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *idString = @"idString";
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault
                                                  reuseIdentifier:idString];
    switch (indexPath.section)
    {
        case 0:
        {
            switch (indexPath.row)
            {
                case 0:         //电话接听
                {
                    UILabel *phoneLab = [[UILabel alloc]init];
                    phoneLab.text  = @"电话接听";
                    phoneLab.frame = CGRectMake(10, 12, 80, 20);
                    phoneLab.backgroundColor = [UIColor clearColor];
                    [cell addSubview:phoneLab];
                    [phoneLab release];
                    
                    UISwitch *sw = [[UISwitch alloc]init];
                    sw.frame = CGRectMake(230, 4, 80, 20);
                    [cell addSubview:sw];
                    [sw release];
                    break;
                }
                case 1:         //定位
                {
                    UILabel *locLab = [[UILabel alloc]init];
                    locLab.text  = @"定位";
                    locLab.frame = CGRectMake(10, 12, 80, 20);
                    locLab.backgroundColor = [UIColor clearColor];
                    [cell addSubview:locLab];
                    [locLab release];
                    
                    UISwitch *sw = [[UISwitch alloc]init];
                    sw.frame = CGRectMake(230, 4, 80, 20);
                    [cell addSubview:sw];
                    [sw release];
                    break;
                }
                default:
                    break;
            }
            break;
        }
        case 1:
        {
            switch (indexPath.row)
            {
                case 0:
                {
                    UILabel *emailLab = [[UILabel alloc]init];
                    emailLab.text  = @"邮箱";
                    emailLab.frame = CGRectMake(10, 12, 80, 20);
                    emailLab.backgroundColor = [UIColor clearColor];
                    [cell addSubview:emailLab];
                    [emailLab release];
                    break;
                }
                case 1:
                {
                    UILabel *phoneLab = [[UILabel alloc]init];
                    phoneLab.text  = @"手机";
                    phoneLab.frame = CGRectMake(10, 12, 80, 20);
                    phoneLab.backgroundColor = [UIColor clearColor];
                    [cell addSubview:phoneLab];
                    [phoneLab release];
                    break;
                }
                case 2:
                {
                    UILabel *classLab = [[UILabel alloc]init];
                    classLab.text  = @"年级";
                    classLab.frame = CGRectMake(10, 12, 80, 20);
                    classLab.backgroundColor = [UIColor clearColor];
                    [cell addSubview:classLab];
                    [classLab release];
                    break;
                }
                case 3:
                {
                    UILabel *sexLab = [[UILabel alloc]init];
                    sexLab.text  = @"性别";
                    sexLab.frame = CGRectMake(10, 12, 80, 20);
                    sexLab.backgroundColor = [UIColor clearColor];
                    [cell addSubview:sexLab];
                    [sexLab release];
                    break;
                }
                case 4:
                {
                    UILabel *nameLab = [[UILabel alloc]init];
                    nameLab.text  = @"昵称";
                    nameLab.frame = CGRectMake(10, 12, 80, 20);
                    nameLab.backgroundColor = [UIColor clearColor];
                    [cell addSubview:nameLab];
                    [nameLab release];
                    break;
                }
                case 5:
                {
                    UILabel *numberLab = [[UILabel alloc]init];
                    numberLab.text  = @"绑定账号";
                    numberLab.frame = CGRectMake(10, 12, 80, 20);
                    numberLab.backgroundColor = [UIColor clearColor];
                    [cell addSubview:numberLab];
                    [numberLab release];
                    break;
                }
                default:
                    break;
            }
            break;
        }
        case 2:
        {
            switch (indexPath.row)
            {
                case 0:
                {
                    UILabel *adviseLab = [[UILabel alloc]init];
                    adviseLab.text  = @"建议反馈";
                    adviseLab.frame = CGRectMake(10, 12, 80, 20);
                    adviseLab.backgroundColor = [UIColor clearColor];
                    [cell addSubview:adviseLab];
                    [adviseLab release];
                    break;
                }
                case 1:
                {
                    UILabel *aboutLab = [[UILabel alloc]init];
                    aboutLab.text  = @"关于轻轻";
                    aboutLab.frame = CGRectMake(10, 12, 80, 20);
                    aboutLab.backgroundColor = [UIColor clearColor];
                    [cell addSubview:aboutLab];
                    [aboutLab release];
                    break;
                }
                case 2:
                {
                    UILabel *versionLab = [[UILabel alloc]init];
                    versionLab.text  = @"版本检查";
                    versionLab.frame = CGRectMake(10, 12, 80, 20);
                    versionLab.backgroundColor = [UIColor clearColor];
                    [cell addSubview:versionLab];
                    [versionLab release];
                    break;
                }
                case 3:
                {
                    UIButton *logoutBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                    [logoutBtn setTitle:@"退出当前账号" forState:UIControlStateNormal];
                    logoutBtn.frame = CGRectMake(20, 20, 280, 40);
                    [logoutBtn addTarget:self
                                  action:@selector(doLogoutBtnClicked:)
                        forControlEvents:UIControlEventTouchUpInside];
                    [cell addSubview:logoutBtn];
                }
                default:
                    break;
            }
            break;
        }
        default:
            break;
    }
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section)
    {
        case 0:
        {
            break;
        }
        case 1:
        {
            break;
        }
        case 2:
        {
            switch (indexPath.row)
            {
                case 0:
                {
                    break;
                }
                case 1:
                {
                    AboutSoftwareViewController *aboutVctr = [[AboutSoftwareViewController alloc]init];
                    [self.navigationController pushViewController:aboutVctr
                                                         animated:YES];
                    [aboutVctr release];
                    break;
                }
                case 2:
                {
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
@end
