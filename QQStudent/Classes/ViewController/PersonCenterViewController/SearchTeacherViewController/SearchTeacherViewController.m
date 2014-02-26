//
//  SearchTeacherViewController.m
//  QQStudent
//
//  Created by lynn on 14-1-29.
//  Copyright (c) 2014年 lynn. All rights reserved.
//

#import "SearchTeacherViewController.h"

@interface SearchTeacherViewController ()

@end

@implementation SearchTeacherViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.tabBarItem.title = @"搜索";
        self.tabBarItem.image = [UIImage imageNamed:@"user_2_1"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initUI];
}

- (void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (void) viewDidAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewDidUnload
{
    searchFld = nil;
    searchFld.delegate = nil;
    
    searchTab.delegate   = nil;
    searchTab.dataSource = nil;
    
    searchLab = nil;
    searchTab = nil;
    
    [searchArray  removeAllObjects];
    [super viewDidUnload];
}

- (void) dealloc
{
    [bgInfoLab release];
    [bgImgView release];
    [searchTab release];
    [searchArray release];
    
    [searchLab release];
    [searchFld release];
    [super dealloc];
}

#pragma mark -
#pragma mark - Custom Action
- (void) initUI
{
    self.view.backgroundColor = [UIColor colorWithHexString:@"#E1E0DE"];
    
    searchTab = [[UITableView alloc]init];
    searchTab.delegate   = self;
    searchTab.dataSource = self;
    searchTab.backgroundColor = [UIColor colorWithHexString:@"#E1E0DE"];
    searchTab.frame = [UIView fitCGRect:CGRectMake(0, 10, 320, 300)
                             isBackView:NO];
    [self.view addSubview:searchTab];
    
    UIImage *bgImg = [UIImage imageNamed:@"pp_nodata_bg"];
    bgImgView      = [[UIImageView alloc]initWithImage:bgImg];
    bgImgView.frame= [UIView fitCGRect:CGRectMake(160-50,
                                                  280/2-40,
                                                  100,
                                                  80)
                            isBackView:NO];
    [self.view addSubview:bgImgView];
    
    bgInfoLab = [[UILabel alloc]init];
    bgInfoLab.text  = @"输入手机号/前14位身份证号/9位搜索码";
    bgInfoLab.frame = [UIView fitCGRect:CGRectMake(10, 200, 300, 20)
                             isBackView:NO];
    bgInfoLab.backgroundColor = [UIColor clearColor];
    bgInfoLab.font            = [UIFont systemFontOfSize:14.f];
    bgInfoLab.textColor       = [UIColor lightGrayColor];
    bgInfoLab.textAlignment   = NSTextAlignmentCenter;
    [self.view addSubview:bgInfoLab];
    
    searchArray = [[NSMutableArray alloc]init];
    
    searchLab = [[UILabel alloc]init];
    searchLab.text  = @"搜索:";
    searchLab.font  = [UIFont systemFontOfSize:14];
    searchLab.backgroundColor = [UIColor clearColor];
    searchLab.frame = [UIView fitCGRect:CGRectMake(0, 372-50, 40, 20)
                             isBackView:NO];
    [self.view addSubview:searchLab];
    
    UIImage *okImg  = [UIImage imageNamed:@"sp_search_btn_normal"];
    UIImageView *fldBgImgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"normal_fld"]];
    fldBgImgView.frame = [UIView fitCGRect:CGRectMake(33, 372-55, 230, okImg.size.height-3)
                                isBackView:NO];
    [self.view addSubview:fldBgImgView];
    [fldBgImgView release];
    
    searchFld = [[UITextField alloc]init];
    searchFld.delegate = self;
    searchFld.font  = [UIFont systemFontOfSize:14];
    searchFld.placeholder = @"输入手机号/前14位身份证号/9位搜索码";
    searchFld.frame = [UIView fitCGRect:CGRectMake(38, 372-48, 225, okImg.size.height-3)
                             isBackView:NO];
    [self.view addSubview:searchFld];
    
    UIButton *okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [okBtn setTitle:@"确定"
           forState:UIControlStateNormal];
    [okBtn setTitleColor:[UIColor blackColor]
                forState:UIControlStateNormal];
    okBtn.titleLabel.font = [UIFont systemFontOfSize:14.f];
    [okBtn setBackgroundImage:okImg
                     forState:UIControlStateNormal];
    okBtn.frame = [UIView fitCGRect:CGRectMake(320-10-okImg.size.width,
                                               372-55,
                                               okImg.size.width,
                                               okImg.size.height-3)
                         isBackView:NO];
    [okBtn addTarget:self
              action:@selector(doOkBtnClicked:)
    forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:okBtn];
}

- (void) doOkBtnClicked:(id)sender
{
    [self repickView:self.view];
    [searchFld resignFirstResponder];
    
    if (searchFld.text.length == 0)
    {
        return;
    }
    
    if ((searchFld.text.length!=14) && (searchFld.text.length!=9)
                                    && (searchFld.text.length!=11))
    {
        [self showAlertWithTitle:@"提示"
                             tag:0
                         message:@"输入手机号/前14位身份证号/9位搜索码"
                        delegate:self
               otherButtonTitles:@"确定",nil];
    }
    
    //搜索老师
    [self searchTeacherFromServer];
}

