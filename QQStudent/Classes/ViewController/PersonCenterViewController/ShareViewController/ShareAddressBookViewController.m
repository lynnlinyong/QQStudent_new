//
//  ShareAddressBookViewController.m
//  QQStudent
//
//  Created by lynn on 14-2-18.
//  Copyright (c) 2014年 lynn. All rights reserved.
//

#import "ShareAddressBookViewController.h"

@interface ShareAddressBookViewController ()

@end

@implementation ShareAddressBookViewController

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
    
    //读取所有通讯信息
    [self readAllPeoples];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewDidUnload
{
    [addressArray removeAllObjects];
    
    addressTab.delegate = nil;
    addressTab.dataSource = nil;
    
    addressTab = nil;
    [super viewDidUnload];
}

- (void) dealloc
{
    [addressTab   release];
    [addressArray release];
    [selectArray  release];
    CFRelease (tmpAddressBook);
    [super dealloc];
}

#pragma mark - 
#pragma mark - Custom Action
- (void) initUI
{
    UILabel *title        = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    title.textColor       = [UIColor colorWithHexString:@"#009f66"];
    title.backgroundColor = [UIColor clearColor];
    title.textAlignment = UITextAlignmentCenter;
    title.text = @"分享到通讯录";
    self.navigationItem.titleView = title;
    [title release];
    
    //设置返回按钮
    UIImage *backImg  = [UIImage imageNamed:@"nav_back_normal_btn@2x"];
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame     = CGRectMake(0, 0,
                                   50,
                                   30);
    [backBtn setBackgroundImage:backImg
                       forState:UIControlStateNormal];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"nav_back_hlight_btn@2x"]
                       forState:UIControlStateHighlighted];
    [backBtn addTarget:self
                action:@selector(doBackBtnClicked:)
      forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *titleLab = [[UILabel alloc]init];
    titleLab.text     = @"返回";
    titleLab.textColor= [UIColor whiteColor];
    titleLab.font     = [UIFont systemFontOfSize:12.f];
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.frame = CGRectMake(8, 0,
                                50,
                                30);
    titleLab.backgroundColor = [UIColor clearColor];
    [backBtn addSubview:titleLab];
    [titleLab release];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    
    addressArray = [[NSMutableArray alloc]init];
    selectArray  = [[NSMutableArray alloc]init];
    
    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [shareBtn setTitle:@"分享" forState:UIControlStateNormal];
    shareBtn.frame = CGRectMake(0, 0, 40, 20);
    [shareBtn addTarget:self
                 action:@selector(doShareBtnClicked:)
       forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:shareBtn];
    
    addressTab   = [[UITableView alloc]init];
    addressTab.delegate   = self;
    addressTab.dataSource = self;
    addressTab.frame = [UIView fitCGRect:CGRectMake(0, 0, 320, 460) isBackView:NO];
    [self.view addSubview:addressTab];
}

- (void) readAllPeoples
{
    //取得本地通信录名柄
    if ([[UIDevice currentDevice].systemVersion floatValue]>=6.0) {
        tmpAddressBook=ABAddressBookCreateWithOptions(NULL, NULL);
        dispatch_semaphore_t sema=dispatch_semaphore_create(0);
        ABAddressBookRequestAccessWithCompletion(tmpAddressBook, ^(bool greanted, CFErrorRef error){
            dispatch_semaphore_signal(sema);
        });
        
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
        dispatch_release(sema);
    }
    else
    {
        tmpAddressBook =ABAddressBookCreate();
    }
    
    //取得本地所有联系人记录
    if (tmpAddressBook==nil) {
        return ;
    }
    
    addressArray = [(NSMutableArray *)ABAddressBookCopyArrayOfAllPeople(tmpAddressBook) copy];
}

- (NSString *) getName:(id) person
{
    NSString *name = @"";
    NSString* tmpFirstName = (NSString*)ABRecordCopyValue(person, kABPersonFirstNameProperty);
    if (tmpFirstName)
    {
        name = tmpFirstName;
        CLog(@"First name:%@", tmpFirstName);
        [tmpFirstName release];
        return name;
    }
    [tmpFirstName release];
    
    //获取的联系人单一属性:Last name
    NSString* tmpLastName = (NSString*)ABRecordCopyValue(person, kABPersonLastNameProperty);
    if (tmpLastName)
    {
        name = tmpLastName;
        CLog(@"Last name:%@", tmpLastName);
        [tmpLastName release];
        return name;
    }
    [tmpLastName release];
    
    //获取的联系人单一属性:Nickname
    NSString* tmpNickname = (NSString*)ABRecordCopyValue(person, kABPersonNicknameProperty);
    if (tmpNickname)
    {
        name = tmpNickname;
        CLog(@"Nickname:%@", tmpNickname);
        [tmpNickname release];
        return name;
    }
    [tmpNickname release];

    
    //获取的联系人单一属性:Department name
    NSString* tmpDepartmentName = (NSString*)ABRecordCopyValue(person, kABPersonDepartmentProperty);
    if (tmpDepartmentName)
    {
        name = tmpDepartmentName;
        CLog(@"Department name:%@", tmpDepartmentName);
        [tmpDepartmentName release];
        return name;
    }
    [tmpDepartmentName release];
    
    return name;
}

