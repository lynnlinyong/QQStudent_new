//
//  ComplainViewController.m
//  QQStudent
//
//  Created by lynn on 14-2-13.
//  Copyright (c) 2014年 lynn. All rights reserved.
//

#import "ComplainViewController.h"

@interface ComplainViewController ()

@end

@implementation ComplainViewController
@synthesize tObj;

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
    cmpTab.delegate = nil;
    cmpTab.dataSource = nil;
    
    cmpTab = nil;
    [super viewDidUnload];
}

- (void) dealloc
{
    [contentView release];
    [cmpTab release];
    [super dealloc];
}

#pragma mark -
#pragma mark - Custom Action
- (void) initUI
{
    self.view.frame = [UIView fitCGRect:CGRectMake(0, 0, 240, 250)
                             isBackView:NO];
    self.view.backgroundColor = [UIColor whiteColor];
 
    UILabel *titleLab = [[UILabel alloc]init];
    titleLab.text = @"投诉TA";
    titleLab.backgroundColor = [UIColor clearColor];
    titleLab.frame = CGRectMake(85, 0, 100, 20);
    [self.view addSubview:titleLab];
    [titleLab release];
    
    cmpTab = [[UITableView alloc]init];
    cmpTab.delegate = self;
    cmpTab.dataSource = self;
    cmpTab.scrollEnabled = NO;
    cmpTab.frame = CGRectMake(0, 20, 240, 200);
    [self.view addSubview:cmpTab];
}

#pragma mark -
#pragma mark - UITableViewDelegate and UITableViewDataScource
- (int) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (int) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}

- (float) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row)
    {
        case 0:
        case 1:
        case 2:
        case 3:
        {
            return 30;
            break;
        }
        case 4:
        {
            return 50;
            break;
        }
        case 5:
        {
            return 30;
            break;
        }
        default:
            break;
    }
    
    return 1;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *idString    = @"idString";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:idString];
    if (!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault
                                     reuseIdentifier:idString];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    switch (indexPath.row)
    {
        case 0:     // title
        {
            UILabel *titleLab = [[UILabel alloc]init];
            titleLab.text = @"选择投诉理由,我们将为您处理:";
            titleLab.backgroundColor = [UIColor clearColor];
            titleLab.frame = CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height);
            [cell addSubview:titleLab];
            [titleLab release];
            break;
        }
        case 1:
        {
            QRadioButton *qrBtn = [[QRadioButton alloc]initWithDelegate:self
                                                                groupId:@"grade"];
            [qrBtn setTitle:@"态度恶劣,有辱骂行为"
                   forState:UIControlStateNormal];
            [qrBtn setTitleColor:[UIColor grayColor]
                        forState:UIControlStateNormal];
            qrBtn.frame = CGRectMake(0, 0, cell.frame.size.width, 30);
            [qrBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
            [qrBtn setChecked:NO];
            [cell addSubview:qrBtn];
            qrBtn.exclusiveTouch = YES;
            qrBtn.userInteractionEnabled = YES;
            [qrBtn release];
            break;
        }
        case 2:
        {
            QRadioButton *qrBtn = [[QRadioButton alloc]initWithDelegate:self
                                                                groupId:@"grade"];
            [qrBtn setTitle:@"对学生造成伤害或侵犯"
                   forState:UIControlStateNormal];
            [qrBtn setTitleColor:[UIColor grayColor]
                        forState:UIControlStateNormal];
            qrBtn.frame = CGRectMake(0, 0, cell.frame.size.width, 30);
            [qrBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
            [qrBtn setChecked:YES];
            [cell addSubview:qrBtn];
            qrBtn.exclusiveTouch = YES;
            qrBtn.userInteractionEnabled = YES;
            [qrBtn release];
            break;
        }
        case 3:
        {
            QRadioButton *qrBtn = [[QRadioButton alloc]initWithDelegate:self
                                                                groupId:@"grade"];
            [qrBtn setTitle:@"不来上课、逃课"
                   forState:UIControlStateNormal];
            [qrBtn setTitleColor:[UIColor grayColor]
                        forState:UIControlStateNormal];
            qrBtn.frame = CGRectMake(0, 0, cell.frame.size.width, 30);
            [qrBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
            [qrBtn setChecked:NO];
            [cell addSubview:qrBtn];
            qrBtn.exclusiveTouch = YES;
            qrBtn.userInteractionEnabled = YES;
            [qrBtn release];
            break;
        }
        case 4:
        {
            contentView = [[UITextField alloc] init];
            contentView.text  = @"";
            contentView.delegate     = self;
            contentView.placeholder  = @"其他理由(140字以内)";
            contentView.borderStyle  = UITextBorderStyleLine;
            contentView.frame = CGRectMake(5, 5, 230, 40);
            [cell addSubview:contentView];
            break;
        }
        case 5:
        {
            UIButton *okBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            okBtn.tag = 0;
            okBtn.frame = CGRectMake(55, 5, 50, 20);
            [okBtn setTitle:@"确定"
                   forState:UIControlStateNormal];
            [okBtn addTarget:self
                      action:@selector(doButtonClicked:)
            forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:okBtn];
            
            UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            cancelBtn.tag = 1;
            cancelBtn.frame = CGRectMake(125, 5, 50, 20);
            [cancelBtn setTitle:@"取消"
                   forState:UIControlStateNormal];
            [cancelBtn addTarget:self
                      action:@selector(doButtonClicked:)
            forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:cancelBtn];
            break;
        }
        default:
            break;
    }
    
    return cell;
}

#pragma mark -
#pragma mark - QRadioButtonDelegate
- (void) didSelectedRadioButton:(QRadioButton *)radio groupId:(NSString *)groupId
{
    titleRadioTitle = radio.titleLabel.text;
}

#pragma mark -
#pragma mark - UITextFieldDelegate
- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [self repickView:self.view];
    [textField resignFirstResponder];
    return YES;
}

