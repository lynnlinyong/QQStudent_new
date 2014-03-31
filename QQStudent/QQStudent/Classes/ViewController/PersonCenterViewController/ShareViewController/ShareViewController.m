//
//  ShareViewController.m
//  QQStudent
//
//  Created by lynn on 14-1-29.
//  Copyright (c) 2014年 lynn. All rights reserved.
//

#import "ShareViewController.h"

@interface ShareViewController ()

@end

@implementation ShareViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.tabBarItem = [[UITabBarItem alloc]initWithTitle:@""
                                                       image:[UIImage imageNamed:@"icon_setting.png"]
                                                         tag:0];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //初始化UI
    [self initUI];
    
    //获取分享内容
    [self getShareContentFromServer];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(getDismissView:)
                                                 name:@"dismissView"
                                               object:nil];
}

- (void) viewDidDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];   
    
    [super viewDidDisappear:animated];
}

- (void) viewDidUnload
{
    [super viewDidUnload];
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
    [MainViewController setNavTitle:@"个人中心"];
    
    UIImage *cellBgImg = [UIImage imageNamed:@"sp_content_normal_cell"];
    shareTab = [[UITableView alloc]init];
    if ([shareTab respondsToSelector:@selector(setSeparatorInset:)]) {
        [shareTab setSeparatorInset:UIEdgeInsetsZero];
    }
    shareTab.delegate   = self;
    shareTab.dataSource = self;

    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7)
    {
        if (iPhone5)
        {
            //ios7 iphone5
            CLog(@"It's is iphone5 IOS7");
            shareTab.frame      = [UIView fitCGRect:CGRectMake(40, 100, cellBgImg.size.width, 240)
                                         isBackView:NO];
        }
        else
        {
            CLog(@"It's is iphone4 IOS7");
            //ios 7 iphone 4
            shareTab.frame      = [UIView fitCGRect:CGRectMake(40, 100, cellBgImg.size.width, 240)
                                         isBackView:NO];
        }
    }
    else
    {
        if (!iPhone5)
        {
            // ios 6 iphone4
            CLog(@"It's is iphone4 IOS6");
            shareTab.frame      = [UIView fitCGRect:CGRectMake(40, 80, cellBgImg.size.width, 240)
                                         isBackView:NO];
            
        }
        else
        {
            //ios 6 iphone5
            CLog(@"It's is iphone5 IOS6");
            shareTab.frame      = [UIView fitCGRect:CGRectMake(40, 100, cellBgImg.size.width, 240)
                                         isBackView:NO];
        }
    }
    shareTab.scrollEnabled = NO;
    shareTab.separatorStyle  = UITableViewCellSeparatorStyleNone;
    shareTab.backgroundColor = [UIColor colorWithHexString:@"#e1e0de"];
    [self.view addSubview:shareTab];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#e1e0de"];
}

- (void) getShareContentFromServer
{
    if (![AppDelegate isConnectionAvailable:YES withGesture:NO])
    {
        return;
    }
    
    NSString *ssid = [[NSUserDefaults standardUserDefaults] objectForKey:SSID];
    NSArray *paramsArr = [NSArray arrayWithObjects:@"action",@"sessid", nil];
    NSArray *valuesArr = [NSArray arrayWithObjects:@"getShareSet",ssid, nil];
    NSDictionary *pDic = [NSDictionary dictionaryWithObjects:valuesArr
                                                     forKeys:paramsArr];
    
    NSString *webAdd   = [[NSUserDefaults standardUserDefaults] objectForKey:WEBADDRESS];
    if (!webAdd)
    {
        CustomNavigationViewController *nav = [MainViewController getNavigationViewController];
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:nav.view
                                                  withText:@"服务器地址不可用"
                                                  animated:YES
                                                  delegate:NULL];
        [hud hide:YES afterDelay:3];
        return;
    }
    NSString *url      = [NSString stringWithFormat:@"%@%@", webAdd, STUDENT];
    ServerRequest *serverReq = [ServerRequest sharedServerRequest];
    serverReq.delegate = self;
    [serverReq requestASyncWith:kServerPostRequest
                       paramDic:pDic
                         urlStr:url];
}