- (NSString *) getPhone:(id) person
{
    NSString *phoneNum = @"";
    
    //获取的联系人单一属性:Generic phone number
    ABMultiValueRef tmpPhones = ABRecordCopyValue(person, kABPersonPhoneProperty);
    for(NSInteger j = 0; j < ABMultiValueGetCount(tmpPhones); j++)
    {
        NSString *tmpPhoneIndex = (NSString*)ABMultiValueCopyValueAtIndex(tmpPhones, j);
        if (tmpPhoneIndex)
        {
            phoneNum = tmpPhoneIndex;
            [tmpPhoneIndex release];
            return phoneNum;
        }
        [tmpPhoneIndex release];
    }
    
    return phoneNum;
}

#pragma mark -
#pragma mark - UITableViewDelegate and UITableViewDataSource
- (int) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (int) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return addressArray.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *idString = @"idString";
    UITableViewCell *cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault
                                                  reuseIdentifier:idString]autorelease];
    id person = [addressArray objectAtIndex:indexPath.row];
    NSString *name  = [self getName:person];
    NSString *phone = [self getPhone:person];
    
    UIImageView *headImgView = [[UIImageView alloc]init];
    headImgView.image = [UIImage imageNamed:@"s_boy.png"];
    headImgView.frame = CGRectMake(10, 2, 40, 40);
    [cell addSubview:headImgView];
    [headImgView release];
    
    UILabel *nameLab = [[UILabel alloc]init];
    nameLab.text  = name;
    nameLab.frame = CGRectMake(60, 2, 100, 20);
    nameLab.backgroundColor = [UIColor clearColor];
    [cell addSubview:nameLab];
    [nameLab release];
    
    UILabel *phoneLab = [[UILabel alloc]init];
    phoneLab.text  = phone;
    phoneLab.frame = CGRectMake(60, 20, 200, 20);
    phoneLab.backgroundColor = [UIColor clearColor];
    [cell addSubview:phoneLab];
    [phoneLab release];
    
    QCheckBox *_check1 = [[QCheckBox alloc] initWithDelegate:self];
    _check1.tag   = indexPath.row;
    _check1.frame = CGRectMake(320-30, 12, 20, 20);
    [_check1 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [_check1.titleLabel setFont:[UIFont boldSystemFontOfSize:13.0f]];
    [_check1 addTarget:self
                action:@selector(doChangValues:)
      forControlEvents:UIControlEventTouchUpInside];
    [cell addSubview:_check1];
    [_check1 setChecked:NO];
    [_check1 release];
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath
                             animated:YES];
}

#pragma mark -
#pragma mark - Control Event
- (void) doChangValues:(id)sender
{
    QCheckBox *checkBox = sender;
    if ([checkBox checked])
        [selectArray addObject:[NSNumber numberWithInt:checkBox.tag]];
    else
        [selectArray removeObject:[NSNumber numberWithInt:checkBox.tag]];
}

- (void) doBackBtnClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) doShareBtnClicked:(id)sender
{
    CLog(@"selectArray:%@", selectArray);
    NSMutableArray *phoneArray = [[NSMutableArray alloc]init];
    for (int i=0; i<selectArray.count; i++)
    {
        id person = [addressArray objectAtIndex:i];
        NSString *phone = [self getPhone:person];
        [phoneArray addObject:phone];
    }
    
    if (selectArray.count>0)
    {
        //调用短信
        if( [MFMessageComposeViewController canSendText] )
        {
            MFMessageComposeViewController * controller = [[MFMessageComposeViewController alloc]init]; //autorelease];
            controller.recipients = phoneArray;
            controller.body = @"轻轻家教赶快去下载哦!!!www.baidu.com";
            controller.messageComposeDelegate = self;
            [self presentModalViewController:controller animated:YES];
            [[[[controller viewControllers] lastObject] navigationItem] setTitle:@"测试短信"];//修改短信界面标题
        }else
        {
            [self showAlertWithTitle:@"提示"
                                 tag:0
                             message:@"设备没有短信功能"
                            delegate:self
                   otherButtonTitles:@"确定", nil];
        }
    }
    [phoneArray release];
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [controller dismissModalViewControllerAnimated:NO];
    switch ( result )
    {
        case MessageComposeResultCancelled:
        {
            break;
        }
        case MessageComposeResultFailed:
        {
            [self showAlertWithTitle:@"提示"
                                 tag:0
                             message:@"发送取消"
                            delegate:self
                   otherButtonTitles:@"确定", nil];
            break;
        }
        case MessageComposeResultSent:
        {
            [self showAlertWithTitle:@"提示"
                                 tag:0
                             message:@"发送失败"
                            delegate:self
                   otherButtonTitles:@"确定", nil];
            break;
        }
        default:
            break;
    }
}
@end
