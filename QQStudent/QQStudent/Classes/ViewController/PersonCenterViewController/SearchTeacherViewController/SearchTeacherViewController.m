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
    [self.view addSubview:searchTab];
    
    UIImage *bgImg = [UIImage imageNamed:@"pp_nodata_bg"];
    bgImgView      = [[UIImageView alloc]initWithImage:bgImg];
    
    [self.view addSubview:bgImgView];
    
    UIImage *okImg  = [UIImage imageNamed:@"sp_search_btn_normal"];
    bgInfoLab = [[UILabel alloc]init];
    bgInfoLab.text  = @"输入手机号/前14位身份证号/9位搜索码";

    bgInfoLab.backgroundColor = [UIColor clearColor];
    bgInfoLab.font            = [UIFont systemFontOfSize:14.f];
    bgInfoLab.textColor       = [UIColor lightGrayColor];
    bgInfoLab.textAlignment   = NSTextAlignmentCenter;
    [self.view addSubview:bgInfoLab];
    
    offset = 0;
    searchArray = [[NSMutableArray alloc]init];
    
    
    searchLab = [[UILabel alloc]init];
    searchLab.text  = @"搜索:";
    searchLab.font  = [UIFont systemFontOfSize:14];
    searchLab.backgroundColor = [UIColor clearColor];

    [self.view addSubview:searchLab];
    
    UIImageView *fldBgImgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cp_input_bg"]];

    [self.view addSubview:fldBgImgView];
    [fldBgImgView release];
    
    searchFld = [[UITextField alloc]init];
    searchFld.delegate = self;
    searchFld.font  = [UIFont systemFontOfSize:14];
    searchFld.placeholder = @"输入手机号/前14位身份证号/9位搜索码";

    searchFld.backgroundColor = [UIColor clearColor];
    [self.view addSubview:searchFld];
    
    UIButton *okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [okBtn setTitle:@"确定"
           forState:UIControlStateNormal];
    [okBtn setTitleColor:[UIColor blackColor]
                forState:UIControlStateNormal];
    okBtn.titleLabel.font = [UIFont systemFontOfSize:14.f];
    [okBtn setBackgroundImage:okImg
                     forState:UIControlStateNormal];
 
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7)
    {
        if (iPhone5)
        {
            //ios7 iphone5
            CLog(@"It's is iphone5 IOS7");
            searchTab.frame = [UIView fitCGRect:CGRectMake(0, 44, 320, 480)
                                     isBackView:YES];
            bgImgView.frame= [UIView fitCGRect:CGRectMake(160-50,
                                                          280/2-40+44,
                                                          100,
                                                          80)
                                    isBackView:NO];
            bgInfoLab.frame = [UIView fitCGRect:CGRectMake(10, 480-44-44-okImg.size.height/2-8-5, 300, 20)
                                     isBackView:NO];
            searchLab.frame = [UIView fitCGRect:CGRectMake(5, 480-44-44-20-5, 40, 20)
                                     isBackView:NO];
            fldBgImgView.frame = [UIView fitCGRect:CGRectMake(38, 480-44-44-24-5,
                                                              320-10-okImg.size.width-searchLab.frame.size.width+7,
                                                              okImg.size.height-3)
                                        isBackView:NO];
            searchFld.frame = [UIView fitCGRect:CGRectMake(searchLab.frame.size.width+5,
                                                           480-44-44-22-5,
                                                           320-10-okImg.size.width-searchLab.frame.size.width-5,
                                                           okImg.size.height-7)
                                     isBackView:NO];
            okBtn.frame = [UIView fitCGRect:CGRectMake(320-10-okImg.size.width+5,
                                                       480-44-44-24-5,
                                                       okImg.size.width,
                                                       okImg.size.height-3)
                                 isBackView:NO];
        }
        else
        {
            CLog(@"It's is iphone4 IOS7");
            //ios 7 iphone 4
            searchTab.frame = [UIView fitCGRect:CGRectMake(0, 44, 320, 480)
                                     isBackView:YES];
            bgImgView.frame= [UIView fitCGRect:CGRectMake(160-50,
                                                          280/2-40+44,
                                                          100,
                                                          80)
                                    isBackView:NO];
            bgInfoLab.frame = [UIView fitCGRect:CGRectMake(10, 480-44-44-okImg.size.height/2-8-5, 300, 20)
                                     isBackView:NO];
            searchLab.frame = [UIView fitCGRect:CGRectMake(5, 480-44-44-20-5, 40, 20)
                                     isBackView:NO];
            fldBgImgView.frame = [UIView fitCGRect:CGRectMake(38, 480-44-44-24-5,
                                                              320-10-okImg.size.width-searchLab.frame.size.width+7,
                                                              okImg.size.height-3)
                                        isBackView:NO];
            searchFld.frame = [UIView fitCGRect:CGRectMake(searchLab.frame.size.width+5,
                                                           480-44-44-22-5,
                                                           320-10-okImg.size.width-searchLab.frame.size.width-5,
                                                           okImg.size.height-7)
                                     isBackView:NO];
            okBtn.frame = [UIView fitCGRect:CGRectMake(320-10-okImg.size.width+5,
                                                       480-44-44-24-5,
                                                       okImg.size.width,
                                                       okImg.size.height-2.5)
                                 isBackView:NO];
        }
    }
    else
    {
        if (!iPhone5)
        {
            // ios 6 iphone4
            CLog(@"It's is iphone4 IOS6");
            searchTab.frame = [UIView fitCGRect:CGRectMake(0, 4, 320, 480)
                                     isBackView:YES];
            bgImgView.frame= [UIView fitCGRect:CGRectMake(160-50,
                                                          280/2-40+54-5,
                                                          100,
                                                          80)
                                    isBackView:NO];
            bgInfoLab.frame = [UIView fitCGRect:CGRectMake(10, 480-44-44-okImg.size.height/2-8-20, 300, 20)
                                     isBackView:NO];
            searchLab.frame = [UIView fitCGRect:CGRectMake(5, 480-44-44-20-20, 40, 20)
                                     isBackView:NO];
            fldBgImgView.frame = [UIView fitCGRect:CGRectMake(38, 480-44-44-24-20,
                                                              320-10-okImg.size.width-searchLab.frame.size.width+7,
                                                              okImg.size.height-3)
                                        isBackView:NO];
            searchFld.frame = [UIView fitCGRect:CGRectMake(searchLab.frame.size.width+5,
                                                           480-44-44-22-15,
                                                           320-10-okImg.size.width-searchLab.frame.size.width-5,
                                                           okImg.size.height-7)
                                     isBackView:NO];
            okBtn.frame = [UIView fitCGRect:CGRectMake(320-10-okImg.size.width+5,
                                                       480-44-44-24-20,
                                                       okImg.size.width,
                                                       okImg.size.height-2.7)
                                 isBackView:NO];
            
        }
        else
        {
            //ios 6 iphone5
            CLog(@"It's is iphone5 IOS6");
            searchTab.frame = [UIView fitCGRect:CGRectMake(0, 4, 320, 480)
                                     isBackView:YES];
            bgImgView.frame= [UIView fitCGRect:CGRectMake(160-50,
                                                          280/2-40+44,
                                                          100,
                                                          80)
                                    isBackView:NO];
            bgInfoLab.frame = [UIView fitCGRect:CGRectMake(10, 480-44-44-okImg.size.height/2-8-5, 300, 20)
                                     isBackView:NO];
            searchLab.frame = [UIView fitCGRect:CGRectMake(5, 480-44-44-20-5, 40, 20)
                                     isBackView:NO];
            fldBgImgView.frame = [UIView fitCGRect:CGRectMake(38, 480-44-44-24-5,
                                                              320-10-okImg.size.width-searchLab.frame.size.width+7,
                                                              okImg.size.height-3)
                                        isBackView:NO];
            searchFld.frame = [UIView fitCGRect:CGRectMake(searchLab.frame.size.width+5,
                                                           480-44-44-22,
                                                           320-10-okImg.size.width-searchLab.frame.size.width-5,
                                                           okImg.size.height-7)
                                     isBackView:NO];
            okBtn.frame = [UIView fitCGRect:CGRectMake(320-10-okImg.size.width+5,
                                                       480-44-44-24-5,
                                                       okImg.size.width,
                                                       okImg.size.height-2.7)
                                 isBackView:NO];
        }
    }
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
    if (![AppDelegate isConnectionAvailable:YES withGesture:NO])
    {
        return;
    }
    
    [searchArray removeAllObjects];
    
    CustomNavigationViewController *nav = [MainViewController getNavigationViewController];
    [MBProgressHUD showHUDAddedTo:nav.view animated:YES];
    
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
    self.view.frame = [UIView fitCGRect:CGRectMake(0, 0, 320, 480)
                             isBackView:YES];
    [self moveViewWhenViewHidden:textField parent:self.view];
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [self repickView:self.view];
    [textField resignFirstResponder];
    return YES;
}