- (void) setCellBgImage:(UIImage *)bgImg sender:(id)sender
{
    UIButton *btn = sender;
    for (UIView *view in btn.subviews)
    {
        if (view.tag == 110)
        {
            UIImageView *imgView = (UIImageView *)view;
            imgView.image = bgImg;
        }
    }
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
        NSString *action = [resDic objectForKey:@"action"];
        if ([action isEqualToString:@"getShareSet"])
        {
            CLog(@"shareContent:%@", resDic);
            [[NSUserDefaults standardUserDefaults] setObject:resDic
                                                      forKey:@"ShareContent"];
        }
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

#pragma mark -
#pragma mark - Control Event
- (void) doShareFrdBtnClicked:(id)sender
{
    [self setCellBgImage:[UIImage imageNamed:@"sp_content_normal_cell"]
                  sender:sender];
    CustomNavigationViewController *nav    = (CustomNavigationViewController *)[MainViewController getNavigationViewController];
    ShareAddressBookViewController *shareBook = [[ShareAddressBookViewController alloc]init];
    [nav pushViewController:shareBook animated:YES];
//    [self.navigationController pushViewController:shareBook
//                                         animated:YES];
    [shareBook release];
}

- (void) doShareWicoBtnClicked:(id)sender
{
    [self setCellBgImage:[UIImage imageNamed:@"sp_content_normal_cell"]
                  sender:sender];
    
    //检测是否安装微信,没有安装,提示安装
    if (![WXApi isWXAppInstalled])
    {
        CLog(@"NO Installed");
        [self showAlertWithTitle:@"提示"
                             tag:11
                         message:@"您尚未安装微信,马上去安装它!"
                        delegate:self
               otherButtonTitles:@"马上去",@"取消",nil];
    }
    else
    {
        CLog(@"YES Installed");
        ShareWeixinViewController *swVctr   = [[ShareWeixinViewController alloc]init];
        CustomNavigationViewController *nav = [MainViewController getNavigationViewController];
        [nav presentPopupViewController:swVctr
                          animationType:MJPopupViewAnimationFade];
    }
}

- (void) doShareSinaBtnClicked:(id)sender
{
    [self setCellBgImage:[UIImage imageNamed:@"sp_content_normal_cell"]
                  sender:sender];
    
    CustomNavigationViewController *nav    = (CustomNavigationViewController *)[MainViewController getNavigationViewController];
    SignalSinaWeibo *sgWeibo = [SignalSinaWeibo shareInstance:self];
    if (![sgWeibo.sinaWeibo isAuthValid])
    {
        BoundSinaViewController *bsVctr = [[BoundSinaViewController alloc]init];
        [nav pushViewController:bsVctr animated:YES];
        [bsVctr release];
    }
    else
    {
        
        ShareSinaViewController *sVctr = [[ShareSinaViewController alloc]init];
        [nav pushViewController:sVctr animated:YES];
        [sVctr release];
    }
}

- (void) doShareTecentBtnClicked:(id)sender
{
    [self setCellBgImage:[UIImage imageNamed:@"sp_content_normal_cell"]
                  sender:sender];
    
    SingleTCWeibo *tcWeibo = [SingleTCWeibo shareInstance];
    CustomNavigationViewController *nav    = (CustomNavigationViewController *)[MainViewController getNavigationViewController];
    if (![tcWeibo.tcWeiboApi isAuthValid])
    {
        BoundTecentViewController *btVctr = [[BoundTecentViewController alloc]init];
//        [self.navigationController pushViewController:btVctr
//                                             animated:YES];
        [nav pushViewController:btVctr animated:YES];
        [btVctr release];
    }
    else
    {
        ShareTecentViewController *stVctr = [[ShareTecentViewController alloc]init];
//        [self.navigationController pushViewController:stVctr
//                                             animated:YES];
        [nav pushViewController:stVctr animated:YES];
        [stVctr release];
    }
}

- (void) doButtonDowned:(id)sender
{
    [self setCellBgImage:[UIImage imageNamed:@"sp_content_hlight_cell"]
                  sender:sender];
}

#pragma mark - 
#pragma mark - UITabelViewDelegate and UITableViewDatasource
- (int) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (int) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (float) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *idString = @"idString";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:idString];
    if (!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault
                                     reuseIdentifier:idString];
    }
    
    cell.backgroundColor = [UIColor colorWithHexString:@"#e1e0de"];
    UIImage *cellBgImg = [UIImage imageNamed:@"sp_content_normal_cell"];
    switch (indexPath.row)
    {
        case 0:
        {
            UIImageView *bgImgView = [[UIImageView alloc]init];
            bgImgView.tag   = 110;
            bgImgView.image = cellBgImg;
            bgImgView.frame = CGRectMake(0,
                                         0,
                                         cellBgImg.size.width,
                                         cellBgImg.size.height);
            [cell addSubview:bgImgView];
            
            UIImage *iconImg = [UIImage imageNamed:@"sp_abook_btn"];
            UIImageView *iconImgView = [[UIImageView alloc]init];
            iconImgView.image = iconImg;
            iconImgView.frame = CGRectMake(6,
                                           5,
                                           cellBgImg.size.height-10,
                                           cellBgImg.size.height-10);
            [bgImgView addSubview:iconImgView];
            [iconImgView release];
            
            UILabel *titleLab = [[UILabel alloc]init];
            titleLab.text  = @"分享通讯录";
            titleLab.font  = [UIFont systemFontOfSize:14.f];
            titleLab.backgroundColor = [UIColor clearColor];
            titleLab.frame = CGRectMake(cellBgImg.size.height+10,
                                        cellBgImg.size.height/2-10,
                                        200, 20);
            [bgImgView addSubview:titleLab];
            [titleLab release];
            
            UIButton *shareFrdBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            shareFrdBtn.frame     = CGRectMake(0, 0,
                                               cellBgImg.size.width,
                                               cellBgImg.size.height);
            [shareFrdBtn addTarget:self
                            action:@selector(doShareFrdBtnClicked:)
                  forControlEvents:UIControlEventTouchUpInside|UIControlEventTouchUpOutside];
            [shareFrdBtn addSubview:bgImgView];
            [shareFrdBtn  addTarget:self
                             action:@selector(doButtonDowned:)
                   forControlEvents:UIControlEventTouchDown];
            [cell addSubview:shareFrdBtn];
            break;
        }
        case 1:
        {
            UIImageView *bgImgView = [[UIImageView alloc]init];
            bgImgView.tag   = 110;
            bgImgView.image = cellBgImg;
            bgImgView.frame = CGRectMake(0,
                                         0,
                                         cellBgImg.size.width,
                                         cellBgImg.size.height);
            [cell addSubview:bgImgView];
            
            UIImage *iconImg = [UIImage imageNamed:@"sp_wincon_btn"];
            UIImageView *iconImgView = [[UIImageView alloc]init];
            iconImgView.image = iconImg;
            iconImgView.frame = CGRectMake(6,
                                           5,
                                           cellBgImg.size.height-10,
                                           cellBgImg.size.height-10);
            [bgImgView addSubview:iconImgView];
            [iconImgView release];
            
            UILabel *titleLab = [[UILabel alloc]init];
            titleLab.text  = @"分享到微信";
            titleLab.font  = [UIFont systemFontOfSize:14.f];
            titleLab.backgroundColor = [UIColor clearColor];
            titleLab.frame = CGRectMake(cellBgImg.size.height+10,
                                        cellBgImg.size.height/2-10,
                                        200, 20);
            [bgImgView addSubview:titleLab];
            [titleLab release];
            
            UIButton *shareWicoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            shareWicoBtn.frame     = CGRectMake(0, 0,
                                               cellBgImg.size.width,
                                               cellBgImg.size.height);
            [shareWicoBtn addTarget:self
                            action:@selector(doShareWicoBtnClicked:)
                  forControlEvents:UIControlEventTouchUpInside|UIControlEventTouchUpOutside];
            [shareWicoBtn addSubview:bgImgView];
            [shareWicoBtn addTarget:self
                             action:@selector(doButtonDowned:)
                   forControlEvents:UIControlEventTouchDown];
            [cell addSubview:shareWicoBtn];
            break;
        }
        case 2:
        {
            UIImageView *bgImgView = [[UIImageView alloc]init];
            bgImgView.tag   = 110;
            bgImgView.image = cellBgImg;
            bgImgView.frame = CGRectMake(0,
                                         0,
                                         cellBgImg.size.width,
                                         cellBgImg.size.height);
            [cell addSubview:bgImgView];
            
            UIImage *iconImg = [UIImage imageNamed:@"sp_sina_btn"];
            UIImageView *iconImgView = [[UIImageView alloc]init];
            iconImgView.image = iconImg;
            iconImgView.frame = CGRectMake(6,
                                           5,
                                           cellBgImg.size.height-10,
                                           cellBgImg.size.height-10);
            [bgImgView addSubview:iconImgView];
            [iconImgView release];
            
            UILabel *titleLab = [[UILabel alloc]init];
            titleLab.text  = @"分享到新浪微博";
            titleLab.font  = [UIFont systemFontOfSize:14.f];
            titleLab.backgroundColor = [UIColor clearColor];
            titleLab.frame = CGRectMake(cellBgImg.size.height+10,
                                        cellBgImg.size.height/2-10,
                                        200, 20);
            [bgImgView addSubview:titleLab];
            [titleLab release];
            
            UIButton *shareSinaBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            shareSinaBtn.frame     = CGRectMake(0, 0,
                                                cellBgImg.size.width,
                                                cellBgImg.size.height);
            [shareSinaBtn addTarget:self
                             action:@selector(doShareSinaBtnClicked:)
                   forControlEvents:UIControlEventTouchUpInside|UIControlEventTouchUpOutside];
            [shareSinaBtn addTarget:self
                               action:@selector(doButtonDowned:)
                     forControlEvents:UIControlEventTouchDown];
            [shareSinaBtn addSubview:bgImgView];
            [cell addSubview:shareSinaBtn];
            break;
        }
        case 3:
        {
            UIImageView *bgImgView = [[UIImageView alloc]init];
            bgImgView.tag   = 110;
            bgImgView.image = cellBgImg;
            bgImgView.frame = CGRectMake(0,
                                         0,
                                         cellBgImg.size.width,
                                         cellBgImg.size.height);
            [cell addSubview:bgImgView];
            
            UIImage *iconImg = [UIImage imageNamed:@"sp_tecent_btn"];
            UIImageView *iconImgView = [[UIImageView alloc]init];
            iconImgView.image = iconImg;
            iconImgView.frame = CGRectMake(6,
                                           5,
                                           cellBgImg.size.height-10,
                                           cellBgImg.size.height-10);
            [bgImgView addSubview:iconImgView];
            [iconImgView release];
            
            UILabel *titleLab = [[UILabel alloc]init];
            titleLab.text  = @"分享到腾讯微博";
            titleLab.font  = [UIFont systemFontOfSize:14.f];
            titleLab.backgroundColor = [UIColor clearColor];
            titleLab.frame = CGRectMake(cellBgImg.size.height+10,
                                        cellBgImg.size.height/2-10,
                                        200, 20);
            [bgImgView addSubview:titleLab];
            [titleLab release];
            
            UIButton *shareTecentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            shareTecentBtn.frame     = CGRectMake(0, 0,
                                                cellBgImg.size.width,
                                                cellBgImg.size.height);
            [shareTecentBtn addTarget:self
                             action:@selector(doShareTecentBtnClicked:)
                   forControlEvents:UIControlEventTouchUpInside|UIControlEventTouchUpOutside];
            [shareTecentBtn addTarget:self
                               action:@selector(doButtonDowned:)
                     forControlEvents:UIControlEventTouchDown];
            [shareTecentBtn addSubview:bgImgView];
            [cell addSubview:shareTecentBtn];
            break;
        }
        default:
            break;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark -
#pragma mark - UIAlertViewDelegate
- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 11)
    {
        switch (buttonIndex)
        {
            case 0:    //马上去
            {
                NSString *url = [WXApi getWXAppInstallUrl];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
                break;
            }
            case 1:    //取消
            {
                break;
            }
            default:
                break;
        }
    }
}

#pragma mark -
#pragma mark - Notice
- (void) getDismissView:(NSNotification *) notice
{
    CustomNavigationViewController *nav = [MainViewController getNavigationViewController];
    [nav dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
}
@end
