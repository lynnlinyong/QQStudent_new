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

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [MainViewController setNavTitle:@"家教信息"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //获得老师个人信息
    [self getTeacherDetail];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) dealloc
{
    [bgScroll release];
    [bgImgView release];
    [headImageView release];
    [super dealloc];
}

#pragma mark -
#pragma mark - Custom Action
- (void) initUI
{
    bgScroll = [[UIScrollView alloc]init];
    bgScroll.delegate = self;
    bgScroll.frame    = [UIView fitCGRect:CGRectMake(0, 0, 320, 426)
                               isBackView:YES];
    bgScroll.contentSize   = CGSizeMake(320, 446);
    bgScroll.scrollEnabled = YES;
    bgScroll.backgroundColor = [UIColor colorWithHexString:@"#E1E0DE"];
    [self.view addSubview:bgScroll];
    
    NSString *webAdd = [[NSUserDefaults standardUserDefaults] objectForKey:WEBADDRESS];
    
    headImageView = [[UIImageView alloc]init];
    headImageView.frame = CGRectMake(110, 30, 100, 100);
    [bgScroll addSubview:headImageView];
    
    TTImageView *hImageView = [[TTImageView alloc]init];
    hImageView.delegate = self;
    hImageView.URL   = [NSString stringWithFormat:@"%@%@", webAdd,tObj.headUrl];
    
    UIImage *bgImg = [UIImage imageNamed:@"tdp_bg"];
    bgImgView = [[UIImageView alloc]initWithImage:bgImg];
    bgImgView.frame = CGRectMake(160-bgImg.size.width/2, 150,
                                 bgImg.size.width,
                                 bgImg.size.height);
    [bgScroll addSubview:bgImgView];
    
    UILabel *infoLab = [[UILabel alloc]init];
    infoLab.text  = [NSString stringWithFormat:@"%@  %@  %@", tObj.name, [Student searchGenderName:[NSString stringWithFormat:@"%d",tObj.sex]], tObj.pf];
    infoLab.frame = CGRectMake(35, 170, 120, 20);
    infoLab.backgroundColor = [UIColor clearColor];
    [bgScroll addSubview:infoLab];
    [infoLab release];
    
    UIStartsImageView *starImgView = [[UIStartsImageView alloc]initWithFrame:CGRectMake(180, 170, 100, 20)];
    [starImgView setHlightStar:tObj.comment];
    [bgScroll addSubview:starImgView];
    [starImgView release];

    UILabel *idNumsLab = [[UILabel alloc]init];
    idNumsLab.text = tObj.phoneNums;
    idNumsLab.frame= CGRectMake(35, 200, 120, 20);
    idNumsLab.backgroundColor = [UIColor clearColor];
    [bgScroll addSubview:idNumsLab];
    [idNumsLab release];

    UILabel *studyLab = [[UILabel alloc]init];
    studyLab.text     = [NSString stringWithFormat:@"已辅导%d位学生", tObj.studentCount];
    studyLab.frame    = CGRectMake(35, 230, 120, 20);
    studyLab.backgroundColor = [UIColor clearColor];
    [bgScroll addSubview:studyLab];
    [studyLab release];

    UILabel *commentLab = [[UILabel alloc]init];
    commentLab.text = @"口碑";
    commentLab.frame=CGRectMake(35, 260, 40, 20);
    commentLab.backgroundColor = [UIColor clearColor];
    [bgScroll addSubview:commentLab];
    [commentLab release];

    UIImageView *goodImgView = [[UIImageView alloc]init];
    goodImgView.image = [UIImage imageNamed:@"tdp_good_comment"];
    goodImgView.frame = CGRectMake(85, 260, 20, 20);
    [bgScroll addSubview:goodImgView];
    [goodImgView release];
    
    UILabel *goodLab = [[UILabel alloc]init];
    goodLab.font = [UIFont systemFontOfSize:14.f];
    goodLab.textColor = [UIColor redColor];
    goodLab.text = [NSString stringWithFormat:@"%d",tObj.goodCount];
    goodLab.backgroundColor = [UIColor clearColor];
    goodLab.frame = CGRectMake(115, 260, 20, 20);
    [bgScroll addSubview:goodLab];
    [goodLab release];
    
    UIImageView *badImgView = [[UIImageView alloc]init];
    badImgView.image = [UIImage imageNamed:@"tdp_bad_comment"];
    badImgView.frame = CGRectMake(145, 263, 20, 20);
    [bgScroll addSubview:badImgView];
    [badImgView release];
    
    UILabel *badLab = [[UILabel alloc]init];
    badLab.font = [UIFont systemFontOfSize:14.f];
    badLab.text = [NSString stringWithFormat:@"%d",tObj.badCount];
    badLab.backgroundColor = [UIColor clearColor];
    badLab.frame = CGRectMake(170, 260, 40, 20);
    [bgScroll addSubview:badLab];
    [badLab release];
    
    UIImage *lineImg = [UIImage imageNamed:@"tdp_splite_line"];
    UIImageView *lineImgView = [[UIImageView alloc]initWithImage:lineImg];
    lineImgView.frame = CGRectMake(0, 290,
                                   lineImg.size.width,
                                   lineImg.size.height);
    [bgScroll addSubview:lineImgView];
    [lineImgView release];

    UILabel *sayLab = [[UILabel alloc]init];
    sayLab.text = @"TA这样说";
    sayLab.frame=CGRectMake(35, 310, 100, 20);
    sayLab.backgroundColor = [UIColor clearColor];
    [bgScroll addSubview:sayLab];
    [sayLab release];
    
    UIImageView *topImgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"tdp_content_top"]];
    topImgView.frame = CGRectMake(0, 330, topImgView.frame.size.width,
                                  topImgView.frame.size.height);
    [bgScroll addSubview:topImgView];
    [topImgView release];
    
    UIImageView *bmImgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"tdp_content_bottom"]];
    bmImgView.frame = CGRectMake(0, 330+topImgView.frame.size.height-4,
                                                    bmImgView.frame.size.width,
                                                    bmImgView.frame.size.height+15);
    [bgScroll addSubview:bmImgView];
    [bmImgView release];
    
    if (tObj.info)
    {
        CGSize size = [tObj.info sizeWithFont:[UIFont systemFontOfSize:14.f]
                            constrainedToSize:CGSizeMake(bmImgView.frame.size.width, MAXFLOAT)];
        bmImgView.frame = CGRectMake(bmImgView.frame.origin.x,
                                     bmImgView.frame.origin.y,
                                     bmImgView.frame.size.width, size.height);
    }
    
    UILabel *sayValueLab = [[UILabel alloc]init];
    sayValueLab.text = tObj.info;
    sayValueLab.font = [UIFont systemFontOfSize:14.f];
    sayValueLab.frame= CGRectMake(45, topImgView.frame.origin.y+8, 240, 20);
    sayValueLab.backgroundColor = [UIColor clearColor];
    sayValueLab.lineBreakMode   = NSLineBreakByWordWrapping;
    sayValueLab.numberOfLines   = 0;
    [bgScroll addSubview:sayValueLab];
    [sayValueLab release];

    UILabel *qfLab = [[UILabel alloc]init];
    qfLab.text     = @"TA的资历";
    qfLab.backgroundColor = [UIColor clearColor];
    qfLab.frame    = CGRectMake(35,
                                bmImgView.frame.origin.y+bmImgView.frame.size.height+10,
                                100, 20);
    [bgScroll addSubview:qfLab];
    [qfLab release];
    
    //判断是否有资历照片,设置Scroll高度
    if (tObj.certArray)
    {
        for(int i=0; i<tObj.certArray.count; i++)
        {
            NSString *url = [tObj.certArray objectAtIndex:i];
            NSString *webAdd = [[NSUserDefaults standardUserDefaults] objectForKey:WEBADDRESS];
            url = [NSString stringWithFormat:@"%@%@", webAdd,url];
            
            TTImageView *certImgView = [[TTImageView alloc]init];
            certImgView.tag      = 1111;
            certImgView.delegate = self;
            certImgView.URL      = url;
            UIImage *defaultImg  = [UIImage imageNamed:@"tdp_cert_default_bg"];
            certImgView.defaultImage = defaultImg;
            if (i==0)
                certImgView.frame = CGRectMake(40,
                                              bmImgView.frame.origin.y+bmImgView.frame.size.height+40,
                                              50,
                                              80);
            else
                certImgView.frame = CGRectMake(40+i*70,
                                           bmImgView.frame.origin.y+bmImgView.frame.size.height+40,
                                           50,
                                           80);
            [bgScroll addSubview:certImgView];
        }
        
        //修改背景高度
        CGRect rect = CGRectMake(bgImgView.frame.origin.x,
                                 150,
                                 bgImgView.frame.size.width,
                                 bgImgView.frame.size.height+80);
        bgImgView.frame = rect;
        
        bgScroll.contentSize = CGSizeMake(bgScroll.contentSize.width,
                                          bgScroll.contentSize.height+80);
    }
}