#pragma mark -
#pragma mark - UIViewController Custom Methods
- (void) repickView:(UIView *)parent
{
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    
    [UIView setAnimationDuration:animationDuration];
    CGRect rect  = CGRectMake(parent.frame.origin.x,
                              parent.frame.origin.y+offset,
                              parent.frame.size.width,
                              parent.frame.size.height);
    parent.frame = rect;
    
    [UIView commitAnimations];
    
    offset = 0;
}

- (void) moveViewWhenViewHidden:(UIView *)view parent:(UIView *) parentView
{
    //键盘高度216
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyBoard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    offset = 180;
    
    int width  = parentView.frame.size.width;
    int height = parentView.frame.size.height;
    CGRect rect= CGRectMake(parentView.frame.origin.x,
                            parentView.frame.origin.y-offset,width, height);
    parentView.frame = rect;
    [UIView commitAnimations];
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
        
        headBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        headBtn.tag   = indexPath.row;
        headBtn.frame = CGRectMake(10, 10, 60, 60);
        [cell addSubview:headBtn];
        
        UILabel *itrLab = [[UILabel alloc]init];
        if (tObj.sex==1)
        {
            [headBtn setImage:[UIImage imageNamed:@"s_boy"]
                     forState:UIControlStateNormal];
            itrLab.text = [NSString stringWithFormat:@"%@ %@ %@",tObj.name,@"男",tObj.pf];
        }
        else
        {
            [headBtn setImage:[UIImage imageNamed:@"s_girl"]
                     forState:UIControlStateNormal];
            itrLab.text = [NSString stringWithFormat:@"%@ %@ %@",tObj.name,@"女",tObj.pf];
        }
        itrLab.backgroundColor = [UIColor clearColor];
        itrLab.frame = CGRectMake(80, 0, 200, 20);
        itrLab.font  = [UIFont systemFontOfSize:12.f];
        [cell addSubview:itrLab];
        [itrLab release];
        
        TTImageView *hImgView = [[[TTImageView alloc]init]autorelease];
        hImgView.delegate = self;
        hImgView.URL      = imgUrl;
        
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

    CustomNavigationViewController *nav    = (CustomNavigationViewController *)[MainViewController getNavigationViewController];
    
    //订单编辑
    SearchConditionViewController *scVctr = [[SearchConditionViewController alloc]init];
    scVctr.tObj = tObj;
    [nav pushViewController:scVctr animated:YES];
    [scVctr release];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -
#pragma mark - TTImageViewDelegate
- (void)imageView:(TTImageView*)imageView didLoadImage:(UIImage*)image
{
    CLog(@"Enter LoadImage");
    [headBtn setImage:[UIImage circleImage:image
                                 withParam:0
                                 withColor:[UIColor redColor]]
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
        NSArray *tearchArray = [resDic objectForKey:@"teachers"];
        for (NSDictionary *item in tearchArray)
        {
            Teacher *tObj = [Teacher setTeacherProperty:item];
            tObj.pf  = [[item objectForKey:@"subject"] copy];
            NSString *genderId = [[item objectForKey:@"genderId"] copy];
            if (genderId)
                tObj.sex = genderId.intValue;
            else
                tObj.sex = 0;
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
