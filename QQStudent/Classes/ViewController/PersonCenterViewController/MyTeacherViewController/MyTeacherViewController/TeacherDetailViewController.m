//
//  TeacherDetailViewController.m
//  QQStudent
//
//  Created by lynn on 14-1-31.
//  Copyright (c) 2014年 lynn. All rights reserved.
//

#import "TeacherDetailViewController.h"

@interface TeacherDetailViewController ()

@end

@implementation TeacherDetailViewController
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
    
    UILabel *title        = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    title.textColor       = [UIColor colorWithHexString:@"#009f66"];
    title.backgroundColor = [UIColor clearColor];
    title.textAlignment = UITextAlignmentCenter;
    title.text = @"家教信息";
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
    
    //获得老师个人信息
    [self getTeacherDetail];
    
//    [self initUI];
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
    NSString *webAdd = [[NSUserDefaults standardUserDefaults] objectForKey:WEBADDRESS];
    TTImageView *headImageView = [[TTImageView alloc]init];
    headImageView.frame = CGRectMake(110, 30, 100, 120);
    headImageView.URL   = [NSString stringWithFormat:@"%@%@", webAdd,tObj.headUrl];
    [self.view addSubview:headImageView];
    [headImageView release];
    
    UILabel *infoLab = [[UILabel alloc]init];
    infoLab.text  = [NSString stringWithFormat:@"%@ %@ %@", tObj.name, [Student searchGenderName:[NSString stringWithFormat:@"%d",tObj.sex]], tObj.pf];
    infoLab.frame = CGRectMake(20, 190, 200, 20);
    infoLab.backgroundColor = [UIColor clearColor];
    [self.view addSubview:infoLab];
    [infoLab release];
    
    UILabel *idNumsLab = [[UILabel alloc]init];
    idNumsLab.text = tObj.phoneNums;
    idNumsLab.frame= CGRectMake(20, 210, 200, 20);
    idNumsLab.backgroundColor = [UIColor clearColor];
    [self.view addSubview:idNumsLab];
    [idNumsLab release];
    
    UILabel *studyLab = [[UILabel alloc]init];
    studyLab.text = [NSString stringWithFormat:@"已辅导%d位学生", tObj.studentCount];
    studyLab.frame= CGRectMake(20, 230, 200, 20);
    studyLab.backgroundColor = [UIColor clearColor];
    [self.view addSubview:studyLab];
    [studyLab release];
    
    UILabel *commentLab = [[UILabel alloc]init];
    commentLab.text = @"口碑";
    commentLab.frame=CGRectMake(20, 250, 40, 20);
    commentLab.backgroundColor = [UIColor clearColor];
    [self.view addSubview:commentLab];
    [commentLab release];
    
    UIImageView *goodImgView = [[UIImageView alloc]init];
    goodImgView.image = [UIImage imageNamed:@"zan_hao.png"];
    goodImgView.frame = CGRectMake(65, 250, 20, 20);
    [self.view addSubview:goodImgView];
    [goodImgView release];
    
    UILabel *goodLab = [[UILabel alloc]init];
    goodLab.font = [UIFont systemFontOfSize:14.f];
    goodLab.text = [NSString stringWithFormat:@"%d",tObj.goodCount];
    goodLab.backgroundColor = [UIColor clearColor];
    goodLab.frame = CGRectMake(90, 250, 20, 20);
    [self.view addSubview:goodLab];
    [goodLab release];
    
    UIImageView *badImgView = [[UIImageView alloc]init];
    badImgView.image = [UIImage imageNamed:@"xun_3.png"];
    badImgView.frame = CGRectMake(115, 250, 20, 20);
    [self.view addSubview:badImgView];
    [badImgView release];
    
    UILabel *badLab = [[UILabel alloc]init];
    badLab.font = [UIFont systemFontOfSize:14.f];
    badLab.text = [NSString stringWithFormat:@"%d",tObj.badCount];
    badLab.backgroundColor = [UIColor clearColor];
    badLab.frame = CGRectMake(135, 250, 40, 20);
    [self.view addSubview:badLab];
    [badLab release];
    
    UILabel *sayLab = [[UILabel alloc]init];
    sayLab.text = @"TA这样说";
    sayLab.frame=CGRectMake(20, 290, 100, 20);
    sayLab.backgroundColor = [UIColor clearColor];
    [self.view addSubview:sayLab];
    [sayLab release];
    
    UILabel *sayValueLab = [[UILabel alloc]init];
    sayValueLab.text = tObj.info;
    sayValueLab.frame= CGRectMake(20, 330, 100, 20);
    sayValueLab.backgroundColor = [UIColor clearColor];
    [self.view addSubview:sayValueLab];
    
    UILabel *qfLab = [[UILabel alloc]init];
    qfLab.text     = @"TA的资历";
    qfLab.backgroundColor = [UIColor clearColor];
    qfLab.frame    = CGRectMake(20, 370, 100, 20);
    [self.view addSubview:qfLab];
    [qfLab release];
}

- (void) getTeacherDetail
{
    NSString *ssid      = [[NSUserDefaults standardUserDefaults] objectForKey:SSID];
    NSArray  *paramsArr = [NSArray arrayWithObjects:@"action",@"teacher_phone",@"sessid",nil];
    NSArray  *valuesArr = [NSArray arrayWithObjects:@"getTeacher",tObj.phoneNums,ssid,nil];
    NSDictionary  *pDic = [NSDictionary dictionaryWithObjects:valuesArr
                                                      forKeys:paramsArr];
    NSString *webAdd = [[NSUserDefaults standardUserDefaults] objectForKey:WEBADDRESS];
    NSString *url    = [NSString stringWithFormat:@"%@%@", webAdd, STUDENT];
    
    ServerRequest *request = [ServerRequest sharedServerRequest];
    request.delegate = self;
    [request requestASyncWith:kServerPostRequest
                     paramDic:pDic
                       urlStr:url];
}

- (void) doBackBtnClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark - ServerRequest Delegate
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
        NSDictionary *tDic = [resDic objectForKey:@"teacherInfo"];
        tObj = [Teacher setTeacherProperty:tDic];
        
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