- (void) getTeacherDetail
{
    CustomNavigationViewController *nav = [MainViewController getNavigationViewController];
    [MBProgressHUD showHUDAddedTo:nav.view animated:YES];
    
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

#pragma mark - 
#pragma mark - TTImageViewDelegate
- (void) imageView:(TTImageView *)imageView didLoadImage:(UIImage *)image
{
    if (imageView.tag == 1111)
    {
        //修改TTImageView的高度
        imageView.frame = CGRectMake(imageView.frame.origin.x,
                                     imageView.frame.origin.y,
                                     imageView.frame.size.width, 80);
        
        //修改背景高度
        CGRect rect = CGRectMake(bgImgView.frame.origin.x,
                                 150,
                                 bgImgView.frame.size.width,
                                 bgImgView.frame.size.height);
        bgImgView.frame = rect;
    
        bgScroll.contentSize = CGSizeMake(bgScroll.contentSize.width,
                                          bgScroll.contentSize.height);
    }
    else
    {
        if (tObj.sex==1)
            headImageView.image = [UIImage circleImage:image
                                             withParam:0
                                             withColor:[UIColor greenColor]];
        else
            headImageView.image = [UIImage circleImage:image
                                             withParam:0
                                             withColor:[UIColor orangeColor]];
    }
}

- (void) imageView:(TTImageView *)imageView didFailLoadWithError:(NSError *)error
{
    
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
    
    CustomNavigationViewController *nav = [MainViewController getNavigationViewController];
    [MBProgressHUD hideHUDForView:nav.view animated:YES];
}

- (void) requestAsyncSuccessed:(ASIHTTPRequest *)request
{
    CustomNavigationViewController *nav = [MainViewController getNavigationViewController];
    [MBProgressHUD hideHUDForView:nav.view animated:YES];
    
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