- (void) textFieldDidBeginEditing:(UITextField *)textField
{
    [self moveViewWhenViewHidden:textField parent:self.view];
}

#pragma mark -
#pragma mark - Control Event
- (void) doButtonClicked:(id)sender
{
    [self repickView:self.view];
    UIButton *btn = sender;
    switch (btn.tag)
    {
        case 0:     //确定
        {
            NSString *ssid = [[NSUserDefaults standardUserDefaults] objectForKey:SSID];
            
            NSArray *paramsArr = [NSArray arrayWithObjects:@"action",@"teacher_phone",@"tsType",@"tsText",@"sessid", nil];
            NSArray *valuesArr = [NSArray arrayWithObjects:@"submitTs",tObj.phoneNums,titleRadioTitle,contentView.text,ssid, nil];
            
            NSDictionary *pDic = [NSDictionary dictionaryWithObjects:valuesArr
                                                             forKeys:paramsArr];
            
            NSString *webAdd = [[NSUserDefaults standardUserDefaults] objectForKey:WEBADDRESS];
            NSString *url    = [NSString stringWithFormat:@"%@%@", webAdd,STUDENT];
            
            ServerRequest *request = [ServerRequest sharedServerRequest];
            request.delegate = self;
            [request requestASyncWith:kServerPostRequest
                             paramDic:pDic
                               urlStr:url];
            break;
        }
        case 1:     //取消
        {
            break;
        }
        default:
            break;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"dismissComplainNotice"
                                                        object:nil];
}

#pragma mark -
#pragma mark ServerRequest Delegate
- (void) requestAsyncFailed:(ASIHTTPRequest *)request
{
    [self showAlertWithTitle:@"提示"
                         tag:1
                     message:@"网络繁忙"
                    delegate:self
           otherButtonTitles:@"确定",nil];
    
    CLog(@"***********Result****************");
    CLog(@"ERROR");
    CLog(@"***********Result****************");
}

- (void) requestAsyncSuccessed:(ASIHTTPRequest *)request
{
    NSData   *resVal = [request responseData];
    NSString *resStr = [[[NSString alloc]initWithData:resVal
                                             encoding:NSUTF8StringEncoding]autorelease];
    NSDictionary *resDic   = [resStr JSONValue];
    NSArray      *keysArr  = [resDic allKeys];
    NSArray      *valsArr  = [resDic allValues];
    CLog(@"***********Result****************");
    for (int i=0; i<keysArr.count; i++)
    {
        CLog(@"%@=%@", [keysArr objectAtIndex:i], [valsArr objectAtIndex:i]);
    }
    CLog(@"***********Result****************");
    
    
    NSNumber *errorid = [resDic objectForKey:@"errorid"];
    if (errorid.intValue == 0)
    {
        [self showAlertWithTitle:@"提示"
                             tag:0
                         message:@"投诉成功"
                        delegate:self
               otherButtonTitles:@"确定",nil];
    }
    else
    {
        NSString *errorMsg = [resDic objectForKey:@"message"];
        [self showAlertWithTitle:@"提示"
                             tag:0
                         message:[NSString stringWithFormat:@"错误码%@,%@",errorid,errorMsg]
                        delegate:self
               otherButtonTitles:@"确定",nil];
    }
}

@end