- (void) searchTeacherFromServer
{
    NSString *ssid = [[NSUserDefaults standardUserDefaults] objectForKey:SSID];
    NSArray *paramsArr = [NSArray arrayWithObjects:@"action",@"text",@"sessid", nil];
    NSArray *valusArr  = [NSArray arrayWithObjects:@"findTeacher",
                                                   searchFld.text,ssid, nil];
    NSDictionary *pDic = [NSDictionary dictionaryWithObjects:valusArr
                                                     forKeys:paramsArr];
    ServerRequest *serverReq = [ServerRequest sharedServerRequest];
    serverReq.delegate       = self;
    NSString *webAddress     = [[NSUserDefaults standardUserDefaults] valueForKey:WEBADDRESS];
    NSString *url = [NSString stringWithFormat:@"%@%@/", webAddress,STUDENT];
    [serverReq requestASyncWith:kServerPostRequest
                       paramDic:pDic
                         urlStr:url];
}

#pragma mark -
#pragma mark - UITextFieldDelegate
- (void) textFieldDidBeginEditing:(UITextField *)textField
{
    self.view.frame = CGRectMake(0, 0, 320, 430);
    [self moveViewWhenViewHidden:textField parent:self.view];
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [self repickView:self.view];
    [textField resignFirstResponder];
    return YES;
}

#pragma mark -
#pragma mark - UITableViewDelegate And UITableViewDataSource
- (int) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (int) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (searchArray.count>0)
    {
        bgInfoLab.hidden = YES;
        bgImgView.hidden = YES;
    }
    else
    {
        bgInfoLab.hidden = NO;
        bgImgView.hidden = NO;
    }
    
    return searchArray.count;
}

- (float) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *idString = @"idString";
    UITableViewCell *cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault
                                                   reuseIdentifier:idString]autorelease];
    if (cell)
    {
        Teacher *tObj = [searchArray objectAtIndex:indexPath.row];
        NSString *webAddress  = [[NSUserDefaults standardUserDefaults] objectForKey:WEBADDRESS];
        NSString *imgUrl = [NSString stringWithFormat:@"%@%@",webAddress,tObj.headUrl];
        
        headBtn = [UIButton buttonWithType:UIButtonTypeCustom];//[[UIImageView alloc]init];
        headBtn.frame = CGRectMake(10, 10, 60, 60);
        [cell addSubview:headBtn];
        
        TTImageView *hImgView = [[[TTImageView alloc]init]autorelease];
        hImgView.delegate = self;
        hImgView.URL      = imgUrl;
        
        UILabel *itrLab = [[UILabel alloc]init];
        if (tObj.sex==1)
        {
//            headImgView.image = [UIImage imageNamed:@"sp_abook_btn"];
            itrLab.text = [NSString stringWithFormat:@"%@ %@ %@",tObj.name,@"男",tObj.pf];
        }
        else
        {
//            headImgView.image = [UIImage imageNamed:@"sp_head_img"];
            itrLab.text = [NSString stringWithFormat:@"%@ %@ %@",tObj.name,@"女",tObj.pf];
        }
        itrLab.backgroundColor = [UIColor clearColor];
        itrLab.frame = CGRectMake(80, 0, 200, 20);
        itrLab.font  = [UIFont systemFontOfSize:12.f];
        [cell addSubview:itrLab];
        [itrLab release];
        
        UILabel *cntLab = [[UILabel alloc]init];
        cntLab.text = [NSString stringWithFormat:@"辅导%d个学生", tObj.studentCount];
        cntLab.backgroundColor = [UIColor clearColor];
        cntLab.frame = CGRectMake(80, 20, 200, 20);
        cntLab.font  = [UIFont systemFontOfSize:12.f];
        [cell addSubview:cntLab];
        [cntLab release];
        
        UILabel *idLab = [[UILabel alloc]init];
        idLab.text = tObj.idNums;
        idLab.backgroundColor = [UIColor clearColor];
        idLab.frame = CGRectMake(80, 40, 200, 20);
        idLab.font  = [UIFont systemFontOfSize:12.f];
        [cell addSubview:idLab];
        [idLab release];
        
        UIStartsImageView *sImgView = [[UIStartsImageView alloc]initWithFrame:CGRectMake(80, 60, 100, 20)];
        [sImgView setHlightStar:tObj.comment];
        [cell addSubview:sImgView];
        [sImgView release];
    }
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Teacher *tObj = [searchArray objectAtIndex:indexPath.row];

    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UINavigationController *nav    = (UINavigationController *)app.window.rootViewController;
    
    //订单编辑
    SearchConditionViewController *scVctr = [[SearchConditionViewController alloc]init];
    scVctr.tObj = tObj;
    [nav pushViewController:scVctr animated:YES];
    //    [self.navigationController pushViewController:scVctr
//                                         animated:YES];
    [scVctr release];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -
#pragma mark - TTImageViewDelegate
- (void)imageView:(TTImageView*)imageView didLoadImage:(UIImage*)image
{
    CLog(@"Enter LoadImage");
    [headBtn setImage:[UIImage circleImage:image withParam:0]
             forState:UIControlStateNormal];
}

- (void)imageView:(TTImageView*)imageView didFailLoadWithError:(NSError*)error
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
        NSArray *tearchArray = [resDic objectForKey:@"teachers"];
        for (NSDictionary *item in tearchArray)
        {
            Teacher *tObj = [Teacher setTeacherProperty:item];
            [searchArray addObject:tObj];
        }
        [searchTab reloadData];
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
