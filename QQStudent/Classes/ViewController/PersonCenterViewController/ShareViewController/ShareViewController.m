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
//        self.tabBarItem.title = @"分享";
        self.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"sdfsf"
                                                       image:[UIImage imageNamed:@"icon_setting.png"] tag:0];
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
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(getDismissView:)
                                                 name:@"dismissView"
                                               object:nil];
    [super viewDidAppear:animated];
}

- (void) viewDidUnload
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
    
    UILabel *title        = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    title.textColor       = [UIColor colorWithHexString:@"#009f66"];
    title.backgroundColor = [UIColor clearColor];
    title.textAlignment = UITextAlignmentCenter;
    title.text = @"个人中心";
    self.navigationItem.titleView = title;
    [title release];
    
    UIImage *cellBgImg = [UIImage imageNamed:@"sp_content_normal_cell"];
    shareTab = [[UITableView alloc]init];
    shareTab.delegate   = self;
    shareTab.dataSource = self;
    shareTab.frame      = CGRectMake(40, 50, cellBgImg.size.width, 300);
    shareTab.scrollEnabled = NO;
    shareTab.backgroundColor = [UIColor colorWithHexString:@"#e1e0de"];
    [self.view addSubview:shareTab];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#e1e0de"];
}

- (void) getShareContentFromServer
{
    NSString *ssid = [[NSUserDefaults standardUserDefaults] objectForKey:SSID];
    NSArray *paramsArr = [NSArray arrayWithObjects:@"action",@"sessid", nil];
    NSArray *valuesArr = [NSArray arrayWithObjects:@"getShareSet",ssid, nil];
    NSDictionary *pDic = [NSDictionary dictionaryWithObjects:valuesArr
                                                     forKeys:paramsArr];
    
    NSString *webAdd   = [[NSUserDefaults standardUserDefaults] objectForKey:WEBADDRESS];
    NSString *url      = [NSString stringWithFormat:@"%@%@", webAdd, STUDENT];
    ServerRequest *serverReq = [ServerRequest sharedServerRequest];
    NSData *resVal     = [serverReq requestSyncWith:kServerPostRequest
                                           paramDic:pDic
                                             urlStr:url];
    NSString *resStr = [[[NSString alloc]initWithData:resVal
                                             encoding:NSUTF8StringEncoding]autorelease];
    NSDictionary *resDic  = [resStr JSONValue];
    NSString *eerid = [[resDic objectForKey:@"errorid"] copy];
    if (resDic)
    {
        if (eerid.intValue==0)
        {
            CLog(@"shareContent:%@", resDic);
        }
        else
        {
            NSString *errorMsg = [resDic objectForKey:@"message"];
            [self showAlertWithTitle:@"提示"
                                 tag:4
                             message:[NSString stringWithFormat:@"错误码%@,%@",eerid,errorMsg]
                            delegate:self
                   otherButtonTitles:@"确定",nil];
        }
    }
    else
    {
        [self showAlertWithTitle:@"提示"
                             tag:3
                         message:@"获取数据失败!"
                        delegate:self
               otherButtonTitles:@"确定",nil];
    }
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
#pragma mark - Control Event
- (void) doBackBtnClicked:(id)sender
{
    MainViewController *mVctr = [[MainViewController alloc]init];
    UINavigationController *nvc = [[UINavigationController alloc]initWithRootViewController:mVctr];
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    app.window.rootViewController = nvc;
    [mVctr release];
}

- (void) doShareFrdBtnClicked:(id)sender
{
    [self setCellBgImage:[UIImage imageNamed:@"sp_content_normal_cell"]
                  sender:sender];
    
    ShareAddressBookViewController *shareBook = [[ShareAddressBookViewController alloc]init];
    [self.navigationController pushViewController:shareBook
                                         animated:YES];
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
                             tag:0
                         message:@"您尚未安装微信,马上去安装它!"
                        delegate:self
               otherButtonTitles:@"马上去",@"取消",nil];
    }
    else
    {
        CLog(@"YES Installed");
        ShareWeixinViewController *swVctr = [[ShareWeixinViewController alloc]init];
        [self presentPopupViewController:swVctr
                           animationType:MJPopupViewAnimationFade];
    }
}

- (void) doShareSinaBtnClicked:(id)sender
{
    [self setCellBgImage:[UIImage imageNamed:@"sp_content_normal_cell"]
                  sender:sender];
    
    SignalSinaWeibo *sgWeibo = [SignalSinaWeibo shareInstance:self];
    if (![sgWeibo.sinaWeibo isAuthValid])
    {
        BoundSinaViewController *bsVctr = [[BoundSinaViewController alloc]init];
        [self.navigationController pushViewController:bsVctr
                                             animated:YES];
        [bsVctr release];
    }
    else
    {
        ShareSinaViewController *sVctr = [[ShareSinaViewController alloc]init];
        [self.navigationController pushViewController:sVctr
                                             animated:YES];
        [sVctr release];
    }
}

- (void) doShareTecentBtnClicked:(id)sender
{
    [self setCellBgImage:[UIImage imageNamed:@"sp_content_normal_cell"]
                  sender:sender];
    
    SingleTCWeibo *tcWeibo = [SingleTCWeibo shareInstance];
    if (![tcWeibo.tcWeiboApi isAuthValid])
    {
        BoundTecentViewController *btVctr = [[BoundTecentViewController alloc]init];
        [self.navigationController pushViewController:btVctr
                                             animated:YES];
        [btVctr release];
    }
    else
    {
        ShareTecentViewController *stVctr = [[ShareTecentViewController alloc]init];
        [self.navigationController pushViewController:stVctr
                                             animated:YES];
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
            titleLab.text  = @"分享到新浪微博";
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

#pragma mark - 
#pragma mark - Notice
- (void) getDismissView:(NSNotification *) notice
{
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
}
@end
