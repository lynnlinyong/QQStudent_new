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
    
    self.view.frame = [UIView fitCGRect:CGRectMake(0, 0, 240, 260)
                             isBackView:NO];
    self.view.backgroundColor = [UIColor whiteColor];
    
    subArr = [[NSMutableArray alloc]init];
    //获得课程
    [self getSubjects];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) dealloc
{
    [subArr release];
    [super dealloc];
}

#pragma mark -
#pragma mark - Custom Action
- (void) initUI
{    
    UILabel *infoLab = [[UILabel alloc]init];
    infoLab.text  = @"选择辅导科目";
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

- (void) getSubjects
{
    NSString *ssid     = [[NSUserDefaults standardUserDefaults] objectForKey:SSID];
    NSArray *paramsArr = [NSArray arrayWithObjects:@"action",@"sessid", nil];
    NSArray *valuesArr = [NSArray arrayWithObjects:@"getsubjects",ssid, nil];
    NSDictionary *pDic = [NSDictionary dictionaryWithObjects:valuesArr
                                                     forKeys:paramsArr];
    NSString *webAdd = [[NSUserDefaults standardUserDefaults] objectForKey:WEBADDRESS];
    NSString *url    = [NSString stringWithFormat:@"%@%@", webAdd, STUDENT];
    ServerRequest *request = [ServerRequest sharedServerRequest];
    request.delegate = self;
    [request requestASyncWith:kServerPostRequest
                     paramDic:pDic
                       urlStr:url];
}

- (void) doButtonClicked:(id)sender
{
    NSDictionary *subDic = [subArr objectAtIndex:index];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"setSubjectNotice"
                                                        object:nil
                                                      userInfo:subDic];
}

#pragma mark -
#pragma mark - QRadioButtonDelegate
- (void) didSelectedRadioButton:(QRadioButton *)radio groupId:(NSString *)groupId
{
    index = radio.tag;
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
    return subArr.count;
}

- (UIGridViewCell *) gridView:(UIGridView *)grid cellForRowAt:(int)rowIndex AndColumnAt:(int)columnIndex
{
    NSString *idString = @"idString";
    UIGridViewCell *cell = [grid dequeueReusableCellWithIdentifier:idString];
    if (!cell)
    {
        cell = [[[UIGridViewCell alloc]init]autorelease];
    }
    
    int indexTag = rowIndex*2+columnIndex;
    NSDictionary *subDic= [subArr objectAtIndex:indexTag];
    
    QRadioButton *qrBtn = [[QRadioButton alloc]initWithDelegate:self
                                                        groupId:@"grade"];
    qrBtn.tag = indexTag;
    [qrBtn setTitle:[subDic objectForKey:@"name"]
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

    return cell;
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
        subArr = [[resDic objectForKey:@"subjects"] copy];
        
        //保存科目列表
        [[NSUserDefaults standardUserDefaults] setObject:subArr
                                                  forKey:SUBJECT_LIST];
        
        //显示UI
        [self initUI];
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
