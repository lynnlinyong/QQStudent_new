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
    
    gradeArr = [[NSMutableArray alloc]initWithCapacity:0];
    
    [self initUI];
    
    //获得年级
    [self getGrade];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) dealloc
{
    [gradeArr release];
    [super dealloc];
}

#pragma mark -
#pragma mark - Custom Action
- (void) initUI
{
    UIImage *titleImg         = [UIImage imageNamed:@"dialog_title"];
    self.view.frame = [UIView fitCGRect:CGRectMake(0, 0,
                                                   titleImg.size.width,
                                                   358)
                             isBackView:NO];
    self.view.backgroundColor = [UIColor whiteColor];
    
    LBorderView *groupView = [[LBorderView alloc]initWithFrame:CGRectMake(-10, -5,
                                                                          self.view.frame.size.width+20,
                                                                          self.view.frame.size.height+10)];
    groupView.borderType   = BorderTypeSolid;
    groupView.dashPattern  = 8;
    groupView.spacePattern = 8;
    groupView.borderWidth  = 1;
    groupView.cornerRadius = 5;
    groupView.borderColor  = [UIColor whiteColor];
    groupView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:groupView];
    
    UIImageView *titleImgView = [[UIImageView alloc]init];
    titleImgView.frame = [UIView fitCGRect:CGRectMake(-2.5, -2,
                                                      groupView.frame.size.width+5, titleImg.size.height)
                                isBackView:NO];
    titleImgView.image = titleImg;
    [groupView addSubview:titleImgView];
    [titleImgView release];
    
    
    UILabel *titleLab = [[UILabel alloc]init];
    titleLab.text  = @"选择年级";
    titleLab.textColor = [UIColor whiteColor];
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.frame= [UIView fitCGRect:CGRectMake(-2.5, -2,
                                                 groupView.frame.size.width+5, titleImg.size.height)
                           isBackView:NO];
    titleLab.backgroundColor = [UIColor clearColor];
    titleLab.textAlignment   = NSTextAlignmentCenter;
    [groupView addSubview:titleLab];
    [titleLab release];
    
    UIImage *bottomImg= [UIImage imageNamed:@"dialog_bottom"];
    gdView = [[UIGridView alloc]init];
    gdView.uiGridViewDelegate = self;
    gdView.scrollEnabled = NO;
    gdView.frame = [UIView fitCGRect:CGRectMake(0, 20, 240, 338-bottomImg.size.height)
                          isBackView:NO];
    [self.view addSubview:gdView];
    
    UIImageView *bottomImgView = [[UIImageView alloc]init];
    bottomImgView.image = bottomImg;
    bottomImgView.frame = [UIView fitCGRect:CGRectMake(-11,
                                                       self.view.frame.size.height-bottomImg.size.height+6,
                                                       self.view.frame.size.width+23, bottomImg.size.height)
                                 isBackView:NO];
    [self.view addSubview:bottomImgView];
    [bottomImgView release];
    
    UIImage *okBtnImg = [UIImage imageNamed:@"dialog_ok_normal_btn"];
    UIButton *okBtn   = [UIButton buttonWithType:UIButtonTypeCustom];
    okBtn.tag   = 0;
    [okBtn setTitleColor:[UIColor blackColor]
                forState:UIControlStateNormal];
    okBtn.titleLabel.font = [UIFont systemFontOfSize:13.f];
    okBtn.frame = CGRectMake(self.view.frame.size.width/2-okBtnImg.size.width-10,
                             self.view.frame.size.height-okBtnImg.size.height+3,
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
                                 self.view.frame.size.height-cancelImg.size.height+3,
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
}

- (void) getGrade
{
    NSString *ssid     = [[NSUserDefaults standardUserDefaults] objectForKey:SSID];
    NSArray *paramsArr = [NSArray arrayWithObjects:@"action",@"sessid", nil];
    NSArray *valuesArr = [NSArray arrayWithObjects:@"getgrade",ssid, nil];
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

#pragma mark -
#pragma mark - Control Event
- (void) doButtonClicked:(id)sender
{
    UIButton *button = sender;
    NSDictionary *gradDic = [gradeArr objectAtIndex:index];
    NSDictionary *userDic = [NSDictionary dictionaryWithObjectsAndKeys:gradDic,@"UserInfo",
                             [NSNumber numberWithInt:button.tag],@"TAG", nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"setGradeNotice"
                                                        object:nil
                                                      userInfo:userDic];

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
    return 44;
}

- (NSInteger) numberOfColumnsOfGridView:(UIGridView *) grid
{
    return 2;
}

- (NSInteger) numberOfCellsOfGridView:(UIGridView *) grid
{
    return gradeArr.count;
}

- (UIGridViewCell *) gridView:(UIGridView *)grid cellForRowAt:(int)rowIndex AndColumnAt:(int)columnIndex
{
    NSString *idString = @"idString";
    UIGridViewCell *cell = [grid dequeueReusableCellWithIdentifier:idString];
    if (!cell)
    {
        cell = [[[UIGridViewCell alloc]init]autorelease];
    }
    
    NSDictionary *gradDic = nil;
    if ([gradeArr count]>0)
        gradDic = [gradeArr objectAtIndex:rowIndex*2+columnIndex];
    
    QRadioButton *qrBtn = [[QRadioButton alloc]initWithDelegate:self
                                                        groupId:@"grade"];
    qrBtn.tag = rowIndex*2+columnIndex;
    [qrBtn setTitle:[gradDic objectForKey:@"name"]
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
        gradeArr = [[resDic objectForKey:@"grades"] copy];
        
        //保存年级列表
        [[NSUserDefaults standardUserDefaults] setObject:gradeArr
                                                  forKey:GRADE_LIST];
        
        
        [gdView reloadData];
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
