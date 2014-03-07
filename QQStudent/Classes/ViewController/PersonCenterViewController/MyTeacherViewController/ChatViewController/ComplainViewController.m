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
    UIImage *bottomImg        = [UIImage imageNamed:@"dialog_bottom"];
    UIImage *titleImg         = [UIImage imageNamed:@"dialog_title"];
    self.view.frame = CGRectMake(0, 0,
                                 titleImg.size.width,
                                 320+bottomImg.size.height);
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIImageView *titleImgView = [[UIImageView alloc]init];
    titleImgView.frame = CGRectMake(-2, -titleImg.size.height,
                                    self.view.frame.size.width+5, titleImg.size.height);
    titleImgView.image = titleImg;
    [self.view addSubview:titleImgView];
    [titleImgView release];
    
    UILabel *titleLab  = [[UILabel alloc]init];
    titleLab.text      = @"投诉TA";
    titleLab.textColor = [UIColor whiteColor];
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.frame= CGRectMake(0, -titleImg.size.height,
                               self.view.frame.size.width+5, titleImg.size.height);
    titleLab.backgroundColor = [UIColor clearColor];
    titleLab.textAlignment   = NSTextAlignmentCenter;
    [self.view addSubview:titleLab];
    [titleLab release];
    
//    UIImage *bottomImg= [UIImage imageNamed:@"dialog_bottom"];
    UIImageView *bottomImgView = [[UIImageView alloc]init];
    bottomImgView.image = bottomImg;
    bottomImgView.frame = CGRectMake(-2,
                                     self.view.frame.size.height-bottomImg.size.height+5,
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
                             self.view.frame.size.height-bottomImg.size.height+11,
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
                                 self.view.frame.size.height-bottomImg.size.height+11,
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
 
    cmpTab = [[UITableView alloc]init];
    cmpTab.delegate = self;
    cmpTab.dataSource = self;
    cmpTab.scrollEnabled = NO;
    cmpTab.frame = CGRectMake(0, 0, 240, 300);
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
    return 5;
}

- (float) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row)
    {
        case 0:
        {
            return 40;
        }
        case 1:
        case 2:
        case 3:
        {
            return 50;
        }
        case 4:
        {
            return 100;
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
            titleLab.font = [UIFont systemFontOfSize:16.f];
            titleLab.textColor = [UIColor grayColor];
            titleLab.backgroundColor = [UIColor clearColor];
            titleLab.frame = CGRectMake(10, 0, cell.frame.size.width,
                                        cell.frame.size.height-10);
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
            qrBtn.frame = CGRectMake(10, 0, cell.frame.size.width, 30);
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
            qrBtn.frame = CGRectMake(10, 0, cell.frame.size.width, 30);
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
            qrBtn.frame = CGRectMake(10, 0, cell.frame.size.width, 30);
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
            UIImageView *bgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"spg_input_bg"]];
            bgView.frame = CGRectMake(10,
                                      3,
                                      225, 92);
            [cell addSubview:bgView];
            
            contentView = [[UITextField alloc] init];
            contentView.text  = @"";
            contentView.delegate     = self;
            contentView.font = [UIFont systemFontOfSize:14.f];
            contentView.placeholder  = @"其他理由(140字以内)";
            contentView.frame = CGRectMake(15, 5, 220, 90);
            [cell addSubview:contentView];
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
            if (![AppDelegate isConnectionAvailable:YES withGesture:NO])
            {
                return;
            }
            
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
#pragma mark - UIViewController Custom Methods
- (void) repickView:(UIView *)parent
{
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    
    [UIView setAnimationDuration:animationDuration];
    CGRect rect  = CGRectMake(parent.frame.origin.x,
                              parent.frame.origin.y+205,
                              parent.frame.size.width,
                              parent.frame.size.height);
    parent.frame = rect;
    
    [UIView commitAnimations];
}

- (void) moveViewWhenViewHidden:(UIView *)view parent:(UIView *) parentView
{
    //键盘高度216
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyBoard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    int width  = parentView.frame.size.width;
    int height = parentView.frame.size.height;
    CGRect rect= CGRectMake(parentView.frame.origin.x,
                            parentView.frame.origin.y-205,width, height);
    parentView.frame = rect;
    [UIView commitAnimations];
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
        //重复登录
        if (errorid.intValue==2)
        {
            //清除sessid,清除登录状态,回到地图页
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:SSID];
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:LOGINE_SUCCESS];
            [AppDelegate popToMainViewController];
        }
    }
}

@end
